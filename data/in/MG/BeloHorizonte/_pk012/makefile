# PWD:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
pg_io  =/tmp/pg_io
ori    =/var/www/preserv.addressforall.org/download
pg_uri ="postgres://postgres@localhost/ingest1"

ENDERECO_ZIP	=$(ori)/1ce29a555565be5f540ab0c6f93ac55797c368293e0a6bfb479a645a5a23f542.zip
ENDERECO_CSV	=br_pk012-enderecos.csv

all: 
	@echo "USAGE: make etl_toPgis_endereco"
	
etl_toPgis_endereco:
	@echo "Creating table ingest.pk012_endereco on PostGIS"
	@whoami
	@echo "Run with tmux! (DANGER: idempotent but destroy old versions)"
	mkdir -p $(pg_io)
	@tput bold
	@echo Extraindo ...
	@tput sgr0
	cd $(pg_io) ; 7z e -y  $(ENDERECO_ZIP) $(ENDERECO_CSV).* > /dev/null
	# @echo "Conferindo se SRID esta configurado:"
	@echo "== Convertendo ENDERECO_CSV para PostgreSQL =="
	psql $(pg_uri) < ENDERECO_make.sql
	@echo "== FIM (confira pk012 na tabela ingest.addr_point) =="
