# 9. The genome of *C. fulvum* exhibits signatures of asymmetric two-speed model of evolution

## Estimate pi for the genes
In the directory `01pi_genes`, there is a `Snakefile` with a Snakemake workflow to calculate nucleotide diversity (pi) for the genes. Using the genome annotation, it converts a `vcf` file containing only SNPs to `fasta` files. Each gene *g* will have a `fasta` file containing the alleles of *g* from all isolates. This is done using [`vcf2fasta.py`](https://github.com/santiagosnchez/vcf2fasta). Then, the script `scripts/get_pi_per_file.R` calculates for each `fasta` file. This script uses the `nuc.div()` function from the `pegas` package to calculate pi.
