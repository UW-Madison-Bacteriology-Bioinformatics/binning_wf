#!/bin/bash
set -e 

FOLDER="$1"
SAMPLE="$2"
SAMPLE_READS="$3"
CPUS="$4"

echo "LOG: folder: $FOLDER"
echo "LOG: scaffolds: $SAMPLE"
echo "LOG: reads: $SAMPLE_READS"
echo "LOG: cpus: $CPUS"

# copy data to working directory:
echo "LOG: copy data to working directory"
mkdir data
mv ${SAMPLE}_scaffolds.fasta data/.
mv ${SAMPLE_READS}_R.non.host.R1.fastq.gz data/.
mv ${SAMPLE_READS}_R.non.host.R2.fastq.gz data/.

ls -lh data/*
ls

# Note the fastq file don't need to be unzipped.

echo $PWD

echo "LOG: print help"
bowtie2 -h

# Building a large index on fasta file
echo "LOG: Building a large index on fasta file"
mkdir data/index
# Note that the index does not have the file extension ".fasta"
bowtie2-build --large-index ./data/${SAMPLE}_scaffolds.fasta ./data/index/${SAMPLE}_scaffolds


echo "LOG: inspect index"
bowtie2-inspect --large-index ./data/index/${SAMPLE}_scaffolds


echo "LOG: listing contents of index folder"
ls -lh data/index/

# Aligning paired reads - output will be sam format
echo "LOG: Aligning paired reads - output will be sam format"
echo $(pwd)
bowtie2 -p ${CPUS} \
	-x ./data/index/${SAMPLE}_scaffolds \
	-1 ./data/${SAMPLE_READS}_R.non.host.R1.fastq.gz \
	-2 ./data/${SAMPLE_READS}_R.non.host.R2.fastq.gz \
	-S ./${SAMPLE}_vs_${SAMPLE_READS}.sam

ls

# Convert sam to bam format:
echo "LOG: Convert sam to sorted bam format"
samtools sort ./${SAMPLE}_vs_${SAMPLE_READS}.sam -o ./${SAMPLE}_vs_${SAMPLE_READS}.sorted.bam
ls
