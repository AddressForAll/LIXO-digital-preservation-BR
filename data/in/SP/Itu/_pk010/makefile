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
srid   =32723

pkid = 27
fullPkID=27_001
sandbox=$(sandbox_root)/_pk$(fullPkID)

## USER CONFIGS
pg_db  =ingest1
thisTplFile_root = digital-preservation-BR

## ## ## ## ## ## ##
## THIS_MAKE, _pk27

part1_file  =00f40e3731f0e04b8d1050a4716385f412aed5b32b560a47cc321ef4ea5413f8.rar
part1_name  =Lotes

part2_file  =258772459588f7941ac6eeda7c6839df02d58741cf6bc3e48825aecd60418251.zip
part2_name  =Bairros

part3_file  =c35e3b2825d3da122a74c6c8dd5f3157a3bd6201208d2a6d13dec433a6ded9fc.zip
part3_name  =Eixos

## COMPOSED VARS
pg_uri_db   =$(pg_uri)/$(pg_db)
part1_path  =$(orig)/$(part1_file)
part2_path  =$(orig)/$(part2_file)
part3_path  =$(orig)/$(part3_file)

all:
	@echo "=== Resumo deste makefile de recuperação de dados preservados ==="
	@printf "Targets para a geração de layers:\n\tall_layers geoaddress nsvia via \n"
	@printf "Demais targets implementados:\n\tclean wget_files me\n"
	@echo "A gereação de layers requer os seguintes comandos e versões:\n\t$(need_commands)"

all_layers: geoaddress nsvia via 
	@echo "--ALL LAYERS--"

## ## ## ## ## ## ## ## ##
## ## ## ## ## ## ## ## ##
## Make targets of the Project Digital Preservation

## ## ## ## sponsored by Project AddressForAll
geoaddress: layername = geoaddress_full
geoaddress: tabname = pk$(fullPkID)_p1_geoaddress
geoaddress: makedirs $(part1_path)
	@# pk27_p1 - ETL extrating to PostgreSQL/PostGIS the "geoaddress" datatype (point with house_number but no via name)
	@echo
	@echo "------------------------------------------"
	@echo "------ Layer tipo $(layername)  ------"
	@echo "-- Incluindo dados do arquivo-1 do package-$(fullPkID) na base $(pg_db) --"
	@echo " Nome-hash do arquivo-1: $(part1_file)"
	@echo " Tabela do layer geoaddress sem nome de rua, só com numero predial: $(tabname)"
	@echo " Sub-arquivos do arquivo-1 com o conteúdo alvo: lotes_Itu.*"
	@echo " Tema dos sub-arquivos: $(part1_name)"
	@echo "Run with tmux and sudo! (DANGER: seems not idempotent on psql)"
	@whoami
	@printf "Above user is root? If not, you have permissions for all paths?\n [press ENTER for yes else ^C]"
	@read _press_enter_
	psql $(pg_uri_db) -c "DROP TABLE IF EXISTS $(tabname) CASCADE"
	@tput bold
	@echo Extracting ....
	@tput sgr0
	cd $(sandbox);  7z x -y  $(part1_path) "lotes_Itu*" ; chmod -R a+rx . > /dev/null
	docker run --rm --network host -v $(sandbox):/tmp osgeo/gdal ogr2ogr -overwrite -f "PostgreSQL" PG:" dbname='$(pg_db)' host='localhost' port='5432' user='postgres'     " "/tmp/lotes_Itu.TAB"  -nln $(tabname)
	psql $(pg_uri_db) -c "SELECT ingest.any_load('ogr2ogr','$(sandbox)/lotes_Itu','$(layername)','$(tabname)','$(fullPkID)','$(part1_file)',array['ogc_fid AS gid', 'Bairro AS nsvia_name', 'Logradouro AS via_name', '"Número"', 'wkb_geometry AS geom'])"
	@echo "Confira os resultados nas tabelas ingest.layer_file e ingest.feature_asis".
ifeq ('ogr2ogr','csv2sql')
	psql $(pg_uri_db) -c "DROP FOREIGN TABLE IF EXISTS $(tabname)"
endif
	@echo FIM.

geoaddress-clean: tabname = pk$(fullPkID)_p1_geoaddress
geoaddress-clean:
	rm -f "$(sandbox)/lotes_Itu.*" || true
	psql $(pg_uri_db) -c "DROP TABLE IF EXISTS $(tabname) CASCADE"



