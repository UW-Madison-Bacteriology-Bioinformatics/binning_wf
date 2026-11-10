#!/bin/bash

# Creates folders

# Usage: bash set_up.sh sample_list.txt
# What this does: for every sample (rows) in sample_list.txt, the following folder structure will be created.

SAMPLE="$1"

echo "Folder: $STAGING"
echo "Sample: $SAMPLE"

#set -e

echo "Making directories"

mkdir -p $STAGING/binning_wf/
mkdir -p $STAGING/binning_wf/mapping/
mkdir -p $STAGING/binning_wf/${SAMPLE}/
mkdir -p $STAGING/binning_wf/${SAMPLE}/depths/
mkdir -p $STAGING/binning_wf/${SAMPLE}/bins/
mkdir -p $STAGING/binning_wf/${SAMPLE}/bins/metabat2/
mkdir -p $STAGING/binning_wf/${SAMPLE}/bins/maxbin2/
mkdir -p $STAGING/binning_wf/${SAMPLE}/bins/refined/
mkdir -p $STAGING/binning_wf/${SAMPLE}/bins/QA
mkdir -p $STAGING/binning_wf/${SAMPLE}/bins/taxonomy

echo "Finished setting up directories for $SAMPLE"
