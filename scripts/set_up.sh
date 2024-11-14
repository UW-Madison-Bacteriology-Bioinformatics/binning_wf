#!/bin/bash

# Creates folders

FOLDER="$1"
SAMPLE="$2"

echo "Folder: $FOLDER"
echo "Sample: $SAMPLE"

#set -e

echo "making directories"

mkdir -p ${FOLDER}/binning_wf/
mkdir -p ${FOLDER}/binning_wf/mapping/
mkdir -p ${FOLDER}/binning_wf/${SAMPLE}/
mkdir -p ${FOLDER}/binning_wf/${SAMPLE}/depths/
mkdir -p ${FOLDER}/binning_wf/${SAMPLE}/bins/
mkdir -p ${FOLDER}/binning_wf/${SAMPLE}/bins/metabat2/
mkdir -p ${FOLDER}/binning_wf/${SAMPLE}/bins/maxbin2/
mkdir -p ${FOLDER}/binning_wf/${SAMPLE}/bins/refined/
mkdir -p ${FOLDER}/binning_wf/${SAMPLE}/bins/QA
mkdir -p ${FOLDER}/binning_wf/${SAMPLE}/bins/taxonomy

echo "set up directories"
