#Script to download test data from the CAMI dataset 
# Original dataset: https://www.ebi.ac.uk/ena/browser/view/PRJEB20380
# Project: PRJEB20380
# Rat gut extrachromosomal elements for the Critical Assessment of Metagenomic Interpretation (CAMI). DNA from samples were processed as in doi:10.1371/journal.pone.0087924

# Download this data to /staging/n/netid reads folder

mkdir -p $STAGING/reads

# 3 paired-end reads for 3 samples
wget -p $STAGING/reads/ -nc ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR192/005/ERR1924605/ERR1924605_2.fastq.gz
wget -p $STAGING/reads/ -nc ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR192/000/ERR1924590/ERR1924590_2.fastq.gz
wget -p $STAGING/reads/ -nc ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR192/008/ERR1924598/ERR1924598_2.fastq.gz
wget -p $STAGING/reads/ -nc ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR192/005/ERR1924605/ERR1924605_1.fastq.gz
wget -p $STAGING/reads/ -nc ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR192/000/ERR1924590/ERR1924590_1.fastq.gz
wget -p $STAGING/reads/ -nc ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR192/008/ERR1924598/ERR1924598_1.fastq.gz

