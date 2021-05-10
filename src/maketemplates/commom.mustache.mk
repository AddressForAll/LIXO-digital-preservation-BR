

## ############################
## SELF-GENERATE MAKE (make me)
##

baseSrc      = /opt/gits/_a4a
srcPy        =  $(baseSrc)/digital-preservation/src/run_mustache.py
mkme_input0  =  $(baseSrc)/digital-preservation-BR/src/maketemplates/commom.yaml
mkme_srcTplLast  =  $(baseSrc)/digital-preservation-BR/src/maketemplates/commom.mustache.mk
mkme_srcTpl  =  $(baseSrc)/digital-preservation-BR/src/maketemplates/make_ref027a.mustache.mk
mkme_input   = ./make_conf.yaml
mkme_output  = /tmp/digitalPresservation-make_me.mk


me: $(srcPy) $(mkme_input0) $(mkme_input) $(mkme_srcTpl)
	@echo "-- Updating this make --"
	python3 $(srcPy) -t $(mkme_srcTpl) --tplLast=$(mkme_srcTplLast) -i $(mkme_input) --input0=$(mkme_input0) > $(mkme_output)
	@echo " check diff, '>' is new... changed?"
	@diff $(mkme_output) ./makefile || :
	@echo "If some changes, and no error in the changes, move the script:"
	@echo " mv $(mkme_output) ./makefile"
