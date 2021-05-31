
# PWD:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
pg_io  =/tmp/pg_io
ori    =/var/www/preserv.addressforall.org/download
pg_uri ="postgres://postgres@localhost/ingest1"

LOTES_ZIP     =$(ori)/3d4a6f528249d062a0bcfb18aa6c115828bb651a164617489c14017b6433c02a.zip
LOTES         =lotes2020_uso

PASTA         =*

LOTESR_ZIP    =$(ori)/3d4a6f528249d062a0bcfb18aa6c115828bb651a164617489c14017b6433c02a.zip
LOTESR        =Lotes_rurais

QUADRAS_ZIP   =$(ori)/3d4a6f528249d062a0bcfb18aa6c115828bb651a164617489c14017b6433c02a.zip
QUADRAS       =Edificacoes

EIXOS_ZIP     =$(ori)/207c82a3f2fa79f943c7b393b0e4fe636ff60305302f9c64c8364851fc6bf6c2.zip
EIXOS         =logradouros

all:
	@echo Favor consultar as opcoes de target

etl_toPgis_lotes:
# ETL extrating to PostgreSQL/PostGIS the "lotes" datatype (point and house number)
	@echo "Creating table ingest.pk038_lotes on PostGIS"
	@whoami
	@echo "Run with tmux and sudo! (DANGER: seems not idempotent on psql)"
	mkdir -p $(pg_io)
	psql $(pg_uri) -c "drop table if exists lotes cascade; drop table if exists ingest.pk038_lotes cascade;"
	@tput bold
	@echo Extraindo ....
	@tput sgr0
	cd $(pg_io) ; 7z e -y  $(LOTES_ZIP) $(PASTA)/$(LOTES).* > /dev/null
	@echo "Conferindo se SRID esta configurado:"
	@( psql $(pg_uri) -c "SELECT srid, proj4text FROM spatial_ref_sys where srid=31982" )
	@echo Executando shp2pgsql ...
	@( cd $(pg_io) ; shp2pgsql -s 31982 $(LOTES).shp lotes | psql -q $(pg_uri) 2> /dev/null  )
	@echo "Conferira se bate o perfil:  140816 | 5121513.19 |  0.00 | 1494.82 |   396.85 "
	psql $(pg_uri) -c "SELECT count(*) n, round(max(a),2) a_max, round(min(a),2) a_min, round(avg(a),2) a_avg, round(percentile_disc(0.5) WITHIN GROUP ( ORDER BY a),2) a_median FROM ( select  st_area(geom) a from lotes ) t"
	psql $(pg_uri) -c "CREATE TABLE ingest.pk038_lotes AS select gid, ___logradour, ___numero_25, ___bairro_28, uso, ST_centroid(ST_Transform(geom,4326)) as geom FROM lotes"
	@echo Limpando...
	rm $(pg_io)/$(LOTES).*
	psql $(pg_uri) -c "drop table lotes cascade"
	@echo FIM.

etl_toPgis_lotesr:
# ETL extrating to PostgreSQL/PostGIS the "lotesr" datatype (point and house number)
	@echo "Creating table ingest.pk038_lotesr on PostGIS"
	@whoami
	@echo "Run with tmux and sudo! (DANGER: seems not idempotent on psql)"
	mkdir -p $(pg_io)
	psql $(pg_uri) -c "drop table if exists lotesr cascade; drop table if exists ingest.pk038_lotesr cascade;"
	@tput bold
	@echo Extraindo ....
	@tput sgr0
	cd $(pg_io) ; 7z e -y  $(LOTESR_ZIP) $(PASTA)/$(LOTESR).* > /dev/null
	@echo "Conferindo se SRID esta configurado:"
	@( psql $(pg_uri) -c "SELECT srid, proj4text FROM spatial_ref_sys where srid=31982" )
	@echo Executando shp2pgsql ...
	@( cd $(pg_io) ; shp2pgsql -s 31982 $(LOTESR).shp lotesr | psql -q $(pg_uri) 2> /dev/null  )
	@echo "Conferira se bate o perfil:   3761 | 50664452.86 | 12.21 | 274018.68 | 58697.75 "
	psql $(pg_uri) -c "SELECT count(*) n, round(max(a),2) a_max, round(min(a),2) a_min, round(avg(a),2) a_avg, round(percentile_disc(0.5) WITHIN GROUP ( ORDER BY a),2) a_median FROM ( select  st_area(geom) a from lotesr ) t"
	psql $(pg_uri) -c "CREATE TABLE ingest.pk038_lotesr AS select gid, iq_lote, ST_centroid(ST_Transform(geom,4326)) as geom FROM lotesr"
	@echo Limpando...
	rm $(pg_io)/$(LOTESR).*
	psql $(pg_uri) -c "drop table lotesr cascade"
	@echo FIM.

