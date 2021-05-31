##
## Template file reference: digital-preservation-BR/data/in/RS/PortoAlegre/_pk027
##

## BASIC CONFIG
pg_io  =/tmp/pg_io
orig   =/var/www/preserv.addressforall.org/download
pg_uri =postgres://postgres@localhost
sandbox_root=/tmp/sandbox

pkid = 27
fullPkID=27_1
sandbox=$(sandbox_root)/_pk$(fullPkID)

## USER CONFIGS
pg_db  =ingest1
thisTplFile_root = digital-preservation-BR

## ## ## ## ## ## ##
## THIS_MAKE, _pk27

need_commands   ="7z psql shp2pgsql" # and a prepared database ingest1

part1_file  =51a6beb9fca43e0fb45727138982f7806b8df52fce53f5e0e31edd61bfbc21b9.rar
part1_name  =Lotes

part2_file  =f4d3819f9853e85e43bf7a58de7f257eed5f63bcf36daed1c4db0f2701544adc.zip
part2_name  =Eixos

part3_file  =9600dcba403c8dc0b066c8f429507e4672966a01c93119923f75361a6ebc64c0.zip
part3_name  =Bairros

part4_file  =9600dcba403c8dc0b066c8f429507e4672966a01c93119923f75361a6ebc64c0.zip
part4_name  =Quadras

## COMPOSED VARS
pg_uri_db   =$(pg_uri)/$(pg_db)
part1_path  =$(orig)/$(part1_file)
part2_path  =$(orig)/$(part2_file)
part3_path  =$(orig)/$(part3_file)
part4_path  =$(orig)/$(part4_file)


all:
	@echo "Requer comandos $(need_commands)."
	@echo "Targets implementados no all_layers:"
	@echo " geoaddress_none via_full nsvia_full"
	@echo "Targets opcionais e ferramentas: me wget_files clean"

all_layers: geoaddress_none via_full nsvia_full
	@echo "--ALL LAYERS--"


## ## ## ## ## ## ## ## ##
## Make targets of the Project AddressForAll
## man at https://github.com/AddressForAll/digital-preservation/wiki/makefile-generator

makedirs: clean_sandbox
	@mkdir -p $(sandbox_root)
	@mkdir -p $(sandbox)
	@mkdir -p $(pg_io)

 ## ## ## ##

geoaddress_none: layername = geoaddress_none
geoaddress_none: tabname = pk$(fullPkID)_p1_geoaddress
geoaddress_none: makedirs $(part1_path)
	@# pk27_p1 - ETL extrating to PostgreSQL/PostGIS the "geoaddress_none" datatype (point with house_number but no via name)
	@echo
	@echo "------------------------------------------"
	@echo "------ Layer tipo $(layername)  ------"
	@echo "-- Incluindo dados do arquivo-1 do package-$(fullPkID) na base $(pg_db) --"
	@echo " Tema do arquivo-1: $(part1_name)"
	@echo " Nome-hash do arquivo-1: $(part1_file)"
	@echo " Tabela do layer geoaddress sem nome de rua, só com numero predial: $(tabname)"
	@echo " Sub-arquivos do arquivo-1 com o conteúdo alvo: NRO_IMOVEL.*"
	@echo "Run with tmux and sudo! (DANGER: seems not idempotent on psql)"
	@whoami
	@printf "Above user is root? If not, you have permissions for all paths?\n [press ENTER for yes else ^C]"
	@read _press_enter_
	psql $(pg_uri_db) -c "DROP TABLE IF EXISTS $(tabname) CASCADE"
	@tput bold
	@echo Extracting ....
	@tput sgr0
	cd $(sandbox);  7z e -y  $(part1_path) NRO_IMOVEL.* > /dev/null
	@echo "Conferindo se SRID 31982 esta configurado:"
	@psql $(pg_uri_db) -c "SELECT srid, proj4text FROM spatial_ref_sys where srid=31982"
	@echo "Tudo bem até aqui?  [ENTER para continuar ou ^C para rodar WS/ingest-step1]"
	@read _tudo_bem_
	@echo Executando shp2pgsql ...
	cd $(sandbox);	shp2pgsql -s 31982 NRO_IMOVEL.shp $(tabname) | psql -q $(pg_uri_db) 2> /dev/null
	psql $(pg_uri_db) -c "SELECT ingest.any_load('$(sandbox)/NRO_IMOVEL.shp','$(layername)','$(tabname)','$(fullPkID)',array['gid', 'textstring as house_number', 'setor', 'last_edi_1 as dateModified', 'geom'])"
	@echo "Confira os resultados nas tabelas ingest.layer_file e ingest.feature_asis".
	@echo FIM.

