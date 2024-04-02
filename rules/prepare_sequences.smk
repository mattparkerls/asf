"""
This part of the workflow cleans and parses the FASTA sequences before filtering.

REQUIRED INPUTS:

    raw_sequences            = NONE

OUTPUTS:

    node_data = data/sequences_all_subset.fasta, results/metadata.tsv, results/sequences_index.tsv
"""

# 1) Removes sequences that are missing dates or strain names
rule clean_sequences:
    params:
        scripts = "scripts/clean_sequences.R"
    shell:
        """
        "Rscript {params.scripts}"
        """

# 2) create metadata.tsv file
rule parse:
    input:
        sequences = "data/sequences_all_subset.fasta" # subsetting sequences after running scripts/clean_sequences.R
    output:
        sequences = "results/sequences.fasta",
        metadata = "results/metadata.tsv"
    params:
        fields = "accession virus strain country date"
    shell:
        """
        augur parse \
            --sequences {input.sequences} \
            --fields {params.fields} \
            --output-sequences {output.sequences} \
            --output-metadata {output.metadata} \
            --fix-dates monthfirst
        """

# 3) create sequence_index.tsv file
rule index_sequences:
    message:
        """
        Creating an index of sequence composition for filtering.
        """
    input:
        sequences = "results/sequences.fasta" # parsed sequences without accession number
    output:
        sequence_index = "results/sequence_index.tsv"
    shell:
        """
        augur index \
            --sequences {input.sequences} \
            --output {output.sequence_index}
        """