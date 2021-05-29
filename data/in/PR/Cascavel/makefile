
# PWD:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
pg_io  =/tmp/pg_io
ori    =/var/www/preserv.addressforall.org/download
pg_uri ="postgres://postgres@localhost/ingest1"

BAIRROS_ZIP     =$(ori)/305df61c61e90caef0a0409a09b7d01a56beb6e107ae4430188617c7058f02a1.zip
BAIRROS_EXTRACT =Bairros

EIXOS_ZIP       =$(ori)/f4fe1f604f927b1d07ae56ec11ea9e3c4c64a4d02c01ce80ad041beadab165dc.zip
EIXOS_EXTRACT   =Logradouros

LOTES_ZIP       =$(ori)/ae8dc027fe9e0983b553508c3a313061f7f466c50d66124c86c96254f70c4c15.zip
LOTES_EXTRACT   =Lotes


all:
	@echo Favor consultar as opcoes de target

etl_toPgis_Bairros:
# ETL extrating to PostgreSQL/PostGIS the "Bairros" datatype (point and house number)
	@echo "Creating table ingest.pk016_bairros on PostGIS"
	@whoami
	@echo "Run with tmux and sudo! (DANGER: seems not idempotent on psql)"
	mkdir -p $(pg_io)
	psql $(pg_uri) -c "drop table if exists bairros cascade; drop table if exists ingest.pk016_bairros cascade;"
	@tput bold
	@echo Extraindo ....
	@tput sgr0
	cd $(pg_io) ; 7z e -y  $(BAIRROS_ZIP) $(BAIRROS_EXTRACT).* > /dev/null
	@echo "Conferindo se SRID esta configurado:"
	@( psql $(pg_uri) -c "SELECT srid, proj4text FROM spatial_ref_sys where srid=31982" )
	@echo Executando shp2pgsql ...
	@( cd $(pg_io) ; shp2pgsql -W iso-8859-1 -s 31982 $(BAIRROS_EXTRACT).shp bairros | psql -q $(pg_uri) 2> /dev/null  )
	@echo "Conferira se bate o perfil:  32 | 7871259.83 | 1231978.28 | 3355085.32 | 2879061.01 "
	psql $(pg_uri) -c "SELECT count(*) n, round(max(a),2) a_max, round(min(a),2) a_min, round(avg(a),2) a_avg, round(percentile_disc(0.5) WITHIN GROUP ( ORDER BY a),2) a_median FROM ( select  st_area(geom) a from bairros ) t"
	psql $(pg_uri) -c "CREATE TABLE ingest.pk016_bairros AS select gid,  nmbairro as neighborhood, ST_centroid(ST_Transform(geom,4326)) as geom FROM bairros"
	@echo Limpando...
	rm $(pg_io)/$(BAIRROS_EXTRACT).*
	psql $(pg_uri) -c "drop table bairros cascade"
	@echo FIM.

etl_toPgis_Eixos:
# ETL extrating to PostgreSQL/PostGIS the "Eixos" datatype (point and house number)
	@echo "Creating table ingest.pk016_eixos on PostGIS"
	@whoami
	@echo "Run with tmux and sudo! (DANGER: seems not idempotent on psql)"
	mkdir -p $(pg_io)
	psql $(pg_uri) -c "drop table if exists eixos cascade; drop table if exists ingest.pk016_eixos cascade;"
	@tput bold
	@echo Extraindo ....
	@tput sgr0
	cd $(pg_io) ; 7z e -y  $(EIXOS_ZIP) $(EIXOS_EXTRACT).* > /dev/null
	@echo "Conferindo se SRID esta configurado:"
	@( psql $(pg_uri) -c "SELECT srid, proj4text FROM spatial_ref_sys where srid=31982" )
	@echo Executando shp2pgsql ...
	@( cd $(pg_io) ; shp2pgsql -s 31982 $(EIXOS_EXTRACT).shp eixos | psql -q $(pg_uri) 2> /dev/null  )
	@echo "Conferira se bate o perfil:   6220 |  0.00 |  0.00 |  0.00 |     0.00 "
	psql $(pg_uri) -c "SELECT count(*) n, round(max(a),2) a_max, round(min(a),2) a_min, round(avg(a),2) a_avg, round(percentile_disc(0.5) WITHIN GROUP ( ORDER BY a),2) a_median FROM ( select  st_area(geom) a from eixos ) t"
	psql $(pg_uri) -c "CREATE TABLE ingest.pk016_eixos AS select gid, tipolograd, nmlogradou, ST_centroid(ST_Transform(geom,4326)) as geom FROM eixos"
	@echo Limpando...
	rm $(pg_io)/$(EIXOS_EXTRACT).*
	psql $(pg_uri) -c "drop table eixos cascade"
	@echo FIM.

etl_toPgis_Lotes:
# ETL extrating to PostgreSQL/PostGIS the "Lotes" datatype (point and house number)
	@echo "Creating table ingest.pk016_lotes on PostGIS"
	@whoami
	@echo "Run with tmux and sudo! (DANGER: seems not idempotent on psql)"
	mkdir -p $(pg_io)
	psql $(pg_uri) -c "drop table if exists lotes cascade; drop table if exists ingest.pk016_lotes cascade;"
	@tput bold
	@echo Extraindo ....
	@tput sgr0
	cd $(pg_io) ; 7z e -y  $(LOTES_ZIP) $(LOTES_EXTRACT).* > /dev/null
	@echo "Conferindo se SRID esta configurado:"
	@( psql $(pg_uri) -c "SELECT srid, proj4text FROM spatial_ref_sys where srid=31982" )
	@echo Executando shp2pgsql ...
	@( cd $(pg_io) ; shp2pgsql -W iso-8859-1 -s 31982 $(LOTES_EXTRACT).shp lotes | psql -q $(pg_uri) 2> /dev/null  )
	@echo "Conferira se bate o perfil:    161045 | 8997440.63 |  1.29 | 5531.13 |   480.53 "
	psql $(pg_uri) -c "SELECT count(*) n, round(max(a),2) a_max, round(min(a),2) a_min, round(avg(a),2) a_avg, round(percentile_disc(0.5) WITHIN GROUP ( ORDER BY a),2) a_median FROM ( select  st_area(geom) a from lotes ) t"
	psql $(pg_uri) -c "CREATE TABLE ingest.pk016_lotes AS select gid, logradouro, numerologr, ST_centroid(ST_Transform(geom,4326)) as geom FROM lotes"
	@echo Limpando...
	rm $(pg_io)/$(LOTES_EXTRACT).*
	psql $(pg_uri) -c "drop table lotes cascade"
	@echo FIM.

