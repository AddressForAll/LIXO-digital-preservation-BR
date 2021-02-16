
# PWD:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
pg_io  =/tmp/pg_io
ori    =/var/www/preserv.addressforall.org/download
pg_uri ="postgres://postgres@localhost/ingest1"

RECEBIDOS_ZIP   =$(ori)/6cd0d4b475e61b8cbd078787ea8b38ebdd051a1def026ca476d4a83d40354738.zip
EIXOS_EXTRACT   =lograd
LOTES_EXTRACT   =lotes
QUADRAS_EXTRACT =quadras


all:
	@echo Favor consultar as opcoes de target

etl_toPgis_quadras:
# ETL extrating to PostgreSQL/PostGIS the "quadras" datatype (point and house number)
	@echo "Creating table ingest.pk058_quadras on PostGIS"
	@whoami
	@echo "Run with tmux and sudo! (DANGER: seems not idempotent on psql)"
	mkdir -p $(pg_io)
	psql $(pg_uri) -c "drop table if exists quadras cascade; drop table if exists ingest.pk058_quadras cascade;"
	@tput bold
	@echo Extraindo ....
	@tput sgr0
	cd $(pg_io) ; 7z e -y  $(RECEBIDOS_ZIP) $(QUADRAS_EXTRACT).* > /dev/null
	@echo Executando shp2pgsql ...
	@( cd $(pg_io) ; shp2pgsql -s 31983 $(QUADRAS_EXTRACT).shp quadras | psql -q $(pg_uri) 2> /dev/null  )
	@echo "Conferira se bate o perfil:  11090 | 6090485.55 | 18.40 | 19623.47 |  7454.39"
	psql $(pg_uri) -c "SELECT count(*) n, round(max(a),2) a_max, round(min(a),2) a_min, round(avg(a),2) a_avg, round(percentile_disc(0.5) WITHIN GROUP ( ORDER BY a),2) a_median FROM ( select  st_area(geom) a from quadras ) t"
	psql $(pg_uri) -c "CREATE TABLE ingest.pk058_quadras AS select gid, QUADRA, ST_centroid(ST_Transform(geom,4326)) as geom FROM quadras"
	@echo Limpando...
	rm $(pg_io)/$(QUADRAS_EXTRACT).*
	psql $(pg_uri) -c "drop table quadras cascade"
	@echo FIM.

etl_toPgis_lotes:
# ETL extrating to PostgreSQL/PostGIS the "lotes" datatype (point and house number)
	@echo "Creating table ingest.pk058_lotes on PostGIS"
	@whoami
	@echo "Run with tmux and sudo! (DANGER: seems not idempotent on psql)"
	mkdir -p $(pg_io)
	psql $(pg_uri) -c "drop table if exists lotes cascade; drop table if exists ingest.pk058_lotes cascade;"
	@tput bold
	@echo Extraindo ....
	@tput sgr0
	cd $(pg_io) ; 7z e -y  $(RECEBIDOS_ZIP) $(LOTES_EXTRACT).* > /dev/null
	@echo Executando shp2pgsql ...
	@( cd $(pg_io) ; shp2pgsql -s 31983 $(LOTES_EXTRACT).shp lotes | psql -q $(pg_uri) 2> /dev/null  )
	@echo "Conferira se bate o perfil:  227365 | 5420493.43 |  0.00 | 872.28 |   210.91 "
	psql $(pg_uri) -c "SELECT count(*) n, round(max(a),2) a_max, round(min(a),2) a_min, round(avg(a),2) a_avg, round(percentile_disc(0.5) WITHIN GROUP ( ORDER BY a),2) a_median FROM ( select  st_area(geom) a from lotes ) t"
	psql $(pg_uri) -c "CREATE TABLE ingest.pk058_lotes AS select gid,NRO_IMOV, COD_DV_LOG, ST_centroid(ST_Transform(geom,4326)) as geom FROM lotes"
	@echo Limpando...
	rm $(pg_io)/$(LOTES_EXTRACT).*
	psql $(pg_uri) -c "drop table lotes cascade"
	@echo FIM.

etl_toPgis_eixos:
# ETL extrating to PostgreSQL/PostGIS the "eixos" datatype (point and house number)
	@echo "Creating table ingest.pk058_eixos on PostGIS"
	@whoami
	@echo "Run with tmux and sudo! (DANGER: seems not idempotent on psql)"
	mkdir -p $(pg_io)
	psql $(pg_uri) -c "drop table if exists eixos cascade; drop table if exists ingest.pk058_eixos cascade;"
	@tput bold
	@echo Extraindo ....
	@tput sgr0
	cd $(pg_io) ; 7z e -y  $(RECEBIDOS_ZIP) $(EIXOS_EXTRACT).* > /dev/null
	@echo Executando shp2pgsql ...
	@( cd $(pg_io) ; shp2pgsql -s 31983 $(EIXOS_EXTRACT).shp eixos | psql -q $(pg_uri) 2> /dev/null  )
	@echo "Conferira se bate o perfil:  32119 |  0.00 |  0.00 |  0.00 |     0.00 "
	psql $(pg_uri) -c "SELECT count(*) n, round(max(a),2) a_max, round(min(a),2) a_min, round(avg(a),2) a_avg, round(percentile_disc(0.5) WITHIN GROUP ( ORDER BY a),2) a_median FROM ( select  st_area(geom) a from eixos ) t"
	psql $(pg_uri) -c "CREATE TABLE ingest.pk058_eixos AS select gid, NOME_LOGR, COD_DV_LOG, ST_centroid(ST_Transform(geom,4326)) as geom FROM eixos"
	@echo Limpando...
	rm $(pg_io)/$(EIXOS_EXTRACT).*
	psql $(pg_uri) -c "drop table eixos cascade"
	@echo FIM.

