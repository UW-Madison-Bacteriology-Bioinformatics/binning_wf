#!/bin/bash
set -e 

FOLDER="$1"
SAMPLE="$2"
CPU="$3"

OMP_THREAD_LIMIT=${CPU}

echo "LOG: print help"
run_MaxBin.pl -h

echo "LOG: copy files over"
cp ${FOLDER}/binning_wf/${SAMPLE}/depths/${SAMPLE}_vs_*.txt .
#cp ${FOLDER}/preprocessing/assembly/${SAMPLE}_scaffolds.fasta .

echo "LOG: how many txt files? "$(ls -lht *.txt | wc)

echo "LOG: for each txt file, we want to rename them"
for file in *depth.txt; do
	new_file="${file%.txt}_2.txt"
	tail -n+2 "$file" | awk -v OFS="\t" '{print $1, $3}' > "$new_file"
done

echo "LOG: done renaming"

#tail -n+2 ${SAMPLE}_depth.txt | awk -v OFS="\t" '{print $1, $3}' > ${SAMPLE}_depth_2.txt
echo "LOG: list new file names: "$(ls *2.txt)
echo "LOG: count how many new files were created: "$(ls -lht *2.txt | wc -l)

echo "LOG: print first few lines from the 1st file listed"
head -n 5 $(ls | head -n 1)

echo "LOG: count how many contigs in depth file: "$(wc -l $(ls | head -n 1))

echo "LOG: count how many scaffolds in the assembly: "$(grep '>' ${SAMPLE}_scaffolds.fasta | wc -l)

echo "LOG: create abund list"
ls *2.txt > abund_list
head abund_list

echo "LOG: start maxbin with minimum contig size 2500 to match metabat2"
run_MaxBin.pl -contig ${SAMPLE}_scaffolds.fasta \
	-abund_list abund_list \
	-out ${SAMPLE}_maxbin2 \
	-thread ${CPU} \
	-min_contig_length 2500

echo "LOG: done binning"

echo "LOG: dir contents: "$(ls)

echo "LOG: zipping and moving"
# Note: Maxbin creates files with the extension .fasta rather than .fa as in metabat2.
tar cvzf ${SAMPLE}_maxbin2_bins.tar.gz ${SAMPLE}_maxbin2.summary ${SAMPLE}_maxbin2.marker ${SAMPLE}_maxbin2.marker_of_each_bin.tar.gz ${SAMPLE}_maxbin2.*.fasta

echo "LOG: done"

