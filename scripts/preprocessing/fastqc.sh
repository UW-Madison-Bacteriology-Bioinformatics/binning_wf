
#!/bin/bash
set -e

SAMPLE="$1"
echo "Running FASTQC on ${SAMPLE}"
echo $STAGING

# create output folder
mkdir -p $STAGING/reads/fastqc

# each job will run fastqc on that pair of samples
fastqc --outdir $STAGING/reads/fastqc $STAGING/reads/${SAMPLE}_1.fastq.gz $STAGING/reads/${SAMPLE}_2.fastq.gz
