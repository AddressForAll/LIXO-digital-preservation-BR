
# PWD:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
pg_io  =/tmp/pg_io
ori    =/var/www/preserv.addressforall.org/download
pg_uri ="postgres://postgres@localhost/ingest1"

LOTES_ZIP     =$(ori)/51a6beb9fca43e0fb45727138982f7806b8df52fce53f5e0e31edd61bfbc21b9.rar
LOTES         =lote


all:
	@echo Favor consultar as opcoes de target

etl_toPgis_lotes:
# ETL extrating to PostgreSQL/PostGIS the "lotes" datatype (point and house number)
	@echo "Creating table ingest.pk031_lotes on PostGIS"
	@whoami
	@echo "Run with tmux and sudo! (DANGER: seems not idempotent on psql)"
	mkdir -p $(pg_io)
	psql $(pg_uri) -c "drop table if exists lotes cascade; drop table if exists ingest.pk031_lotes cascade;"
	@tput bold
	@echo Extraindo ....
	@tput sgr0
	cd $(pg_io) ; 7z e -y  $(LOTES_ZIP) > /dev/null
	@echo "Conferindo se SRID esta configurado:"
	@( psql $(pg_uri) -c "SELECT srid, proj4text FROM spatial_ref_sys where srid=31982" )
	@echo Executando shp2pgsql ...
	@( cd $(pg_io) ; shp2pgsql -s 31982 $(LOTES).shp lotes | psql -q $(pg_uri) 2> /dev/null  )
	@echo "Conferira se bate o perfil:  75028 | 6103227.09 | 17.72 | 1194.77 |   333.54 "
	psql $(pg_uri) -c "SELECT count(*) n, round(max(a),2) a_max, round(min(a),2) a_min, round(avg(a),2) a_avg, round(percentile_disc(0.5) WITHIN GROUP ( ORDER BY a),2) a_median FROM ( select  st_area(geom) a from lotes ) t"
	psql $(pg_uri) -c "CREATE TABLE ingest.pk031_lotes AS select gid, Tipo, Logradouro, Numero, Bairro, ST_centroid(ST_Transform(geom,4326)) as geom FROM lotes"
	@echo Limpando...
	rm  $(pg_io)/$(LOTES).*
	psql $(pg_uri) -c "drop table lotes cascade"
	@echo FIM.

EIXOS_ZIP       =$(ori)/9600dcba403c8dc0b066c8f429507e4672966a01c93119923f75361a6ebc64c0.zip
EIXOS_SHPREFIX  =Ruas
etl_toPgis_eixos:
	@echo "Creating table ingest.pk031_eixos on PostGIS"
	@whoami
	@echo "Run with tmux and sudo! (DANGER: seems not idempotent on psql)"
	mkdir -p $(pg_io)
	@( psql $(pg_uri) -c "drop table if exists eixos cascade; drop table if exists ingest.pk031_eixos cascade;" )
	@tput bold
	@echo Extraindo ....
	@tput sgr0
	cd $(pg_io) ; 7z e -y  $(EIXOS_ZIP) $(EIXOS_SHPREFIX).* > /dev/null
	@echo "Conferindo se SRID esta configurado:"
	@( psql $(pg_uri) -c "SELECT srid, proj4text FROM spatial_ref_sys where srid=31983" )
	@echo Executando shp2pgsql ...
	@( cd $(pg_io) ; shp2pgsql -s 31983 $(EIXOS_SHPREFIX).shp eixos |  psql -q $(pg_uri) 2> /dev/null  )
	@echo "Conferira se bate o perfil:  10330 |  0.00 |  0.00 |  0.00 |     0.00 "
	psql $(pg_uri) -c "SELECT count(*) n, round(max(a),2) a_max, round(min(a),2) a_min, round(avg(a),2) a_avg, round(percentile_disc(0.5) WITHIN GROUP ( ORDER BY a),2) a_median FROM ( select  st_area(geom) a from eixos ) t"
	psql $(pg_uri) -c "CREATE TABLE ingest.pk031_eixos AS select gid, LOGRADOURO, NOME, ST_centroid(ST_Transform(geom,4326)) as geom FROM eixos"
	@echo Limpando...
	rm $(pg_io)/$(EIXOS_SHPREFIX).*
	psql $(pg_uri) -c "drop table eixos cascade"
	@echo FIM.


