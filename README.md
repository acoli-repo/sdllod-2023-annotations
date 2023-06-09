# SD-LLOD 2023 annotations (hands-on)

Data and experiments for SD-LLOD 2023 annotation hands-on

Idea:

- Slides to introduce CoNLL-RDF as a NIF subset [TODO]
- Slides to introduce CoNLL-RDF library [TODO]
- Sample data in CoNLL-RDF, to be used in SPARQL end point [DONE]
- Sample SPARQL queries and updates to be applied to this data [TODO]

The CoNLL-RDF data to work with is provided in this repo under `ttl/`, along with build scripts to create it from CoNLL-U, and to export it back to CoNLL-U.

## RDF Data

Normally, you can just work with the data in `ttl/` as is. The following is relevant only if you want to re-build it from scratch or to process other files.
To update/re-build from scratch, delete the `ttl/` folder before running `make`. Note that this may require you to install CoNLL-RDF and some dependencies.

- build using

	`make`

	> Note: If the `ttl/` folder is provided, already, it will just terminate, otherwise, it will install dependencies, retrieve fresh source data, etc.

- check data using

	`make check`

	> Note: This will convert the RDF data from `ttl/` back to CoNLL-U and print on stdout for manual verification. Necessary only after building the data from scratch. 

## Data: HR-SET corpus, UD edition

We work with the dev set of https://universaldependencies.org/treebanks/hr_set/index.html

CC BY-SA 4.0

Željko Agić and Nikola Ljubešić. 2015. Universal Dependencies for Croatian (that work for Serbian, too).. In Proc. BSNLP, pp. 1–8 (bib).

(News, from the https://en.wikipedia.org/wiki/Southeast_European_Times, news site sponsored 1999-2015 by US military [United States European Command, EUCOM], addressing former Yugoslavia, Bulgaria, Greece, Romania and Turkey)

online queries:
- https://lindat.mff.cuni.cz/services/pmltq/#!/treebank/udhr_set212/query/