#!/bin/bash
set -e 

FOLDER="$1"
SAMPLE="$2"
CPU="$3"

OMP_THREAD_LIMIT=${CPU}

echo "print help"
run_MaxBin.pl -h

echo "copy files over"
cp  ${FOLDER}/binning_wf/${SAMPLE}/depths/${SAMPLE}_vs_*.txt .
cp ${FOLDER}/preprocessing/assembly/${SAMPLE}_scaffolds.fasta .

echo "how many txt files? "$(ls -lht *.txt | wc)

echo "for each txt file, we want to rename them"
for file in *depth.txt; do
	new_file="${file%.txt}_2.txt"
	tail -n+2 "$file" | awk -v OFS="\t" '{print $1, $3}' > "$new_file"
done

echo "done renaming"

#tail -n+2 ${SAMPLE}_depth.txt | awk -v OFS="\t" '{print $1, $3}' > ${SAMPLE}_depth_2.txt
echo "list new file names: "$(ls *2.txt)
echo "count how many new files were created: "$(ls -lht *2.txt | wc -l)

echo "print first few lines from the 1st file listed"
head -n 5 $(ls | head -n 1)

echo "count how many contigs in depth file: "$(wc -l $(ls | head -n 1))

echo "count how many scaffolds in the assembly: "$(grep '>' ${SAMPLE}_scaffolds.fasta | wc -l)

echo "create abund list"
ls *2.txt > abund_list
head abund_list

echo "start maxbin with minimum contig size 2500 to match metabat2"
run_MaxBin.pl -contig ${SAMPLE}_scaffolds.fasta \
	-abund_list abund_list \
	-out ${SAMPLE}_maxbin2 \
	-thread ${CPU} \
	-min_contig_length 2500

echo "done binning"

echo "dir contents: "$(ls)

#echo "create output folder"
#mkdir -p ${FOLDER}/binning_wf/${SAMPLE}/bins/maxbin2/

echo "zipping and moving"
# Note: Maxbin creates files with the extension .fasta rather than .fa as in metabat2.
tar cvzf ${SAMPLE}_maxbin2_bins.tar.gz ${SAMPLE}_maxbin2.summary ${SAMPLE}_maxbin2.marker ${SAMPLE}_maxbin2.marker_of_each_bin.tar.gz ${SAMPLE}_maxbin2.*.fasta
echo "moving"
mv ${SAMPLE}_maxbin2_bins.tar.gz ${FOLDER}/binning_wf/${SAMPLE}/bins/maxbin2/.

echo "remove extra files"
rm ${SAMPLE}_scaffolds.fasta
rm ${SAMPLE}_*depth.txt
rm ${SAMPLE}_*depth_2.txt
rm ${SAMPLE}_maxbin2.*
rm abund_list
echo "done"

