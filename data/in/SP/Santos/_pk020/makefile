
pg_io  =/tmp/pg_io
ori    =/var/www/preserv.addressforall.org/download
pg_base =ingest1
pg_uri ="postgres://postgres@localhost/$(pg_base)"

NRO_IMOVEL_ZIP     =$(ori)/b192fba419ef8133861a9051d2382d08476193eafbd8932f0ea05456157c301c.zip
NRO_IMOVEL         =LOTES_PONTO_S2K


all:
	@echo Favor consultar as opcoes de target

.SILENT: etl_toPgis_P2

etl_toPgis_P2:
# ETL extrating to PostgreSQL/PostGIS the "P2" datatype (point and house number)
	echo "Creating table ingest.pk020_p2 on PostGIS"
	whoami
	echo "Run with tmux and sudo! (DANGER: seems not idempotent on psql)"
	mkdir -p $(pg_io)
	psql $(pg_uri) -c "drop table if exists p2 cascade; drop table if exists ingest.pk020_p2 cascade;"
	tput bold
	echo Extraindo ....
	tput sgr0
	cd $(pg_io) ; 7z e -y  $(NRO_IMOVEL_ZIP) $(NRO_IMOVEL).* > /dev/null
	echo "Conferindo se SRID esta configurado:"
	( psql $(pg_uri) -c "SELECT srid, proj4text FROM spatial_ref_sys where srid=31983" )
	echo Executando shp2pgsql ...
	( cd $(pg_io) ; shp2pgsql -W iso-8859-1 -s 31983 $(NRO_IMOVEL).shp p2 | psql -q $(pg_uri) 2> /dev/null  )
	echo "Conferira se bate o perfil:  43389 |  0.00 |  0.00 |  0.00 |     0.00 "
	psql $(pg_uri) -c "SELECT count(*) n, round(max(a),2) a_max, round(min(a),2) a_min, round(avg(a),2) a_avg, round(percentile_disc(0.5) WITHIN GROUP ( ORDER BY a),2) a_median FROM ( select  st_area(geom) a from p2 ) t"
	psql $(pg_uri) -c "CREATE TABLE ingest.pk020_p2 AS select gid, LOTE, L_NUMERO, X, Y, ST_centroid(ST_Transform(geom,4326)) as geom FROM p2"
	echo Limpando...
	rm $(pg_io)/$(NRO_IMOVEL).*
	psql $(pg_uri) -c "drop table p2 cascade"
	echo FIM.

