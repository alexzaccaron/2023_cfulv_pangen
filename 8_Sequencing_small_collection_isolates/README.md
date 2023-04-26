# 8. Genome sequencing of a small world-wide collection of C. fulvum isolates indicates high levels of gene conservation

## Read mapping
In the directory `01read_mapping`, there are two `Snakefile` files with Snakemake workflows to map Illumina and HiFi reads to the reference. For Illumina, reads are QC with `fastp`, mapped with `bwa mem`, and then read groups are added to the resulting `bam` files. For HiFi, reads are mapped with `pbmm2`. Read groups are passed as parameter to `pbmm2` during mapping.

## Call SNPs
In the directory `02call_snps`, there is a `Snakefile` with a Snakemake workflow to call SNPs from the mapped reads. SNPs are called with `freebayes` and filtered with `VCFtools`. At the end, SNPs and INDELs are split into two `vcf` files with `VCFtools`.

## Select SNPs to build phylogenetic tree
In the directory `03select_snps_unmasked`, there is a `Snakefile` with a Snakemake workflow to select SNPs to infer a phylogeentic tree. Basically, regions of the non-repetitive (unmasked) regions of the reference genome are obtained. SNPs overlaping these non-repetitive regions are then obtained.

## Phylogenetic tree from SNPs (Fig 6)
In the directory `04phylogeny`, there is a `Snakefile` with a Snakemake workflow to infer a phylogenetic tree from SNPs. First, it will remove SNPs that are located in regions with too much (> 500x) or too low (< 10x) coverage, as they could be from collapsed or unreliable regions. After removing them, SNPs are converted to `fasta` format with `vk phylo fasta`. The reference alleles are also added to the `fasta` file. Finally, `RAxML` is used to infer a tree.

## Estimate number of segregating sites (Fig 6)
In the directory `05snp_dist_heatmap`, there is a `Snakefile` with a Snakemake workflow to estimtate the number of segregating sites in a pairwise manner based on the SNPs used to infer the tree. It used `snp-dists` to generate a quadratic matrix with the pairwise number of segregating sites between isolates. A heatmap is then drawn from the number of segregating sites.


## Annotate impact of SNPs
In the directory `06snpeff`, there is a `Snakefile` with a Snakemake workflow to annotate SNPs and INDELs. It uses `SnpEff` to build a custom database from the gene annotation, and then SNPs and INDELs are annotated. The script `scripts/get_lof_genes.R` extracts genes predicted to harbor loss of function mutations, i.e., stop or start codon lost, premature stop codon, and frameshift variants.
