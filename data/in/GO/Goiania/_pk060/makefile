
# PWD:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
pg_io  =/tmp/pg_io
ori    =/var/www/preserv.addressforall.org/download
pg_uri ="postgres://postgres@localhost/ingest1"

LOTES_ZIP     =$(ori)/db2d3b64a2494ff53212d276645986490890025d2b5d1fc5a1b90af7e7bbdf39.zip
LOTES         =LOT

QUADRA_ZIP    =$(ori)/1fd83fa52b1a8b9179f8e38703b1a33a30256f68994794404acde1ad786dac7e.zip
QUADRA        =QDR

BAIRROS_ZIP   =$(ori)/981d55ac26d0131ff4040aeca1444ad2310e20b89ceeac70c9d4ca12caf5151b.zip
BAIRROS       =BAI

EIXOS_ZIP     =$(ori)/926566fc01aa45a22ede663e66e371ce9e70e730e7f4e28b10b3bdf19d67fd38.zip
EIXOS         =SEG

all:
	@echo Favor consultar as opcoes de target

etl_toPgis_lotes:
# ETL extrating to PostgreSQL/PostGIS the "lotes" datatype (point and house number)
	@echo "Creating table ingest.pk060_lotes on PostGIS"
	@whoami
	@echo "Run with tmux and sudo! (DANGER: seems not idempotent on psql)"
	mkdir -p $(pg_io)
	psql $(pg_uri) -c "drop table if exists lotes cascade; drop table if exists ingest.pk060_lotes cascade;"
	@tput bold
	@echo Extraindo ....
	@tput sgr0
	cd $(pg_io) ; 7z e -y  $(LOTES_ZIP) $(LOTES).* > /dev/null
	@echo "Conferindo se SRID esta configurado:"
	@( psql $(pg_uri) -c "SELECT srid, proj4text FROM spatial_ref_sys where srid=31982" )
	@echo Executando shp2pgsql ...
	@( cd $(pg_io) ; shp2pgsql -s 31982 $(LOTES).shp lotes | psql -q $(pg_uri) 2> /dev/null  )
	@echo "Conferira se bate o perfil:   388860 | 3993378.23 |  3.66 | 828.23 |   360.00 "
	psql $(pg_uri) -c "SELECT count(*) n, round(max(a),2) a_max, round(min(a),2) a_min, round(avg(a),2) a_avg, round(percentile_disc(0.5) WITHIN GROUP ( ORDER BY a),2) a_median FROM ( select  st_area(geom) a from lotes ) t"
	psql $(pg_uri) -c "CREATE TABLE ingest.pk060_lotes AS select gid, id, nm_lot, ST_centroid(ST_Transform(geom,4326)) as geom FROM lotes"
	@echo Limpando...
	rm $(pg_io)/$(LOTES).*
	psql $(pg_uri) -c "drop table lotes cascade"
	@echo FIM.

etl_toPgis_quadra:
# ETL extrating to PostgreSQL/PostGIS the "quadra" datatype (point and house number)
	@echo "Creating table ingest.pk060_quadra on PostGIS"
	@whoami
	@echo "Run with tmux and sudo! (DANGER: seems not idempotent on psql)"
	mkdir -p $(pg_io)
	psql $(pg_uri) -c "drop table if exists quadra cascade; drop table if exists ingest.pk060_quadra cascade;"
	@tput bold
	@echo Extraindo ....
	@tput sgr0
	cd $(pg_io) ; 7z e -y  $(QUADRA_ZIP) $(QUADRA).* > /dev/null
	@echo "Conferindo se SRID esta configurado:"
	@( psql $(pg_uri) -c "SELECT srid, proj4text FROM spatial_ref_sys where srid=31982" )
	@echo Executando shp2pgsql ...
	@( cd $(pg_io) ; shp2pgsql -s 31982 $(QUADRA).shp quadra | psql -q $(pg_uri) 2> /dev/null  )
	@echo "Conferira se bate o perfil:  24547 | 3993378.16 |  0.02 | 13129.16 |  7586.72 "
	psql $(pg_uri) -c "SELECT count(*) n, round(max(a),2) a_max, round(min(a),2) a_min, round(avg(a),2) a_avg, round(percentile_disc(0.5) WITHIN GROUP ( ORDER BY a),2) a_median FROM ( select  st_area(geom) a from quadra ) t"
	psql $(pg_uri) -c "CREATE TABLE ingest.pk060_quadra AS select gid, nm_qdr, ST_centroid(ST_Transform(geom,4326)) as geom FROM quadra"
	@echo Limpando...
	rm $(pg_io)/$(QUADRA).*
	psql $(pg_uri) -c "drop table quadra cascade"
	@echo FIM.

