##
## Template file reference: digital-preservation-BR/data/in/RS/PortoAlegre/_pk027
##

## BASIC CONFIG
pg_io  ={{pg_io}}
orig   ={{orig}}
pg_uri ={{pg_uri}}
sandbox_root={{sandbox}}

pkid = {{pkid}}
fullPkID={{pkid}}_{{pkversion}}
sandbox=$(sandbox_root)/_pk$(fullPkID)

## USER CONFIGS
pg_db  ={{pg_db}}
thisTplFile_root = {{thisTplFile_root}}

## ## ## ## ## ## ##
## THIS_MAKE, _pk{{pkid}}

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


all:
	@echo "Requer comandos $(need_commands)."
	@echo "Targets implementados no all_layers:"
	@echo " geoaddress_none via_full nsvia_full"
	@echo "Targets opcionais e ferramentas: me wget_files clean"

all_layers: geoaddress_none via_full nsvia_full
	@echo "--ALL LAYERS--"


## ## ## ## ## ## ## ## ##
## Make targets of the Project AddressForAll
## man at https://github.com/AddressForAll/digital-preservation/wiki/makefile-generator

makedirs: clean_sandbox
	@mkdir -p $(sandbox_root)
	@mkdir -p $(sandbox)
	@mkdir -p $(pg_io)

{{#parts}}
{{#geoaddress_none}} ## ## ## ##

geoaddress_none: layername = geoaddress_none
geoaddress_none: tabname = pk$(fullPkID)_p{{file}}_{{tabname}}
geoaddress_none: makedirs $(part{{file}}_path)
	@# pk{{pkid}}_p{{file}} - ETL extrating to PostgreSQL/PostGIS the "geoaddress_none" datatype (point with house_number but no via name)
{{>common002_layerHeader}}
	cd $(sandbox);  7z e -y  $(part{{file}}_path) {{orig_filename}}.* > /dev/null
{{>common003_shp2pgsql}}
{{>common001_pgAny_load}}
	@echo FIM.

geoaddress_none-clean:
	rm -f $(sandbox)/{{orig_filename}}.* || true
	psql $(pg_uri_db) -c "DROP TABLE IF EXISTS $(tabname) CASCADE"

{{/geoaddress_none}}


{{#nsvia_full}} ## ## ## ##

nsvia_full: layername = nsvia_full
nsvia_full: tabname = pk$(fullPkID)_p{{file}}_{{tabname}}
nsvia_full: makedirs $(part{{file}}_path)
	@# pk{{pkid}}_p{{file}} - ETL extrating to PostgreSQL/PostGIS the "nsvia_full" datatype (zone with name)
{{>common002_layerHeader}}
	cd $(sandbox);  7z e -y  $(part{{file}}_path) {{orig_filename}}.* > /dev/null
{{>common003_shp2pgsql}}
{{>common001_pgAny_load}}
	@echo FIM.

nsvia_full-clean: tabname = pk$(fullPkID)_p{{file}}_{{tabname}}
nsvia_full-clean:
	rm -f $(sandbox)/{{orig_filename}}.* || true
	psql $(pg_uri_db) -c "DROP TABLE IF EXISTS $(tabname) CASCADE;  DROP VIEW IF EXISTS vw_$(tabname) CASCADE;"

{{/nsvia_full}}


{{#via_full}} ## ## ## ##
via_full: layername = via_full
via_full: tabname = pk$(fullPkID)_p{{file}}_{{tabname}}
via_full: makedirs $(part{{file}}_path)
	@# pk{{pkid}}_p{{file}} - ETL extrating to PostgreSQL/PostGIS the "via_full" datatype (street axes)
{{>common002_layerHeader}}
	cd $(sandbox);  7z e -y  $(part{{file}}_path) {{orig_filename}}.* > /dev/null
{{>common003_shp2pgsql}}
{{>common001_pgAny_load}}
	@echo FIM.

via_full-clean:
	rm -f $(sandbox)/{{orig_filename}}.* || true
	psql $(pg_uri_db) -c "DROP TABLE IF EXISTS $(tabname) CASCADE"

{{/via_full}}


{{#parcel_none}} ## ## ## ##
parcel_none: layername = parcel_none
parcel_none: tabname = pk$(fullPkID)_p{{file}}_{{tabname}}
parcel_none: makedirs $(part{{file}}_path)
	@# pk{{pkid}}_p{{file}} - ETL extrating to PostgreSQL/PostGIS the "parcel_none" datatype (street axes)
{{>common002_layerHeader}}
	cd $(sandbox);  7z e -y  $(part{{file}}_path) {{orig_filename}}.* > /dev/null
{{>common003_shp2pgsql}}
{{>common001_pgAny_load}}
	@echo FIM.

parcel_none-clean:
	rm -f $(sandbox)/{{orig_filename}}.* || true
	psql $(pg_uri_db) -c "DROP TABLE IF EXISTS $(tabname) CASCADE"

{{/parcel_none}}

{{/parts}}

## ## ## ##
wget_files:
	@echo "Under construction, need to check that orig path is not /var/www! or use orig=x [ENTER if not else ^C]"
	@echo $(orig)
	@read _ENTER_OK_
	mkdir -p $(orig)
{{#files}}
	@cd $(orig); wget http://preserv.addressforall.org/download/{{file}}
{{/files}}
	@echo "Please, if orig not default, run 'make _target_ orig=$(orig)'"


## ## ## ##

clean_sandbox:
	@rm -rf $(sandbox) || true

clean: geoaddress_none-clean nsvia_full-clean via_full-clean
