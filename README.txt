README file
Author: Patricia Q. Tran, ptran5@wisc.edu, University of Wisconsin-Madison
Date: October 2, 2024

Program: Binning_wf
Version: 1.0
Purpose: Binning_wf is metagenomic binning software and wrapper script that assembles, refines, quality-checks and assigns taxonomy to metagenome-assembled-genomes (MAGs), or bins.
This is a DAGman workflow that is built to run on the Center for High-Throughput Computing (CHTC, UW-Madison).
The software takes assembled contigs, reads, and annotated scaffolds, and bins them.

Folder file descriptions:
- Scripts such as .sh and .sub files are located in "scripts/"
- Apptainer container images are located in "containers/"
	- Bowtie v.2.5.4 
	- Metabat2 version 2:2.17 (Bioconda); 2024-06-20T09:50:37 
	- MaxBin 2.2.7 
	- DAS Tool 1.1.7 
	- CheckM2 v.1.0.1]
	- GTDB-tk v2.4.0 with GTDB database release 220 (April 24, 2024 - Current) 
- a template DAG is named "binning_wf_template.dag" in this main directory.
- A DAGman configuration file is named "dagman.dag".
- Two helper scripts are provided to edit the template for you to run the script.
	- "create_custom_dag.sh" is a bash script that creates multiple dag for each of your samples.
	- "create_main_dag.sh" is a bash script that creates a "super dag" to run all your "individual dags" at once, given the configuration in dagman.dag.

Get Help: ptran5@wisc.edu | Patricia Tran
Please view the full Notion tutorial for up-to-date instructions.

## Quick Start Guide ## 
# have a list of samples (sample_list.txt) where each sample is a row.
bash create_custom_dag.sh sample_list.txt ptran5 binning_wf_template.dag 
bash create_main_dag.sh sample_list.txt ultimate_dag.dag

# Submit your job from the access point:
condor_submit_dag ultimate_dag.dag
condor_q -dag -nobatch