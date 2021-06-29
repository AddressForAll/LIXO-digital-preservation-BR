
# PWD:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
pg_io  =/tmp/pg_io
ori    =/var/www/preserv.addressforall.org/download
pg_uri ="postgres://postgres@localhost/ingest1"

EDIFICACOES_ZIP     =$(ori)/6d741572b6c31ffd82cf004b92fa98056545df805bcb64afba5e7b26e32b62ab.zip
EDIFICACOES         = edificacoes
EIXOS_ZIP           =$(ori)/0a7fedd6e8e30541f706fa7f77166a183a3cc43d2b1d3d3d0a8d3fb7f077e804.zip
EIXOS               = CAD_LOG
LOTES_ZIP           =$(ori)/b6221fa57754ec8c4db284591a6ceeea7acf986eb215b2e521647e32fb175488.zip
LOTES               = lotes


all:
	@echo Favor consultar as opcoes de target

etl_toPgis_lotes:
# ETL extrating to PostgreSQL/PostGIS the "lotes" datatype (point and house number)
	@echo "Creating table ingest.pk036_lotes on PostGIS"
	@whoami
	@echo "Run with tmux and sudo! (DANGER: seems not idempotent on psql)"
	mkdir -p $(pg_io)
	psql $(pg_uri) -c "drop table if exists lotes cascade; drop table if exists ingest.pk036_lotes cascade;"
	@tput bold
	@echo Extraindo ....
	@tput sgr0
	cd $(pg_io) ; 7z e -y  $(LOTES_ZIP)  > /dev/null
	@echo Executando shp2pgsql ...
	@( cd $(pg_io) ; shp2pgsql -s 29193 $(LOTES).shp lotes | psql -q $(pg_uri) 2> /dev/null  )
	@echo "Conferira se bate o perfil:  154067 | 112.28 |  0.81 | 12.24 |    11.65"
	psql $(pg_uri) -c "SELECT count(*) n, round(max(a),2) a_max, round(min(a),2) a_min, round(avg(a),2) a_avg, round(percentile_disc(0.5) WITHIN GROUP ( ORDER BY a),2) a_median FROM ( select  st_area(geom) a from lotes ) t"
	psql $(pg_uri) -c "CREATE TABLE ingest.pk036_lotes AS select gid, num, ST_centroid(ST_Transform(geom,4326)) as geom FROM lotes"
	@echo Limpando...
	rm $(pg_io)/$(LOTES).*
	psql $(pg_uri) -c "drop table lotes cascade"
	@echo FIM.

etl_toPgis_eixos:
# ETL extrating to PostgreSQL/PostGIS the "eixos" datatype (point and house number)
	@echo "Creating table ingest.pk036_eixos on PostGIS"
	@whoami
	@echo "Run with tmux and sudo! (DANGER: seems not idempotent on psql)"
	mkdir -p $(pg_io)
	psql $(pg_uri) -c "drop table if exists eixos cascade; drop table if exists ingest.pk036_eixos cascade;"
	@tput bold
	@echo Extraindo ....
	@tput sgr0
	cd $(pg_io) ; 7z e -y  $(EIXOS_ZIP)  > /dev/null
	@echo Executando shp2pgsql ...
	@( cd $(pg_io) ; shp2pgsql -s 29193 $(EIXOS).shp eixos | psql -q $(pg_uri) 2> /dev/null  )
	@echo "Conferira se bate o perfil:  8849 |  0.00 |  0.00 |  0.00 |     0.00 "
	psql $(pg_uri) -c "SELECT count(*) n, round(max(a),2) a_max, round(min(a),2) a_min, round(avg(a),2) a_avg, round(percentile_disc(0.5) WITHIN GROUP ( ORDER BY a),2) a_median FROM ( select  st_area(geom) a from eixos ) t"
	psql $(pg_uri) -c "CREATE TABLE ingest.pk036_eixos AS select gid, tiv_codigo, log_nome, log_nome_c, ini_imp, fim_imp, ini_par, fim_par, ST_centroid(ST_Transform(geom,4326)) as geom FROM eixos"
	@echo Limpando...
	rm $(pg_io)/$(EIXOS).*
	psql $(pg_uri) -c "drop table eixos cascade"
	@echo FIM.


etl_toPgis_edificacoes:
# ETL extrating to PostgreSQL/PostGIS the "edificacoes" datatype (point and house number)
	@echo "Creating table ingest.pk036_edificacoes on PostGIS"
	@whoami
	@echo "Run with tmux and sudo! (DANGER: seems not idempotent on psql)"
	mkdir -p $(pg_io)
	psql $(pg_uri) -c "drop table if exists edificacoes cascade; drop table if exists ingest.pk036_edificacoes cascade;"
	@tput bold
	@echo Extraindo ....
	@tput sgr0
	cd $(pg_io) ; 7z e -y  $(EDIFICACOES_ZIP)  > /dev/null
	@echo Executando shp2pgsql ...
	@( cd $(pg_io) ; shp2pgsql -s 3857 $(EDIFICACOES).shp edificacoes | psql -q $(pg_uri) 2> /dev/null  )
	@echo "Conferira se bate o perfil:   87622 | 28596.64 |  0.00 | 149.95 |   100.56 "
	psql $(pg_uri) -c "SELECT count(*) n, round(max(a),2) a_max, round(min(a),2) a_min, round(avg(a),2) a_avg, round(percentile_disc(0.5) WITHIN GROUP ( ORDER BY a),2) a_median FROM ( select  st_area(geom) a from edificacoes ) t"
	psql $(pg_uri) -c "CREATE TABLE ingest.pk036_edificacoes AS select gid, numero, ST_centroid(ST_Transform(geom,4326)) as geom FROM edificacoes"
	@echo Limpando...
	rm $(pg_io)/$(EDIFICACOES).*
	psql $(pg_uri) -c "drop table edificacoes cascade"
	@echo FIM.

