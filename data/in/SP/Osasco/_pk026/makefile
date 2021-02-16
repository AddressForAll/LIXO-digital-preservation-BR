
# PWD:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
pg_io  =/tmp/pg_io
ori    =/var/www/preserv.addressforall.org/download
pg_uri ="postgres://postgres@localhost/ingest1"

LOTES_ZIP     =$(ori)/3d4a6f528249d062a0bcfb18aa6c115828bb651a164617489c14017b6433c02a.zip
LOTES         =lotes2020_uso

PASTA         =*

LOTESR_ZIP    =$(ori)/3d4a6f528249d062a0bcfb18aa6c115828bb651a164617489c14017b6433c02a.zip
LOTESR        =Lotes_rurais

EDIFICACOES_ZIP   =$(ori)/3d4a6f528249d062a0bcfb18aa6c115828bb651a164617489c14017b6433c02a.zip
EDIFICACOES       =Edificacoes

EIXOS_ZIP     =$(ori)/207c82a3f2fa79f943c7b393b0e4fe636ff60305302f9c64c8364851fc6bf6c2.zip
EIXOS         =logradouros

all:
	@echo Favor consultar as opcoes de target

etl_toPgis_lotes:
# ETL extrating to PostgreSQL/PostGIS the "lotes" datatype (point and house number)
	@echo "Creating table ingest.pk026_lotes on PostGIS"
	@whoami
	@echo "Run with tmux and sudo! (DANGER: seems not idempotent on psql)"
	mkdir -p $(pg_io)
	psql $(pg_uri) -c "drop table if exists lotes cascade; drop table if exists ingest.pk026_lotes cascade;"
	@tput bold
	@echo Extraindo ....
	@tput sgr0
	cd $(pg_io) ; 7z e -y  $(LOTES_ZIP) $(PASTA)/$(LOTES).* > /dev/null
	@echo "Conferindo se SRID esta configurado:"
	@( psql $(pg_uri) -c "SELECT srid, proj4text FROM spatial_ref_sys where srid=31982" )
	@echo Executando shp2pgsql ...
	@( cd $(pg_io) ; shp2pgsql -s 31982 $(LOTES).shp lotes | psql -q $(pg_uri) 2> /dev/null  )
	@echo "Conferira se bate o perfil:  154067 | 112.28 |  0.81 | 12.24 |    11.65"
	psql $(pg_uri) -c "SELECT count(*) n, round(max(a),2) a_max, round(min(a),2) a_min, round(avg(a),2) a_avg, round(percentile_disc(0.5) WITHIN GROUP ( ORDER BY a),2) a_median FROM ( select  st_area(geom) a from nro_imovel ) t"
	psql $(pg_uri) -c "CREATE TABLE ingest.pk026_lotes AS select gid, setor, textstring as housenumber, ST_centroid(ST_Transform(geom,4326)) as geom FROM nro_imovel"
	@echo Limpando...
	rm $(pg_io)/$(LOTES).*
	psql $(pg_uri) -c "drop table lotes cascade"
	@echo FIM.

etl_toPgis_lotesr:
# ETL extrating to PostgreSQL/PostGIS the "lotesr" datatype (point and house number)
	@echo "Creating table ingest.pk026_lotesr on PostGIS"
	@whoami
	@echo "Run with tmux and sudo! (DANGER: seems not idempotent on psql)"
	mkdir -p $(pg_io)
	psql $(pg_uri) -c "drop table if exists lotesr cascade; drop table if exists ingest.pk026_lotesr cascade;"
	@tput bold
	@echo Extraindo ....
	@tput sgr0
	cd $(pg_io) ; 7z e -y  $(LOTESR_ZIP) $(PASTA)/$(LOTESR).* > /dev/null
	@echo "Conferindo se SRID esta configurado:"
	@( psql $(pg_uri) -c "SELECT srid, proj4text FROM spatial_ref_sys where srid=31982" )
	@echo Executando shp2pgsql ...
	@( cd $(pg_io) ; shp2pgsql -s 31982 $(LOTESR).shp ingest.pk026_lotesr | psql -q $(pg_uri) 2> /dev/null  )
	#@echo "Conferira se bate o perfil:  154067 | 112.28 |  0.81 | 12.24 |    11.65"
	#psql $(pg_uri) -c "SELECT count(*) n, round(max(a),2) a_max, round(min(a),2) a_min, round(avg(a),2) a_avg, round(percentile_disc(0.5) WITHIN GROUP ( ORDER BY a),2) a_median FROM ( select  st_area(geom) a from nro_imovel ) t"
	#psql $(pg_uri) -c "CREATE TABLE ingest.pk026_lotesr AS select gid, setor, textstring as housenumber, ST_centroid(ST_Transform(geom,4326)) as geom FROM nro_imovel"
	@echo Limpando...
	rm $(pg_io)/$(LOTESR).*
	psql $(pg_uri) -c "drop table lotesr cascade"
	@echo FIM.

