#!/bin/bash
set -e

echo "list file : $(ls)"
echo "untar"
tar xf sample_$1_reads.tar.gz

echo "mv into the subfolder"
cd sample_$1_reads

echo "unzip reads"
gunzip anonymous_reads.fq.gz

echo "ls : $(ls)"

echo "reformat"
reformat.sh in=anonymous_reads.fq out1=sample_$1_1.fastq out2=sample_$1_2.fastq

echo "gz output"
pigz -3 sample_$1_1.fastq
pigz -3 sample_$1_2.fastq

echo "list: $(ls)"

echo "move files"
cd ..
mv sample_$1_reads/sample_$1_1.fastq.gz .
mv sample_$1_reads/sample_$1_2.fastq.gz .

echo "pwd : $(pwd)"
echo "ls : $(ls)"
