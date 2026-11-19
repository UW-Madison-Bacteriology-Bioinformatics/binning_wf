#!/bin/bash

CPUS="$1"
SAMPLE="$2"

spades.py -1 ${SAMPLE}_R.non.host.R1.fastq.gz\
	-2 ${SAMPLE}_R.non.host.R2.fastq.gz \
	-o ${SAMPLE}_spades_output \
	--meta \
	-t ${CPUS} \
	-m 1000

# Zip the output folder:
tar -cvzf ${SAMPLE}_spades_output.tar.gz ${SAMPLE}_spades_output

echo "Print contents: $(ls)"

cp ${SAMPLE}_spades_output/scaffolds.fasta .

echo "Done."