## ## ## ## sponsored by Project AddressForAll
nsvia: layername = nsvia_full
nsvia: tabname = pk$(fullPkID)_p2_nsvia
nsvia: makedirs $(part2_path)
	@# pk27_p2 - ETL extrating to PostgreSQL/PostGIS the "nsvia" datatype (zone with name)
	@echo
	@echo "------------------------------------------"
	@echo "------ Layer tipo $(layername)  ------"
	@echo "-- Incluindo dados do arquivo-2 do package-$(fullPkID) na base $(pg_db) --"
	@echo " Nome-hash do arquivo-2: $(part2_file)"
	@echo " Tabela do layer geoaddress sem nome de rua, só com numero predial: $(tabname)"
	@echo " Sub-arquivos do arquivo-2 com o conteúdo alvo: Bairros_LC12112_16.*"
	@echo " Tema dos sub-arquivos: $(part2_name)"
	@echo "Run with tmux and sudo! (DANGER: seems not idempotent on psql)"
	@whoami
	@printf "Above user is root? If not, you have permissions for all paths?\n [press ENTER for yes else ^C]"
	@read _press_enter_
	psql $(pg_uri_db) -c "DROP TABLE IF EXISTS $(tabname) CASCADE"
	@tput bold
	@echo Extracting ....
	@tput sgr0
	cd $(sandbox);  7z x -y  $(part2_path) "Bairros_LC12112_16*" ; chmod -R a+rx . > /dev/null
	docker run --rm --network host -v $(sandbox):/tmp osgeo/gdal ogr2ogr -overwrite -f "PostgreSQL" PG:" dbname='$(pg_db)' host='localhost' port='5432' user='postgres'     " "/tmp/Bairros_LC12112_16"  -nln $(tabname)
	psql $(pg_uri_db) -c "CREATE VIEW vw2_$(tabname) AS SELECT row_number() OVER () as gid, * \
FROM ( \
  SELECT upper(trim(nome)) as nome, count(*) n, round(sum(st_area(geom))) area, \
         max(data_edica) dateModified, ST_UNION(geom) as geom \
  FROM $(tabname)\
  GROUP BY 1 ORDER BY 1 \
) t"
	psql $(pg_uri_db) -c "SELECT ingest.any_load('shp2sql','$(sandbox)/Bairros_LC12112_16','$(layername)','vw2_$(tabname)','$(fullPkID)','$(part2_file)',array[]::text[])"
	psql $(pg_uri_db) -c "DROP VIEW vw2_$(tabname)"
	@echo "Confira os resultados nas tabelas ingest.layer_file e ingest.feature_asis".
ifeq ('shp2sql','csv2sql')
	psql $(pg_uri_db) -c "DROP FOREIGN TABLE IF EXISTS $(tabname)"
endif
	@echo FIM.

nsvia-clean: tabname = pk$(fullPkID)_p2_nsvia
nsvia-clean:
	rm -f "$(sandbox)/Bairros_LC12112_16.*" || true
	psql $(pg_uri_db) -c "DROP TABLE IF EXISTS $(tabname) CASCADE;  DROP VIEW IF EXISTS vw_$(tabname) CASCADE;"



## ## ## ## sponsored by Project AddressForAll
via: layername = via_full
via: tabname = pk$(fullPkID)_p3_via
via: makedirs $(part3_path)
	@# pk27_p3 - ETL extrating to PostgreSQL/PostGIS the "via" datatype (street axes)
	@echo
	@echo "------------------------------------------"
	@echo "------ Layer tipo $(layername)  ------"
	@echo "-- Incluindo dados do arquivo-3 do package-$(fullPkID) na base $(pg_db) --"
	@echo " Nome-hash do arquivo-3: $(part3_file)"
	@echo " Tabela do layer geoaddress sem nome de rua, só com numero predial: $(tabname)"
	@echo " Sub-arquivos do arquivo-3 com o conteúdo alvo: EixosLogradouros.*"
	@echo " Tema dos sub-arquivos: $(part3_name)"
	@echo "Run with tmux and sudo! (DANGER: seems not idempotent on psql)"
	@whoami
	@printf "Above user is root? If not, you have permissions for all paths?\n [press ENTER for yes else ^C]"
	@read _press_enter_
	psql $(pg_uri_db) -c "DROP TABLE IF EXISTS $(tabname) CASCADE"
	@tput bold
	@echo Extracting ....
	@tput sgr0
	cd $(sandbox);  7z x -y  $(part3_path) "EixosLogradouros*" ; chmod -R a+rx . > /dev/null
	docker run --rm --network host -v $(sandbox):/tmp osgeo/gdal ogr2ogr -overwrite -f "PostgreSQL" PG:" dbname='$(pg_db)' host='localhost' port='5432' user='postgres'     " "/tmp/EixosLogradouros"  -nln $(tabname)
	psql $(pg_uri_db) -c "CREATE VIEW vw3_$(tabname) AS SELECT gid, CDIDECAT || iif(NMIDEPRE>'',' ' || NMIDEPRE,''::text) || ' ' || NMIDELOG AS via_name,\
       NRIMPINI, NRIMPFIN, NRPARINI, NRPARFIN, geom \
FROM $(tabname)"
	psql $(pg_uri_db) -c "SELECT ingest.any_load('shp2sql','$(sandbox)/EixosLogradouros','$(layername)','vw3_$(tabname)','$(fullPkID)','$(part3_file)',array[]::text[])"
	psql $(pg_uri_db) -c "DROP VIEW vw3_$(tabname)"
	@echo "Confira os resultados nas tabelas ingest.layer_file e ingest.feature_asis".
ifeq ('shp2sql','csv2sql')
	psql $(pg_uri_db) -c "DROP FOREIGN TABLE IF EXISTS $(tabname)"
endif
	@echo FIM.

via-clean: tabname = pk$(fullPkID)_p3_via
via-clean:
	rm -f "$(sandbox)/EixosLogradouros.*" || true
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
	@cd $(orig); wget http://preserv.addressforall.org/download/00f40e3731f0e04b8d1050a4716385f412aed5b32b560a47cc321ef4ea5413f8.rar
	@cd $(orig); wget http://preserv.addressforall.org/download/258772459588f7941ac6eeda7c6839df02d58741cf6bc3e48825aecd60418251.zip
	@cd $(orig); wget http://preserv.addressforall.org/download/c35e3b2825d3da122a74c6c8dd5f3157a3bd6201208d2a6d13dec433a6ded9fc.zip
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

