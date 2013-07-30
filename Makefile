#####################################################################
# MAKEFILE
#####################################################################
# Carlos Maniero <carlosmaniero@gmail.com>
# http://maniero.tk
#####################################################################
# Licença: http://creativecommons.org/licenses/by/3.0/deed.pt_BR
#####################################################################


#####################################################################
# Configuração de pastas
#####################################################################

# CoffeScript
COFFEE_PATH = src/coffee
ANGULARJS_PATH = ${COFFEE_PATH}/angularjs
JQUERY_PATH = ${COFFEE_PATH}/jquery
COMMON_PATH = ${COFFEE_PATH}/common

# Less
LESS_PATH = src/less

# Sufixo de arquivos comprimidos
COMPRESS_SUFIX = min

# Output
CSS_PATH = css
JS_PATH = js
JS_ANGULARJS_PATH = ${JS_PATH}/angularjs
JS_JQUERY_PATH = ${JS_PATH}/jquery

#####################################################################
# Fim de Configuração de pastas
#####################################################################

# Lista de pastas CoffeeScript
ANGULARJS_DIRS := ${shell find ${ANGULARJS_PATH}/* -type d -print -prune}
JQUERY_DIRS := ${shell find ${JQUERY_PATH}/* -type d -print -prune}

# Lista de pastas  LESS
LESS_FILES := ${shell find ${LESS_PATH}/*/main.less -type f -print -prune}


build:
	@make angularjs
	@make jquery
	@make less
	@echo "Fim <3"

angularjs:
	
	@echo "Gerando arquivos CoffeScript do AngularJS"

	@$(foreach dir, $(ANGULARJS_DIRS), (echo "### File: ${dir}/app.coffee ###"; cat "${dir}/app.coffee"; echo "\n";) > ${dir}.coffee; )
	@$(foreach dir, $(ANGULARJS_DIRS), for f in ${dir}/helpers/*.coffee; do (echo "### File: $${f} ###"; cat "$${f}"; echo "\n";) >> ${dir}.coffee; done; )
	@$(foreach dir, $(ANGULARJS_DIRS), for f in ${dir}/services/*.coffee; do (echo "### File: $${f} ###"; cat "$${f}"; echo "\n";) >> ${dir}.coffee; done; )
	@$(foreach dir, $(ANGULARJS_DIRS), for f in ${dir}/controllers/*.coffee; do (echo "### File: $${f} ###"; cat "$${f}"; echo "\n";) >> ${dir}.coffee; done; )

	@echo "Compilando arquivos CoffeScript do AngularJS"
	@coffee -o ${JS_ANGULARJS_PATH}/ -c ${ANGULARJS_PATH}/*.coffee

	@echo "Removendo arquivos CoffeScript do AngularJS temporários"
	@rm -f ${ANGULARJS_PATH}/*.coffee

	@echo "Removendo arquivos temporários antigos do AngularJS"
	@rm -f ${JS_ANGULARJS_PATH}/*${COMPRESS_SUFIX}.js

	@echo "Comprindo Arquivos do AngularJS"
	@for f in ${JS_ANGULARJS_PATH}/*.js; do (uglifyjs $${f} > `echo $${f} | sed 's/\(.*\.\)js/\1${COMPRESS_SUFIX}.js/'` ); done;

jquery:

	@$(foreach dir, $(JQUERY_DIRS), for f in ${dir}/*.coffee; do (echo "### File: $${f} ###"; cat "$${f}"; echo "\n";) >> ${dir}.coffee; done;)

	@echo "Compilando arquivos CoffeScript do JQUERY"
	@coffee -o ${JS_JQUERY_PATH}/ -c ${JQUERY_PATH}/*.coffee

	@echo "Removendo arquivos CoffeScript do JQUERY temporários"
	@rm -f ${JQUERY_PATH}/*.coffee

	@echo "Removendo arquivos temporários antigos do JQUERY"
	@rm -f ${JS_JQUERY_PATH}/*${COMPRESS_SUFIX}.js

	@echo "Comprindo Arquivos do JQUERY"
	@for f in ${JS_JQUERY_PATH}/*.js; do (uglifyjs $${f} > `echo $${f} | sed 's/\(.*\.\)js/\1${COMPRESS_SUFIX}.js/'` ); done;

less:
	@echo "Compile LESS File ..."
	@for file in ${LESS_FILES}; do (lessc $${file} --line-numbers=comments > ${CSS_PATH}/`basename \`dirname $${file}.less\``.css); done;
	@for file in ${LESS_FILES}; do (lessc $${file} --yui-compress > ${CSS_PATH}/`basename \`dirname $${file}.less\``.${COMPRESS_SUFIX}.css); done;

watch:
	@make
	@echo "Watching ..."
	@watchr -e "watch('${LESS_PATH}/(.*)\/.*\.less') { system 'make' };watch('${COFFEE_PATH}/(.*)\.coffee') { system 'make' };"