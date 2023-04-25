# 3. A pangenome analysis of five *C. fulvum* genomes indicates a stable gene content with low number of accessory genes

## UpSet plot (Fig 2A)
To construct a gene-based pangenome for C. fulvum, all the 74,756 genes predicted among the five isolates were organized into hierarchical orthogroups (HOGs) with OrthoFinder v2.5.4. The input is a folder with `fasta` files of the protein sequences of all isolates:

```
orthofinder -t 8 -f {input} > {log} 2>&1
```

OrthoFinder outputs many files, but the one we need is the `N0.tsv` in `Phylogenetic_Hierarchical_Orthogroups/` folder.

I use the script `count_hog_orthofinder.R` to produce the file `N0_count.tsv`, which has the counts, instead of IDs, of genes from each orthogroup:
```
Rscript scripts/count_hog_orthofinder.R N0.tsv N0_count.tsv
```

Then, I used the script `count_hog_upset.R` to make an UpSet plot based on the `No_count.tsv` file:
```
Rscript scripts/count_hog_upset.R
```

## Pangneome scatterplot (Fig 2B)

To make a scatterplot showing the changes in size of the core and pangenomes as more isolates are analyzed, the script `plot_pangenome_scatter.R` was used. Briefly, this script reads in the `N0.tsv` produced by OrthoFinder, and finds the size of core (orthogroups shared by all) and pangenomes (all orthogroups) based on all possible combinations of isolates.
```
Rscript scripts/plot_pangenome_scatter.R N0.tsv out_plot.pdf
```
