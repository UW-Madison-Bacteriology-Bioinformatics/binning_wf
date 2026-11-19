SAMPLE="$1"

echo "Folder: $STAGING"
echo "Sample: $SAMPLE"

#set -e

echo "Making directories"

mkdir -p $STAGING/reads/
mkdir -p $STAGING/reads/kraken2/
mkdir -p $STAGING/reads/multiqc/

mkdir -p $STAGING/preprocessing/
mkdir -p $STAGING/preprocessing/assembly/
mkdir -p $STAGING/preprocessing/assembly/reads/
mkdir -p $STAGING/preprocessing/annotation/

