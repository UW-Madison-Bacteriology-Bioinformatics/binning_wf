#!/bin/bash
set -e 

# Parameters
FOLDER="$1"
SAMPLE="$2"
CPU="$3"

# Use it on the real data
echo "copy files"
cp ${FOLDER}/binning_wf/${SAMPLE}/bins/metabat2/${SAMPLE}_metabat2_bins.tar.gz .
cp ${FOLDER}/binning_wf/${SAMPLE}/bins/maxbin2/${SAMPLE}_maxbin2_bins.tar.gz .
cp ${FOLDER}/preprocessing/assembly/${SAMPLE}_scaffolds.fasta .
cp ${FOLDER}/preprocessing/annotation/${SAMPLE}.faa .

# Unzip mags
tar -xvzf ${SAMPLE}_metabat2_bins.tar.gz
# files will have extension bins_dir/*.fa
mkdir maxbin_bins
tar -xvzf ${SAMPLE}_maxbin2_bins.tar.gz -C maxbin_bins
# bins are in maxbin_bins/*.fasta

echo "rename metabat2 bins for .fasta instead of .fa file extension"
cd bins_dir
for file in *.fa; do mv "$file" "${file%.fa}.fasta"; done
cd ..

echo "dastool version:"
DAS_Tool --version

echo "creating scaf2bin files"
# Metabat2
Fasta_to_Contig2Bin.sh -i bins_dir -e fasta > scaf2bin_metabat2.tsv
# Maxbin2
Fasta_to_Contig2Bin.sh -i maxbin_bins -e fasta > scaf2bin_maxbin2.tsv

echo "start refinining"
DAS_Tool -h

DAS_Tool -i scaf2bin_metabat2.tsv,scaf2bin_maxbin2.tsv \
        -c ${SAMPLE}_scaffolds.fasta \
        -o ${SAMPLE}_refine_bins \
        -p ${SAMPLE}.faa \
        -l metabat2,maxbin2 \
        -t ${CPU} \
        --write_bins \
        --write_bin_evals

echo "list files"
ls 

echo "copy important file"
cp -r ${SAMPLE}_refine_bins_DASTool_bins ${FOLDER}/binning_wf/${SAMPLE}/bins/refined/.
#cp ${SAMPLE}_refine_bins_DASTool_summary.tsv ${FOLDER}/binning_wf/${SAMPLE}/bins/refined/.

echo "zipping the rest"
tar czf ${SAMPLE}_refine_bins.tar.gz ${SAMPLE}_refine_bins*

echo "done"

