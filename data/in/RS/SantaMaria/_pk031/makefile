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
srid   =31982

pkid = 31
fullPkID=31_001
sandbox=$(sandbox_root)/_pk$(fullPkID)

## USER CONFIGS
pg_db  =ingest1
thisTplFile_root = digital-preservation-BR

## ## ## ## ## ## ##
## THIS_MAKE, _pk31

part1_file  =51a6beb9fca43e0fb45727138982f7806b8df52fce53f5e0e31edd61bfbc21b9.rar
part1_name  =Lotes

part2_file  =f4d3819f9853e85e43bf7a58de7f257eed5f63bcf36daed1c4db0f2701544adc.zip
part2_name  =Eixos

part3_file  =9600dcba403c8dc0b066c8f429507e4672966a01c93119923f75361a6ebc64c0.zip
part3_name  =Bairros

## COMPOSED VARS
pg_uri_db   =$(pg_uri)/$(pg_db)
part1_path  =$(orig)/$(part1_file)
part2_path  =$(orig)/$(part2_file)
part3_path  =$(orig)/$(part3_file)

all:
	@echo "=== Resumo deste makefile de recuperação de dados preservados ==="
	@printf "Targets para a geração de layers:\n\tall_layers parcel via nsvia block \n"
	@printf "Demais targets implementados:\n\tclean wget_files me\n"
	@echo "A gereação de layers requer os seguintes comandos e versões:\n\t$(need_commands)"

all_layers: parcel via nsvia block 
	@echo "--ALL LAYERS--"

## ## ## ## ## ## ## ## ##
## ## ## ## ## ## ## ## ##
## Make targets of the Project Digital Preservation



## ## ## ## sponsored by Project AddressForAll
nsvia: layername = nsvia_full
nsvia: tabname = pk$(fullPkID)_p2_nsvia
nsvia: makedirs $(part2_path)
	@# pk31_p2 - ETL extrating to PostgreSQL/PostGIS the "nsvia" datatype (zone with name)
	@echo
	@echo "------------------------------------------"
	@echo "------ Layer tipo $(layername)  ------"
	@echo "-- Incluindo dados do arquivo-2 do package-$(fullPkID) na base $(pg_db) --"
	@echo " Nome-hash do arquivo-2: $(part2_file)"
	@echo " Tabela do layer geoaddress sem nome de rua, só com numero predial: $(tabname)"
	@echo " Sub-arquivos do arquivo-2 com o conteúdo alvo: Bairros.*"
	@echo " Tema dos sub-arquivos: $(part2_name)"
	@echo "Run with tmux and sudo! (DANGER: seems not idempotent on psql)"
	@whoami
	@printf "Above user is root? If not, you have permissions for all paths?\n [press ENTER for yes else ^C]"
	@read _press_enter_
	psql $(pg_uri_db) -c "DROP TABLE IF EXISTS $(tabname) CASCADE"
	@tput bold
	@echo Extracting ....
	@tput sgr0
	cd $(sandbox);  7z x -y  $(part2_path) "Bairros.*"  ; chmod -R a+rx . > /dev/null
	@echo "Conferindo se SRID 31982 esta configurado:"
	@psql $(pg_uri_db) -c "SELECT srid, proj4text FROM spatial_ref_sys where srid=31982"
	@echo "Tudo bem até aqui?  [ENTER para continuar ou ^C para rodar WS/ingest-step1]"
	@read _tudo_bem_
ifeq ('shp2sql','shp2sql')
	@echo Executando shp2pgsql ...
	cd $(sandbox);	shp2pgsql   -s 31982 "Bairros.shp" $(tabname) | psql -q $(pg_uri_db) 2> /dev/null
endif
ifeq ('shp2sql','csv2sql')
	@echo Executando csc2sql ...
	psql $(pg_uri_db) -c "SELECT ingest.fdw_generate_direct_csv( '$(sandbox)/Bairros.csv', '$(tabname)' )"
endif
	psql $(pg_uri_db) -c "SELECT ingest.any_load('shp2sql','$(sandbox)/Bairros','$(layername)','$(tabname)','$(fullPkID)','$(part2_file)',array['gid', 'NOME AS ns_name', 'geom'])"
	@echo "Confira os resultados nas tabelas ingest.layer_file e ingest.feature_asis".
ifeq ('shp2sql','csv2sql')
	psql $(pg_uri_db) -c "DROP FOREIGN TABLE IF EXISTS $(tabname)"
