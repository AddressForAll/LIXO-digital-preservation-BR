##
## Template file reference: digital-preservation-BR/data/in/RS/PortoAlegre/_pk027
##

## BASIC CONFIGS
pg_io  ={{pg_io}}
orig   ={{orig}}
pg_uri ={{pg_uri}}
sandbox_root={{sandbox}}

pkid = {{pkid}}
fullPkID={{pkid}}_{{pkversion}}
sandbox=$(sandbox_root)/_pk$(fullPkID)

## USER CONFIGS
pg_db  ={{pg_db}}
thisTplFile_root = {{thisTplFile_root}}

## ## ## ## ## ## ##
## THIS_MAKE, _pk{{pkid}}

need_commands   ="{{need_commands}}" # and a prepared database {{pg_db}}

{{#files}}
part{{p}}_file  ={{file}}
part{{p}}_name  ={{name}}

{{/files}}
## COMPOSED VARS
pg_uri_db   =$(pg_uri)/$(pg_db)
{{#files}}
part{{p}}_path  =$(orig)/$(part{{p}}_file)
{{/files}}


all:
	@echo "Requer comandos $(need_commands)."
	@echo "Principais targets implementados neste makefile:"
	@echo " geoaddress_none via_full nsvia_full"

## ## ## ## ## ## ## ## ##
## Make targets of the Project AddressForAll
## man at https://github.com/AddressForAll/digital-preservation/wiki/makefile-generator

makedirs: clean_sandbox
	@mkdir -p $(sandbox_root)
	@mkdir -p $(sandbox)
	@mkdir -p $(pg_io)

{{#parts}}
{{#geoaddress_none}}

geoaddress_none: tabname = pk$(fullPkID)_p{{file}}_{{tabname}}
geoaddress_none: makedirs $(part{{file}}_path)
	@# pk{{pkid}}_p{{file}} - ETL extrating to PostgreSQL/PostGIS the "geoaddress_none" datatype (point with house_number but no via name)
	@echo
	@echo "-- Incluindo dados tipo geoaddress_none do arquivo-{{file}} do package-$(fullPkID) na base $(pg_db) --"
	@echo " Tema do arquivo-{{file}}: $(part{{file}}_name)"
	@echo " Nome-hash do arquivo-{{file}}: $(part{{file}}_file)"
	@echo " Tabela do layer geoaddress sem nome de rua, só com numero predial: $(tabname)"
	@echo " Sub-arquivos do arquivo-{{file}} com o conteúdo alvo: {{orig_filename}}.*"
	@echo "Run with tmux and sudo! (DANGER: seems not idempotent on psql)"
	@whoami
	@printf "Above user is root? If not, you have permissions for all paths?\n [press ENTER for yes else ^C]"
	@read _press_enter_
	psql $(pg_uri_db) -c "DROP TABLE IF EXISTS $(tabname) CASCADE"
	@tput bold
	@echo Extraindo ....
	@tput sgr0
	cd $(sandbox);  7z e -y  $(part{{file}}_path) {{orig_filename}}.* > /dev/null
	@echo "Conferindo se SRID esta configurado:"
	@psql $(pg_uri_db) -c "SELECT srid, proj4text FROM spatial_ref_sys where srid={{srid}}"
	@echo "Tudo bem até aqui?  [ENTER para continuar ou ^C para rodar WS/ingest-step1]"
	@read _tudo_bem_
	@echo Executando shp2pgsql ...
	cd $(sandbox);	shp2pgsql -s {{srid}} {{orig_filename}}.shp $(tabname) | psql -q $(pg_uri_db) 2> /dev/null
	# falta o assert das assinaturas, na preservação digital precisaria ser baseado em diff.
	# as assinaturas dependem do tipo de geometria (ponto, linha ou rea), requerem função especializada (comprovando reprodutibilidade).
	psql $(pg_uri_db) -c "SELECT ingest.any_load('$(sandbox)/{{orig_filename}}.shp','geoaddress_none','$(tabname)',$(pkid),array['gid','textstring'])"
	@echo FIM.

geoaddress_none-clean:
	rm -f $(sandbox)/{{orig_filename}}.* || true
	psql $(pg_uri_db) -c "DROP TABLE IF EXISTS $(tabname) CASCADE"

{{/geoaddress_none}}

## ## ## ##
{{#nsvia_full}}

nsvia_full: tabname = pk$(fullPkID)_p{{file}}_{{tabname}}
nsvia_full: makedirs $(part{{file}}_path)
	@# pk{{pkid}}_p{{file}} - ETL extrating to PostgreSQL/PostGIS the "nsvia_full" datatype (zone with name)
	@echo
	@echo "-- Incluindo dados tipo nsvia_full do arquivo-{{file}} do package-$(fullPkID) na base $(pg_db) --"
	@echo " Tema do arquivo-{{file}}: $(part{{file}}_name)"
	@echo " Nome-hash do arquivo-{{file}}: $(part{{file}}_file)"
	@echo " Tabela do layer geoaddress sem nome de rua, só com numero predial: $(tabname)"
	@echo " Sub-arquivos do arquivo-{{file}} com o conteúdo alvo: {{orig_filename}}.*"

nsvia_full-clean:
	rm -f $(sandbox)/{{orig_filename}}.* || true
	psql $(pg_uri_db) -c "DROP TABLE IF EXISTS $(tabname) CASCADE"

{{/nsvia_full}}

## ## ## ##
{{#via_full}}

via_full: tabname = pk$(fullPkID)_p{{file}}_{{tabname}}
via_full: makedirs $(part{{file}}_path)
	@# pk{{pkid}}_p{{file}} - ETL extrating to PostgreSQL/PostGIS the "via_full" datatype (street axes)
	@echo
	@echo "-- Incluindo dados tipo via_full do arquivo-{{file}} do package-$(fullPkID) na base $(pg_db) --"
	@echo " Tema do arquivo-{{file}}: $(part{{file}}_name)"
	@echo " Nome-hash do arquivo-{{file}}: $(part{{file}}_file)"
	@echo " Tabela do layer geoaddress sem nome de rua, só com numero predial: $(tabname)"
	@echo " Sub-arquivos do arquivo-{{file}} com o conteúdo alvo: {{orig_filename}}.*"

via_full-clean:
	rm -f $(sandbox)/{{orig_filename}}.* || true
	psql $(pg_uri_db) -c "DROP TABLE IF EXISTS $(tabname) CASCADE"

{{/via_full}}

{{/parts}}

## ## ## ##
wget_files:
	@echo "Under construction, need to check that orig path is not /var/www! [ENTER if not else ^C]"
	@echo $(orig)
	@read _ENTER_OK_
{{#files}}
	@cd $(orig); wget http://preserv.addressforall.org/download/{{file}}
{{/files}}

## ## ## ##

clean_sandbox:
	@rm -rf $(sandbox) || true

clean: geoaddress_none-clean nsvia_full-clean