geoaddress_none-clean:
	rm -f $(sandbox)/NRO_IMOVEL.* || true
	psql $(pg_uri_db) -c "DROP TABLE IF EXISTS $(tabname) CASCADE"



 ## ## ## ##

nsvia_full: layername = nsvia_full
nsvia_full: tabname = pk$(fullPkID)_p2_namespace
nsvia_full: makedirs $(part2_path)
	@# pk27_p2 - ETL extrating to PostgreSQL/PostGIS the "nsvia_full" datatype (zone with name)
	@echo
	@echo "------------------------------------------"
	@echo "------ Layer tipo $(layername)  ------"
	@echo "-- Incluindo dados do arquivo-2 do package-$(fullPkID) na base $(pg_db) --"
	@echo " Tema do arquivo-2: $(part2_name)"
	@echo " Nome-hash do arquivo-2: $(part2_file)"
	@echo " Tabela do layer geoaddress sem nome de rua, só com numero predial: $(tabname)"
	@echo " Sub-arquivos do arquivo-2 com o conteúdo alvo: Bairros_LC12112_16.*"
	@echo "Run with tmux and sudo! (DANGER: seems not idempotent on psql)"
	@whoami
	@printf "Above user is root? If not, you have permissions for all paths?\n [press ENTER for yes else ^C]"
	@read _press_enter_
	psql $(pg_uri_db) -c "DROP TABLE IF EXISTS $(tabname) CASCADE"
	@tput bold
	@echo Extracting ....
	@tput sgr0
	cd $(sandbox);  7z e -y  $(part2_path) Bairros_LC12112_16.* > /dev/null
	@echo "Conferindo se SRID 31982 esta configurado:"
	@psql $(pg_uri_db) -c "SELECT srid, proj4text FROM spatial_ref_sys where srid=31982"
	@echo "Tudo bem até aqui?  [ENTER para continuar ou ^C para rodar WS/ingest-step1]"
	@read _tudo_bem_
	@echo Executando shp2pgsql ...
	cd $(sandbox);	shp2pgsql -s 31982 Bairros_LC12112_16.shp $(tabname) | psql -q $(pg_uri_db) 2> /dev/null
	psql $(pg_uri_db) -c "CREATE VIEW vw_$(tabname) AS \
  SELECT row_number() OVER () as gid, * \
  FROM ( \
    SELECT upper(trim(nome)) as nome, count(*) n, round(sum(st_area(geom))) area, \
           max(data_edica) dateModified, ST_UNION(geom) as geom \
    FROM $(tabname)\
    GROUP BY 1 ORDER BY 1 \
  ) t"
	psql $(pg_uri_db) -c "SELECT ingest.any_load('$(sandbox)/Bairros_LC12112_16.shp','$(layername)','vw_$(tabname)','$(fullPkID)',array[]::text[])"
	psql $(pg_uri_db) -c "DROP VIEW vw_$(tabname)"
	@echo "Confira os resultados nas tabelas ingest.layer_file e ingest.feature_asis".
	@echo FIM.

nsvia_full-clean: tabname = pk$(fullPkID)_p2_namespace
nsvia_full-clean:
	rm -f $(sandbox)/Bairros_LC12112_16.* || true
	psql $(pg_uri_db) -c "DROP TABLE IF EXISTS $(tabname) CASCADE;  DROP VIEW IF EXISTS vw_$(tabname) CASCADE;"



 ## ## ## ##