etl_toPgis_bairros:
# ETL extrating to PostgreSQL/PostGIS the "bairros" datatype (point and house number)
	@echo "Creating table ingest.pk060_bairros on PostGIS"
	@whoami
	@echo "Run with tmux and sudo! (DANGER: seems not idempotent on psql)"
	mkdir -p $(pg_io)
	psql $(pg_uri) -c "drop table if exists bairros cascade; drop table if exists ingest.pk060_bairros cascade;"
	@tput bold
	@echo Extraindo ....
	@tput sgr0
	cd $(pg_io) ; 7z e -y  $(BAIRROS_ZIP) $(BAIRROS).* > /dev/null
	@echo "Conferindo se SRID esta configurado:"
	@( psql $(pg_uri) -c "SELECT srid, proj4text FROM spatial_ref_sys where srid=31982" )
	@echo Executando shp2pgsql ...
	@( cd $(pg_io) ; shp2pgsql -s 31982 $(BAIRROS).shp bairros | psql -q $(pg_uri) 2> /dev/null  )
	@echo "Conferira se bate o perfil:   1156 | 6456164.91 |  0.00 | 365233.37 | 132935.24 "
	psql $(pg_uri) -c "SELECT count(*) n, round(max(a),2) a_max, round(min(a),2) a_min, round(avg(a),2) a_avg, round(percentile_disc(0.5) WITHIN GROUP ( ORDER BY a),2) a_median FROM ( select  st_area(geom) a from bairros ) t"
	psql $(pg_uri) -c "CREATE TABLE ingest.pk060_bairros AS select gid, tp_bai, nm_bai, nm, ST_centroid(ST_Transform(geom,4326)) as geom FROM bairros"
	@echo Limpando...
	rm $(pg_io)/$(BAIRROS).*
	psql $(pg_uri) -c "drop table bairros cascade"
	@echo FIM.


etl_toPgis_eixos:
# ETL extrating to PostgreSQL/PostGIS the "eixos" datatype (point and house number)
	@echo "Creating table ingest.pk060_eixos on PostGIS"
	@whoami
	@echo "Run with tmux and sudo! (DANGER: seems not idempotent on psql)"
	mkdir -p $(pg_io)
	psql $(pg_uri) -c "drop table if exists eixos cascade; drop table if exists ingest.pk060_eixos cascade;"
	@tput bold
	@echo Extraindo ....
	@tput sgr0
	cd $(pg_io) ; 7z e -y  $(EIXOS_ZIP) $(EIXOS).* > /dev/null
	@echo "Conferindo se SRID esta configurado:"
	@( psql $(pg_uri) -c "SELECT srid, proj4text FROM spatial_ref_sys where srid=31982" )
	@echo Executando shp2pgsql ...
	@( cd $(pg_io) ; shp2pgsql -s 31982 $(EIXOS).shp eixos | psql -q $(pg_uri) 2> /dev/null  )
	@echo "Conferira se bate o perfil:   66274 |  0.00 |  0.00 |  0.00 |     0.00 "
	psql $(pg_uri) -c "SELECT count(*) n, round(max(a),2) a_max, round(min(a),2) a_min, round(avg(a),2) a_avg, round(percentile_disc(0.5) WITHIN GROUP ( ORDER BY a),2) a_median FROM ( select  st_area(geom) a from eixos ) t"
	psql $(pg_uri) -c "CREATE TABLE ingest.pk060_eixos AS select gid, tp_log, nm_log, ST_centroid(ST_Transform(geom,4326)) as geom FROM eixos"
	@echo Limpando...
	rm $(pg_io)/$(EIXOS).*
	psql $(pg_uri) -c "drop table eixos cascade"
	@echo FIM.

