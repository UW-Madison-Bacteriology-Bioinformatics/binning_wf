#!/bin/bash

set -e
# This runs MULTIQC on the chekm and gtdbtk output
# It looks for the files summary.tsv  in gtdbtk and quality_report.tsv for checkM2

echo $STAGING

ls -lht $STAGING/reads/**/

multiqc $STAGING/reads/**/.
