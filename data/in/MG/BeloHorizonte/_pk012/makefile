# PWD:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
pg_io  =/tmp/pg_io
ori    =/var/www/preserv.addressforall.org/download
pg_uri ="postgres://postgres@localhost/ingest1"

ENDERECO_ZIP	=$(ori)/1ce29a555565be5f540ab0c6f93ac55797c368293e0a6bfb479a645a5a23f542.zip
ENDERECO	=ENDERECO.csv

etl_toPgis_endereco:
	@echo "Creating table ingest.pk012_endereco on PostGIS"
	@whoami
	@echo "Run with tmux and sudo! (DANGER: seems not idempotent on psql)"
	mkdir -p $(pg_io)
	@echo psql $(pg_uri) -c "drop table if exists ingest.pk012_endereco cascade;"
	@tput bold
	@echo Extraindo ....
	@tput sgr0
	cd $(pg_io) ; 7z e -y  $(ENDERECO_ZIP) $(ENDERECO).* > /dev/null
	# @echo "Conferindo se SRID esta configurado:"
	@echo "== Convertendo ENDERECOS.CSV para PostgreSQL =="
	psql $(pg_uri) < ENDERECO_make.sql
	@echo "== FIM =="
