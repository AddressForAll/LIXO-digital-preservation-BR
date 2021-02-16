
# PWD:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
pg_io  =/tmp/pg_io
ori    =/var/www/preserv.addressforall.org/download
pg_uri ="postgres://postgres@localhost/ingest1"

NRO_IMOVEL_ZIP     =$(ori)/04fffd56aef1c5a53cb35e5864b940b0b103e6e4752adcff7d4f30a2cb99ddb6.zip
NRO_IMOVEL         =Lotes


all:
	@echo Favor consultar as opcoes de target

etl_toPgis_lotes:
# ETL extrating to PostgreSQL/PostGIS the "lotes" datatype (point and house number)
	@echo "Creating table ingest.pk021_lotes on PostGIS"
	@whoami
	@echo "Run with tmux and sudo! (DANGER: seems not idempotent on psql)"
	mkdir -p $(pg_io)
	psql $(pg_uri) -c "drop table if exists lotes cascade; drop table if exists ingest.pk021_lotes cascade;"
	@tput bold
	@echo Extraindo ....
	@tput sgr0
	cd $(pg_io) ; 7z e -y  $(NRO_IMOVEL_ZIP) $(NRO_IMOVEL).* > /dev/null
	@echo "Conferindo se SRID esta configurado:"
	@( psql $(pg_uri) -c "SELECT srid, proj4text FROM spatial_ref_sys where srid=31985" )
	@echo Executando shp2pgsql ...
	@( cd $(pg_io) ; shp2pgsql -s 31985 $(NRO_IMOVEL).shp lotes | psql -q $(pg_uri) 2> /dev/null  )
	@echo "Conferira se bate o perfil: 97920 | 2389279.68 |  0.02 | 589.86 |   238.42 "
	psql $(pg_uri) -c "SELECT count(*) n, round(max(a),2) a_max, round(min(a),2) a_min, round(avg(a),2) a_avg, round(percentile_disc(0.5) WITHIN GROUP ( ORDER BY a),2) a_median FROM ( select  st_area(geom) a from lotes ) t"
	psql $(pg_uri) -c "CREATE TABLE ingest.pk021_lotes AS select gid, ENDNUMERO, QTDPAVIMEN, NMEDIFICAC, ST_centroid(ST_Transform(geom,4326)) as geom FROM lotes"
	@echo Limpando...
	rm $(pg_io)/$(NRO_IMOVEL).*
	psql $(pg_uri) -c "drop table lotes cascade"
	@echo FIM.

EIXOS_ZIP       =$(ori)/04fffd56aef1c5a53cb35e5864b940b0b103e6e4752adcff7d4f30a2cb99ddb6.zip
EIXOS_SHPREFIX  =TrechoLogradouros
etl_toPgis_eixos:
	@echo "Creating table ingest.pk021_eixos on PostGIS"
	@whoami
	@echo "Run with tmux and sudo! (DANGER: seems not idempotent on psql)"
	mkdir -p $(pg_io)
	@psql $(pg_uri) -c "drop table if exists eixos cascade; drop table if exists ingest.pk021_eixos cascade;"
	@tput bold
	@echo Extraindo ....
	@tput sgr0
	cd $(pg_io) ; 7z e -y  $(EIXOS_ZIP) $(EIXOS_SHPREFIX).* > /dev/null
	@echo "Conferindo se SRID esta configurado:"
	@( psql $(pg_uri) -c "SELECT srid, proj4text FROM spatial_ref_sys where srid=31985" )
	@echo Executando shp2pgsql ...
	@( cd $(pg_io) ; shp2pgsql -W iso-8859-1 -s 31985 $(EIXOS_SHPREFIX).shp eixos |  psql -q $(pg_uri) 2> /dev/null  )
	@echo "Conferira se bate o perfil:  9404 |  0.00 |  0.00 |  0.00 |     0.00 "
	psql $(pg_uri) -c "SELECT count(*) n, round(max(a),2) a_max, round(min(a),2) a_min, round(avg(a),2) a_avg, round(percentile_disc(0.5) WITHIN GROUP ( ORDER BY a),2) a_median FROM ( select  st_area(geom) a from eixos ) t"
	psql $(pg_uri) -c "CREATE TABLE ingest.pk021_eixos AS select gid, NLGPAVOFIC, ST_centroid(ST_Transform(geom,4326)) as geom FROM eixos"
	@echo Limpando...
	rm $(pg_io)/$(EIXOS_SHPREFIX).*
	psql $(pg_uri) -c "drop table eixos cascade"
	@echo FIM.


BAIRROS_ZIP	=$(ori)/04fffd56aef1c5a53cb35e5864b940b0b103e6e4752adcff7d4f30a2cb99ddb6.zip
BAIRROS_SHPREFIX=Bairros
etl_toPgis_bairros:
	@echo "Creating table ingest.pk021_bairros on PostGIS"
	@whoami
	@echo "Run with tmux and sudo! (DANGER: seems not idempotent on psql)"
	mkdir -p $(pg_io)
	@psql $(pg_uri) -c "drop table if exists bairros cascade;drop table if exists ingest.pk021_bairros cascade;"
	@tput bold
	@echo Extraindo ....
	@tput sgr0
	cd $(pg_io) ; 7z e -y  $(BAIRROS_ZIP) $(BAIRROS_SHPREFIX).* > /dev/null
	@echo Executando shp2pgsql ...
	@( cd $(pg_io) ; shp2pgsql -W iso-8859-1 -s 31985 $(BAIRROS_SHPREFIX).shp bairros | psql -q $(pg_uri) 2> /dev/null  )
	@echo "Conferira se bate o perfil:  94 | 46819322.87 | 139305.12 | 2373829.90 | 877517.22 "
	psql $(pg_uri) -c "SELECT count(*) n, round(max(a),2) a_max, round(min(a),2) a_min, round(avg(a),2) a_avg, round(percentile_disc(0.5) WITHIN GROUP ( ORDER BY a),2) a_median FROM ( select  st_area(geom) a from bairros ) t"
	psql $(pg_uri) -c "CREATE TABLE ingest.pk021_bairros AS select gid, EBAIRRNO_1, ST_centroid(ST_Transform(geom,4326)) as geom FROM bairros"
	@echo Limpando...
	rm $(pg_io)/$(BAIRROS_SHPREFIX).*
	psql $(pg_uri) -c "drop table bairros cascade"
	@echo FIM.
