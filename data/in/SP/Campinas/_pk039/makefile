##
## Template file reference: digital-preservation-BR/data/in/RS/PortoAlegre/_pk027
## tplId: 027a
##
tplInputSchema_id=027a


## BASIC CONFIG
pg_io  =/tmp/pg_io
orig   =/var/www/preserv.addressforall.org/download
pg_uri =postgres://postgres@localhost
sandbox_root=/tmp/sandbox
need_commands= 7z v16+; psql v12+; shp2pgsql v3+; 
srid   =31983

pkid = 39
fullPkID=39_001
sandbox=$(sandbox_root)/_pk$(fullPkID)

## USER CONFIGS
pg_db  =ingest1
thisTplFile_root = digital-preservation-BR

## ## ## ## ## ## ##
## THIS_MAKE, _pk39

part1_file  =b594f8717d9912e25938029f8ac55eb5842b561ff29d9768c5b77489945a9c1c.zip
part1_name  =Eixos

part2_file  =6bb020e023ffd10570d887f907fdad909eecde1003c8911ef64ac63d48f5fe8b.zip
part2_name  =Pontos de lotes

## COMPOSED VARS
pg_uri_db   =$(pg_uri)/$(pg_db)
part1_path  =$(orig)/$(part1_file)
part2_path  =$(orig)/$(part2_file)

all:
	@echo "=== Resumo deste makefile de recuperação de dados preservados ==="
	@printf "Targets para a geração de layers:\n\tall_layers via geoaddress \n"
	@printf "Demais targets implementados:\n\tclean wget_files me\n"
	@echo "A gereação de layers requer os seguintes comandos e versões:\n\t$(need_commands)"

all_layers: via geoaddress 
	@echo "--ALL LAYERS--"

## ## ## ## ## ## ## ## ##
## ## ## ## ## ## ## ## ##
## Make targets of the Project Digital Preservation

## ## ## ## sponsored by Project AddressForAll
geoaddress: layername = geoaddress_none
geoaddress: tabname = pk$(fullPkID)_p2_geoaddress
geoaddress: makedirs $(part2_path)
	@# pk39_p2 - ETL extrating to PostgreSQL/PostGIS the "geoaddress" datatype (point with house_number but no via name)
	@echo
	@echo "------------------------------------------"
	@echo "------ Layer tipo $(layername)  ------"
	@echo "-- Incluindo dados do arquivo-2 do package-$(fullPkID) na base $(pg_db) --"
	@echo " Nome-hash do arquivo-2: $(part2_file)"
	@echo " Tabela do layer geoaddress sem nome de rua, só com numero predial: $(tabname)"
	@echo " Sub-arquivos do arquivo-2 com o conteúdo alvo: 256b0041-6e29-1649-4b2b-00006944c8fb.*"
	@echo " Tema dos sub-arquivos: $(part2_name)"
	@echo "Run with tmux and sudo! (DANGER: seems not idempotent on psql)"
	@whoami
	@printf "Above user is root? If not, you have permissions for all paths?\n [press ENTER for yes else ^C]"
	@read _press_enter_
	psql $(pg_uri_db) -c "DROP TABLE IF EXISTS $(tabname) CASCADE"
	@tput bold
	@echo Extracting ....
	@tput sgr0
	cd $(sandbox);  7z  x -y  $(part2_path) "256b0041-6e29-1649-4b2b-00006944c8fb.*" ; chmod -R a+rx . > /dev/null
	@echo "Conferindo se SRID 31983 esta configurado:"
	@psql $(pg_uri_db) -c "SELECT srid, proj4text FROM spatial_ref_sys where srid=31983"
	@echo "Tudo bem até aqui?  [ENTER para continuar ou ^C para rodar WS/ingest-step1]"
	@read _tudo_bem_
ifeq ('shp2sql','shp2sql')
	@echo Executando shp2pgsql ...
	cd $(sandbox);	shp2pgsql   -s 31983 "256b0041-6e29-1649-4b2b-00006944c8fb.shp" $(tabname) | psql -q $(pg_uri_db) 2> /dev/null
endif
ifeq ('shp2sql','csv2sql')
	@echo Executando csc2sql ...
	psql $(pg_uri_db) -c "SELECT ingest.fdw_generate_direct_csv( '$(sandbox)/256b0041-6e29-1649-4b2b-00006944c8fb.csv', '$(tabname)' )"
endif
	psql $(pg_uri_db) -c "SELECT ingest.any_load('shp2sql','$(sandbox)/256b0041-6e29-1649-4b2b-00006944c8fb','$(layername)','$(tabname)','$(fullPkID)','$(part2_file)',array['gid', 'geom'])"
	@echo "Confira os resultados nas tabelas ingest.layer_file e ingest.feature_asis".
ifeq ('shp2sql','csv2sql')
	psql $(pg_uri_db) -c "DROP FOREIGN TABLE IF EXISTS $(tabname)"
endif
	@echo FIM.

geoaddress-clean: tabname = pk$(fullPkID)_p2_geoaddress
geoaddress-clean:
	rm -f "$(sandbox)/256b0041-6e29-1649-4b2b-00006944c8fb.*" || true
	psql $(pg_uri_db) -c "DROP TABLE IF EXISTS $(tabname) CASCADE"





