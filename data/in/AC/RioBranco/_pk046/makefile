## MUSTACHE MAKE e seu JSON.

pg_io  =/tmp/pg_io
ori    =/var/www/preserv.addressforall.org/download
pg_uri ="postgres://postgres@localhost/ingest1"




=========== ORIGINAL: =============
# PWD:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
pg_io  =/tmp/pg_io
ori    =/var/www/preserv.addressforall.org/download
pg_uri ="postgres://postgres@localhost/ingest1"


all:
	@echo Favor consultar as opcoes de target

LOTES_ZIP       =$(ori)/d96f47270e22336cf4660f742ae4dba5694f15c6833363167c91d9fc9929871b.zip
LOTES_SHPREFIX  =lotes
LOTES_PASTA     =rb_20201116
etl_toPgis_lotes:
	@echo "Creating table ingest.pk046_lotes on PostGIS"
	@whoami
	@echo "Run with tmux and sudo! (DANGER: seems not idempotent on psql)"
	mkdir -p $(pg_io)
	@psql $(pg_uri) -c "drop table if exists lotes cascade; drop table if exists ingest.pk046_lotes cascade;"
	@tput bold
	@echo Extraindo ....
	@tput sgr0
	cd $(pg_io) ; 7z e -y  $(LOTES_ZIP) > /dev/null
	@echo "Conferindo se SRID esta configurado:"
	@( psql $(pg_uri) -c "SELECT srid, proj4text FROM spatial_ref_sys where srid=32719" )
	@echo Executando shp2pgsql ...
	@( cd $(pg_io) ; shp2pgsql -s 32719 $(LOTES_SHPREFIX).shp lotes |  psql -q $(pg_uri) 2> /dev/null  )
	@echo "Conferira se bate o perfil:  106493 | 2701867.67 |  0.00 | 680.77 |   264.14 "
	psql $(pg_uri) -c "SELECT count(*) n, round(max(a),2) a_max, round(min(a),2) a_min, round(avg(a),2) a_avg, round(percentile_disc(0.5) WITHIN GROUP ( ORDER BY a),2) a_median FROM ( select  st_area(geom) a from lotes ) t"
	psql $(pg_uri) -c "CREATE TABLE ingest.pk046_lotes AS select gid, nomelog, endereco_n, ST_centroid(ST_Transform(geom,4326)) as geom FROM lotes"
	@echo Limpando...
	rm $(pg_io)/$(LOTES_SHPREFIX).*
	rm -rf $(pg_io)/$(LOTES_PASTA)
	psql $(pg_uri) -c "drop table lotes cascade"
	@echo FIM.


BAIRROS_ZIP       =$(ori)/73d02ba0ae4b0a994a629f7d06f0a027259f5c1d97e53f9b771fecd345c2a02b.zip
BAIRROS_SHPREFIX  =bairros
BAIRROS_PASTA     =rb_20201111
etl_toPgis_bairros:
	@echo "Creating table ingest.pk046_bairros on PostGIS"
	@whoami
	@echo "Run with tmux and sudo! (DANGER: seems not idempotent on psql)"
	mkdir -p $(pg_io)
	@psql $(pg_uri) -c "drop table if exists bairros cascade; drop table if exists ingest.pk046_bairros cascade;"
	@tput bold
	@echo Extraindo ....
	@tput sgr0
	cd $(pg_io) ; 7z x -y  $(BAIRROS_ZIP) > /dev/null
	@echo "Conferindo se SRID esta configurado:"
	@( psql $(pg_uri) -c "SELECT srid, proj4text FROM spatial_ref_sys where srid=32719" )
	@echo Executando shp2pgsql ...
	@( cd $(pg_io) ; shp2pgsql -s 32719 $(BAIRROS_PASTA)/$(BAIRROS_SHPREFIX).shp bairros |  psql -q $(pg_uri) 2> /dev/null  )
	@echo "Conferira se bate o perfil:208 | 11690044.13 | 37640.29 | 1196976.28 | 508916.63"
	psql $(pg_uri) -c "SELECT count(*) n, round(max(a),2) a_max, round(min(a),2) a_min, round(avg(a),2) a_avg, round(percentile_disc(0.5) WITHIN GROUP ( ORDER BY a),2) a_median FROM ( select  st_area(geom) a from bairros ) t"
	psql $(pg_uri) -c "CREATE TABLE ingest.pk046_bairros AS select gid, name, ST_centroid(ST_Transform(geom,4326)) as geom FROM bairros"
	@echo Limpando...
	rm -rf $(pg_io)/$(BAIRROS_PASTA)
	psql $(pg_uri) -c "drop table bairros cascade"
	@echo FIM.


