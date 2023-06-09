all: ttl

conllu:
	@if [ ! -e conllu ]; then \
		mkdir conllu;\
		cd conllu;\
		wget -nc https://raw.githubusercontent.com/UniversalDependencies/UD_Croatian-SET/master/hr_set-ud-dev.conllu;\
		wget -nc https://raw.githubusercontent.com/UniversalDependencies/UD_Croatian-SET/master/LICENSE.txt;\
	fi;

conll-rdf: 
	if echo 1 | conll-rdf/run.sh CoNLLStreamExtractor '#' ID >/dev/null 2>/dev/null; \
		then echo Found operational CoNLL-RDF installation 1>&2;\
	else \
		echo Building CoNLL-RDF 1>&2;\
		make conll-rdf/run.sh;\
		echo 1>&2;\
		echo Initializing CoNLL-RDF 1>&2;\
		conll-rdf/compile.sh;\
		echo 1>&2;\
	fi;\

conll-rdf/run.sh:
	@if [ ! -e conll-rdf/ ]; then \
		echo "This will install the CoNLL-RDF library." 1>&2;\
		echo "If you have it running already, create a symlink to your installation under " 1>&2;\
		echo `pwd`/conll-rdf/ and interrupt the make script 1>&2;\
		git clone https://github.com/acoli-repo/conll-rdf.git;\
	fi;
	@if [ ! -e conll-rdf/run.sh ]; then \
		echo "Error: Did not find "`pwd`/conll-rdf/run.sh 1>&2;\
		echo "       If you created the conll-rdf/ directory manually, please check your paths or consider deleting it to get a fresh clone" 1>&2;\
	fi;

ttl: 
	@if [ -e ttl ]; then \
		echo Found `pwd`/ttl folder, please remove it to update CoNLL-RDF data / rebuild it from scratch 1>&2; \
	else \
		make conllu;\
		make conll-rdf;\
		for file in `find conllu/ | grep 'conllu$$'`; do \
			tgt=`echo $$file | sed -e s/'^conllu\/'/'ttl\/'/ -e s/'\.conllu$$'//`.ttl;\
			tgt_dir=`dirname $$tgt`;\
			if [ ! -e  $$tgt_dir ]; then \
				mkdir -p $$tgt_dir;\
			fi;\
			tgt_dir=`cd $$tgt_dir 2>/dev/null; pwd`;\
			tgt=$$tgt_dir/`basename $$tgt`;\
			if [ ! -e $$tgt ]; then \
				echo $$file '>' $$tgt; \
				cat $$file \
				| conll-rdf/run.sh CoNLLStreamExtractor \
						$$tgt'#' \
						ID WORD LEMMA UPOS XPOS FEATS HEAD EDGE DEPS MISC \
				| conll-rdf/run.sh CoNLLRDFFormatter \
				> $$tgt;\
			fi;\
		done;\
	fi;\


check: ttl conll-rdf
	@echo We now check whether the generated RDF data can be transformed back to CoNLL-U 1>&2;\
	for file in `find ttl/ | grep '\.ttl$$'`; do \
		echo -n checking $$file '...' 1>&2;\
		if  cat $$file \
			| conll-rdf/run.sh CoNLLRDFFormatter \
				-conll \
				ID WORD LEMMA UPOS XPOS FEATS HEAD EDGE DEPS MISC;  \
		then echo '... ok' 1>&2;\
		else echo '... failed for '$$file 1>&2;\
		fi;\
		echo 1>&2;\
		echo 1>&2;\
	done;
