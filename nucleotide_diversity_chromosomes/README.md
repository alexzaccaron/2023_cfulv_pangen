# Nucleotide diversity across chromosomes

This directory contains scripts used to calculate the nucleotide diversity across the chromosomes of Cladosporium fulvum based on whole-genome alignments of five near complete genome assemblies.

* `01syri`: There is a Snakemake pipeline that uses NUCmer to alignm four genomes to a reference, filter the alignment, and uses SyRI to call polymorphisms.

* `02pi_windows`: There is a Snakemake pipeline that uses the output of SyRI to calculate average pairwise nucleotide diversity (pi). First, only SNPs are extracted from the output of SyRI. The SNPs are merged with BCFtools and converted to a genotype matrix with the following format, with the alternative (1) or reference (0) genotypes in binary

```
CHROM	POS	R4	R5	W4	W7
chr1	500	1	1	0	0
chr1	564	1	1	1	1
chr1	864	0	1	1	1
chr1	6260	0	1	1	1
chr1	9361	1	1	1	0
```

The R script `calculate_window_pi.R` will read this table, add the reference genotype (0), and then calculate pi within windows. The logic to calculate pi is described below. Consider a window of size 1 kb. The first window will include the first three SNPs of the table able, which can be represented as the following three binary strings. Note that the first 4 digits correspond to the genotype of the four samples shown in the table abovem, and the last digit correspond to the reference genome.

```
11000
11110
01110
```

Then, we count the differences of all possible pairwise combinations, in this case there are 3 possible combinations: 

* first vs second: 2 differences
* first vs third: 3 difference
* second vs third: 1 difference

Thus, a total of 6 differences were found. We divide the total differences by the total possible combinations, i.e., 6/3 = 2. Finally, we divide by the size of the window, i.e., (6/3) / 1000 = 0.002. And this is the value of pi for the first window.
