
# PWD:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
pg_io  =/tmp/pg_io
ori    =/var/www/preserv.addressforall.org/download
pg_uri ="postgres://postgres@localhost/ingest1"

LOTES_ZIP     =$(ori)/56d32368409f4ba2c99afadc7ad307bd8cc660b93d38e57936da313fafde1f13.rar
LOTES         =LOTES


all:
	@echo Favor consultar as opcoes de target

etl_toPgis_lotes:
# ETL extrating to PostgreSQL/PostGIS the "lotes" datatype (point and house number)
	@echo "Creating table ingest.pk029_lotes on PostGIS"
	@whoami
	@echo "Run with tmux and sudo! (DANGER: seems not idempotent on psql)"
	mkdir -p $(pg_io)
	psql $(pg_uri) -c "drop table if exists lotes cascade; drop table if exists ingest.pk029_lotes cascade;"
	@tput bold
	@echo Extraindo ....
	@tput sgr0
	cd $(pg_io) ; 7z e -y  $(LOTES_ZIP) $(LOTES).* > /dev/null
	@echo "Conferindo se SRID esta configurado:"
	@( psql $(pg_uri) -c "SELECT srid, proj4text FROM spatial_ref_sys where srid=31982" )
	@echo Executando shp2pgsql ...
	@( cd $(pg_io) ; shp2pgsql -s 31982 $(LOTES).shp lotes | psql -q $(pg_uri) 2> /dev/null  )
	@echo "Conferira se bate o perfil:  31571 | 4502606.72 |  0.05 | 1668.35 |   429.84"
	psql $(pg_uri) -c "SELECT count(*) n, round(max(a),2) a_max, round(min(a),2) a_min, round(avg(a),2) a_avg, round(percentile_disc(0.5) WITHIN GROUP ( ORDER BY a),2) a_median FROM ( select  st_area(geom) a from lotes ) t"
	psql $(pg_uri) -c "CREATE TABLE ingest.pk029_lotes AS select gid, NOME_LOGRA, TIPO_LOGRA, NUMERO, NOME_BAIRR, ST_centroid(ST_Transform(geom,4326)) as geom FROM lotes"
	@echo Limpando...
	rm $(pg_io)/$(LOTES).*
	psql $(pg_uri) -c "drop table lotes cascade"
	@echo FIM.

EIXOS_ZIP       =$(ori)/27c0c467222a668837f62e9f40ac85f94685ea50f3d655207384f2343d13f573.rar
EIXOS_SHPREFIX  =RUAS
etl_toPgis_eixos:
	@echo "Creating table ingest.pk029_eixos on PostGIS"
	@whoami
	@echo "Run with tmux and sudo! (DANGER: seems not idempotent on psql)"
	mkdir -p $(pg_io)
	@psql $(pg_uri) -c "drop table if exists eixos cascade; drop table if exists ingest.pk029_eixos cascade;"
	@tput bold
	@echo Extraindo ....
	@tput sgr0
	cd $(pg_io) ; 7z e -y  $(EIXOS_ZIP) $(EIXOS_SHPREFIX).* > /dev/null
	@echo "Conferindo se SRID esta configurado:"
	@( psql $(pg_uri) -c "SELECT srid, proj4text FROM spatial_ref_sys where srid=31983" )
	@echo Executando shp2pgsql ...
	@( cd $(pg_io) ; shp2pgsql -W iso-8859-1 -s 31983 $(EIXOS_SHPREFIX).shp eixos |  psql -q $(pg_uri) 2> /dev/null  )
	@echo "Conferira se bate o perfil:  696 |  0.00 |  0.00 |  0.00 |     0.00"
	psql $(pg_uri) -c "SELECT count(*) n, round(max(a),2) a_max, round(min(a),2) a_min, round(avg(a),2) a_avg, round(percentile_disc(0.5) WITHIN GROUP ( ORDER BY a),2) a_median FROM ( select  st_area(geom) a from eixos ) t"
	psql $(pg_uri) -c "CREATE TABLE ingest.pk029_eixos AS select gid, NOME_RUA, ST_centroid(ST_Transform(geom,4326)) as geom FROM eixos"
	@echo Limpando...
	rm $(pg_io)/$(EIXOS_SHPREFIX).*
	psql $(pg_uri) -c "drop table eixos cascade"
	@echo FIM.


BAIRROS_ZIP	=$(ori)/7d96c19771ca271623058eeb9fdc4ceb67ff68c3937a7b66e7ccdb1a4e6580fb.rar
BAIRROS_SHPREFIX=BAIRROS
etl_toPgis_bairros:
	@echo "Creating table ingest.pk029_bairros on PostGIS"
	@whoami
	@echo "Run with tmux and sudo! (DANGER: seems not idempotent on psql)"
	mkdir -p $(pg_io)
	@psql $(pg_uri) -c "drop table if exists bairros cascade; drop table if exists ingest.pk029_bairros cascade;"
	@tput bold
	@echo Extraindo ....
	@tput sgr0
	cd $(pg_io) ; 7z e -y  $(BAIRROS_ZIP) $(BAIRROS_SHPREFIX).* > /dev/null
	@echo Executando shp2pgsql ...
	@( cd $(pg_io) ; shp2pgsql -s 31982 $(BAIRROS_SHPREFIX).shp bairros | psql -q $(pg_uri) 2> /dev/null  )
	@echo "Conferira se bate o perfil:  15 | 20745315.23 | 981644.34 | 4064593.76 | 2407254.34"
	psql $(pg_uri) -c "SELECT count(*) n, round(max(a),2) a_max, round(min(a),2) a_min, round(avg(a),2) a_avg, round(percentile_disc(0.5) WITHIN GROUP ( ORDER BY a),2) a_median FROM ( select  st_area(geom) a from bairros ) t"
	psql $(pg_uri) -c "CREATE TABLE ingest.pk029_bairros AS select gid, BAIRRO, ST_centroid(ST_Transform(geom,4326)) as geom FROM bairros"
	@echo Limpando...
	rm $(pg_io)/$(BAIRROS_SHPREFIX).*
	psql $(pg_uri) -c "drop table bairros cascade"
	@echo FIM.
