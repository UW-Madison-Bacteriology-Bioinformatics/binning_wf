#!/bin/bash

set -e

CPUS="$1"
SAMPLE="$2"
DB_PATH="$3"

echo "CPUS: ${CPUS}"
echo "SAMPLE: ${SAMPLE}"
echo "DB PATH: ${DB_PATH}"

echo "Start"

kraken2 --help

kraken2 --db ${DB_PATH} \
	--threads ${CPUS} \
	--output output.txt \
	--use-names \
	--paired \
	${SAMPLE}_1.fastq.gz \
	${SAMPLE}_2.fastq.gz

# You can add the --confidence 0.1


echo "end"
