![Status - Testing](https://img.shields.io/badge/Status-Testing-2ea44f)
![Version - pre-release](https://img.shields.io/badge/Version-pre--release-af7777)
[![Documentation - Quick-start](https://img.shields.io/badge/Documentation-Quick--start-57e8ad)](https://github.com/UW-Madison-Bacteriology-Bioinformatics/binning_wf?tab=readme-ov-file#quick-start-guide)

# About this pipeline
**Program**: Binning_wf

**Current Version**: 0.1

**Status**: Testing with researchers

**Scientific Purpose**: Binning_wf is metagenomic binning software and wrapper script that assembles, refines, quality-checks and assigns taxonomy to metagenome-assembled-genomes (MAGs), or bins. This workflow is suited to assemble high-quality microbial (archaeal, bacterial) genomes from high-throughput sequencing data (metagenomics).
The software requirements are, for each sample, assembled contigs, reads, and annotated scaffolds, and bins them.

**Computing Technologies**: This is a DAGman workflow that is built to run on the [Center for High-Throughput Computing](https://chtc.cs.wisc.edu/). Therefore, it uses HTCondor to automatically identify remote machines into which each "job" can be run simultaneously. This enables us to scale analyses across hundreds of samples.
Biologically, it was important that this pipeline performs all-vs-all mapping for each samples, which has been benchmarked to show that methods results in a higher number of mags, and of higher quality when compare to mapping to 1 sample only. I designed the DAGman such that it would manage job submission and remove uncessary files from `/staging` accordingly. This workflow utilizes Apptainer container images for reproducibility.

**Intended users**: Researchers who have metagenomics sequencing data (bulk environmental dna) and would like to reconstruct high-quality genomes from those datasets. This worfklow will be especially useful if you have many samples to process. You can save time by processing all your samples as the same time.

# Workflow design
![Blank diagram](https://github.com/user-attachments/assets/93816abc-e625-4d21-9ce5-f95bf7046c38)

# Building containers

To run this pipeline, you will either need access to `/projects/bacteriology_tran_data/binning_wf_containers` where I have pre-built containers OR built them yourself using the apptainer definition files under `scripts/recipes`.

If you would like to build the containers yourself, using the interactive build jobs to create the containers in `scripts/recipes` once you are logged into chtc.

# Description of files in this directory
- `/scripts`: Scripts such as .sh and .sub files.
- (to do) Apptainer container images are located in `containers/`
	- Bowtie v.2.5.4 
	- Metabat2 version 2:2.17 (Bioconda); 2024-06-20T09:50:37 
	- MaxBin 2.2.7 
	- DAS Tool 1.1.7 
	- CheckM2 v.1.0.1
	- GTDB-tk v2.4.0 with GTDB database release 220 (April 24, 2024 - Current) 
- a template DAG is named `binning_wf_template.dag` in this main directory.
- A DAGman configuration file is named `dagman.dag`.
- Two helper scripts are provided to edit the template for you to run the script.
	- `create_custom_dag.sh` is a bash script that creates multiple dag for each of your samples.
	- `create_main_dag.sh` is a bash script that creates a "super dag" to run all your "individual dags" at once, given the configuration in dagman.dag.

# Quick-start guide
## Preparing input files & folder directory

You will first need access to a `/staging/netid` folder. For more information about /staging folders, please visit: https://chtc.cs.wisc.edu/uw-research-computing/file-avail-largedata . The `/staging` folder will be used for the large genomic input files, and the large genomic output files.

In your request, please consider your input files (how many samples will you have, have the size of all your reads and assembled data, as well as your output files)

>[!NOTE]
> This version of binning_wf assumes that you have ran [AMR-Metagenomics] (https://github.com/UW-Madison-Bacteriology-Bioinformatics/amr-metagenomics) prior, and have an assembled FASTA file and cleaned, host-removed FASTQ files in your staging folder.


Alternative: If you want to run `binning_wf` as standalone, the pipeline assumes that you have already preprocessed your data (trimming, assembling reads into contigs, and annotated contigs). For example, you can trim your samples using `Trimmomatic`, assemble your reads using `SPADES` if using short-reads, and annotate the assembled scaffolds using `prodigal` such that you have a file with translated amino acids. For the reads, we expected the trimmed reads with this file name format : `${SAMPLE_READS}_R.non.host.R1.fastq.gz` or `${SAMPLE_READS}_R.non.host.R2.fastq.gz`

Once you have preprocessed your data, please organize them in the following manner:
```
/staging/netID
/staging/netID/preprocessing/assembly/${sample}_scaffolds.fasta
/staging/netID/preprocessing/assembly/reads/${sample}_R.non.host.R{1,2}.fastq.gz # [both directions]
/staging/netID/preprocessing/annotation/${sample}_scaffolds_proteins.faa
```

The `binning_wf` expects this folder structure to access the assembled data, cleaned up reads, and faa files.

## Instructions
1. Log into CHTC
2. Copy this directory and cd into it, make the .sh script executable
```
git clone https://github.com/UW-Madison-Bacteriology-Bioinformatics/binning_wf.git
cd binning_wf
chmod +x scripts/*.sh
```
3. Create a list of samples named `sample_list.txt`.

>[!WARNING]
> What should go in your sample_list? The sample list will be used for all-vs-all mapping in the first step of the pipeline. Scientifically speaking, we prefer to map all-vs-all samples that correspond to the same ecological group (splitting samples by where in the water column they occur, some kind of important soil characteristics, etd.). The idea is to use differential coverage across samples of a similar type to better bin low-abundance or hard to bin genomes.
> Therefore when you make a list, you can make a list for each group. for example, if you have 1 sample list for Depth1-5m, Depth6-10m, and Depth11-lower, you will run binning_wf 3 times.

```
nano sample_list.txt
# write your samples
# save and exit editor
```

4. Use the helper scripts and templates to create a .dag for all your samples, and an "ultimate_dag" file that will connect all your subdags.
   
Usage: `bash create_custom_dag.sh <samples_list> <netid> <path to checkm DB> <path to GTDB database>`

Usage: `bash create_main_dag.sh <list of samples> <output_file>`

For example (change path of checkm and path of GTDB of your choice) (make sure you are using the correct DB versions). If you are at UW-Madison and would like me to add your to the `/projects/bacteriology_tran_data` simply send me an email! No need to redownload the whole database yourself. 

```
bash create_custom_dag.sh sample_list.txt ptran5 /projects/bacteriology_tran_data/checkm2_database/CheckM2_database/uniref100.KO.1.dmnd /projects/bacteriology_tran_data/gtdbtk_v220/

bash create_main_dag.sh sample_list.txt ultimate_dag.dag
```

5. Create a logs folder for you CHTC log, err and out files.
```
mkdir logs
```

6. Submit your job to chtc like usual!
```
condor_submit_dag ultimate_dag.dag
condor_q -dag -nobatch
```

7. MultiQC
   
You use use the script multiqc.sub to summarize all the genome qualities and taxonomies across the samples found in `/staging/netid/binning_wf`. Essentially, it will look for file extensions corresponding to the CheckM2 and GTDB-tk output files and put them all into 1 HTML file that you can interactively explore. 

8. Clean up & repeat.

If you have more than 1 sample_list, repeat Step 4 and 6 or the remaining sample_list. You might need to 

# Citations
If you find this software useful, please cite this GitHub Repository
1. Tran, P. Q. (2024). Binning_WF DAGman (Version 0.1) [Computer software]. https://github.com/UW-Madison-Bacteriology-Bioinformatics/binning_wf/

This workflow relies on the following softwares, please cite them as well in your work:
1. Metabat:
Kang DD, Li F, Kirton E, Thomas A, Egan R, An H, Wang Z. MetaBAT 2: an adaptive binning algorithm for robust and efficient genome reconstruction from metagenome assemblies. PeerJ. 2019 Jul 26;7:e7359. doi: 10.7717/peerj.7359. PMID: 31388474; PMCID: PMC6662567.
2. Maxbin2:
Yu-Wei Wu, Blake A. Simmons, Steven W. Singer, MaxBin 2.0: an automated binning algorithm to recover genomes from multiple metagenomic datasets, Bioinformatics, Volume 32, Issue 4, February 2016, Pages 605–607, https://doi.org/10.1093/bioinformatics/btv638
3. DAS_Tool:
Sieber, C.M.K., Probst, A.J., Sharrar, A. et al. Recovery of genomes from metagenomes via a dereplication, aggregation and scoring strategy. Nat Microbiol 3, 836–843 (2018). https://doi.org/10.1038/s41564-018-0171-1
4. CheckM2:
Chklovski, A., Parks, D.H., Woodcroft, B.J. et al. CheckM2: a rapid, scalable and accurate tool for assessing microbial genome quality using machine learning. Nat Methods 20, 1203–1212 (2023). https://doi.org/10.1038/s41592-023-01940-w
5. GTDB-tk v.2.4.0
Pierre-Alain Chaumeil, Aaron J Mussig, Philip Hugenholtz, Donovan H Parks, GTDB-Tk: a toolkit to classify genomes with the Genome Taxonomy Database, Bioinformatics, Volume 36, Issue 6, March 2020, Pages 1925–1927, https://doi.org/10.1093/bioinformatics/btz848

# More information
Patricia Q. Tran, ptran5@wisc.edu, University of Wisconsin-Madison
Get Help: 
- For people at UW-Madison, please visit [the departmental bioinformatics research support service main website](bioinformatics.bact.wisc.edu). If you are part of the Department of Bacteriology please make an 1-on-1 individual appointment, others please attend one of my weekly office hours.
- For external people, please submit an issue via the github page.

