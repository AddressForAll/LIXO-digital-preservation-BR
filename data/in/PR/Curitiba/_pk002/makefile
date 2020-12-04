
# PWD:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
pg_io  =/tmp/pg_io
ori    =/var/www/preserv.addressforall.org/download
pg_uri ="postgres://postgres@localhost/ingest1"

NRO_IMOVEL_ZIP     =$(ori)/fbc62efdbd0f16a7db03b5b775c50c9425367a8dee8a85d9b53e4475bbdb99d2.zip
NRO_IMOVEL_EXTRACT =NRO_IMOVEL


all:
	@echo Favor consultar as opcoes de target

etl_toPgis_P2:
# ETL extrating to PostgreSQL/PostGIS the "P2" datatype (point and house number)
	@echo "Creating table ingest.pk027_p2 on PostGIS"
	@whoami
	@echo "Run with tmux and sudo! (DANGER: seems not idempotent on psql)"
	mkdir -p $(pg_io)
	psql $(pg_uri) -c "drop table if exists nro_imovel cascade; drop table if exists ingest.pk027_p2 cascade;"
	@tput bold
	@echo Extraindo ....
	@tput sgr0
	cd $(pg_io) ; 7z e -y  $(NRO_IMOVEL_ZIP) $(NRO_IMOVEL).* > /dev/null
	@echo "Conferindo se SRID esta configurado:"
	@( psql $(pg_uri) -c "SELECT srid, proj4text FROM spatial_ref_sys where srid=952013" )
	@echo Executando shp2pgsql ...
	@( cd $(pg_io) ; shp2pgsql -s 952013 $(NRO_IMOVEL).shp ingest.pk027_p2 | psql -q $(pg_uri) 2> /dev/null  )
	@echo "Conferira se bate o perfil:  154067 | 112.28 |  0.81 | 12.24 |    11.65"
	psql $(pg_uri) -c "SELECT count(*) n, round(max(a),2) a_max, round(min(a),2) a_min, round(avg(a),2) a_avg, round(percentile_disc(0.5) WITHIN GROUP ( ORDER BY a),2) a_median FROM ( select  st_area(geom) a from nro_imovel ) t"
	psql $(pg_uri) -c "CREATE TABLE ingest.pk027_p2 AS select gid, setor, textstring as housenumber, ST_centroid(ST_Transform(geom,4326)) as geom FROM nro_imovel"
	@echo Limpando...
	rm $(pg_io)/$(NRO_IMOVEL).*
	psql $(pg_uri) -c "drop table nro_imovel cascade"
	@echo FIM.

# Make all lista os targets
# ToDo csv pandas
EIXOS_ZIP       =$(ori)/c35e3b2825d3da122a74c6c8dd5f3157a3bd6201208d2a6d13dec433a6ded9fc.zip
EIXOS_SHPREFIX  = EixosLogradouros
etl_toPgis_eixos:
	@echo "Creating table ingest.pk027_eixo on PostGIS"
	@whoami
	@echo "Run with tmux and sudo! (DANGER: seems not idempotent on psql)"
	mkdir -p $(pg_io)
	@echo psql $(pg_uri) -c "drop table if exists ingest1.pk027_eixo cascade;"
	@tput bold
	@echo Extraindo ....
	@tput sgr0
	cd $(pg_io) ; 7z e -y  $(EIXOS_ZIP) $(EIXOS_SHPREFIX).* > /dev/null
	@echo Executando shp2pgsql ...
	@( cd $(pg_io) ; shp2pgsql -s 952013 $(EIXOS_SHPREFIX).shp ingest.pk027_eixo | psql -q $(pg_uri) 2> /dev/null  )
	@echo "Conferindo se SRID esta configurado:"


BAIRROS_ZIP	=$(ori)/258772459588f7941ac6eeda7c6839df02d58741cf6bc3e48825aecd60418251.zip
BAIRROS_SHPREFIX= Bairros_LC12112_16
etl_toPgis_bairros:
	@echo "Creating table ingest.pk027_bairros on PostGIS"
	@whoami
	@echo "Run with tmux and sudo! (DANGER: seems not idempotent on psql)"
	mkdir -p $(pg_io)
	@echo psql $(pg_uri) -c "drop table if exists ingest.pk027_bairros cascade;"
	@tput bold
	@echo Extraindo ....
	@tput sgr0
	cd $(pg_io) ; 7z e -y  $(BAIRROS_ZIP) $(BAIRROS_SHPREFIX).* > /dev/null
	@echo Executando shp2pgsql ...
	@( cd $(pg_io) ; shp2pgsql -s 952013 $(BAIRROS_SHPREFIX).shp ingest.pk027_bairros | psql -q $(pg_uri) 2> /dev/null  )
	@echo "Conferindo se SRID esta configurado:"

