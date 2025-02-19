#!/bin/bash
set -e 

# Parameters
FOLDER="$1"
SAMPLE="$2"
CPU="$3"

# Use it on the real data
echo "LOG: List folder contents, unzipping relevant files:"
ls -lht

# Unzip mags
tar -xvzf ${SAMPLE}_metabat2_bins.tar.gz
# files will have extension bins_dir/*.fa
mkdir maxbin_bins
tar -xvzf ${SAMPLE}_maxbin2_bins.tar.gz -C maxbin_bins
# bins are in maxbin_bins/*.fasta

echo "LOG: rename metabat2 bins for .fasta instead of .fa file extension"
cd bins_dir
for file in *.fa; do mv "$file" "${file%.fa}.fasta"; done
cd ..

echo "LOG: DASTool version:"
DAS_Tool --version

echo "LOG: creating scaf2bin files"
# Metabat2
Fasta_to_Contig2Bin.sh -i bins_dir -e fasta > scaf2bin_metabat2.tsv
# Maxbin2
Fasta_to_Contig2Bin.sh -i maxbin_bins -e fasta > scaf2bin_maxbin2.tsv

echo "LOG: checking if the refined bins folder is empty or not"
if [ -z "$( ls ${FOLDER}/binning_wf/${SAMPLE}/bins/refined/${SAMPLE}_refine_bins_DASTool_bins/*fa )" ]; then
   echo "LOG: Empty, proceeding with bin refinement..."
else
   echo "LOG: CAUTION! The folder is not empty. Deleting contents before proceeding with bin refinement."
   rm ${FOLDER}/binning_wf/${SAMPLE}/bins/refined/*.fa 
   echo "LOG: Done emptying the refined bins folder. Proceeding..."
fi

echo "LOG: start refining"
DAS_Tool -h

DAS_Tool -i scaf2bin_metabat2.tsv,scaf2bin_maxbin2.tsv \
        -c ${SAMPLE}_scaffolds.fasta \
        -o ${SAMPLE}_refine_bins \
        -l metabat2,maxbin2 \
        -t ${CPU} \
        --write_bins \
        --write_bin_evals

echo "LOG: list files"
ls 

echo "LOG: copy important file"
cp -r ${SAMPLE}_refine_bins_DASTool_bins ${FOLDER}/binning_wf/${SAMPLE}/bins/refined/.
#cp ${SAMPLE}_refine_bins_DASTool_summary.tsv ${FOLDER}/binning_wf/${SAMPLE}/bins/refined/.

echo "LOG: zipping the rest"
tar czf ${SAMPLE}_refine_bins.tar.gz ${SAMPLE}_refine_bins*

echo "LOG: done"

