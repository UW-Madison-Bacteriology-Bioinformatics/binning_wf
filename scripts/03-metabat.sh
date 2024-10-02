#!/bin/bash
set -e 

echo "print help"
metabat2 -h

# copy data
echo "copy data"
FOLDER="$1"
SAMPLE="$2"
cp ${FOLDER}/preprocessing/assembly/${SAMPLE}_scaffolds.fasta .
cp ${FOLDER}/binning_wf/${SAMPLE}/depths/${SAMPLE}_depth_all.txt .
ls
echo "finished copying data"

# run Metabat
echo "start binning"
# Order has to be command, options, then mandatory inputs
metabat2 -m 2500 --seed 123 -i ${SAMPLE}_scaffolds.fasta -a ${SAMPLE}_depth_all.txt -o bins_dir/${SAMPLE}_metabat2_bin
echo "done binning"

echo "count bins:"
ls bins_dir/${SAMPLE}_metabat2_bin* |wc -l

# zip and move:
echo "rm extra files"
rm ${SAMPLE}_scaffolds.fasta
rm ${SAMPLE}_depth_all.txt

#echo "create output folder"
#mkdir -p ${FOLDER}/binning_wf/${SAMPLE}/bins/
#mkdir -p ${FOLDER}/binning_wf/${SAMPLE}/bins/metabat2/

echo "zipping"
tar czf ${SAMPLE}_metabat2_bins.tar.gz bins_dir
echo "moving"
mv ${SAMPLE}_metabat2_bins.tar.gz ${FOLDER}/binning_wf/${SAMPLE}/bins/metabat2/.

echo "done"

