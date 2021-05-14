##
## Template file reference: digital-preservation-BR/data/in/RS/PortoAlegre/_pk027
##

## BASIC CONFIGS
pg_io  =/tmp/pg_io
orig   =/var/www/preserv.addressforall.org/download
pg_uri =postgres://postgres@localhost
sandbox_root=/tmp/sandbox

pkid = 27
fullPkID=27_2
sandbox=$(sandbox_root)/_pk$(fullPkID)

## USER CONFIGS
pg_db  =ingest1
thisTplFile_root = digital-preservation-BR

## ## ## ## ## ## ##
## THIS_MAKE, _pk27

need_commands   ="7z psql shp2pgsql" # and a prepared database ingest1

part1_file  =fbc62efdbd0f16a7db03b5b775c50c9425367a8dee8a85d9b53e4475bbdb99d2.zip
part1_name  =Imóveis

part2_file  =258772459588f7941ac6eeda7c6839df02d58741cf6bc3e48825aecd60418251.zip
part2_name  =Bairros

part3_file  =c35e3b2825d3da122a74c6c8dd5f3157a3bd6201208d2a6d13dec433a6ded9fc.zip
part3_name  =Eixos de via

## COMPOSED VARS
pg_uri_db   =$(pg_uri)/$(pg_db)
part1_path  =$(orig)/$(part1_file)
part2_path  =$(orig)/$(part2_file)
part3_path  =$(orig)/$(part3_file)


all:
	@echo Requer comandos $(need_commands)
	@echo Principais targets implementados neste makefile:
	@echo geoaddress-novia namespace-full 

## ## ## ## ## ## ## ## ##
## Make targets of the Project AddressForAll
## man at https://github.com/AddressForAll/digital-preservation/wiki/makefile-generator

makedirs: clean_sandbox
	@mkdir -p $(sandbox_root)
	@mkdir -p $(sandbox)
	@mkdir -p $(pg_io)


geoaddress-novia: tabname = pk$(fullPkID)_p1_geoaddress
geoaddress-novia: makedirs
	@# pk27_p1 - ETL extrating to PostgreSQL/PostGIS the "geoaddress-novia" datatype (point with house_number but no via name)
	@echo
	@echo "-- Incluindo dados tipo geoaddress-novia do arquivo-1 do package-$(fullPkID) na base $(pg_db) --"
	@echo " Tema do arquivo-1: $(part1_name)"
	@echo " Hash do arquivo-1: $(part1_file)"
	@echo " Tabela do layer geoaddress sem nome de rua, só com numero predial: $(tabname)"
	@echo " Parte do arquivo que representa a tabela: $(part1_path)"
	@echo "Run with tmux and sudo! (DANGER: seems not idempotent on psql)"
	@whoami
	@printf "Above user is root? If not, you have permissions for all paths?\n [press ENTER for yes else ^C]"
	@read _press_enter_
	psql $(pg_uri_db) -c "DROP TABLE IF EXISTS $(tabname) CASCADE"
	@tput bold
	@echo Extraindo ....
	@tput sgr0
	cd $(sandbox);  7z e -y  $(part1_path) NRO_IMOVEL.* > /dev/null
	@echo "Conferindo se SRID esta configurado:"
	@psql $(pg_uri_db) -c "SELECT srid, proj4text FROM spatial_ref_sys where srid=952013"
	@echo "Tudo bem até aqui?  [ENTER para continuar ou ^C para rodar WS/ingest-step1]"
	@read _tudo_bem_
	@echo Executando shp2pgsql ...
	cd $(sandbox);	shp2pgsql -s 952013 NRO_IMOVEL.shp $(tabname) | psql -q $(pg_uri_db) 2> /dev/null
	# assert das assinaturas precisa ser baseado em diff, ideal ter um shell ou python para isso, gerando erro se não bater.
	# falta tabem usar funcao que gera assinatura conforme tipo de dado  postado.
	#psql $(pg_uri_db) -c "SELECT ingest.getmeta_to_file('NRO_IMOVEL.shp','geoaddress-novia',$(pkid))"
	psql $(pg_uri_db) -c "SELECT ingest.any_load('$(sandbox)/NRO_IMOVEL.shp','geoaddress_none','$(tabname)',$(pkid),array['gid','textstring'])"
	@echo FIM.

geoaddress-novia-clean:
	rm -f $(sandbox)/NRO_IMOVEL.* || true
	psql $(pg_uri_db) -c "DROP TABLE IF EXISTS $(tabname) CASCADE"


namespace-full: sandbox
	@echo ok!


clean_sandbox:
	@rm -rf $(sandbox)


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

