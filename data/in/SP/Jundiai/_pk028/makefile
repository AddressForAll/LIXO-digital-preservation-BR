
# PWD:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
pg_io  =/tmp/pg_io
ori    =/var/www/preserv.addressforall.org/download
pg_uri ="postgres://postgres@localhost/ingest1"

LOTES_ZIP         =$(ori)/4c4a1565e1f7d5675ff2d546d0e6a85acd7bbaa018503601dd07e1be80dee130.zip
LOTES             =lotes_jund

EIXOS_ZIP         =$(ori)/ce76963d0679cbbb3f57e7ce53b32ccc3afd1768299509f539b4bdd22074e7e8.zip
EIXOS             =logradouro

ORTOFOTO_ZIP      =$(ori)/7e81a3e7184b56197c0ae2f435e6fd3876ac0a0548993a37a2ae4644d83c8877.zip
ORTOFOTO          =v_logr_ortofoto

OSM_ZIP           =$(ori)/64b4af485458099065ff5fcf2c4e37f5d30cad57d746a7550129fec7e90079d8.zip
OSM               =L_8683-2016_m12_vias_func_urbanistica

EDIFICACOES_ZIP   =$(ori)/512fe4c44525a211c68415da0ab06d565a6ba3653739809d46404d6653ce5064.zip
EDIFICACOES       =edificacoes

BAIRROS_ZIP       =$(ori)/7995d41f628e31599f80b367650d363f47e75e1515be9fefabefca91189608a5.zip
BAIRROS           =v_bairros_populacao

all:
	@echo Favor consultar as opcoes de target

etl_toPgis_lotes:
# ETL extrating to PostgreSQL/PostGIS the "lotes" datatype (point and house number)
	@echo "Creating table ingest.pk028_lotes on PostGIS"
	@whoami
	@echo "Run with tmux and sudo! (DANGER: seems not idempotent on psql)"
	mkdir -p $(pg_io)
	psql $(pg_uri) -c "drop table if exists lotes cascade; drop table if exists ingest.pk028_lotes cascade;"
	@tput bold
	@echo Extraindo ....
	@tput sgr0
	cd $(pg_io) ; 7z e -y  $(LOTES_ZIP) $(LOTES).* > /dev/null
	@echo "Conferindo se SRID esta configurado:"
	@( psql $(pg_uri) -c "SELECT srid, proj4text FROM spatial_ref_sys where srid=31983" )
	@echo Executando shp2pgsql ...
	@( cd $(pg_io) ; shp2pgsql -s 31983 $(LOTES).shp lotes | psql -q $(pg_uri) 2> /dev/null  )
	@echo "Conferira se bate o perfil: 105354 | 7278844.76 |  0.00 | 1913.19 |   254.53 "
	psql $(pg_uri) -c "SELECT count(*) n, round(max(a),2) a_max, round(min(a),2) a_min, round(avg(a),2) a_avg, round(percentile_disc(0.5) WITHIN GROUP ( ORDER BY a),2) a_median FROM ( select  st_area(geom) a from lotes ) t"
	psql $(pg_uri) -c "CREATE TABLE ingest.pk028_lotes AS select gid, ST_centroid(ST_Transform(geom,4326)) as geom FROM lotes"
	@echo Limpando...
	rm $(pg_io)/$(LOTES).*
	psql $(pg_uri) -c "drop table lotes cascade"
	@echo FIM.

