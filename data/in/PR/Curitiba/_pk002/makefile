
# PWD:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
pg_io  =/tmp/pg_io
ori    =/var/www/preserv.addressforall.org/download
pg_uri ="postgres://postgres@localhost/ingest1"

OSM_ZIP         =$(ori)/058a6022054e8b3f9ba81f25f7511b58cbd4ad616b0510033b917f3f7f9f23d5.rar
OSM_GDB         =OpenStreetMap.gdb
OSM_SHD         =OpenStreetMap

BAIRROS         =Bairros
BAIRROS_SQL     =bairros
BAIRROS_INGEST  =ingest.pk002_bairros

ENDERECO        =Endereco
ENDERECO_SQL    =endereco
ENDERECO_INGEST =ingest.pk002_endereco

EIXOS           =Logradouros
EIXOS_SQL       =eixos
EIXOS_INGEST    =ingest.pk002_eixos

LOTES           =Lotes
LOTES_SQL       =lotes
LOTES_INGEST    =ingest.pk002_lotes

PRACAS          =Pracas
PRACAS_SQL      =pracas
PRACAS_INGEST   =ingest.pk002_pracas

QUADRAS         =Quadras
QUADRAS_SQL     =quadras
QUADRAS_INGEST  =ingest.pk002_quadras

all:
	@echo Favor consultar as opcoes de target

etl_toPgis_bairros:
# ETL extrating to PostgreSQL/PostGIS the "bairros" datatype (point and house number)
	@echo "Creating table $(BAIRROS_INGEST) on PostGIS"
	@whoami
	@echo "Run with tmux and sudo! (DANGER: seems not idempotent on psql)"
	mkdir -p $(pg_io)
	psql $(pg_uri) -c "drop table if exists $(BAIRROS_SQL) cascade; drop table if exists $(BAIRROS_INGEST) cascade;"
	@tput bold
	@echo Extraindo ....
	@tput sgr0
	cd $(pg_io) ; 7z x -y  $(OSM_ZIP) > /dev/null
	psql $(pg_uri) -P pager=off -c "SELECT srid, proj4text FROM spatial_ref_sys where srid=3857" 
	@echo Executando ogr2ogr ...
	@( cd $(pg_io) ; \
		docker run --rm --network host -v /tmp:/tmp osgeo/gdal \
		ogr2ogr -f "ESRI Shapefile" $(pg_io)/OpenStreetMap $(pg_io)/OpenStreetMap.gdb )
	@echo Executando shp2pgsql ...
	@( cd $(pg_io)/OpenStreetMap ; shp2pgsql -s 3857 $(BAIRROS).shp  $(BAIRROS_SQL) | psql -q $(pg_uri) 2> /dev/null  )
	@echo "Conferira se bate o perfil:   269 | 54029716.59 | 4872.61 | 812944.06 | 250734.99 "
	psql $(pg_uri) -c "SELECT count(*) n, round(max(a),2) a_max, round(min(a),2) a_min, round(avg(a),2) a_avg, round(percentile_disc(0.5) WITHIN GROUP ( ORDER BY a),2) a_median FROM ( select  st_area(geom) a from $(BAIRROS_SQL) ) t"
	@echo "Conferindo se SRID esta configurado:"
	@echo "SRID = 3857"
	psql $(pg_uri) -c "SELECT Find_SRID('public', '$(BAIRROS_SQL)', 'geom')"
	psql $(pg_uri) -c "CREATE TABLE $(BAIRROS_INGEST) AS select * FROM $(BAIRROS_SQL)"
	@echo Limpando...
	rm -rf $(pg_io)/$(OSM_SHD)
	rm -rf $(pg_io)/$(OSM_GDB)
	psql $(pg_uri) -c "drop table if exists $(BAIRROS_SQL) cascade;" 
	@echo FIM.

