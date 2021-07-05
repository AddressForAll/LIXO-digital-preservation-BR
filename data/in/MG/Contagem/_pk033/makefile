##
## Template file reference: digital-preservation-BR/data/in/MG/Contagem/_pk033
## tplId: 033a
##
tplInputSchema_id=033a


## BASIC CONFIG
pg_io  =/tmp/pg_io
orig   =/var/www/preserv.addressforall.org/download
pg_uri =postgres://postgres@localhost
sandbox_root=/tmp/sandbox
need_commands= 7z v16+; ogr2ogr v3+ ; 
srid   =

pkid = 33
fullPkID=33_001
sandbox=$(sandbox_root)/_pk$(fullPkID)

## USER CONFIGS
pg_db  =ingest1
thisTplFile_root = digital-preservation-BR

## ## ## ## ## ## ##
## THIS_MAKE, _pk33

part1_file  =058a6022054e8b3f9ba81f25f7511b58cbd4ad616b0510033b917f3f7f9f23d5.rar
part1_name  =GDB Geodatabase

## COMPOSED VARS
pg_uri_db   =$(pg_uri)/$(pg_db)
part1_path  =$(orig)/$(part1_file)

all:
	@echo "=== Resumo deste makefile de recuperação de dados preservados ==="
	@printf "Targets para a geração de layers:\n\tall_layers nsvia via geoaddress parcel genericvia \n"
	@printf "Demais targets implementados:\n\tclean wget_files me\n"
	@echo "A gereação de layers requer os seguintes comandos e versões:\n\t$(need_commands)"

all_layers: nsvia via geoaddress parcel genericvia 
	@echo "--ALL LAYERS--"

## ## ## ## ## ## ## ## ##
## ## ## ## ## ## ## ## ##
## Make targets of the Project Digital Preservation

## ## ## ## sponsored by Project AddressForAll
geoaddress: layername = geoaddress_full
geoaddress: tabname = pk$(fullPkID)_p1_geoaddress
geoaddress: makedirs $(part1_path)
	@# pk33_p1 - ETL extrating to PostgreSQL/PostGIS the "geoaddress" datatype (point with house_number but no via name)
	@echo
	@echo "------------------------------------------"
	@echo "------ Layer tipo $(layername)  ------"
	@echo "-- Incluindo dados do arquivo-1 do package-$(fullPkID) na base $(pg_db) --"
	@echo " Nome-hash do arquivo-1: $(part1_file)"
	@echo " Tabela do layer geoaddress sem nome de rua, só com numero predial: $(tabname)"
	@echo " Sub-arquivos do arquivo-1 com o conteúdo alvo: OpenStreetMap.gdb.*"
	@echo " Tema dos sub-arquivos: $(part1_name)"
	@echo "Run with tmux and sudo! (DANGER: seems not idempotent on psql)"
	@whoami
	@printf "Above user is root? If not, you have permissions for all paths?\n [press ENTER for yes else ^C]"
	@read _press_enter_
	psql $(pg_uri_db) -c "DROP TABLE IF EXISTS $(tabname) CASCADE"
	@tput bold
	@echo Extracting ....
	@tput sgr0
	cd $(sandbox);  7z x -y  $(part1_path) "OpenStreetMap.gdb*" ; chmod -R a+rx . > /dev/null
	docker run --rm --network host -v $(sandbox):/tmp osgeo/gdal ogr2ogr -overwrite -f "PostgreSQL" PG:" dbname='$(pg_db)' host='localhost' port='5432' user='postgres'     " "/tmp/OpenStreetMap.gdb" Endereco -nln $(tabname)
	psql $(pg_uri_db) -c "SELECT ingest.any_load('ogr2ogr','$(sandbox)/OpenStreetMap.gdb','$(layername)','$(tabname)','$(fullPkID)','$(part1_file)',array['objectid AS gid', 'ident_logr', 'nome_logra AS via_name', 'num_imovel AS house_number', 'shape AS geom'])"
	@echo "Confira os resultados nas tabelas ingest.layer_file e ingest.feature_asis".
