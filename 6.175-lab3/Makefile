compile:
	mkdir -p buildDir
	bsc -u -sim -bdir buildDir -info-dir buildDir -simdir buildDir -vdir buildDir -aggressive-conditions TestBench.bsv

fold: compile
	bsc -sim -e mkTbFftFolded -bdir buildDir -info-dir buildDir -simdir buildDir -o simFold
	
inelastic: compile
	bsc -sim -e mkTbFftInelasticPipeline -bdir buildDir -info-dir buildDir -simdir buildDir -o simInelastic

elastic: compile
	bsc -sim -e mkTbFftElasticPipeline -bdir buildDir -info-dir buildDir -simdir buildDir -o simElastic

sfol: compile
	bsc -sim -e mkTbFftSuperFolded -bdir buildDir -info-dir buildDir -simdir buildDir -o simSfol

all: fold inelastic elastic sfol

clean:
	rm -rf buildDir sim*

.PHONY: clean all fold inelastic elastic sfol compile
.DEFAULT_GOAL := all