etl_toPgis_endereco:
# ETL extrating to PostgreSQL/PostGIS the "endereco" datatype (point and house number)
	@echo "Creating table $(ENDERECO_INGEST) on PostGIS"
	@whoami
	@echo "Run with tmux and sudo! (DANGER: seems not idempotent on psql)"
	mkdir -p $(pg_io)
	psql $(pg_uri) -c "drop table if exists $(ENDERECO_SQL) cascade; drop table if exists $(ENDERECO_INGEST) cascade;"
	@tput bold
	@echo Extraindo ....
	@tput sgr0
	cd $(pg_io) ; 7z x -y  $(OSM_ZIP) > /dev/null
	psql $(pg_uri) -P pager=off -c "SELECT srid, proj4text FROM spatial_ref_sys where srid=3857" 
	@echo Executando ogr2ogr ...
	@( cd $(pg_io) ; \
		docker run --rm --network host -v /tmp:/tmp osgeo/gdal \
		ogr2ogr -f "ESRI Shapefile" $(pg_io)/OpenStreetMap $(pg_io)/OpenStreetMap.gdb )
	@echo Executando shp2pgsql ...
	@( cd $(pg_io)/OpenStreetMap ; shp2pgsql -s 3857 $(ENDERECO).shp  $(ENDERECO_SQL) | psql -q $(pg_uri) 2> /dev/null  )
	@echo "Conferira se bate o perfil:    103847 |  0.00 |  0.00 |  0.00 |     0.00  "
	psql $(pg_uri) -c "SELECT count(*) n, round(max(a),2) a_max, round(min(a),2) a_min, round(avg(a),2) a_avg, round(percentile_disc(0.5) WITHIN GROUP ( ORDER BY a),2) a_median FROM ( select  st_area(geom) a from $(ENDERECO_SQL) ) t"
	@echo "Conferindo se SRID esta configurado:"
	@echo "SRID = 3857"
	psql $(pg_uri) -c "SELECT Find_SRID('public', '$(ENDERECO_SQL)', 'geom')"
	psql $(pg_uri) -c "CREATE TABLE $(ENDERECO_INGEST) AS select * FROM $(ENDERECO_SQL)"
	@echo Limpando...
	rm -rf $(pg_io)/$(OSM_SHD)
	rm -rf $(pg_io)/$(OSM_GDB)
	psql $(pg_uri) -c "drop table if exists $(ENDERECO_SQL) cascade;" 
	@echo FIM.

etl_toPgis_eixos:
# ETL extrating to PostgreSQL/PostGIS the "eixos" datatype (point and house number)
	@echo "Creating table $(EIXOS_INGEST) on PostGIS"
	@whoami
	@echo "Run with tmux and sudo! (DANGER: seems not idempotent on psql)"
	mkdir -p $(pg_io)
	psql $(pg_uri) -c "drop table if exists $(EIXOS_SQL) cascade; drop table if exists $(EIXOS_INGEST) cascade;"
	@tput bold
	@echo Extraindo ....
	@tput sgr0
	cd $(pg_io) ; 7z x -y  $(OSM_ZIP) > /dev/null
	psql $(pg_uri) -P pager=off -c "SELECT srid, proj4text FROM spatial_ref_sys where srid=3857" 
	@echo Executando ogr2ogr ...
	@( cd $(pg_io) ; \
		docker run --rm --network host -v /tmp:/tmp osgeo/gdal \
		ogr2ogr -f "ESRI Shapefile" $(pg_io)/OpenStreetMap $(pg_io)/OpenStreetMap.gdb )
	@echo Executando shp2pgsql ...
	@( cd $(pg_io)/OpenStreetMap ; shp2pgsql -s 3857 $(EIXOS).shp  $(EIXOS_SQL) | psql -q $(pg_uri) 2> /dev/null  )
	@echo "Conferira se bate o perfil: 16025 |  0.00 |  0.00 |  0.00 |     0.00  "
	psql $(pg_uri) -c "SELECT count(*) n, round(max(a),2) a_max, round(min(a),2) a_min, round(avg(a),2) a_avg, round(percentile_disc(0.5) WITHIN GROUP ( ORDER BY a),2) a_median FROM ( select  st_area(geom) a from $(EIXOS_SQL) ) t"
	@echo "Conferindo se SRID esta configurado:"
	@echo "SRID = 3857"
	psql $(pg_uri) -c "SELECT Find_SRID('public', '$(EIXOS_SQL)', 'geom')"
	psql $(pg_uri) -c "CREATE TABLE $(EIXOS_INGEST) AS select * FROM $(EIXOS_SQL)"
	@echo Limpando...
	rm -rf $(pg_io)/$(OSM_SHD)
	rm -rf $(pg_io)/$(OSM_GDB)
	psql $(pg_uri) -c "drop table if exists $(EIXOS_SQL) cascade;" 
	@echo FIM.

