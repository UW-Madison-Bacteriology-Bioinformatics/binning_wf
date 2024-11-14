#!/bin/bash
set -e

# Parameters
FOLDER="$1"
SAMPLE="$2"
CPU="$3"
DB="$4"

echo "copy things over"
mkdir genomes
cp ${FOLDER}/binning_wf/${SAMPLE}/bins/refined/${SAMPLE}_refine_bins_DASTool_bins/*.fa genomes/.

echo "making tmp folder"
mkdir tmp

echo "print checkm2 help"
checkm2 -h

echo "start quality checking"
checkm2 predict \
	--threads ${CPU} \
	--input genomes \
	--output-directory checkm_out \
	--database_path ${DB} \
	--tmpdir ./tmp \
	-x fa

echo "how many bins > 90% complete and <5% contam?"
HQ=`awk '{ if ($2 > 90 && $3 <5) print $1 }' checkm_out/quality_report.tsv | wc -l`
echo $HQ

echo "how many bins > 50% complete and <10% contam?"
count=`awk '{ if ($2 >= 50 && $3 <10) print $1 }' checkm_out/quality_report.tsv | wc -l`
#echo $count
MQ=$((count-HQ)); echo $MQ

echo "make a list of mag names"
awk '{ if ($2 >= 50 && $3 < 10) print $1 }' checkm_out/quality_report.tsv > checkm_out/${SAMPLE}_mhq_mags.txt


echo "zip files"
tar -czvf ${SAMPLE}_checkm_out.tar.gz checkm_out
echo "done"
