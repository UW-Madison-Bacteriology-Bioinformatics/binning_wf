#!/bin/bash
set -e 

echo "LOG: print help"
metabat2 -h

# copy data
#echo "LOG: copy data"
FOLDER="$1"
SAMPLE="$2"
SAMPLE2="$3"

echo "LOG: Folder: $FOLDER"
echo "LOG: Sample: $SAMPLE"

echo "LOG: make depth file"
jgi_summarize_bam_contig_depths --outputDepth ${SAMPLE}_vs_${SAMPLE2}.depth.txt ${FOLDER}/binning_wf/mapping/${SAMPLE}_vs_${SAMPLE2}.sorted.bam
ls -lh
head -n 5 ${SAMPLE}_vs_${SAMPLE2}.depth.txt 

echo "LOG: done calculating depths"
