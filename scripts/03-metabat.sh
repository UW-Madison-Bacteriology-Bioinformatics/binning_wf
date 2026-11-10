#!/bin/bash
set -e 

SAMPLE="$2"

echo "LOG: print help"
metabat2 -h

# run Metabat
echo "LOG: start binning"
# Order has to be command, options, then mandatory inputs
metabat2 -m 2500 --seed 123 -i ${SAMPLE}_scaffolds.fasta -a ${SAMPLE}_depth_all.txt -o bins_dir/${SAMPLE}_metabat2_bin
echo "LOG: done binning"

echo "LOG: count bins:"
ls bins_dir/${SAMPLE}_metabat2_bin* |wc -l

echo "LOG: zipping"
tar czf ${SAMPLE}_metabat2_bins.tar.gz bins_dir
echo "LOG: done"

