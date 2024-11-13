#!/bin/bash

set -e

echo "print help"
metabat2 -h

FOLDER="$1"
SAMPLE="$2"

echo "Folder: $FOLDER"
echo "Sample: $SAMPLE"

# JGI Depth:
echo "how many bam files?"
${FOLDER}/binning_wf/mapping/.
ls -lh ${FOLDER}/binning_wf/mapping/${SAMPLE}_*.bam | wc -l

# Metabat2 takes 1 single table where each row is a contig, and each column is a sample
echo "calculate depths with all samples"
jgi_summarize_bam_contig_depths --outputDepth ${SAMPLE}_depth_all.txt ${FOLDER}/binning_wf/mapping/${SAMPLE}_*.bam
ls -lh
head -n 5 ${SAMPLE}_depth_all.txt
echo "done calculating depths"

#mv ${SAMPLE}_depth_all.txt ${FOLDER}/binning_wf/${SAMPLE}/depths/.

echo "done"
