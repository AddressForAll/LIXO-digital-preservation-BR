##
## Template file reference: digital-preservation-BR/data/in/RS/PortoAlegre/_pk027
##

## BASIC CONFIGS
pg_io  ={{pg_io}}
orig   ={{orig}}
pg_uri ={{pg_uri}}
sandbox={{sandbox}}

## USER CONFIGS
pg_db  ={{pg_db}}

## ## ## ## ## ## ##
## THIS_MAKE, _pk{{pkid}}

pkid ={{pkid}}
need_commands   ="{{need_commands}}" # and a prepared database {{pg_db}}

{{#files}}
part{{p}}_file  ={{file}}
part{{p}}_name  ={{name}}

{{/files}}
## COMPOSED VARS
pg_uri_db   =$(pg_uri)/$(pg_db)
{{#files}}
part{{p}}_path  =$(orig)/$(part{{p}}_file)
{{/files}}


{{#parts}}
$(part{{p}}_tabname) =

all:
	@echo Requer comandos $(need_commands)
	@echo Principais targets implementados neste makefile:
	@echo {{#parts}}{{#geoaddress-novia}}geoaddress-novia {{/geoaddress-novia}}{{#namespace-full}}namespace-full {{/namespace-full}}{{/parts}}

## ## ## ## ## ## ## ## ##
## Make targets of the Project AddressForAll
## man at https://github.com/AddressForAll/digital-preservation/wiki/makefile-generator

makedirs:
	@mkdir -p $(sandbox)
	@mkdir -p $(pg_io)

{{#parts}}
{{#geoaddress-novia}}

## aqui mais definições, para que include não precise conter mustache!

geoaddress-novia: makedirs
	# pk{{pkid}}_p{{file}} - ETL extrating to PostgreSQL/PostGIS the "geoaddress-novia" datatype (point with house_number but no via name)
	@echo "-- Incluindo dados do arquivo-{{file}} do package-{{pkid}} na Tabela de Endereços da base $(pg_db) --"
	@echo " Tema do arquivo-{{file}}: $(part{{file}}_name)"
	@echo " Hash do arquivo-{{file}}: $(part{{file}}_file)"
	@echo "Creating table ingest.pk{{pkid}}_p{{file}} on PostGIS"
	@whoami
	@echo "Run with tmux and sudo! (DANGER: seems not idempotent on psql)"
	# ATENCAO REVER MEU MODOLO DE DADOS!
	psql $(pg_uri_db) -c "DROP TABLE IF EXISTS $(tabname) CASCADE; DROP TABLE IF EXISTS $(tabname) CASCADE;"
	psql $(pg_uri_db) -c "SELECT ingest.getmeta_to_file('{{orig_filename}}.shp','geoaddress-novia',$(pkid))"

	@tput bold
	@echo Extraindo ....
	@tput sgr0
	cd $(pg_io) ; 7z e -y  $(part{{p}}_path) {{orig_filename}}.* > /dev/null
	@echo "Conferindo se SRID esta configurado:"
	@( psql $(pg_uri_db) -c "SELECT srid, proj4text FROM spatial_ref_sys where srid=952013" )
	@echo Executando shp2pgsql ...
	@( cd $(pg_io) ; shp2pgsql -s 952013 {{orig_filename}}.shp $(part1a_tabname) | psql -q $(pg_uri_db) 2> /dev/null  )
	# assert das assinaturas precisa ser baseado em diff, ideal ter um shell ou python para isso, gerando erro se não bater.
	# falta tabem usar funcao que gera assinatura conforme tipo de dado  postado.
	@echo "Conferira se bate o perfil:  154067 | 112.28 |  0.81 | 12.24 |    11.65"
	psql $(pg_uri_db) -c "SELECT count(*) n, round(max(a),2) a_max, round(min(a),2) a_min, round(avg(a),2) a_avg, round(percentile_disc(0.5) WITHIN GROUP ( ORDER BY a),2) a_median FROM ( select  st_area(geom) a from $(part1a_tabname) ) t"
	psql $(pg_uri_db) -c "CREATE TABLE ingest.pk027_p1 AS select gid, setor, textstring as housenumber, ST_centroid(ST_Transform(geom,4326)) as geom FROM $(part1a_tabname)"
	@echo Limpando...
	rm $(pg_io)/{{orig_filename}}.*
	psql $(pg_uri_db) -c "drop table $(part1a_tabname) cascade"
	@echo FIM.
{{/geoaddress-novia}}

{{#namespace-full}}
namespace-full: sandbox
	@echo ok!
{{/namespace-full}}

{{/parts}}