ifeq ('ogr2ogr','csv2sql')
	psql $(pg_uri_db) -c "DROP FOREIGN TABLE IF EXISTS $(tabname)"
endif
	@echo FIM.

geoaddress-clean: tabname = pk$(fullPkID)_p1_geoaddress
geoaddress-clean:
	rm -f "$(sandbox)/OpenStreetMap.gdb.*" || true
	psql $(pg_uri_db) -c "DROP TABLE IF EXISTS $(tabname) CASCADE"



## ## ## ## sponsored by Project AddressForAll
nsvia: layername = nsvia_full
nsvia: tabname = pk$(fullPkID)_p1_nsvia
nsvia: makedirs $(part1_path)
	@# pk33_p1 - ETL extrating to PostgreSQL/PostGIS the "nsvia" datatype (zone with name)
	@echo
	@echo "------------------------------------------"
	@echo "------ Layer tipo $(layername)  ------"
	@echo "-- Incluindo dados do arquivo-1 do package-$(fullPkID) na base $(pg_db) --"
	@echo " Nome-hash do arquivo-1: $(part1_file)"
	@echo " Tabela do layer geoaddress sem nome de rua, só com numero predial: $(tabname)"
	@echo " Sub-arquivos do arquivo-1 com o conteúdo alvo: OpenStreetMap.gdb.*"
	@echo " Tema dos sub-arquivos: $(part1_name)"
	@echo "Run with tmux and sudo! (DANGER: seems not idempotent on psql)"
	@whoami
	@printf "Above user is root? If not, you have permissions for all paths?\n [press ENTER for yes else ^C]"
	@read _press_enter_
	psql $(pg_uri_db) -c "DROP TABLE IF EXISTS $(tabname) CASCADE"
	@tput bold
	@echo Extracting ....
	@tput sgr0
	cd $(sandbox);  7z x -y  $(part1_path) "OpenStreetMap.gdb*" ; chmod -R a+rx . > /dev/null
	docker run --rm --network host -v $(sandbox):/tmp osgeo/gdal ogr2ogr -overwrite -f "PostgreSQL" PG:" dbname='$(pg_db)' host='localhost' port='5432' user='postgres'     " "/tmp/OpenStreetMap.gdb" Bairros -nln $(tabname)
	psql $(pg_uri_db) -c "SELECT ingest.any_load('ogr2ogr','$(sandbox)/OpenStreetMap.gdb','$(layername)','$(tabname)','$(fullPkID)','$(part1_file)',array['gid', 'Teste2_P_1 AS namespace_name', 'geom'])"
	@echo "Confira os resultados nas tabelas ingest.layer_file e ingest.feature_asis".
ifeq ('ogr2ogr','csv2sql')
	psql $(pg_uri_db) -c "DROP FOREIGN TABLE IF EXISTS $(tabname)"
endif
	@echo FIM.

nsvia-clean: tabname = pk$(fullPkID)_p1_nsvia
nsvia-clean:
	rm -f "$(sandbox)/OpenStreetMap.gdb.*" || true
	psql $(pg_uri_db) -c "DROP TABLE IF EXISTS $(tabname) CASCADE;  DROP VIEW IF EXISTS vw_$(tabname) CASCADE;"