## ## ## ## sponsored by Project AddressForAll
via: layername = via_none
via: tabname = pk$(fullPkID)_p1_via
via: makedirs $(part1_path)
	@# pk39_p1 - ETL extrating to PostgreSQL/PostGIS the "via" datatype (street axes)
	@echo
	@echo "------------------------------------------"
	@echo "------ Layer tipo $(layername)  ------"
	@echo "-- Incluindo dados do arquivo-1 do package-$(fullPkID) na base $(pg_db) --"
	@echo " Nome-hash do arquivo-1: $(part1_file)"
	@echo " Tabela do layer geoaddress sem nome de rua, só com numero predial: $(tabname)"
	@echo " Sub-arquivos do arquivo-1 com o conteúdo alvo: 5486431b-c7fe-aec8-ab9c-00004b294da9.*"
	@echo " Tema dos sub-arquivos: $(part1_name)"
	@echo "Run with tmux and sudo! (DANGER: seems not idempotent on psql)"
	@whoami
	@printf "Above user is root? If not, you have permissions for all paths?\n [press ENTER for yes else ^C]"
	@read _press_enter_
	psql $(pg_uri_db) -c "DROP TABLE IF EXISTS $(tabname) CASCADE"
	@tput bold
	@echo Extracting ....
	@tput sgr0
	cd $(sandbox);  7z  x -y  $(part1_path) "5486431b-c7fe-aec8-ab9c-00004b294da9.*"  ; chmod -R a+rx . > /dev/null
	@echo "Conferindo se SRID 31983 esta configurado:"
	@psql $(pg_uri_db) -c "SELECT srid, proj4text FROM spatial_ref_sys where srid=31983"
	@echo "Tudo bem até aqui?  [ENTER para continuar ou ^C para rodar WS/ingest-step1]"
	@read _tudo_bem_
ifeq ('shp2sql','shp2sql')
	@echo Executando shp2pgsql ...
	cd $(sandbox);	shp2pgsql   -s 31983 "5486431b-c7fe-aec8-ab9c-00004b294da9.shp" $(tabname) | psql -q $(pg_uri_db) 2> /dev/null
endif
ifeq ('shp2sql','csv2sql')
	@echo Executando csc2sql ...
	psql $(pg_uri_db) -c "SELECT ingest.fdw_generate_direct_csv( '$(sandbox)/5486431b-c7fe-aec8-ab9c-00004b294da9.csv', '$(tabname)' )"
endif
	psql $(pg_uri_db) -c "SELECT ingest.any_load('shp2sql','$(sandbox)/5486431b-c7fe-aec8-ab9c-00004b294da9','$(layername)','$(tabname)','$(fullPkID)','$(part1_file)',array['gid', 'LOGRADOURO AS via_name', 'geom'])"
	@echo "Confira os resultados nas tabelas ingest.layer_file e ingest.feature_asis".
ifeq ('shp2sql','csv2sql')
	psql $(pg_uri_db) -c "DROP FOREIGN TABLE IF EXISTS $(tabname)"
endif
	@echo FIM.

via-clean: tabname = pk$(fullPkID)_p1_via
via-clean:
	rm -f "$(sandbox)/5486431b-c7fe-aec8-ab9c-00004b294da9.*" || true
	psql $(pg_uri_db) -c "DROP TABLE IF EXISTS $(tabname) CASCADE"









## ## ## ## ## ## ## ## ##
## ## ## ## ## ## ## ## ##

makedirs: clean_sandbox
	@mkdir -p $(sandbox_root)
	@mkdir -p $(sandbox)
	@mkdir -p $(pg_io)

wget_files:
	@echo "Under construction, need to check that orig path is not /var/www! or use orig=x [ENTER if not else ^C]"
	@echo $(orig)
	@read _ENTER_OK_
	mkdir -p $(orig)
	@cd $(orig); wget http://dl.digital-guard.org/b594f8717d9912e25938029f8ac55eb5842b561ff29d9768c5b77489945a9c1c.zip
	@cd $(orig); wget http://dl.digital-guard.org/6bb020e023ffd10570d887f907fdad909eecde1003c8911ef64ac63d48f5fe8b.zip
	@echo "Please, if orig not default, run 'make _target_ orig=$(orig)'"


## ## ## ##

clean_sandbox:
	@rm -rf $(sandbox) || true

clean: geoaddress-clean nsvia-clean via-clean


## ############################
## SELF-GENERATE MAKE (make me)
##

thisTplFile  = digital-preservation-BR/src/maketemplates/make_ref027a.mustache.mk
country      = BR
baseSrc      = /opt/gits/_a4a

srcPy        =  $(baseSrc)/digital-preservation/src/run_mustache.py
mkme_input0  =  $(baseSrc)/digital-preservation-$(country)/src/maketemplates/commomFirst.yaml
mkme_srcTplLast  =  $(baseSrc)/digital-preservation-$(country)/src/maketemplates/commomLast.mustache.mk
mkme_srcTpl  =  $(baseSrc)/$(thisTplFile)
mkme_input   = ./make_conf.yaml
mkme_output  = /tmp/digitalPresservation-make_me.mk


me: $(srcPy) $(mkme_input0) $(mkme_input) $(mkme_srcTpl)
	@echo "-- Updating this make --"
	python3 $(srcPy) -b $(baseSrc)/ -t $(mkme_srcTpl) --tplLast=$(mkme_srcTplLast) -i $(mkme_input) --input0=$(mkme_input0) > $(mkme_output)
	@echo " Check diff, the '<' lines are the new ones... Something changed?"
	@diff $(mkme_output) ./makefile || :
	@echo "If some changes, and no error in the changes, move the script:"
	@echo " mv ./makefile ./bk-makefile"
	@echo " mv $(mkme_output) ./makefile"
	@echo "[ENTER para rodar mv ou ^C para sair]"
	@read _tudo_bem_
	mv $(mkme_output) ./makefile