etl_toPgis_quadras:
# ETL extrating to PostgreSQL/PostGIS the "quadras" datatype (point and house number)
	@echo "Creating table ingest.pk038_quadras on PostGIS"
	@whoami
	@echo "Run with tmux and sudo! (DANGER: seems not idempotent on psql)"
	mkdir -p $(pg_io)
	psql $(pg_uri) -c "drop table if exists quadras cascade; drop table if exists ingest.pk038_quadras cascade;"
	@tput bold
	@echo Extraindo ....
	@tput sgr0
	cd $(pg_io) ; 7z e -y  $(QUADRAS_ZIP) $(PASTA)/$(QUADRAS).* > /dev/null
	@echo "Conferindo se SRID esta configurado:"
	@( psql $(pg_uri) -c "SELECT srid, proj4text FROM spatial_ref_sys where srid=31982" )
	@echo Executando shp2pgsql ...
	@( cd $(pg_io) ; shp2pgsql -s 31982 $(QUADRAS).shp quadras | psql -q $(pg_uri) 2> /dev/null  )
	@echo "Conferira se bate o perfil:   207014 | 59033.99 |  0.00 | 137.48 |   108.64 "
	psql $(pg_uri) -c "SELECT count(*) n, round(max(a),2) a_max, round(min(a),2) a_min, round(avg(a),2) a_avg, round(percentile_disc(0.5) WITHIN GROUP ( ORDER BY a),2) a_median FROM ( select  st_area(geom) a from quadras ) t"
	psql $(pg_uri) -c "SELECT column_name, data_type FROM information_schema.columns WHERE table_name = 'quadras'"
	psql $(pg_uri) -c "SELECT nome from quadras LIMIT 10"
	psql $(pg_uri) -c "CREATE TABLE ingest.pk038_quadras AS select gid, iq, ST_centroid(ST_Transform(geom,4326)) as geom FROM quadras"
	@echo Limpando...
	rm $(pg_io)/$(QUADRAS).*
	psql $(pg_uri) -c "drop table quadras cascade"
	@echo FIM.


etl_toPgis_eixos:
# ETL extrating to PostgreSQL/PostGIS the "eixos" datatype (point and house number)
	@echo "Creating table ingest.pk038_eixos on PostGIS"
	@whoami
	@echo "Run with tmux and sudo! (DANGER: seems not idempotent on psql)"
	mkdir -p $(pg_io)
	psql $(pg_uri) -c "drop table if exists eixos cascade; drop table if exists ingest.pk038_eixos cascade;"
	@tput bold
	@echo Extraindo ....
	@tput sgr0
	cd $(pg_io) ; 7z e -y  $(EIXOS_ZIP) $(PASTA)/$(EIXOS).* > /dev/null
	@echo "Conferindo se SRID esta configurado:"
	@( psql $(pg_uri) -c "SELECT srid, proj4text FROM spatial_ref_sys where srid=31982" )
	@echo Executando shp2pgsql ...
	@( cd $(pg_io) ; shp2pgsql -s 31982 $(EIXOS).shp eixos | psql -q $(pg_uri) 2> /dev/null  )
	@echo "Conferira se bate o perfil:  16788 |  0.00 |  0.00 |  0.00 |     0.00 "
	psql $(pg_uri) -c "SELECT count(*) n, round(max(a),2) a_max, round(min(a),2) a_min, round(avg(a),2) a_avg, round(percentile_disc(0.5) WITHIN GROUP ( ORDER BY a),2) a_median FROM ( select  st_area(geom) a from eixos ) t"
	psql $(pg_uri) -c "CREATE TABLE ingest.pk038_eixos AS select gid, nomelog, ST_centroid(ST_Transform(geom,4326)) as geom FROM eixos"
	@echo Limpando...
	rm $(pg_io)/$(EIXOS).*
	psql $(pg_uri) -c "drop table eixos cascade"
	@echo FIM.

