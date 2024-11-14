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

echo "zipping"
tar czf ${SAMPLE}_metabat2_bins.tar.gz bins_dir
echo "done"