etl_toPgis_lotes:
# ETL extrating to PostgreSQL/PostGIS the "lotes" datatype (point and house number)
	@echo "Creating table $(LOTES_INGEST) on PostGIS"
	@whoami
	@echo "Run with tmux and sudo! (DANGER: seems not idempotent on psql)"
	mkdir -p $(pg_io)
	psql $(pg_uri) -c "drop table if exists $(LOTES_SQL) cascade; drop table if exists $(LOTES_INGEST) cascade;"
	@tput bold
	@echo Extraindo ....
	@tput sgr0
	cd $(pg_io) ; 7z x -y  $(OSM_ZIP) > /dev/null
	psql $(pg_uri) -P pager=off -c "SELECT srid, proj4text FROM spatial_ref_sys where srid=3857" 
	@echo Executando ogr2ogr ...
	@( cd $(pg_io) ; \
		docker run --rm --network host -v /tmp:/tmp osgeo/gdal \
		ogr2ogr -f "ESRI Shapefile" $(pg_io)/OpenStreetMap $(pg_io)/OpenStreetMap.gdb )
	@echo Executando shp2pgsql ...
	@( cd $(pg_io)/OpenStreetMap ; shp2pgsql -s 3857 $(LOTES).shp  $(LOTES_SQL) | psql -q $(pg_uri) 2> /dev/null  )
	@echo "Conferira se bate o perfil:231172 | 1103045.46 |  0.01 | 824.95 |   362.02  "
	psql $(pg_uri) -c "SELECT count(*) n, round(max(a),2) a_max, round(min(a),2) a_min, round(avg(a),2) a_avg, round(percentile_disc(0.5) WITHIN GROUP ( ORDER BY a),2) a_median FROM ( select  st_area(geom) a from $(LOTES_SQL) ) t"
	@echo "Conferindo se SRID esta configurado:"
	@echo "SRID = 3857"
	psql $(pg_uri) -c "SELECT Find_SRID('public', '$(LOTES_SQL)', 'geom')"
	psql $(pg_uri) -c "CREATE TABLE $(LOTES_INGEST) AS select * FROM $(LOTES_SQL)"
	@echo Limpando...
	rm -rf $(pg_io)/$(OSM_SHD)
	rm -rf $(pg_io)/$(OSM_GDB)
	psql $(pg_uri) -c "drop table if exists $(LOTES_SQL) cascade;" 
	@echo FIM.

