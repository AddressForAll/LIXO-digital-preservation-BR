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
srid   =4326

pkid = 45
fullPkID=45_001
sandbox=$(sandbox_root)/_pk$(fullPkID)

## USER CONFIGS
pg_db  =ingest1
thisTplFile_root = digital-preservation-BR

## ## ## ## ## ## ##
## THIS_MAKE, _pk45

part1_file  =f40eeaa6fe4f78e52be084392cc9c04d07a95112f7fb2acaf3210fd23fbdf4a8.zip
part1_name  =Lotes

part2_file  =23f703b7d1611ea29f53fe3bd2617a5939fe96d21453004838d7fe61064dae45.zip
part2_name  =Quadras

part3_file  =2137f68df828ce00c276a38b969cd651efcc2f8300f9fb4a716b6fd10019862f.zip
part3_name  =Bairros

## COMPOSED VARS
pg_uri_db   =$(pg_uri)/$(pg_db)
part1_path  =$(orig)/$(part1_file)
part2_path  =$(orig)/$(part2_file)
part3_path  =$(orig)/$(part3_file)

all:
	@echo "=== Resumo deste makefile de recuperação de dados preservados ==="
	@printf "Targets para a geração de layers:\n\tall_layers parcel block nsvia \n"
	@printf "Demais targets implementados:\n\tclean wget_files me\n"
	@echo "A gereação de layers requer os seguintes comandos e versões:\n\t$(need_commands)"

all_layers: parcel block nsvia 
	@echo "--ALL LAYERS--"

## ## ## ## ## ## ## ## ##
## ## ## ## ## ## ## ## ##
## Make targets of the Project Digital Preservation



## ## ## ## sponsored by Project AddressForAll
nsvia: layername = nsvia_full
nsvia: tabname = pk$(fullPkID)_p3_nsvia
nsvia: makedirs $(part3_path)
	@# pk45_p3 - ETL extrating to PostgreSQL/PostGIS the "nsvia" datatype (zone with name)
	@echo
	@echo "------------------------------------------"
	@echo "------ Layer tipo $(layername)  ------"
	@echo "-- Incluindo dados do arquivo-3 do package-$(fullPkID) na base $(pg_db) --"
	@echo " Nome-hash do arquivo-3: $(part3_file)"
	@echo " Tabela do layer geoaddress sem nome de rua, só com numero predial: $(tabname)"
	@echo " Sub-arquivos do arquivo-3 com o conteúdo alvo: Bairros.*"
	@echo " Tema dos sub-arquivos: $(part3_name)"
	@echo "Run with tmux and sudo! (DANGER: seems not idempotent on psql)"
	@whoami
	@printf "Above user is root? If not, you have permissions for all paths?\n [press ENTER for yes else ^C]"
	@read _press_enter_
	psql $(pg_uri_db) -c "DROP TABLE IF EXISTS $(tabname) CASCADE"
	@tput bold
	@echo Extracting ....
	@tput sgr0
	cd $(sandbox);  7z x -y  $(part3_path) "Bairros.*"  ; chmod -R a+rx . > /dev/null
	@echo "Conferindo se SRID 4326 esta configurado:"
	@psql $(pg_uri_db) -c "SELECT srid, proj4text FROM spatial_ref_sys where srid=4326"
	@echo "Tudo bem até aqui?  [ENTER para continuar ou ^C para rodar WS/ingest-step1]"
	@read _tudo_bem_
ifeq ('shp2sql','shp2sql')
	@echo Executando shp2pgsql ...
	cd $(sandbox);	shp2pgsql   -s 4326 "Bairros.shp" $(tabname) | psql -q $(pg_uri_db) 2> /dev/null
endif
ifeq ('shp2sql','csv2sql')
	@echo Executando csc2sql ...
	psql $(pg_uri_db) -c "SELECT ingest.fdw_generate_direct_csv( '$(sandbox)/Bairros.csv', '$(tabname)' )"
endif
	psql $(pg_uri_db) -c "SELECT ingest.any_load('shp2sql','$(sandbox)/Bairros','$(layername)','$(tabname)','$(fullPkID)','$(part3_file)',array['gid', 'bairro AS ns_name', 'geom'])"
	@echo "Confira os resultados nas tabelas ingest.layer_file e ingest.feature_asis".
ifeq ('shp2sql','csv2sql')
	psql $(pg_uri_db) -c "DROP FOREIGN TABLE IF EXISTS $(tabname)"
endif
	@echo FIM.

nsvia-clean: tabname = pk$(fullPkID)_p3_nsvia
nsvia-clean:
	rm -f "$(sandbox)/Bairros.*" || true
	psql $(pg_uri_db) -c "DROP TABLE IF EXISTS $(tabname) CASCADE;  DROP VIEW IF EXISTS vw_$(tabname) CASCADE;"





## ## ## ## sponsored by Project AddressForAll
parcel: layername = parcel_full
parcel: tabname = pk$(fullPkID)_p1_parcel
parcel: makedirs $(part1_path)
	@# pk45_p1 - ETL extrating to PostgreSQL/PostGIS the "parcel" datatype (street axes)
	@echo
	@echo "------------------------------------------"
	@echo "------ Layer tipo $(layername)  ------"
	@echo "-- Incluindo dados do arquivo-1 do package-$(fullPkID) na base $(pg_db) --"
	@echo " Nome-hash do arquivo-1: $(part1_file)"
	@echo " Tabela do layer geoaddress sem nome de rua, só com numero predial: $(tabname)"
	@echo " Sub-arquivos do arquivo-1 com o conteúdo alvo: Cadastro de Imoveis.*"
	@echo " Tema dos sub-arquivos: $(part1_name)"
	@echo "Run with tmux and sudo! (DANGER: seems not idempotent on psql)"
	@whoami
	@printf "Above user is root? If not, you have permissions for all paths?\n [press ENTER for yes else ^C]"
	@read _press_enter_
	psql $(pg_uri_db) -c "DROP TABLE IF EXISTS $(tabname) CASCADE"
	@tput bold
	@echo Extracting ....
	@tput sgr0
	cd $(sandbox);  7z x -y  $(part1_path) "Cadastro de Imoveis.*" ; chmod -R a+rx . > /dev/null
	@echo "Conferindo se SRID 4326 esta configurado:"
	@psql $(pg_uri_db) -c "SELECT srid, proj4text FROM spatial_ref_sys where srid=4326"
	@echo "Tudo bem até aqui?  [ENTER para continuar ou ^C para rodar WS/ingest-step1]"
	@read _tudo_bem_
