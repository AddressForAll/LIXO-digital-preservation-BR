##
## Template file reference: digital-preservation-BR/data/in/RS/PortoAlegre/_pk027
##

## BASIC CONFIGS
pg_io  ={{pg_io}}
orig   ={{orig}}
pg_uri ={{pg_uri}}
sandbox={{sandbox}}

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
	@echo Requer comandos $(need_commands)
	@echo Principais targets implementados neste makefile:
	@echo {{#parts}}{{#geoaddress-novia}}geoaddress-novia {{/geoaddress-novia}}{{#namespace-full}}namespace-full {{/namespace-full}}{{/parts}}

## ## ## ## ## ## ## ## ##
## Make targets of the Project AddressForAll
## man at https://github.com/AddressForAll/digital-preservation/wiki/makefile-generator

makedirs:
	@mkdir -p $(sandbox)
	@mkdir -p $(pg_io)

{{#parts}}
{{#geoaddress-novia}}

geoaddress-novia: tabname = pk{{pkid}}_p{{file}}_{{tabname}}
geoaddress-novia: makedirs
	@# pk{{pkid}}_p{{file}} - ETL extrating to PostgreSQL/PostGIS the "geoaddress-novia" datatype (point with house_number but no via name)
	@echo
	@echo "-- Incluindo dados tipo geoaddress-novia do arquivo-{{file}} do package-{{pkid}} na base $(pg_db) --"
	@echo " Tema do arquivo-{{file}}: $(part{{file}}_name)"
	@echo " Hash do arquivo-{{file}}: $(part{{file}}_file)"
	@echo " Tabela do layer geoaddress sem nome de rua, só com numero predial: $(tabname)"
	@echo " Parte do arquivo que representa a tabela: $(part{{file}}_path)"
	@echo "Run with tmux and sudo! (DANGER: seems not idempotent on psql)"
	@whoami
	@echo "Above user is root? If not, you have permissions for all paths? (press ENTER for yes else ^C)"
	@read _press_enter_
	psql $(pg_uri_db) -c "DROP TABLE IF EXISTS $(tabname) CASCADE"
	@tput bold
	@echo Extraindo ....
	@tput sgr0
	cd $(sandbox) ; 7z e -y  $(part{{file}}_path) {{orig_filename}}.* > /dev/null
{{/geoaddress-novia}}

{{#namespace-full}}
namespace-full: sandbox
	@echo ok!
{{/namespace-full}}

{{/parts}}
