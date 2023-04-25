# 5. Replacement of a chromosome end results in loss of the effector gene *Avr9*

## Alignments (Fig 3A-C)
The alignmnets were performed with NUCmer from MUMmer v4 using the Snakemake workflow. The script `Snakefile` has the commands executed. Briefly:

* The first 100 kb of Chr7 of isolate 0WU was aligned with the first 100 kb of Chr7 of isolate 2 4 9 11 (Fig 3A)
* The first 20 kb of Chr7 and Chr 2 of isolate 0WU were aligned (Fig 3C)
* The first 20 kb of Chr7 and Chr 2 of isolate 2 4 9 11 were aligned (Fig 3B)

## Plotting (Fig 3A-D)
Based on the alignments obtained, plots were generated with R scripts. Plots also include location of genes and repeats.

* `plot_100k.R`: plot the alignment between the left end of Chr7 of isolates 0WU and 2 4 9 11 (Fig 3A).
* `plot_W7_20k.R`: plot the alignment between the left end of Chr7 and Chr2 of isolate 2 4 9 11 (Fig 3B). 
* `plot_R0_20k.R`: plot the alignment between the left end of Chr7 and Chr2 of isolate 0WU (Fig 3C).
* `plot_copia_element.R`: plot the domains of the Ty1/Copia element (Fig 3D). Location of the domains was obtained by querying the family representative (from the RepeatModeler library output) with [NCBI CDD](https://www.ncbi.nlm.nih.gov/Structure/cdd/wrpsb.cgi) database.

Plots obtained in PDF format were edited with Inkscape