etl_toPgis_eixos:
# ETL extrating to PostgreSQL/PostGIS the "eixos" datatype (point and house number)
	@echo "Creating table ingest.pk028_eixos on PostGIS"
	@whoami
	@echo "Run with tmux and sudo! (DANGER: seems not idempotent on psql)"
	mkdir -p $(pg_io)
	psql $(pg_uri) -c "drop table if exists eixos cascade; drop table if exists ingest.pk028_eixos cascade;"
	@tput bold
	@echo Extraindo ....
	@tput sgr0
	cd $(pg_io) ; 7z e -y  $(EIXOS_ZIP) $(EIXOS).* > /dev/null
	@echo "Conferindo se SRID esta configurado:"
	@( psql $(pg_uri) -c "SELECT srid, proj4text FROM spatial_ref_sys where srid=31983" )
	@echo Executando shp2pgsql ...
	@( cd $(pg_io) ; shp2pgsql -s 31983 $(EIXOS).shp eixos | psql -q $(pg_uri) 2> /dev/null  )
	@echo "Conferira se bate o perfil:  14056 |  0.00 |  0.00 |  0.00 |     0.00 "
	psql $(pg_uri) -c "SELECT count(*) n, round(max(a),2) a_max, round(min(a),2) a_min, round(avg(a),2) a_avg, round(percentile_disc(0.5) WITHIN GROUP ( ORDER BY a),2) a_median FROM ( select  st_area(geom) a from eixos ) t"
	psql $(pg_uri) -c "CREATE TABLE ingest.pk028_eixos AS select gid, fromleft, toleft, fromright, toright, codlogr, ST_centroid(ST_Transform(geom,4326)) as geom FROM eixos"
	@echo Limpando...
	rm $(pg_io)/$(EIXOS).*
	psql $(pg_uri) -c "drop table eixos cascade"
	@echo FIM.

etl_toPgis_ortofoto:
# ETL extrating to PostgreSQL/PostGIS the "ortofoto" datatype (point and house number)
	@echo "Creating table ingest.pk028_ortofoto on PostGIS"
	@whoami
	@echo "Run with tmux and sudo! (DANGER: seems not idempotent on psql)"
	mkdir -p $(pg_io)
	psql $(pg_uri) -c "drop table if exists ortofoto cascade; drop table if exists ingest.pk028_ortofoto cascade;"
	@tput bold
	@echo Extraindo ....
	@tput sgr0
	cd $(pg_io) ; 7z e -y  $(ORTOFOTO_ZIP) $(ORTOFOTO).* > /dev/null
	@echo "Conferindo se SRID esta configurado:"
	@( psql $(pg_uri) -c "SELECT srid, proj4text FROM spatial_ref_sys where srid=31983" )
	@echo Executando shp2pgsql ...
	@( cd $(pg_io) ; shp2pgsql -W iso-8859-1 -s 31983 $(ORTOFOTO).shp ortofoto | psql -q $(pg_uri) 2> /dev/null  )
	@echo "Conferira se bate o perfil: 14046 |  0.00 |  0.00 |  0.00 |     0.00 "
	psql $(pg_uri) -c "SELECT count(*) n, round(max(a),2) a_max, round(min(a),2) a_min, round(avg(a),2) a_avg, round(percentile_disc(0.5) WITHIN GROUP ( ORDER BY a),2) a_median FROM ( select  st_area(geom) a from ortofoto ) t"
	psql $(pg_uri) -c "CREATE TABLE ingest.pk028_ortofoto AS select gid, Codigo_do_, logrtotal, ST_centroid(ST_Transform(geom,4326)) as geom FROM ortofoto"
	@echo Limpando...
	rm $(pg_io)/$(ORTOFOTO).*
	psql $(pg_uri) -c "drop table ortofoto cascade"
	@echo FIM.

etl_toPgis_osm:
# ETL extrating to PostgreSQL/PostGIS the "osm" datatype (point and house number)
	@echo "Creating table ingest.pk028_osm on PostGIS"
	@whoami
	@echo "Run with tmux and sudo! (DANGER: seems not idempotent on psql)"
	mkdir -p $(pg_io)
	psql $(pg_uri) -c "drop table if exists osm cascade; drop table if exists ingest.pk028_osm cascade;"
	@tput bold
	@echo Extraindo ....
	@tput sgr0
	cd $(pg_io) ; 7z e -y  $(OSM_ZIP) $(OSM).* > /dev/null
	@echo "Conferindo se SRID esta configurado:"
	@( psql $(pg_uri) -c "SELECT srid, proj4text FROM spatial_ref_sys where srid=31983" )
	@echo Executando shp2pgsql ...
	@( cd $(pg_io) ; shp2pgsql -W iso-8859-1 -s 31983 $(OSM).shp osm | psql -q $(pg_uri) 2> /dev/null  )
	@echo "Conferira se bate o perfil:  7085 |  0.00 |  0.00 |  0.00 |     0.00 "
	psql $(pg_uri) -c "SELECT count(*) n, round(max(a),2) a_max, round(min(a),2) a_min, round(avg(a),2) a_avg, round(percentile_disc(0.5) WITHIN GROUP ( ORDER BY a),2) a_median FROM ( select  st_area(geom) a from osm ) t"
	psql $(pg_uri) -c "CREATE TABLE ingest.pk028_osm AS select gid, name,  ST_centroid(ST_Transform(geom,4326)) as geom FROM osm"
	@echo Limpando...
	rm $(pg_io)/$(OSM).*
	psql $(pg_uri) -c "drop table osm cascade"
	@echo FIM.


