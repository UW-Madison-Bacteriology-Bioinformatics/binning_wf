In order to have a good metagenomic assembly it is important to properly preprocess the data.
This folder contains example code and steps you can use to clean up your metagenomic reads.

Recommended steps.
1. Run FASTQC on all your metagenomes to assess the quality of your reads
2. Figure out if you need to remove any adapters or primers, etc.
3. Run a decontamination tool to remove host DNA or other contaminants.
3.1. Examples are FASTQC screen
3.2. Or Mapping your reads to a reference genomes for your host and only usin unmapped (non-host) reads for assembly
3.3. After decontamination or host removal, run a FASTQC report on your data again
4. Run a tool like kraken2 to get an overview of the taxonomic composition of your unassembled reads.

5. Assembling your data. This code is for assembling short-read metagenomic data, but choose the appropriate tool and parameters for your data type.

6. Once your have assembled your data, check the quality of your genome assemblies. You can do that checking stats like N50, L50, etc. Gather information about how many scaffolds or contigs were assembled, what percentage of your reads were assembled vs. not, etc.
6.1. Keep that in mind when interpreting your data downstream, some of your microbiome community is unassembled and will be unbinned.


In this folder, I have htcondor scripts to run FASTQC, FASTQ Screen and Kraken2 on your reads, and run a MultiQC report on all the samples.
You then only need to transfer out the MultiQC report HTML file for browsing.
