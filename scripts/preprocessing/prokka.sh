#!/bin/bash

set -e

CPUS="$1"
SAMPLE="$2"

echo "CPUS: ${CPUS}"
echo "SAMPLE: ${SAMPLE}"

#echo "unzip"
#tar xf ${SAMPLE}_spades_output.tar.gz

#ls ${SAMPLE}_spades_output/*

echo "Start"

prokka --version

prokka --outdir prokka_out \
	--compliant \
	--metagenome \
	--cpus $CPUS \
	--mincontiglen 1000 \
	--prefix $SAMPLE \
	${SAMPLE}_scaffolds.fasta

ls prokka_out

ls prokka_out/$SAMPLE.faa

echo "end"