BAIRROS_ZIP	=$(ori)/f4d3819f9853e85e43bf7a58de7f257eed5f63bcf36daed1c4db0f2701544adc.zip 
BAIRROS_SHPREFIX=Bairros
etl_toPgis_bairros:
	@echo "Creating table ingest.pk031_bairros on PostGIS"
	@whoami
	@echo "Run with tmux and sudo! (DANGER: seems not idempotent on psql)"
	mkdir -p $(pg_io)
	@psql $(pg_uri) -c "drop table if exists bairros cascade; drop table if exists ingest.pk031_bairros cascade;"
	@tput bold
	@echo Extraindo ....
	@tput sgr0
	cd $(pg_io) ; 7z e -y  $(BAIRROS_ZIP) $(BAIRROS_SHPREFIX).* > /dev/null
	@echo Executando shp2pgsql ...
	@( cd $(pg_io) ; shp2pgsql -s 31982 $(BAIRROS_SHPREFIX).shp bairros | psql -q $(pg_uri) 2> /dev/null  )
	@echo "Conferira se bate o perfil: 42 | 21124351.31 | 456724.69 | 3223152.90 | 1970267.0 "
	psql $(pg_uri) -c "SELECT count(*) n, round(max(a),2) a_max, round(min(a),2) a_min, round(avg(a),2) a_avg, round(percentile_disc(0.5) WITHIN GROUP ( ORDER BY a),2) a_median FROM ( select  st_area(geom) a from bairros ) t"
	#psql $(pg_uri) -c "SELECT column_name, data_type FROM information_schema.columns WHERE table_name = 'bairros'"
	psql $(pg_uri) -c "CREATE TABLE ingest.pk031_bairros AS select gid, NOME, ST_centroid(ST_Transform(geom,4326)) as geom FROM bairros"
	@echo Limpando...
	rm $(pg_io)/$(BAIRROS_SHPREFIX).*
	psql $(pg_uri) -c "drop table bairros cascade"
	@echo FIM.

QUADRAS_ZIP	=$(ori)/f4d3819f9853e85e43bf7a58de7f257eed5f63bcf36daed1c4db0f2701544adc.zip
QUADRAS_SHPREFIX=Quadras
etl_toPgis_quadras:
	@echo "Creating table ingest.pk031_quadras on PostGIS"
	@whoami
	@echo "Run with tmux and sudo! (DANGER: seems not idempotent on psql)"
	mkdir -p $(pg_io)
	@psql $(pg_uri) -c "drop table if exists quadras cascade; drop table if exists ingest.pk031_quadras cascade;"
	@tput bold
	@echo Extraindo ....
	@tput sgr0
	cd $(pg_io) ; 7z e -y  $(QUADRAS_ZIP) $(QUADRAS_SHPREFIX).* > /dev/null
	@echo Executando shp2pgsql ...
	@( cd $(pg_io) ; shp2pgsql -s 31982 $(QUADRAS_SHPREFIX).shp quadras | psql -q $(pg_uri) 2> /dev/null  )
	@echo "Conferira se bate o perfil: 3617 | 6103227.09 | 74.74 | 24765.65 |  7490.48 "
	psql $(pg_uri) -c "SELECT count(*) n, round(max(a),2) a_max, round(min(a),2) a_min, round(avg(a),2) a_avg, round(percentile_disc(0.5) WITHIN GROUP ( ORDER BY a),2) a_median FROM ( select  st_area(geom) a from quadras ) t"
	#psql $(pg_uri) -c "SELECT column_name, data_type FROM information_schema.columns WHERE table_name = 'quadras'"
	psql $(pg_uri) -c "CREATE TABLE ingest.pk031_quadras AS select gid, NumQuadra, ST_centroid(ST_Transform(geom,4326)) as geom FROM quadras"
	@echo Limpando...
	rm $(pg_io)/$(QUADRAS_SHPREFIX).*
	psql $(pg_uri) -c "drop table quadras cascade"
	@echo FIM.
