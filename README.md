# Binning_wf

# Author:
Patricia Q. Tran, ptran5@wisc.edu, University of Wisconsin-Madison

Date: October 2, 2024

Get Help: 
- For people at UW-Madison, please visit [the departmental bioinformatics research support service main website](bioinformatics.bact.wisc.edu) and make an 1-on-1 individual appointment
- For external people, please submit an issue via the github page.

Please view the full Notion tutorial for up-to-date instructions.

# About this pipeline
**Program**: Binning_wf

**Current Version**: 0.1

**Status**: Testing with researchers

**Scientific Purpose**: Binning_wf is metagenomic binning software and wrapper script that assembles, refines, quality-checks and assigns taxonomy to metagenome-assembled-genomes (MAGs), or bins. This workflow is suited to assemble high-quality microbial (archaeal, bacterial) genomes from high-throughput sequencing data (metagenomics).
The software requirements are, for each sample, assembled contigs, reads, and annotated scaffolds, and bins them.

**Computing Technologies**: This is a DAGman workflow that is built to run on the [Center for High-Throughput Computing](https://chtc.cs.wisc.edu/). Therefore, it uses HTCondor to automatically identify remote machines into which each "job" can be run simultaneously. This enables us to scale analyses across hundreds of samples.
Biologically, it was important that this pipeline performs all-vs-all mapping for each samples, which has been benchmarked to show that methods results in a higher number of mags, and of higher quality when compare to mapping to 1 sample only. I designed the DAGman such that it would manage job submission and remove uncessary files from `/staging` accordingly. This workflow utilizes Apptainer container images for reproducibility.

**Intended users**: Researchers who have metagenomics sequencing data (bulk environmental dna) and would like to reconstruct high-quality genomes from those datasets. This worfklow will be especially useful if you have many samples to process. You can save time by processing all your samples as the same time.

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

# Quick Start Guide 
1. Log into CHTC
2. Copy this directory and cd into it
```
git clone https://github.com/UW-Madison-Bacteriology-Bioinformatics/binning_wf.git
cd binning_wf
```
3. Create a list of samples named `sample_list.txt`.
```
nano sample_list.txt
# write your samples
# save and exit editor
```
4. Use the helper scripts and templates to create a .dag for all your samples, and an "ultimate_dag" file that will connect all your subdags.
```
bash create_custom_dag.sh sample_list.txt ptran5 binning_wf_template.dag 
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
