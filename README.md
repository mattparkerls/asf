# Nextstrain repository for African swine fever virus

This repository contains three workflows for the analysis of African swine fever virus data:

- [`scripts/`](./scripts) - Removes sequences that are missing dates or strain names
- [`rules/`](./rules) - Parse and Index sequences to create required files for Nextstrain build
- [`Snakefile`](./Snakefile) - Filter sequences, align, construct phylogeny and export for visualization 

## Installation

Follow the [standard installation instructions](https://docs.nextstrain.org/en/latest/install.html) for Nextstrain's suite of software tools (if you don't already have Nextstrain installed!)

## Quickstart

Clone github repo
```
git clone https://github.com/mattparkerls/asf.git
cd asf/
```

Download African swine fever sequences from [`NCBI Virus`](https://www-ncbi-nlm-nih-gov.yale.idm.oclc.org/labs/virus/vssi/#/virus?SeqType_s=Nucleotide&VirusLineage_ss=African%20swine%20fever%20virus,%20taxid:10497)
- recommended filters: Sequence Length > 150000, Sequence Type = GenBank, Collection Date = as narrow a time period as possible

Put sequences.fasta file from NCBI in _/data_ folder

Run clean_sequences.R script: [`scripts/clean_sequences.R`](./scripts/clean_sequences.R)
```
nextstrain build scripts/clean_sequences.R
```

Run rules/parse.smk to create metadata.tsv file
```
nextstrain build rules/parse.smk
```

Run rules/index_sequences.smk to create sequences_index.tsv file
```
nextstrain build rules/index_sequences.smk
```

Run the default phylogenetic workflow (build may take several hours depending on how many sequences you have)
```
nextstrain build .
nextstrain view .
```

## Nextstrain Documentation

- [Running a pathogen workflow](https://docs.nextstrain.org/en/latest/tutorials/running-a-workflow.html)