etl_toPgis_edificacoes:
# ETL extrating to PostgreSQL/PostGIS the "edificacoes" datatype (point and house number)
	@echo "Creating table ingest.pk028_edificacoes on PostGIS"
	@whoami
	@echo "Run with tmux and sudo! (DANGER: seems not idempotent on psql)"
	mkdir -p $(pg_io)
	psql $(pg_uri) -c "drop table if exists edificacoes cascade; drop table if exists ingest.pk028_edificacoes cascade;"
	@tput bold
	@echo Extraindo ....
	@tput sgr0
	cd $(pg_io) ; 7z e -y  $(EDIFICACOES_ZIP) $(EDIFICACOES).* > /dev/null
	@echo "Conferindo se SRID esta configurado:"
	@( psql $(pg_uri) -c "SELECT srid, proj4text FROM spatial_ref_sys where srid=31983" )
	@echo Executando shp2pgsql ...
	@( cd $(pg_io) ; shp2pgsql -s 31983 $(EDIFICACOES).shp ingest.pk028_edificacoes | psql -q $(pg_uri) 2> /dev/null  )
	#@echo "Conferira se bate o perfil:  154067 | 112.28 |  0.81 | 12.24 |    11.65"
	#psql $(pg_uri) -c "SELECT count(*) n, round(max(a),2) a_max, round(min(a),2) a_min, round(avg(a),2) a_avg, round(percentile_disc(0.5) WITHIN GROUP ( ORDER BY a),2) a_median FROM ( select  st_area(geom) a from nro_imovel ) t"
	#psql $(pg_uri) -c "CREATE TABLE ingest.pk028_edificacoes AS select gid, setor, textstring as housenumber, ST_centroid(ST_Transform(geom,4326)) as geom FROM nro_imovel"
	@echo Limpando...
	rm $(pg_io)/$(EDIFICACOES).*
	psql $(pg_uri) -c "drop table edificacoes cascade"
	@echo FIM.

etl_toPgis_bairros:
# ETL extrating to PostgreSQL/PostGIS the "bairros" datatype (point and house number)
	@echo "Creating table ingest.pk028_bairros on PostGIS"
	@whoami
	@echo "Run with tmux and sudo! (DANGER: seems not idempotent on psql)"
	mkdir -p $(pg_io)
	psql $(pg_uri) -c "drop table if exists bairros cascade; drop table if exists ingest.pk028_bairros cascade;"
	@tput bold
	@echo Extraindo ....
	@tput sgr0
	cd $(pg_io) ; 7z e -y  $(BAIRROS_ZIP) $(BAIRROS).* > /dev/null
	@echo "Conferindo se SRID esta configurado:"
	@( psql $(pg_uri) -c "SELECT srid, proj4text FROM spatial_ref_sys where srid=31983" )
	@echo Executando shp2pgsql ...
	@( cd $(pg_io) ; shp2pgsql -s 31983 $(BAIRROS).shp ingest.pk028_bairros | psql -q $(pg_uri) 2> /dev/null  )
	#@echo "Conferira se bate o perfil:  154067 | 112.28 |  0.81 | 12.24 |    11.65"
	#psql $(pg_uri) -c "SELECT count(*) n, round(max(a),2) a_max, round(min(a),2) a_min, round(avg(a),2) a_avg, round(percentile_disc(0.5) WITHIN GROUP ( ORDER BY a),2) a_median FROM ( select  st_area(geom) a from nro_imovel ) t"
	#psql $(pg_uri) -c "CREATE TABLE ingest.pk028_bairros AS select gid, setor, textstring as housenumber, ST_centroid(ST_Transform(geom,4326)) as geom FROM nro_imovel"
	@echo Limpando...
	rm $(pg_io)/$(BAIRROS).*
	psql $(pg_uri) -c "drop table bairros cascade"
	@echo FIM.

