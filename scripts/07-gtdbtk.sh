#!/bin/bash
set -e 

FOLDER="$1"
SAMPLE="$2"
CPUS="$3"
DB="$4"

echo "copy genomes"
mkdir genomes
cp ${FOLDER}/binning_wf/${SAMPLE}/bins/refined/${SAMPLE}_refine_bins_DASTool_bins/*.fa genomes/.

echo "list few first files"
ls genomes/* | head -n 5

export GTDBTK_DATA_PATH=${DB}
echo $GTDBTK_DATA_PATH

echo "start taxonomic assignment"
gtdbtk classify_wf --genome_dir genomes/ \
	--out_dir gtdb_output \
	--cpus ${CPUS} \
	--pplacer_cpus ${CPUS} \
	--tmpdir ./tmp/ \
	--skip_ani_screen \
	-x fa

echo "move important files"
cp gtdb_output/gtdbtk.ar53.summary.tsv ${FOLDER}/binning_wf/${SAMPLE}/bins/taxonomy/.
cp gtdb_output/gtdbtk.bac120.summary.tsv ${FOLDER}/binning_wf/${SAMPLE}/bins/taxonomy/.

echo "zip and move the rest"
tar czf ${SAMPLE}_gtdbtk_output.tar.gz gtdb_output
mv ${SAMPLE}_gtdbtk_output.tar.gz ${FOLDER}/binning_wf/${SAMPLE}/bins/taxonomy/.