ifeq ('shp2sql','shp2sql')
	@echo Executando shp2pgsql ...
	cd $(sandbox);	shp2pgsql   -s 4326 "Cadastro de Imoveis.shp" $(tabname) | psql -q $(pg_uri_db) 2> /dev/null
endif
ifeq ('shp2sql','csv2sql')
	@echo Executando csc2sql ...
	psql $(pg_uri_db) -c "SELECT ingest.fdw_generate_direct_csv( '$(sandbox)/Cadastro de Imoveis.csv', '$(tabname)' )"
endif
	psql $(pg_uri_db) -c "SELECT ingest.any_load('shp2sql','$(sandbox)/Cadastro de Imoveis','$(layername)','$(tabname)','$(fullPkID)','$(part1_file)',array['gid', 'bairro_imo AS ns_name', 'cep_imovel', 'logradouro AS via_name', 'numero_imo AS house_number', 'unidades', 'geom'])"
	@echo "Confira os resultados nas tabelas ingest.layer_file e ingest.feature_asis".
ifeq ('shp2sql','csv2sql')
	psql $(pg_uri_db) -c "DROP FOREIGN TABLE IF EXISTS $(tabname)"
endif
	@echo FIM.

parcel-clean: tabname = pk$(fullPkID)_p1_parcel
parcel-clean:
	rm -f "$(sandbox)/Cadastro de Imoveis.*" || true
	psql $(pg_uri_db) -c "DROP TABLE IF EXISTS $(tabname) CASCADE"


## ## ## ## sponsored by Project AddressForAll
block: layername = block_none
block: tabname = pk$(fullPkID)_p2_block
block: makedirs $(part2_path)
	@# pk45_p2 - ETL extrating to PostgreSQL/PostGIS the "block" datatype (street axes)
	@echo
	@echo "------------------------------------------"
	@echo "------ Layer tipo $(layername)  ------"
	@echo "-- Incluindo dados do arquivo-2 do package-$(fullPkID) na base $(pg_db) --"
	@echo " Nome-hash do arquivo-2: $(part2_file)"
	@echo " Tabela do layer geoaddress sem nome de rua, só com numero predial: $(tabname)"
	@echo " Sub-arquivos do arquivo-2 com o conteúdo alvo: Quadras.*"
	@echo " Tema dos sub-arquivos: $(part2_name)"
	@echo "Run with tmux and sudo! (DANGER: seems not idempotent on psql)"
	@whoami
	@printf "Above user is root? If not, you have permissions for all paths?\n [press ENTER for yes else ^C]"
	@read _press_enter_
	psql $(pg_uri_db) -c "DROP TABLE IF EXISTS $(tabname) CASCADE"
	@tput bold
	@echo Extracting ....
	@tput sgr0
	cd $(sandbox);  7z x -y  $(part2_path) "Quadras.*" ; chmod -R a+rx . > /dev/null
	@echo "Conferindo se SRID 4326 esta configurado:"
	@psql $(pg_uri_db) -c "SELECT srid, proj4text FROM spatial_ref_sys where srid=4326"
	@echo "Tudo bem até aqui?  [ENTER para continuar ou ^C para rodar WS/ingest-step1]"
	@read _tudo_bem_
ifeq ('shp2sql','shp2sql')
	@echo Executando shp2pgsql ...
	cd $(sandbox);	shp2pgsql   -s 4326 "Quadras.shp" $(tabname) | psql -q $(pg_uri_db) 2> /dev/null
endif
ifeq ('shp2sql','csv2sql')
	@echo Executando csc2sql ...
	psql $(pg_uri_db) -c "SELECT ingest.fdw_generate_direct_csv( '$(sandbox)/Quadras.csv', '$(tabname)' )"
endif
	psql $(pg_uri_db) -c "SELECT ingest.any_load('shp2sql','$(sandbox)/Quadras','$(layername)','$(tabname)','$(fullPkID)','$(part2_file)',array['gid', 'chave_qd', 'geom'])"
	@echo "Confira os resultados nas tabelas ingest.layer_file e ingest.feature_asis".
ifeq ('shp2sql','csv2sql')
	psql $(pg_uri_db) -c "DROP FOREIGN TABLE IF EXISTS $(tabname)"
endif
	@echo FIM.

block-clean: tabname = pk$(fullPkID)_p2_block
block-clean:
	rm -f "$(sandbox)/Quadras.*" || true
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
	@cd $(orig); wget http://preserv.addressforall.org/download/f40eeaa6fe4f78e52be084392cc9c04d07a95112f7fb2acaf3210fd23fbdf4a8.zip
	@cd $(orig); wget http://preserv.addressforall.org/download/23f703b7d1611ea29f53fe3bd2617a5939fe96d21453004838d7fe61064dae45.zip
	@cd $(orig); wget http://preserv.addressforall.org/download/2137f68df828ce00c276a38b969cd651efcc2f8300f9fb4a716b6fd10019862f.zip
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