via_full: layername = via_full
via_full: tabname = pk$(fullPkID)_p3_via
via_full: makedirs $(part3_path)
	@# pk27_p3 - ETL extrating to PostgreSQL/PostGIS the "via_full" datatype (street axes)
	@echo
	@echo "------------------------------------------"
	@echo "------ Layer tipo $(layername)  ------"
	@echo "-- Incluindo dados do arquivo-3 do package-$(fullPkID) na base $(pg_db) --"
	@echo " Tema do arquivo-3: $(part3_name)"
	@echo " Nome-hash do arquivo-3: $(part3_file)"
	@echo " Tabela do layer geoaddress sem nome de rua, só com numero predial: $(tabname)"
	@echo " Sub-arquivos do arquivo-3 com o conteúdo alvo: EixosLogradouros.*"
	@echo "Run with tmux and sudo! (DANGER: seems not idempotent on psql)"
	@whoami
	@printf "Above user is root? If not, you have permissions for all paths?\n [press ENTER for yes else ^C]"
	@read _press_enter_
	psql $(pg_uri_db) -c "DROP TABLE IF EXISTS $(tabname) CASCADE"
	@tput bold
	@echo Extracting ....
	@tput sgr0
	cd $(sandbox);  7z e -y  $(part3_path) EixosLogradouros.* > /dev/null
	@echo "Conferindo se SRID 31982 esta configurado:"
	@psql $(pg_uri_db) -c "SELECT srid, proj4text FROM spatial_ref_sys where srid=31982"
	@echo "Tudo bem até aqui?  [ENTER para continuar ou ^C para rodar WS/ingest-step1]"
	@read _tudo_bem_
	@echo Executando shp2pgsql ...
	cd $(sandbox);	shp2pgsql -s 31982 EixosLogradouros.shp $(tabname) | psql -q $(pg_uri_db) 2> /dev/null
	psql $(pg_uri_db) -c "CREATE VIEW vw_$(tabname) AS \
  SELECT gid, CDIDECAT || iif(NMIDEPRE>'',' ' || NMIDEPRE,''::text) || ' ' || NMIDELOG AS via_name,\
         NRIMPINI, NRIMPFIN, NRPARINI, NRPARFIN, geom \
  FROM $(tabname)"
	psql $(pg_uri_db) -c "SELECT ingest.any_load('$(sandbox)/EixosLogradouros.shp','$(layername)','vw_$(tabname)','$(fullPkID)',array[]::text[])"
	psql $(pg_uri_db) -c "DROP VIEW vw_$(tabname)"
	@echo "Confira os resultados nas tabelas ingest.layer_file e ingest.feature_asis".
	@echo FIM.

via_full-clean:
	rm -f $(sandbox)/EixosLogradouros.* || true
	psql $(pg_uri_db) -c "DROP TABLE IF EXISTS $(tabname) CASCADE"





## ## ## ##
wget_files:
	@echo "Under construction, need to check that orig path is not /var/www! or use orig=x [ENTER if not else ^C]"
	@echo $(orig)
	@read _ENTER_OK_
	mkdir -p $(orig)
	@cd $(orig); wget http://preserv.addressforall.org/download/51a6beb9fca43e0fb45727138982f7806b8df52fce53f5e0e31edd61bfbc21b9.rar
	@cd $(orig); wget http://preserv.addressforall.org/download/f4d3819f9853e85e43bf7a58de7f257eed5f63bcf36daed1c4db0f2701544adc.zip
	@cd $(orig); wget http://preserv.addressforall.org/download/9600dcba403c8dc0b066c8f429507e4672966a01c93119923f75361a6ebc64c0.zip
	@cd $(orig); wget http://preserv.addressforall.org/download/9600dcba403c8dc0b066c8f429507e4672966a01c93119923f75361a6ebc64c0.zip
	@echo "Please, if orig not default, run 'make _target_ orig=$(orig)'"


## ## ## ##

clean_sandbox:
	@rm -rf $(sandbox) || true

clean: geoaddress_none-clean nsvia_full-clean via_full-clean


## ############################
## SELF-GENERATE MAKE (make me)
##

thisTplFile = digital-preservation-BR/src/maketemplates/make_ref027a.mustache.mk

baseSrc      = /opt/gits/_a4a
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

