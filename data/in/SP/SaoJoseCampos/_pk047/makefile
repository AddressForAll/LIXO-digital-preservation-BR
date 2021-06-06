
# PWD:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
pg_io  =/tmp/pg_io
ori    =/var/www/preserv.addressforall.org/download
pg_uri ="postgres://postgres@localhost/ingest1"

NRO_IMOVEL_ZIP     =$(ori)/fbc62efdbd0f16a7db03b5b775c50c9425367a8dee8a85d9b53e4475bbdb99d2.zip
NRO_IMOVEL         =NRO_IMOVEL


all:
	@echo Favor consultar as opcoes de target

etl_toPgis_P2:
# ETL extrating to PostgreSQL/PostGIS the "P2" datatype (point and house number)
	@echo "Creating table ingest.pk047_p2 on PostGIS"
	@whoami
	@echo "Run with tmux and sudo! (DANGER: seems not idempotent on psql)"
	mkdir -p $(pg_io)
	psql $(pg_uri) -c "drop table if exists nro_imovel cascade; drop table if exists ingest.pk047_p2 cascade;"
	@tput bold
	@echo Extraindo ....
	@tput sgr0
	cd $(pg_io) ; 7z e -y  $(NRO_IMOVEL_ZIP) $(NRO_IMOVEL).* > /dev/null
	@echo "Conferindo se SRID esta configurado:"
	@( psql $(pg_uri) -c "SELECT srid, proj4text FROM spatial_ref_sys where srid=952013" )
	@echo Executando shp2pgsql ...
	@( cd $(pg_io) ; shp2pgsql -s 952013 $(NRO_IMOVEL).shp nro_imovel | psql -q $(pg_uri) 2> /dev/null  )
	@echo "Conferira se bate o perfil:  154067 | 112.28 |  0.81 | 12.24 |    11.65"
	psql $(pg_uri) -c "SELECT count(*) n, round(max(a),2) a_max, round(min(a),2) a_min, round(avg(a),2) a_avg, round(percentile_disc(0.5) WITHIN GROUP ( ORDER BY a),2) a_median FROM ( select  st_area(geom) a from nro_imovel ) t"
	psql $(pg_uri) -c "CREATE TABLE ingest.pk047_p2 AS select gid, setor, textstring as housenumber, ST_centroid(ST_Transform(geom,4326)) as geom FROM nro_imovel"
	@echo Limpando...
	rm $(pg_io)/$(NRO_IMOVEL).*
	psql $(pg_uri) -c "drop table nro_imovel cascade"
	@echo FIM.

EIXOS_ZIP       =$(ori)/6effb451da343480c3acca559cf55536315c104974fb00f9c9d46b6034e1b2aa.zip
EIXOS_SHPREFIX  =LOGRADOUROS
etl_toPgis_eixos:
	@echo "Creating table ingest.pk047_eixos on PostGIS"
	@whoami
	@echo "Run with tmux and sudo! (DANGER: seems not idempotent on psql)"
	mkdir -p $(pg_io)
	@psql $(pg_uri) -c "drop table eixos cascade; drop table ingest.pk047_eixos cascade;"
	@tput bold
	@echo Extraindo ....
	@tput sgr0
	cd $(pg_io) ; 7z e -y  $(EIXOS_ZIP) $(EIXOS_SHPREFIX).* > /dev/null
	@echo "Conferindo se SRID esta configurado:"
	@( psql $(pg_uri) -c "SELECT srid, proj4text FROM spatial_ref_sys where srid=31983" )
	@echo Executando shp2pgsql ...
	@( cd $(pg_io) ; shp2pgsql -s 31983 $(EIXOS_SHPREFIX).shp eixos |  psql -q $(pg_uri) 2> /dev/null  )
	@echo "Conferira se bate o perfil:  9404 |  0.00 |  0.00 |  0.00 |     0.00 "
	psql $(pg_uri) -c "SELECT count(*) n, round(max(a),2) a_max, round(min(a),2) a_min, round(avg(a),2) a_avg, round(percentile_disc(0.5) WITHIN GROUP ( ORDER BY a),2) a_median FROM ( select  st_area(geom) a from eixos ) t"
	psql $(pg_uri) -c "CREATE TABLE ingest.pk047_eixos AS select gid, oms_id, nome, ST_centroid(ST_Transform(geom,4326)) as geom FROM eixos"
	@echo Limpando...
	rm $(pg_io)/$(EIXOS_SHPREFIX).*
	psql $(pg_uri) -c "drop table eixos cascade"
	@echo FIM.


BAIRROS_ZIP	=$(ori)/258772459588f7941ac6eeda7c6839df02d58741cf6bc3e48825aecd60418251.zip
BAIRROS_SHPREFIX= Bairros_LC12112_16
etl_toPgis_bairros:
	@echo "Creating table ingest.pk047_bairros on PostGIS"
	@whoami
	@echo "Run with tmux and sudo! (DANGER: seems not idempotent on psql)"
	mkdir -p $(pg_io)
	@echo psql $(pg_uri) -c "drop table if exists ingest.pk047_bairros cascade;"
	@tput bold
	@echo Extraindo ....
	@tput sgr0
	cd $(pg_io) ; 7z e -y  $(BAIRROS_ZIP) $(BAIRROS_SHPREFIX).* > /dev/null
	@echo Executando shp2pgsql ...
	@( cd $(pg_io) ; shp2pgsql -s 952013 $(BAIRROS_SHPREFIX).shp bairros | psql -q $(pg_uri) 2> /dev/null  )
	@echo "Conferira se bate o perfil:  154067 | 112.28 |  0.81 | 12.24 |    11.65"
	psql $(pg_uri) -c "SELECT count(*) n, round(max(a),2) a_max, round(min(a),2) a_min, round(avg(a),2) a_avg, round(percentile_disc(0.5) WITHIN GROUP ( ORDER BY a),2) a_median FROM ( select  st_area(geom) a from bairros ) t"
	psql $(pg_uri) -c "SELECT column_name, data_type FROM information_schema.columns WHERE table_name = 'bairros'"
	psql $(pg_uri) -c "CREATE TABLE ingest.pk047_p2 AS select gid, NOME, ST_centroid(ST_Transform(geom,4326)) as geom FROM bairros"
	@echo Limpando...
	rm $(pg_io)/$(NRO_IMOVEL_EXTRACT).*
	psql $(pg_uri) -c "drop table nro_imovel cascade"
	@echo FIM.
