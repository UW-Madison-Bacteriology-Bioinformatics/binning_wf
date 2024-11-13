# Binning_wf

# Author:
Patricia Q. Tran, ptran5@wisc.edu, University of Wisconsin-Madison

Date: October 2, 2024

Get Help: 
- For people at UW-Madison, please visit [the departmental bioinformatics research support service main website](bioinformatics.bact.wisc.edu). If you are part of the Department of Bacteriology please make an 1-on-1 individual appointment, others please attend one of my weekly office hours.
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

# Docker containers
I started adding Docker container images to DockerHub. Docker images can be converted into SIF (apptainer) images using:

`apptainer build {image_output}.sif docker://{username}/{image}:{tag}`

where anything in `{}` is a name of your choice.

for example:

`apptainer build dastool.sif docker://patriciatran/dastool:1.1.7`

to test that the apptainer has been built correctly you try try:

`apptainer shell -e dastool.sif`

For more details about building containers please visit: https://github.com/UW-Madison-Bacteriology-Bioinformatics/chtc-containers

- Bowtie: https://hub.docker.com/r/patriciatran/bowtie2
- Metabat: https://hub.docker.com/r/patriciatran/metabat2
- Maxbin2: https://hub.docker.com/r/patriciatran/maxbin2
- DAStool: https://hub.docker.com/r/patriciatran/dastool
- CheckM2: [to add]
- GTDB-tk: [to add]

# Quick Start Guide 
1. Log into CHTC
2. Copy this directory and cd into it, make the .sh script executable
```
git clone https://github.com/UW-Madison-Bacteriology-Bioinformatics/binning_wf.git
cd binning_wf
chmod +x scripts/*.sh
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

# Citations
If you find this software useful, please cite this GitHub Repository
1. Tran, P. Q. (2024). Binning_WF DAGman (Version 1.0.0) [Computer software]. https://github.com/UW-Madison-Bacteriology-Bioinformatics/binning_wf/

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
