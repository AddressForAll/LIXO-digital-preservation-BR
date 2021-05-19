##
## Template file reference: digital-preservation-BR/data/in/RS/PortoAlegre/_pk027
##

## BASIC CONFIGS
pg_io  =/tmp/pg_io
orig   =/var/www/preserv.addressforall.org/download
pg_uri =postgres://postgres@localhost
sandbox_root=/tmp/sandbox

pkid = 14
fullPkID=14_1
sandbox=$(sandbox_root)/_pk$(fullPkID)

## USER CONFIGS
pg_db  =ingest1
thisTplFile_root = digital-preservation-BR

## ## ## ## ## ## ##
## THIS_MAKE, _pk14

need_commands   ="7z psql shp2pgsql" # and a prepared database ingest1

part1_file  =d101e729d51ddfc33e4a866684074487c5a2601c7c84d4eca01ff9bbca186cda.rar
part1_name  =Todos os shapes

## COMPOSED VARS
pg_uri_db   =$(pg_uri)/$(pg_db)
part1_path  =$(orig)/$(part1_file)


all:
	@echo "Requer comandos $(need_commands)."
	@echo "Principais targets implementados neste makefile:"
	@echo " geoaddress_none via_full nsvia_full"
	@echo "Targets opcionais e ferramentas: me wget_files clean"
## ## ## ## ## ## ## ## ##
## Make targets of the Project AddressForAll
## man at https://github.com/AddressForAll/digital-preservation/wiki/makefile-generator

makedirs: clean_sandbox
	@mkdir -p $(sandbox_root)
	@mkdir -p $(sandbox)
	@mkdir -p $(pg_io)


## ## ## ##

## ## ## ##

via_full: tabname = pk$(fullPkID)_p1_via
via_full: makedirs $(part1_path)
	@# pk14_p1 - ETL extrating to PostgreSQL/PostGIS the "via_full" datatype (street axes)
	@echo
	@echo "-- Incluindo dados tipo via_full do arquivo-1 do package-$(fullPkID) na base $(pg_db) --"
	@echo " Tema do arquivo-1: $(part1_name)"
	@echo " Nome-hash do arquivo-1: $(part1_file)"
	@echo " Tabela do layer geoaddress sem nome de rua, só com numero predial: $(tabname)"
	@echo " Sub-arquivos do arquivo-1 com o conteúdo alvo: sistema_viario.*"
	@tput bold
	@echo Extraindo ....
	@tput sgr0
	cd $(sandbox);  7z e -y  $(part1_path) sistema_viario.* > /dev/null
	@echo "Conferindo se SRID esta configurado:"
	@psql $(pg_uri_db) -c "SELECT srid, proj4text FROM spatial_ref_sys where srid=31982"
	@echo "Tudo bem até aqui?  [ENTER para continuar ou ^C para rodar WS/ingest-step1]"
	@read _tudo_bem_
	@echo Executando shp2pgsql ...
	cd $(sandbox);	shp2pgsql -s 31982 sistema_viario.shp $(tabname) | psql -q $(pg_uri_db) 2> /dev/null
	psql $(pg_uri_db) -c "CREATE VIEW vw_$(tabname) AS SELECT gid, TIPO || ' ' || NOME AS via_name,geom FROM $(tabname) ORDER BY 1, 2"
	psql $(pg_uri_db) -c "SELECT ingest.any_load('$(sandbox)/sistema_viario.shp','via_full','vw_$(tabname)',$(pkid),array['gid','via_name'])"
	psql $(pg_uri_db) -c "DROP VIEW vw_$(tabname)"
	@echo "Confira os resultados nas tabelas ingest.layer_file e ingest.feature_asis".
	@echo FIM.

via_full-clean:
	rm -f $(sandbox)/sistema_viario.* || true
	psql $(pg_uri_db) -c "DROP TABLE IF EXISTS $(tabname) CASCADE"



## ## ## ##
wget_files:
	@echo "Under construction, need to check that orig path is not /var/www! or use orig=x [ENTER if not else ^C]"
	@echo $(orig)
	@read _ENTER_OK_
	@cd $(orig); wget http://preserv.addressforall.org/download/d101e729d51ddfc33e4a866684074487c5a2601c7c84d4eca01ff9bbca186cda.rar
	@echo "Please, if orig not default, run 'make _target_ orig=$(orig)'"


## ## ## ##

clean_sandbox:
	@rm -rf $(sandbox) || true

clean: geoaddress_none-clean nsvia_full-clean via_full-clean


## ############################
## SELF-GENERATE MAKE (make me)
##

thisTplFile = digital-preservation-BR/src/maketemplates/make_ref027a.mustache.mk

baseSrc      = /opt/gits
srcPy        =  $(baseSrc)/digital-preservation/src/run_mustache.py
mkme_input0  =  $(baseSrc)/digital-preservation-BR/src/maketemplates/commomFirst.yaml
mkme_srcTplLast  =  $(baseSrc)/digital-preservation-BR/src/maketemplates/commomLast.mustache.mk
mkme_srcTpl  =  $(baseSrc)/$(thisTplFile)
mkme_input   = ./make_conf.yaml
mkme_output  = /tmp/digitalPresservation-make_me.mk


me: $(srcPy) $(mkme_input0) $(mkme_input) $(mkme_srcTpl)
	@echo "-- Updating this make --"
	python3 $(srcPy) -t $(mkme_srcTpl) --tplLast=$(mkme_srcTplLast) -i $(mkme_input) --input0=$(mkme_input0) > $(mkme_output)
	@echo " Check diff, the '<' lines are the new ones... Something changed?"
	@diff $(mkme_output) ./makefile || :
	@echo "If some changes, and no error in the changes, move the script:"
	@echo " mv ./makefile ./bk-makefile"
	@echo " mv $(mkme_output) ./makefile"