## ## ## ## sponsored by Project AddressForAll
via: layername = via_full
via: tabname = pk$(fullPkID)_p1_via
via: makedirs $(part1_path)
	@# pk33_p1 - ETL extrating to PostgreSQL/PostGIS the "via" datatype (street axes)
	@echo
	@echo "------------------------------------------"
	@echo "------ Layer tipo $(layername)  ------"
	@echo "-- Incluindo dados do arquivo-1 do package-$(fullPkID) na base $(pg_db) --"
	@echo " Nome-hash do arquivo-1: $(part1_file)"
	@echo " Tabela do layer geoaddress sem nome de rua, só com numero predial: $(tabname)"
	@echo " Sub-arquivos do arquivo-1 com o conteúdo alvo: OpenStreetMap.gdb.*"
	@echo " Tema dos sub-arquivos: $(part1_name)"
	@echo "Run with tmux and sudo! (DANGER: seems not idempotent on psql)"
	@whoami
	@printf "Above user is root? If not, you have permissions for all paths?\n [press ENTER for yes else ^C]"
	@read _press_enter_
	psql $(pg_uri_db) -c "DROP TABLE IF EXISTS $(tabname) CASCADE"
	@tput bold
	@echo Extracting ....
	@tput sgr0
	cd $(sandbox);  7z x -y  $(part1_path) "OpenStreetMap.gdb*" ; chmod -R a+rx . > /dev/null
	docker run --rm --network host -v $(sandbox):/tmp osgeo/gdal ogr2ogr -overwrite -f "PostgreSQL" PG:" dbname='$(pg_db)' host='localhost' port='5432' user='postgres'     " "/tmp/OpenStreetMap.gdb" Logradouros -nln $(tabname)
	psql $(pg_uri_db) -c "SELECT ingest.any_load('','$(sandbox)/OpenStreetMap.gdb','$(layername)','$(tabname)','$(fullPkID)','$(part1_file)',array['gid', 'TIPO_LOGRA', 'geom'])"
	@echo "Confira os resultados nas tabelas ingest.layer_file e ingest.feature_asis".
ifeq ('','csv2sql')
	psql $(pg_uri_db) -c "DROP FOREIGN TABLE IF EXISTS $(tabname)"
endif
	@echo FIM.

via-clean: tabname = pk$(fullPkID)_p1_via
via-clean:
	rm -f "$(sandbox)/OpenStreetMap.gdb.*" || true
	psql $(pg_uri_db) -c "DROP TABLE IF EXISTS $(tabname) CASCADE"



## ## ## ## sponsored by Project AddressForAll
parcel: layername = parcel_ext
parcel: tabname = pk$(fullPkID)_p1_parcel
parcel: makedirs $(part1_path)
	@# pk33_p1 - ETL extrating to PostgreSQL/PostGIS the "parcel" datatype (street axes)
	@echo
	@echo "------------------------------------------"
	@echo "------ Layer tipo $(layername)  ------"
	@echo "-- Incluindo dados do arquivo-1 do package-$(fullPkID) na base $(pg_db) --"
	@echo " Nome-hash do arquivo-1: $(part1_file)"
	@echo " Tabela do layer geoaddress sem nome de rua, só com numero predial: $(tabname)"
	@echo " Sub-arquivos do arquivo-1 com o conteúdo alvo: OpenStreetMap.gdb.*"
	@echo " Tema dos sub-arquivos: $(part1_name)"
	@echo "Run with tmux and sudo! (DANGER: seems not idempotent on psql)"
	@whoami
	@printf "Above user is root? If not, you have permissions for all paths?\n [press ENTER for yes else ^C]"
	@read _press_enter_
	psql $(pg_uri_db) -c "DROP TABLE IF EXISTS $(tabname) CASCADE"
	@tput bold
	@echo Extracting ....
	@tput sgr0
	cd $(sandbox);  7z x -y  $(part1_path) "OpenStreetMap.gdb*" ; chmod -R a+rx . > /dev/null
	docker run --rm --network host -v $(sandbox):/tmp osgeo/gdal ogr2ogr -overwrite -f "PostgreSQL" PG:" dbname='$(pg_db)' host='localhost' port='5432' user='postgres'     " "/tmp/OpenStreetMap.gdb" Lotes -nln $(tabname)
	psql $(pg_uri_db) -c "SELECT ingest.any_load('ogr2ogr','$(sandbox)/OpenStreetMap.gdb','$(layername)','$(tabname)','$(fullPkID)','$(part1_file)',array['gid', 'BAIRRO AS namespace_name', 'geom'])"
	@echo "Confira os resultados nas tabelas ingest.layer_file e ingest.feature_asis".
