
# PWD:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
pg_io  =/tmp/pg_io
ori    =/var/www/preserv.addressforall.org/download
pg_uri ="postgres://postgres@localhost/ingest1"

LOTES_ZIP     =$(ori)/49c6dd8968a97b80ddd50f37db3204ae63278f7a9cda94fa35b03429d53a96a6.rar
LOTES         =lotes

BAIRROS_ZIP    =$(ori)/49c6dd8968a97b80ddd50f37db3204ae63278f7a9cda94fa35b03429d53a96a6.rar
BAIRROS        =bairro

EIXOS_ZIP     =$(ori)/49c6dd8968a97b80ddd50f37db3204ae63278f7a9cda94fa35b03429d53a96a6.rar
EIXOS         =logradouros

all:
	@echo Favor consultar as opcoes de target

etl_toPgis_lotes:
# ETL extrating to PostgreSQL/PostGIS the "lotes" datatype (point and house number)
	@echo "Creating table ingest.pk059_lotes on PostGIS"
	@whoami
	@echo "Run with tmux and sudo! (DANGER: seems not idempotent on psql)"
	mkdir -p $(pg_io)
	psql $(pg_uri) -c "drop table if exists lotes cascade; drop table if exists ingest.pk059_lotes cascade;"
	@tput bold
	@echo Extraindo ....
	@tput sgr0
	cd $(pg_io) ; 7z e -y  $(LOTES_ZIP) $(LOTES).* > /dev/null
	@echo "Conferindo se SRID esta configurado:"
	@( psql $(pg_uri) -c "SELECT srid, proj4text FROM spatial_ref_sys where srid=31982" )
	@echo Executando shp2pgsql ...
	@( cd $(pg_io) ; shp2pgsql -s 31982 $(LOTES).shp lotes | psql -q $(pg_uri) 2> /dev/null  )
	@echo "Conferira se bate o perfil:  154067 | 112.28 |  0.81 | 12.24 |    11.65"
	psql $(pg_uri) -c "SELECT count(*) n, round(max(a),2) a_max, round(min(a),2) a_min, round(avg(a),2) a_avg, round(percentile_disc(0.5) WITHIN GROUP ( ORDER BY a),2) a_median FROM ( select  st_area(geom) a from lotes ) t"
	psql $(pg_uri) -c "SELECT column_name, data_type FROM information_schema.columns WHERE table_name = 'lotes'"
	psql $(pg_uri) -c "CREATE TABLE ingest.pk059_lotes AS select gid, logradouro, bairro, ST_centroid(ST_Transform(geom,4326)) as geom FROM lotes"
	@echo Limpando...
	rm $(pg_io)/$(LOTES).*
	psql $(pg_uri) -c "drop table lotes cascade"
	@echo FIM.

etl_toPgis_bairros:
# ETL extrating to PostgreSQL/PostGIS the "bairros" datatype (point and house number)
	@echo "Creating table ingest.pk059_bairros on PostGIS"
	@whoami
	@echo "Run with tmux and sudo! (DANGER: seems not idempotent on psql)"
	mkdir -p $(pg_io)
	psql $(pg_uri) -c "drop table if exists bairros cascade; drop table if exists ingest.pk059_bairros cascade;"
	@tput bold
	@echo Extraindo ....
	@tput sgr0
	cd $(pg_io) ; 7z e -y  $(BAIRROS_ZIP) $(BAIRROS).* > /dev/null
	@echo "Conferindo se SRID esta configurado:"
	@( psql $(pg_uri) -c "SELECT srid, proj4text FROM spatial_ref_sys where srid=31982" )
	@echo Executando shp2pgsql ...
	@( cd $(pg_io) ; shp2pgsql -s 31982 $(BAIRROS).shp bairros | psql -q $(pg_uri) 2> /dev/null  )
	#@echo "Conferira se bate o perfil:  154067 | 112.28 |  0.81 | 12.24 |    11.65"
	psql $(pg_uri) -c "SELECT count(*) n, round(max(a),2) a_max, round(min(a),2) a_min, round(avg(a),2) a_avg, round(percentile_disc(0.5) WITHIN GROUP ( ORDER BY a),2) a_median FROM ( select  st_area(geom) a from bairros ) t"
	psql $(pg_uri) -c "SELECT column_name, data_type FROM information_schema.columns WHERE table_name = 'bairros'"
	psql $(pg_uri) -c "CREATE TABLE ingest.pk059_bairros AS select gid, logradouro, bairro, ST_centroid(ST_Transform(geom,4326)) as geom FROM bairros"
	@echo Limpando...
	rm $(pg_io)/$(BAIRROS).*
	psql $(pg_uri) -c "drop table bairros cascade"
	@echo FIM.


etl_toPgis_eixos:
# ETL extrating to PostgreSQL/PostGIS the "eixos" datatype (point and house number)
	@echo "Creating table ingest.pk059_eixos on PostGIS"
	@whoami
	@echo "Run with tmux and sudo! (DANGER: seems not idempotent on psql)"
	mkdir -p $(pg_io)
	psql $(pg_uri) -c "drop table if exists eixos cascade; drop table if exists ingest.pk059_eixos cascade;"
	@tput bold
	@echo Extraindo ....
	@tput sgr0
	cd $(pg_io) ; 7z e -y  $(EIXOS_ZIP) $(EIXOS).* > /dev/null
	@echo "Conferindo se SRID esta configurado:"
	@( psql $(pg_uri) -c "SELECT srid, proj4text FROM spatial_ref_sys where srid=31983" )
	@echo Executando shp2pgsql ...
	@( cd $(pg_io) ; shp2pgsql -s 31983 $(EIXOS).shp ingest.pk059_eixos | psql -q $(pg_uri) 2> /dev/null  )
	#@echo "Conferira se bate o perfil:  154067 | 112.28 |  0.81 | 12.24 |    11.65"
	#psql $(pg_uri) -c "SELECT count(*) n, round(max(a),2) a_max, round(min(a),2) a_min, round(avg(a),2) a_avg, round(percentile_disc(0.5) WITHIN GROUP ( ORDER BY a),2) a_median FROM ( select  st_area(geom) a from nro_imovel ) t"
	#psql $(pg_uri) -c "CREATE TABLE ingest.pk059_eixos AS select gid, setor, textstring as housenumber, ST_centroid(ST_Transform(geom,4326)) as geom FROM nro_imovel"
	@echo Limpando...
	rm $(pg_io)/$(EIXOS).*
	psql $(pg_uri) -c "drop table eixos cascade"
	@echo FIM.