EIXOS_ZIP       =$(ori)/29d68e5ce006079b06b710cc2df3aa08d6cb6934f32bc0b29fc46d3e8272ff77.rar
EIXOS_SHPREFIX  =logradouros
etl_toPgis_eixos:
	@echo "Creating table ingest.pk046_eixos on PostGIS"
	@whoami
	@echo "Run with tmux and sudo! (DANGER: seems not idempotent on psql)"
	mkdir -p $(pg_io)
	@psql $(pg_uri) -c "drop table if exists eixos cascade; drop table if exists ingest.pk046_eixos cascade;"
	@tput bold
	@echo Extraindo ....
	@tput sgr0
	cd $(pg_io) ; 7z x -y  $(EIXOS_ZIP) > /dev/null
	@echo "Conferindo se SRID esta configurado:"
	@( psql $(pg_uri) -c "SELECT srid, proj4text FROM spatial_ref_sys where srid=32719" )
	@echo Executando shp2pgsql ...
	@( cd $(pg_io) ; shp2pgsql -s 32719 $(EIXOS_SHPREFIX).shp eixos |  psql -q $(pg_uri) 2> /dev/null  )
	@echo "Conferira se bate o perfil: 3181 |  0.00 |  0.00 |  0.00 |     0.00"
	psql $(pg_uri) -c "SELECT count(*) n, round(max(a),2) a_max, round(min(a),2) a_min, round(avg(a),2) a_avg, round(percentile_disc(0.5) WITHIN GROUP ( ORDER BY a),2) a_median FROM ( select  st_area(geom) a from eixos ) t"
	psql $(pg_uri) -c "CREATE TABLE ingest.pk046_eixos AS select gid, Nome, Tipo, ST_centroid(ST_Transform(geom,4326)) as geom FROM eixos"
	@echo Limpando...
	rm $(pg_io)/$(EIXOS_SHPREFIX).*
	psql $(pg_uri) -c "drop table eixos cascade"
	@echo FIM.


QUADRAS_ZIP       =$(ori)/29d68e5ce006079b06b710cc2df3aa08d6cb6934f32bc0b29fc46d3e8272ff77.rar
QUADRAS_SHPREFIX  =logradouros
etl_toPgis_quadras:
	@echo "Creating table ingest.pk046_quadras on PostGIS"
	@whoami
	@echo "Run with tmux and sudo! (DANGER: seems not idempotent on psql)"
	mkdir -p $(pg_io)
	@psql $(pg_uri) -c "drop table if exists quadras cascade; drop table if exists ingest.pk046_quadras cascade;"
	@tput bold
	@echo Extraindo ....
	@tput sgr0
	cd $(pg_io) ; 7z x -y  $(QUADRAS_ZIP) > /dev/null
	@echo "Conferindo se SRID esta configurado:"
	@( psql $(pg_uri) -c "SELECT srid, proj4text FROM spatial_ref_sys where srid=32719" )
	@echo Executando shp2pgsql ...
	@( cd $(pg_io) ; shp2pgsql -s 32719 $(QUADRAS_SHPREFIX).shp quadras |  psql -q $(pg_uri) 2> /dev/null  )
	psql $(pg_uri) -c "SELECT column_name, data_type FROM information_schema.columns where table_name = 'quadras';"
	@echo "Conferira se bate o perfil: 3181 |  0.00 |  0.00 |  0.00 |     0.00"
	psql $(pg_uri) -c "SELECT count(*) n, round(max(a),2) a_max, round(min(a),2) a_min, round(avg(a),2) a_avg, round(percentile_disc(0.5) WITHIN GROUP ( ORDER BY a),2) a_median FROM ( select  st_area(geom) a from quadras ) t"
	psql $(pg_uri) -c "CREATE TABLE ingest.pk046_quadras AS select gid, iq, ST_centroid(ST_Transform(geom,4326)) as geom FROM quadras"
	@echo Limpando...
	rm $(pg_io)/$(QUADRAS_SHPREFIX).*
	psql $(pg_uri) -c "drop table quadras cascade"
	@echo FIM.


LOTEAMENTOS_ZIP       =$(ori)/73d02ba0ae4b0a994a629f7d06f0a027259f5c1d97e53f9b771fecd345c2a02b.zip
LOTEAMENTOS_SHPREFIX  =loteamentos
LOTEAMENTOS_PASTA     =rb_20201111
etl_toPgis_loteamentos:
	@echo "Creating table ingest.pk046_loteamentos on PostGIS"
	@whoami
	@echo "Run with tmux and sudo! (DANGER: seems not idempotent on psql)"
	mkdir -p $(pg_io)
	@psql $(pg_uri) -c "drop table if exists loteamentos cascade; drop table if exists ingest.pk046_loteamentos cascade;"
	@tput bold
	@echo Extraindo ....
	@tput sgr0
	cd $(pg_io) ; 7z x -y  $(LOTEAMENTOS_ZIP) > /dev/null
	@echo "Conferindo se SRID esta configurado:"
	@( psql $(pg_uri) -c "SELECT srid, proj4text FROM spatial_ref_sys where srid=32719" )
	@echo Executando shp2pgsql ...
	@( cd $(pg_io) ; shp2pgsql -s 32719 $(LOTEAMENTOS_PASTA)/$(LOTEAMENTOS_SHPREFIX).shp |  psql -q $(pg_uri) 2> /dev/null  )
	#psql $(pg_uri) -c "SELECT column_name, data_type FROM information_schema.columns where table_name = 'loteamentos';"
	@echo "Conferira se bate o perfil: 316 | 12255107.56 | 8573.21 | 349057.47 | 124942.55 "
	psql $(pg_uri) -c "SELECT count(*) n, round(max(a),2) a_max, round(min(a),2) a_min, round(avg(a),2) a_avg, round(percentile_disc(0.5) WITHIN GROUP ( ORDER BY a),2) a_median FROM ( select  st_area(geom) a from loteamentos ) t"
	psql $(pg_uri) -c "CREATE TABLE ingest.pk046_loteamentos AS select gid, name, ST_centroid(ST_Transform(geom,4326)) as geom FROM loteamentos"
	@echo Limpando...
	rm -rf $(pg_io)/$(LOTEAMENTOS_PASTA)
	psql $(pg_uri) -c "drop table loteamentos cascade"
	@echo FIM.
