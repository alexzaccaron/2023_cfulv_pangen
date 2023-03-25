# Population analysis

This directory has a collection of analyses using WGS data of a small population of individuals (HiFi and Illumina).

- `01read_mapping`: Snakemake pipelines to map Illumina and HiFi reads.

- `02call_snps`: Call SNPs and INDELs from the mapped reads. Filter polymorphisms by quality. Merge VCF files, and them split SNPs and INDELs.

- `03select_snps_unmasked`: get SNPs that are not located in masked regions of the genome. This step select SNPs not within repeats to infer a phylogenetic tree.

- `04plink`: Snakemake that uses PLINK to generate a PCA plot from the SNPs. This is unused, because the tree shows relashionship better. But kept for documentation purposes.

- `05phylogeny`: remove SNPs that overlap repeats, or have too little coverage, or too much coverage. Use the remaining SNPs to build a tree with RAxML.

- `06mosdepth`: estimate read depth of all genes, and identify cases of gene deletion based on lack of coverage.

- `07snpeff`: annotate SNPs and INDEls with SnpEff and predict genes with loss-of-function mutations.

- `08snp_dist_heatmap`: calculate pairwise distances of isolates using the SNPs to infer the phylogenetic tree, and make a heatmap of the distances.

- `10pi`: calculate pi for each gene