#!/bin/bash
set -e 

FOLDER="$1"
SAMPLE="$2"
SAMPLE_READS="$3"
CPUS="$4"

echo "folder: $FOLDER"
echo "scaffolds: $SAMPLE"
echo "reads: $SAMPLE_READS"
echo "cpus: $CPUS"

# copy data to working directory:
echo "copy data to working directory"
mkdir data
cp ${FOLDER}/preprocessing/assembly/${SAMPLE}_scaffolds.fasta data/.
cp ${FOLDER}/preprocessing/assembly/reads/${SAMPLE_READS}.1P.fastq00.0_0.cor.fastq.gz data/.
cp ${FOLDER}/preprocessing/assembly/reads/${SAMPLE_READS}.2P.fastq00.0_0.cor.fastq.gz data/.

ls -lh data/*
ls

# Note the fastq file don't need to be unzipped.

echo $PWD

echo "print help"
bowtie2 -h

# Building a large index on fasta file
echo "Building a large index on fasta file"
mkdir data/index
# Note that the index does not have the file extension ".fasta"
bowtie2-build --large-index ./data/${SAMPLE}_scaffolds.fasta ./data/index/${SAMPLE}_scaffolds


echo "inspect index"
bowtie2-inspect --large-index ./data/index/${SAMPLE}_scaffolds


echo "listing contents of index folder"
ls -lh data/index/

# Aligning paired reads - output will be sam format
echo "Aligning paired reads - output will be sam format"
echo $(pwd)
bowtie2 -p ${CPUS} \
	-x ./data/index/${SAMPLE}_scaffolds \
	-1 ./data/${SAMPLE_READS}.1P.fastq00.0_0.cor.fastq.gz \
	-2 ./data/${SAMPLE_READS}.2P.fastq00.0_0.cor.fastq.gz \
	-S ./${SAMPLE}_vs_${SAMPLE_READS}.sam

ls

# Convert sam to bam format:
echo "Convert sam to sorted bam format"
samtools sort ./${SAMPLE}_vs_${SAMPLE_READS}.sam -o ./${SAMPLE}_vs_${SAMPLE_READS}.sorted.bam
ls

# Move to staging
echo "Move to staging"

mkdir -p ${FOLDER}/binning_wf/
mkdir -p ${FOLDER}/binning_wf/mapping/

#mv ./${SAMPLE}_vs_${SAMPLE_READS}.sorted.bam ${FOLDER}/binning_wf/mapping/.

echo "rm extra files"
rm ${SAMPLE}_vs_${SAMPLE_READS}.sam
echo "done"