ifeq ('ogr2ogr','csv2sql')
	psql $(pg_uri_db) -c "DROP FOREIGN TABLE IF EXISTS $(tabname)"
endif
	@echo FIM.

parcel-clean: tabname = pk$(fullPkID)_p1_parcel
parcel-clean:
	rm -f "$(sandbox)/OpenStreetMap.gdb.*" || true
	psql $(pg_uri_db) -c "DROP TABLE IF EXISTS $(tabname) CASCADE"



## ## ## ## sponsored by Project AddressForAll
genericvia: layername = genericvia_full
genericvia: tabname = pk$(fullPkID)_p1_genericvia
genericvia: makedirs $(part1_path)
	@# pk33_p1 - ETL extrating to PostgreSQL/PostGIS the "genericvia" datatype (lots and blocks)
	@echo
	@echo "------------------------------------------"
	@echo "------ Layer tipo $(layername)  ------"
	@echo "-- Incluindo dados do arquivo-1 do package-$(fullPkID) na base $(pg_db) --"
	@echo " Nome-hash do arquivo-1: $(part1_file)"
	@echo " Tabela do layer geoaddress sem nome de rua, só com numero predial: $(tabname)"
	@echo " Sub-arquivos do arquivo-1 com o conteúdo alvo: OpenStreetMap.gdb.*"
	@echo " Tema dos sub-arquivos: $(part1_name)"
	@echo "Run with tmux and sudo! (DANGER: seems not idempotent on psql)"
	@whoami
	@printf "Above user is root? If not, you have permissions for all paths?\n [press ENTER for yes else ^C]"
	@read _press_enter_
	psql $(pg_uri_db) -c "DROP TABLE IF EXISTS $(tabname) CASCADE"
	@tput bold
	@echo Extracting ....
	@tput sgr0
	cd $(sandbox);  7z x -y  $(part1_path) "OpenStreetMap.gdb*" ; chmod -R a+rx . > /dev/null
	docker run --rm --network host -v $(sandbox):/tmp osgeo/gdal ogr2ogr -overwrite -f "PostgreSQL" PG:" dbname='$(pg_db)' host='localhost' port='5432' user='postgres'     " "/tmp/OpenStreetMap.gdb" Quadras -nln $(tabname)
	psql $(pg_uri_db) -c "SELECT ingest.any_load('ogr2ogr','$(sandbox)/OpenStreetMap.gdb','$(layername)','$(tabname)','$(fullPkID)','$(part1_file)',array['gid', 'QUADRA AS genericvia_number', 'geom'])"
	@echo "Confira os resultados nas tabelas ingest.layer_file e ingest.feature_asis".
ifeq ('ogr2ogr','csv2sql')
	psql $(pg_uri_db) -c "DROP FOREIGN TABLE IF EXISTS $(tabname)"
endif
	@echo FIM.

genericvia-clean: tabname = pk$(fullPkID)_p1_genericvia
genericvia-clean:
	rm -f "$(sandbox)/OpenStreetMap.gdb.*" || true
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
	@cd $(orig); wget http://preserv.addressforall.org/download/058a6022054e8b3f9ba81f25f7511b58cbd4ad616b0510033b917f3f7f9f23d5.rar
	@echo "Please, if orig not default, run 'make _target_ orig=$(orig)'"


## ## ## ##

clean_sandbox:
	@rm -rf $(sandbox) || true

clean: geoaddress-clean nsvia-clean via-clean


## ############################
## SELF-GENERATE MAKE (make me)
##

thisTplFile  = digital-preservation-BR/src/maketemplates/make_ref033a.mustache.mk
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

