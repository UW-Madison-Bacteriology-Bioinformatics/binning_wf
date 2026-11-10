#!/bin/bash

# This runs MULTIQC on the chekm and gtdbtk output
# It looks for the files summary.tsv  in gtdbtk and quality_report.tsv for checkM2

cd $STAGING/binning_wf
ls -lht
multiqc **/**/.