endif
	@echo FIM.

nsvia-clean: tabname = pk$(fullPkID)_p2_nsvia
nsvia-clean:
	rm -f "$(sandbox)/Bairros.*" || true
	psql $(pg_uri_db) -c "DROP TABLE IF EXISTS $(tabname) CASCADE;  DROP VIEW IF EXISTS vw_$(tabname) CASCADE;"



## ## ## ## sponsored by Project AddressForAll
via: layername = via_full
via: tabname = pk$(fullPkID)_p3_via
via: makedirs $(part3_path)
	@# pk31_p3 - ETL extrating to PostgreSQL/PostGIS the "via" datatype (street axes)
	@echo
	@echo "------------------------------------------"
	@echo "------ Layer tipo $(layername)  ------"
	@echo "-- Incluindo dados do arquivo-3 do package-$(fullPkID) na base $(pg_db) --"
	@echo " Nome-hash do arquivo-3: $(part3_file)"
	@echo " Tabela do layer geoaddress sem nome de rua, só com numero predial: $(tabname)"
	@echo " Sub-arquivos do arquivo-3 com o conteúdo alvo: Ruas.*"
	@echo " Tema dos sub-arquivos: $(part3_name)"
	@echo "Run with tmux and sudo! (DANGER: seems not idempotent on psql)"
	@whoami
	@printf "Above user is root? If not, you have permissions for all paths?\n [press ENTER for yes else ^C]"
	@read _press_enter_
	psql $(pg_uri_db) -c "DROP TABLE IF EXISTS $(tabname) CASCADE"
	@tput bold
	@echo Extracting ....
	@tput sgr0
	cd $(sandbox);  7z x -y  $(part3_path) "Ruas.*"  ; chmod -R a+rx . > /dev/null
	@echo "Conferindo se SRID 31982 esta configurado:"
	@psql $(pg_uri_db) -c "SELECT srid, proj4text FROM spatial_ref_sys where srid=31982"
	@echo "Tudo bem até aqui?  [ENTER para continuar ou ^C para rodar WS/ingest-step1]"
	@read _tudo_bem_
ifeq ('shp2sql','shp2sql')
	@echo Executando shp2pgsql ...
	cd $(sandbox);	shp2pgsql   -s 31982 "Ruas.shp" $(tabname) | psql -q $(pg_uri_db) 2> /dev/null
endif
ifeq ('shp2sql','csv2sql')
	@echo Executando csc2sql ...
	psql $(pg_uri_db) -c "SELECT ingest.fdw_generate_direct_csv( '$(sandbox)/Ruas.csv', '$(tabname)' )"
endif
	psql $(pg_uri_db) -c "SELECT ingest.any_load('shp2sql','$(sandbox)/Ruas','$(layername)','$(tabname)','$(fullPkID)','$(part3_file)',array['gid', 'NOME AS via_name', 'geom'])"
	@echo "Confira os resultados nas tabelas ingest.layer_file e ingest.feature_asis".
ifeq ('shp2sql','csv2sql')
	psql $(pg_uri_db) -c "DROP FOREIGN TABLE IF EXISTS $(tabname)"
endif
	@echo FIM.

via-clean: tabname = pk$(fullPkID)_p3_via
via-clean:
	rm -f "$(sandbox)/Ruas.*" || true
	psql $(pg_uri_db) -c "DROP TABLE IF EXISTS $(tabname) CASCADE"



## ## ## ## sponsored by Project AddressForAll
parcel: layername = parcel_full
parcel: tabname = pk$(fullPkID)_p1_parcel
parcel: makedirs $(part1_path)
	@# pk31_p1 - ETL extrating to PostgreSQL/PostGIS the "parcel" datatype (street axes)
	@echo
	@echo "------------------------------------------"
	@echo "------ Layer tipo $(layername)  ------"
	@echo "-- Incluindo dados do arquivo-1 do package-$(fullPkID) na base $(pg_db) --"
	@echo " Nome-hash do arquivo-1: $(part1_file)"
	@echo " Tabela do layer geoaddress sem nome de rua, só com numero predial: $(tabname)"
	@echo " Sub-arquivos do arquivo-1 com o conteúdo alvo: Lotes/lote.*"
	@echo " Tema dos sub-arquivos: $(part1_name)"
	@echo "Run with tmux and sudo! (DANGER: seems not idempotent on psql)"
	@whoami
	@printf "Above user is root? If not, you have permissions for all paths?\n [press ENTER for yes else ^C]"
	@read _press_enter_
	psql $(pg_uri_db) -c "DROP TABLE IF EXISTS $(tabname) CASCADE"
	@tput bold
	@echo Extracting ....
	@tput sgr0
	cd $(sandbox);  7z x -y  $(part1_path) "Lotes/lote.*" ; chmod -R a+rx . > /dev/null
	@echo "Conferindo se SRID 31982 esta configurado:"
	@psql $(pg_uri_db) -c "SELECT srid, proj4text FROM spatial_ref_sys where srid=31982"
	@echo "Tudo bem até aqui?  [ENTER para continuar ou ^C para rodar WS/ingest-step1]"
	@read _tudo_bem_
