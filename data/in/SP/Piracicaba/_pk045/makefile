
# PWD:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
pg_io  =/tmp/pg_io
ori    =/var/www/preserv.addressforall.org/download
pg_uri ="postgres://postgres@localhost/ingest1"

CAD_DE_IMOVEIS_ZIP =$(ori)/f40eeaa6fe4f78e52be084392cc9c04d07a95112f7fb2acaf3210fd23fbdf4a8.zip
CAD_DE_IMOVEIS     =Cadastro de Imoveis

QUADRAS_ZIP        =$(ori)/23f703b7d1611ea29f53fe3bd2617a5939fe96d21453004838d7fe61064dae45.zip 
QUADRAS            =Quadras

BAIRROS_ZIP        =$(ori)/2137f68df828ce00c276a38b969cd651efcc2f8300f9fb4a716b6fd10019862f.zip
BAIRROS            =Bairros


all:
	@echo Favor consultar as opcoes de target

etl_toPgis_bairros:
# ETL extrating to PostgreSQL/PostGIS the "bairros" datatype (point and house number)
	@echo "Creating table ingest.pk045_bairros on PostGIS"
	@whoami
	@echo "Run with tmux and sudo! (DANGER: seems not idempotent on psql)"
	mkdir -p $(pg_io)
	psql $(pg_uri) -c "drop table if exists bairros cascade; drop table if exists ingest.pk045_bairros cascade;"
	@tput bold
	@echo Extraindo ....
	@tput sgr0
	cd $(pg_io) ; 7z e -y  $(BAIRROS_ZIP) "$(BAIRROS).*" > /dev/null
	@echo "Conferindo se SRID esta configurado:"
	@echo Executando shp2pgsql ...
	@( cd $(pg_io) ; shp2pgsql -s 4326 "$(BAIRROS).shp" bairros | psql -q $(pg_uri) 2> /dev/null  )
	@echo "Conferira se bate o perfil:   71 |  0.00 |  0.00 |  0.00 |     0.00 "
	psql $(pg_uri) -c "SELECT count(*) n, round(max(a),2) a_max, round(min(a),2) a_min, round(avg(a),2) a_avg, round(percentile_disc(0.5) WITHIN GROUP ( ORDER BY a),2) a_median FROM ( select  st_area(geom) a from bairros ) t"
	psql $(pg_uri) -c "CREATE TABLE ingest.pk045_bairros AS select gid, bairro, ST_centroid(ST_Transform(geom,4326)) as geom FROM bairros"
	@echo Limpando...
	rm '$(pg_io)/$(BAIRROS)'.*
	psql $(pg_uri) -c "drop table bairros cascade"
	@echo FIM.

etl_toPgis_quadras:
# ETL extrating to PostgreSQL/PostGIS the "quadras" datatype (point and house number)
	@echo "Creating table ingest.pk045_quadras on PostGIS"
	@whoami
	@echo "Run with tmux and sudo! (DANGER: seems not idempotent on psql)"
	mkdir -p $(pg_io)
	psql $(pg_uri) -c "drop table if exists quadras cascade; drop table if exists ingest.pk045_quadras cascade;"
	@tput bold
	@echo Extraindo ....
	@tput sgr0
	cd $(pg_io) ; 7z e -y  $(QUADRAS_ZIP) "$(QUADRAS).*" > /dev/null
	@echo "Conferindo se SRID esta configurado:"
	@echo Executando shp2pgsql ...
	@( cd $(pg_io) ; shp2pgsql -s 4326 "$(QUADRAS).shp" quadras | psql -q $(pg_uri) 2> /dev/null  )
	@echo "Conferira se bate o perfil:  7216 |  0.00 |  0.00 |  0.00 |     0.00"
	psql $(pg_uri) -c "SELECT count(*) n, round(max(a),2) a_max, round(min(a),2) a_min, round(avg(a),2) a_avg, round(percentile_disc(0.5) WITHIN GROUP ( ORDER BY a),2) a_median FROM ( select  st_area(geom) a from quadras ) t"
	psql $(pg_uri) -c "CREATE TABLE ingest.pk045_quadras AS select gid, chave_qd, ST_centroid(ST_Transform(geom,4326)) as geom FROM quadras"
	@echo Limpando...
	rm '$(pg_io)/$(QUADRAS)'.*
	psql $(pg_uri) -c "drop table quadras cascade"
	@echo FIM.

etl_toPgis_cad_de_imoveis:
# ETL extrating to PostgreSQL/PostGIS the "cad_de_imoveis" datatype (point and house number)
	@echo "Creating table ingest.pk045_cad_de_imoveis on PostGIS"
	@whoami
	@echo "Run with tmux and sudo! (DANGER: seems not idempotent on psql)"
	mkdir -p $(pg_io)
	psql $(pg_uri) -c "drop table if exists cad_de_imoveis cascade; drop table if exists ingest.pk045_cad_de_imoveis cascade;"
	@tput bold
	@echo Extraindo ....
	@tput sgr0
	cd $(pg_io) ; 7z e -y  $(CAD_DE_IMOVEIS_ZIP) "$(CAD_DE_IMOVEIS).*" > /dev/null
	@echo "Conferindo se SRID esta configurado:"
	@echo Executando shp2pgsql ...
	@( cd $(pg_io) ; shp2pgsql -s 4326 "$(CAD_DE_IMOVEIS).shp" cad_de_imoveis | psql -q $(pg_uri) 2> /dev/null  )


	@echo "Conferira se bate o perfil: 220957 |  0.00 |  0.00 |  0.00 |     0.00 "
	psql $(pg_uri) -c "SELECT count(*) n, round(max(a),2) a_max, round(min(a),2) a_min, round(avg(a),2) a_avg, round(percentile_disc(0.5) WITHIN GROUP ( ORDER BY a),2) a_median FROM ( select  st_area(geom) a from cad_de_imoveis ) t"
	psql $(pg_uri) -c "CREATE TABLE ingest.pk045_cad_de_imoveis AS SELECT bairro_imo, cep_imovel, logradouro, numero_imo, unidades, ST_centroid(ST_Transform(geom,4326)) as geom FROM cad_de_imoveis"


	@echo Limpando...
	rm '$(pg_io)/$(CAD_DE_IMOVEIS)'.*
	psql $(pg_uri) -c "drop table cad_de_imoveis cascade"
	@echo FIM.

