#!/bin/bash

FOLDER="$1"
SAMPLE="$2"

echo "removing sorted.bam:"$(ls ${FOLDER}/binning_wf/mapping/${SAMPLE}_vs_*.sorted.bam)
rm ${FOLDER}/binning_wf/mapping/${SAMPLE}_vs_*.sorted.bam
echo "removed sorted.bam files"
