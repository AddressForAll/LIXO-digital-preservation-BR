
# PWD:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
pg_io  =/tmp/pg_io
ori    =/var/www/preserv.addressforall.org/download
pg_uri ="postgres://postgres@localhost/ingest1"

LOTES_ZIP           =$(ori)/ca5dab519aae0b5cfbc6f8930641c0cce2abbc34c25e306b3fe0aea87df34b74.rar
LOTES               =IMOVEL_2020_Logradouro

PASTA               =*

LOTEAMENTOS_ZIP    =$(ori)/ca5dab519aae0b5cfbc6f8930641c0cce2abbc34c25e306b3fe0aea87df34b74.rar
LOTEAMENTOS        =PARCELAMENTOS


all:
	@echo Favor consultar as opcoes de target

etl_toPgis_lotes:
# ETL extrating to PostgreSQL/PostGIS the "lotes" datatype (point and house number)
	@echo "Creating table ingest.pk037_lotes on PostGIS"
	@whoami
	@echo "Run with tmux and sudo! (DANGER: seems not idempotent on psql)"
	mkdir -p $(pg_io)
	psql $(pg_uri) -c "drop table if exists lotes cascade; drop table if exists ingest.pk037_lotes cascade;"
	@tput bold
	@echo Extraindo ....
	@tput sgr0
	cd $(pg_io) ; 7z e -y  $(LOTES_ZIP) $(PASTA)/$(LOTES).* > /dev/null
	@echo "Conferindo se SRID esta configurado:"
	@( psql $(pg_uri) -c "SELECT srid, proj4text FROM spatial_ref_sys where srid=31981" )
	@echo Executando shp2pgsql ...
	@( cd $(pg_io) ; shp2pgsql -s 31981 $(LOTES).shp lotes | psql -q $(pg_uri) 2> /dev/null  )
	@echo "Conferira se bate o perfil:   423464 | 10409750.51 |  0.00 | 5376.38 |   360.69 "
	psql $(pg_uri) -c "SELECT count(*) n, round(max(a),2) a_max, round(min(a),2) a_min, round(avg(a),2) a_avg, round(percentile_disc(0.5) WITHIN GROUP ( ORDER BY a),2) a_median FROM ( select  st_area(geom) a from lotes ) t"
	psql $(pg_uri) -c "CREATE TABLE ingest.pk037_lotes AS select gid, RUAIMO, NRPORTA, COMPLEMENT, QUADRA, LOTE, ST_centroid(ST_Transform(geom,4326)) as geom FROM lotes"
	@echo Limpando...
	rm $(pg_io)/$(LOTES).*
	psql $(pg_uri) -c "drop table lotes cascade"
	@echo FIM.

etl_toPgis_loteamentos:
# ETL extrating to PostgreSQL/PostGIS the "loteamentos" datatype (point and house number)
	@echo "Creating table ingest.pk037_loteamentos on PostGIS"
	@whoami
	@echo "Run with tmux and sudo! (DANGER: seems not idempotent on psql)"
	mkdir -p $(pg_io)
	psql $(pg_uri) -c "drop table if exists loteamentos cascade; drop table if exists ingest.pk037_loteamentos cascade;"
	@tput bold
	@echo Extraindo ....
	@tput sgr0
	cd $(pg_io) ; 7z e -y  $(LOTEAMENTOS_ZIP) $(PASTA)/$(LOTEAMENTOS).* > /dev/null
	@echo "Conferindo se SRID esta configurado:"
	@( psql $(pg_uri) -c "SELECT srid, proj4text FROM spatial_ref_sys where srid=31981" )
	@echo Executando shp2pgsql ...
	@( cd $(pg_io) ; shp2pgsql -s 31981 $(LOTEAMENTOS).shp loteamentos | psql -q $(pg_uri) 2> /dev/null  )
	@echo "Conferira se bate o perfil:   858 | 9503941.45 | 1218.54 | 257548.09 | 108006.82 "
	psql $(pg_uri) -c "SELECT count(*) n, round(max(a),2) a_max, round(min(a),2) a_min, round(avg(a),2) a_avg, round(percentile_disc(0.5) WITHIN GROUP ( ORDER BY a),2) a_median FROM ( select  st_area(geom) a from loteamentos ) t"
	psql $(pg_uri) -c "CREATE TABLE ingest.pk037_loteamentos AS select gid, NOME, BAIRRO, ST_centroid(ST_Transform(geom,4326)) as geom FROM loteamentos"
	@echo Limpando...
	rm $(pg_io)/$(LOTEAMENTOS).*
	psql $(pg_uri) -c "drop table loteamentos cascade"
	@echo FIM.