etl_toPgis_pracas:
# ETL extrating to PostgreSQL/PostGIS the "pracas" datatype (point and house number)
	@echo "Creating table $(PRACAS_INGEST) on PostGIS"
	@whoami
	@echo "Run with tmux and sudo! (DANGER: seems not idempotent on psql)"
	mkdir -p $(pg_io)
	psql $(pg_uri) -c "drop table if exists $(PRACAS_SQL) cascade; drop table if exists $(PRACAS_INGEST) cascade;"
	@tput bold
	@echo Extraindo ....
	@tput sgr0
	cd $(pg_io) ; 7z x -y  $(OSM_ZIP) > /dev/null
	psql $(pg_uri) -P pager=off -c "SELECT srid, proj4text FROM spatial_ref_sys where srid=3857" 
	@echo Executando ogr2ogr ...
	@( cd $(pg_io) ; \
		docker run --rm --network host -v /tmp:/tmp osgeo/gdal \
		ogr2ogr -f "ESRI Shapefile" $(pg_io)/OpenStreetMap $(pg_io)/OpenStreetMap.gdb )
	@echo Executando shp2pgsql ...
	@( cd $(pg_io)/OpenStreetMap ; shp2pgsql  -W ISO-8859-1 -s 3857 $(PRACAS).shp  $(PRACAS_SQL) | psql -q $(pg_uri) 2> /dev/null  )
	@echo "Conferira se bate o perfil: 309 | 155648.68 |  4.40 | 2850.72 |   441.30  "
	psql $(pg_uri) -c "SELECT count(*) n, round(max(a),2) a_max, round(min(a),2) a_min, round(avg(a),2) a_avg, round(percentile_disc(0.5) WITHIN GROUP ( ORDER BY a),2) a_median FROM ( select  st_area(geom) a from $(PRACAS_SQL) ) t"
	@echo "Conferindo se SRID esta configurado:"
	@echo "SRID = 3857"
	psql $(pg_uri) -c "SELECT Find_SRID('public', '$(PRACAS_SQL)', 'geom')"
	psql $(pg_uri) -c "CREATE TABLE $(PRACAS_INGEST) AS select * FROM $(PRACAS_SQL)"
	@echo Limpando...
	rm -rf $(pg_io)/$(OSM_SHD)
	rm -rf $(pg_io)/$(OSM_GDB)
	psql $(pg_uri) -c "drop table if exists $(PRACAS_SQL) cascade;" 
	@echo FIM.

etl_toPgis_quadras:
# ETL extrating to PostgreSQL/PostGIS the "quadras" datatype (point and house number)
	@echo "Creating table $(QUADRAS_INGEST) on PostGIS"
	@whoami
	@echo "Run with tmux and sudo! (DANGER: seems not idempotent on psql)"
	mkdir -p $(pg_io)
	psql $(pg_uri) -c "drop table if exists $(QUADRAS_SQL) cascade; drop table if exists $(QUADRAS_INGEST) cascade;"
	@tput bold
	@echo Extraindo ....
	@tput sgr0
	cd $(pg_io) ; 7z x -y  $(OSM_ZIP) > /dev/null
	psql $(pg_uri) -P pager=off -c "SELECT srid, proj4text FROM spatial_ref_sys where srid=3857" 
	@echo Executando ogr2ogr ...
	@( cd $(pg_io) ; \
		docker run --rm --network host -v /tmp:/tmp osgeo/gdal \
		ogr2ogr -f "ESRI Shapefile" $(pg_io)/OpenStreetMap $(pg_io)/OpenStreetMap.gdb )
	@echo Executando shp2pgsql ...
	@( cd $(pg_io)/OpenStreetMap ; shp2pgsql  -s 3857 $(QUADRAS).shp  $(QUADRAS_SQL) | psql -q $(pg_uri) 2> /dev/null  )
	@echo "Conferira se bate o perfil: 5953 | 2360799.58 | 41.06 | 16017.66 |  8639.12  "
	psql $(pg_uri) -c "SELECT count(*) n, round(max(a),2) a_max, round(min(a),2) a_min, round(avg(a),2) a_avg, round(percentile_disc(0.5) WITHIN GROUP ( ORDER BY a),2) a_median FROM ( select  st_area(geom) a from $(QUADRAS_SQL) ) t"
	@echo "Conferindo se SRID esta configurado:"
	@echo "SRID = 3857"
	psql $(pg_uri) -c "SELECT Find_SRID('public', '$(QUADRAS_SQL)', 'geom')"
	psql $(pg_uri) -c "CREATE TABLE $(QUADRAS_INGEST) AS select * FROM $(QUADRAS_SQL)"
	@echo Limpando...
	rm -rf $(pg_io)/$(OSM_SHD)
	rm -rf $(pg_io)/$(OSM_GDB)
	psql $(pg_uri) -c "drop table if exists $(QUADRAS_SQL) cascade;" 
	@echo FIM.

