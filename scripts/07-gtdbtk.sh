#!/bin/bash
set -e 

FOLDER="$1"
SAMPLE="$2"
CPUS="$3"
DB="$4"

echo "LOG: copy genomes"
mkdir genomes
cp ${FOLDER}/binning_wf/${SAMPLE}/bins/refined/${SAMPLE}_refine_bins_DASTool_bins/*.fa genomes/.

echo "LOG: list few first files"
ls genomes/* | head -n 5

export GTDBTK_DATA_PATH=${DB}
echo $GTDBTK_DATA_PATH

echo "LOG: start taxonomic assignment"
gtdbtk classify_wf --genome_dir genomes/ \
	--out_dir gtdb_output \
	--cpus ${CPUS} \
	--pplacer_cpus ${CPUS} \
	--tmpdir ./tmp/ \
	--skip_ani_screen \
	-x fa

echo "LOG: Zip output files."
tar czf ${SAMPLE}_gtdbtk_output.tar.gz gtdb_output
