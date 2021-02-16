# traducao do readme.md

pg_io  =/tmp/pg_io
ori    =/var/www/preserv.addressforall.org/download
pg_uri ="postgres://postgres@localhost/ingest1"

relacao_ZIP	=$(ori)/3cc4fd62882edf648cbe106b5da688bd32f0ee8288293d518320684ab292916c.zip
relacao_CSV	=br_pk044-relacao.csv

all:
	@echo "USAGE: make etl_toPg_relacao"


etl_toPg_relacao:
	@echo "Creating table ingest.pk on PostgreSQL"
	@whoami
	@echo "Run with tmux! (DANGER: idempotent but destroy old versions)"
	mkdir -p $(pg_io)
	@tput bold
	@echo Extraindo ...
	@tput sgr0
	touch      $(pg_io)/$(relacao_CSV)
	chmod 0766 $(pg_io)/$(relacao_CSV)
	7z e -y -so  $(relacao_ZIP) *.csv | iconv -f WINDOWS-1252 -t UTF-8 > $(pg_io)/$(relacao_CSV)
	dos2unix $(pg_io)/$(relacao_CSV)
	@echo "== Convertendo relacao_CSV para PostgreSQL =="
	# psql $(pg_uri) -c "DROP TABLE ingest.pk044_relacao CASCADE"
	psql $(pg_uri) -c "SELECT ingest.fdw_generate_getCSV('relacao','br_pk044',null,';')"
	@echo "== FIM (confira pk044 na tabela ingest.pk044_relacao) =="