etl_toPgis_edificacoes:
# ETL extrating to PostgreSQL/PostGIS the "edificacoes" datatype (point and house number)
	@echo "Creating table ingest.pk026_edificacoes on PostGIS"
	@whoami
	@echo "Run with tmux and sudo! (DANGER: seems not idempotent on psql)"
	mkdir -p $(pg_io)
	psql $(pg_uri) -c "drop table if exists edificacoes cascade; drop table if exists ingest.pk026_edificacoes cascade;"
	@tput bold
	@echo Extraindo ....
	@tput sgr0
	cd $(pg_io) ; 7z e -y  $(EDIFICACOES_ZIP) $(PASTA)/$(EDIFICACOES).* > /dev/null
	@echo "Conferindo se SRID esta configurado:"
	@( psql $(pg_uri) -c "SELECT srid, proj4text FROM spatial_ref_sys where srid=31982" )
	@echo Executando shp2pgsql ...
	@( cd $(pg_io) ; shp2pgsql -s 31982 $(EDIFICACOES).shp ingest.pk026_edificacoes | psql -q $(pg_uri) 2> /dev/null  )
	#@echo "Conferira se bate o perfil:  154067 | 112.28 |  0.81 | 12.24 |    11.65"
	#psql $(pg_uri) -c "SELECT count(*) n, round(max(a),2) a_max, round(min(a),2) a_min, round(avg(a),2) a_avg, round(percentile_disc(0.5) WITHIN GROUP ( ORDER BY a),2) a_median FROM ( select  st_area(geom) a from nro_imovel ) t"
	#psql $(pg_uri) -c "CREATE TABLE ingest.pk026_edificacoes AS select gid, setor, textstring as housenumber, ST_centroid(ST_Transform(geom,4326)) as geom FROM nro_imovel"
	@echo Limpando...
	rm $(pg_io)/$(EDIFICACOES).*
	psql $(pg_uri) -c "drop table edificacoes cascade"
	@echo FIM.


etl_toPgis_eixos:
# ETL extrating to PostgreSQL/PostGIS the "eixos" datatype (point and house number)
	@echo "Creating table ingest.pk026_eixos on PostGIS"
	@whoami
	@echo "Run with tmux and sudo! (DANGER: seems not idempotent on psql)"
	mkdir -p $(pg_io)
	psql $(pg_uri) -c "drop table if exists eixos cascade; drop table if exists ingest.pk026_eixos cascade;"
	@tput bold
	@echo Extraindo ....
	@tput sgr0
	cd $(pg_io) ; 7z e -y  $(EIXOS_ZIP) $(PASTA)/$(EIXOS).* > /dev/null
	@echo "Conferindo se SRID esta configurado:"
	@( psql $(pg_uri) -c "SELECT srid, proj4text FROM spatial_ref_sys where srid=31982" )
	@echo Executando shp2pgsql ...
	@( cd $(pg_io) ; shp2pgsql -s 31982 $(EIXOS).shp ingest.pk026_eixos | psql -q $(pg_uri) 2> /dev/null  )
	#@echo "Conferira se bate o perfil:  154067 | 112.28 |  0.81 | 12.24 |    11.65"
	#psql $(pg_uri) -c "SELECT count(*) n, round(max(a),2) a_max, round(min(a),2) a_min, round(avg(a),2) a_avg, round(percentile_disc(0.5) WITHIN GROUP ( ORDER BY a),2) a_median FROM ( select  st_area(geom) a from nro_imovel ) t"
	#psql $(pg_uri) -c "CREATE TABLE ingest.pk026_eixos AS select gid, setor, textstring as housenumber, ST_centroid(ST_Transform(geom,4326)) as geom FROM nro_imovel"
	@echo Limpando...
	rm $(pg_io)/$(EIXOS).*
	psql $(pg_uri) -c "drop table eixos cascade"
	@echo FIM.

