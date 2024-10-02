#!/bin/bash

FOLDER="$1"
SAMPLE="$2"

echo "removing sorted.bam:"$(ls ${FOLDER}/binning_wf/mapping/${SAMPLE}_vs_*.sorted.bam)
rm ${FOLDER}/binning_wf/mapping/${SAMPLE}_vs_*.sorted.bam
echo "removed sorted.bam files"

#echo "making dir of main results"
#mkdir -p ${FOLDER}/binning_wf/${SAMPLE}/Results
#echo "copy important files"
#cp ${FOLDER}/binning_wf/${SAMPLE}/QA/${SAMPLE}_quality_report.tsv ${FOLDER}/binning_wf/${SAMPLE}/Results/.
#cp ${FOLDER}/binning_wf/${SAMPLE}/Taxonomy/*.tsv ${FOLDER}/binning_wf/${SAMPLE}/Results/.
#echo "done"