ifeq ('shp2sql','shp2sql')
	@echo Executando shp2pgsql ...
	cd $(sandbox);	shp2pgsql   -s 31982 "Lotes/lote.shp" $(tabname) | psql -q $(pg_uri_db) 2> /dev/null
endif
ifeq ('shp2sql','csv2sql')
	@echo Executando csc2sql ...
	psql $(pg_uri_db) -c "SELECT ingest.fdw_generate_direct_csv( '$(sandbox)/Lotes/lote.csv', '$(tabname)' )"
endif
	psql $(pg_uri_db) -c "CREATE VIEW vw1_$(tabname) AS SELECT gid, Tipo || ' ' || Logradouro AS via_name, Numero AS house_number, Bairro AS ns_name, geom FROM $(tabname)"
	psql $(pg_uri_db) -c "SELECT ingest.any_load('shp2sql','$(sandbox)/Lotes/lote','$(layername)','vw1_$(tabname)','$(fullPkID)','$(part1_file)',array[]::text[])"
	psql $(pg_uri_db) -c "DROP VIEW vw1_$(tabname)"
	@echo "Confira os resultados nas tabelas ingest.layer_file e ingest.feature_asis".
ifeq ('shp2sql','csv2sql')
	psql $(pg_uri_db) -c "DROP FOREIGN TABLE IF EXISTS $(tabname)"
endif
	@echo FIM.

parcel-clean: tabname = pk$(fullPkID)_p1_parcel
parcel-clean:
	rm -f "$(sandbox)/Lotes/lote.*" || true
	psql $(pg_uri_db) -c "DROP TABLE IF EXISTS $(tabname) CASCADE"


## ## ## ## sponsored by Project AddressForAll
block: layername = block_none
block: tabname = pk$(fullPkID)_p2_block
block: makedirs $(part2_path)
	@# pk31_p2 - ETL extrating to PostgreSQL/PostGIS the "block" datatype (street axes)
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
	@echo "Conferindo se SRID 31982 esta configurado:"
	@psql $(pg_uri_db) -c "SELECT srid, proj4text FROM spatial_ref_sys where srid=31982"
	@echo "Tudo bem até aqui?  [ENTER para continuar ou ^C para rodar WS/ingest-step1]"
	@read _tudo_bem_
ifeq ('shp2sql','shp2sql')
	@echo Executando shp2pgsql ...
	cd $(sandbox);	shp2pgsql   -s 31982 "Quadras.shp" $(tabname) | psql -q $(pg_uri_db) 2> /dev/null
endif
ifeq ('shp2sql','csv2sql')
	@echo Executando csc2sql ...
	psql $(pg_uri_db) -c "SELECT ingest.fdw_generate_direct_csv( '$(sandbox)/Quadras.csv', '$(tabname)' )"
endif
	psql $(pg_uri_db) -c "SELECT ingest.any_load('shp2sql','$(sandbox)/Quadras','$(layername)','$(tabname)','$(fullPkID)','$(part2_file)',array['gid', 'NumQuadra', 'geom'])"
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
	@cd $(orig); wget http://preserv.addressforall.org/download/51a6beb9fca43e0fb45727138982f7806b8df52fce53f5e0e31edd61bfbc21b9.rar
	@cd $(orig); wget http://preserv.addressforall.org/download/f4d3819f9853e85e43bf7a58de7f257eed5f63bcf36daed1c4db0f2701544adc.zip
	@cd $(orig); wget http://preserv.addressforall.org/download/9600dcba403c8dc0b066c8f429507e4672966a01c93119923f75361a6ebc64c0.zip
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

