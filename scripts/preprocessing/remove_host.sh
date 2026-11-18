#!/bin/bash

set -e

sample="$1" # sample
reference_path="$2" #path
reference="$3" # name
cpus="$4" $cpus

echo "Reference path: $reference_path"
echo "Sample: $sample"
echo "Reference name: $reference"
echo "Cpus: $cpus"

echo "Create bowtie2 index"

cp ${reference_path} .

ls

echo "Build reference"
bowtie2-build ${reference}.fna ${reference}

ls

echo "inspect bowtie2 index"
bowtie2-inspect -n ${reference}

echo "Run bowtie to map the reads to the reference index"

bowtie2 -x ${reference} \
	-1 ${sample}_1.fastq.gz \
        -2 ${sample}_2.fastq.gz \
        -p ${cpus} |
samtools view -bS > ${sample}_${reference}_align.bam

echo "Get the unmapped reads"
samtools view -b -f 4 -f 8 -o ${sample}_${reference}_unmapped.bam ${sample}_${reference}_align.bam

echo "Sort the bam file"
samtools sort -n ${sample}_${reference}_unmapped.bam -o $1_${reference}_unmapped_sorted.bam

echo "Report the statistics about the unmapped reads"
samtools flagstat ${sample}_${reference}_unmapped_sorted.bam

echo "Extract only the unmapped reads to th BAM file"
bamToFastq -i ${sample}_${reference}_unmapped_sorted.bam \
	-fq ${sample}_R.non.host.R1.fastq \
	-fq2 ${sample}_R.non.host.R2.fastq

echo "Gzip the fastq files"
gzip -f ${sample}_R.non.host.R1.fastq
gzip -f ${sample}_R.non.host.R2.fastq

echo "print the folder contents"
ls
