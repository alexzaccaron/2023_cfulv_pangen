# Chromosomes plot and synteny

### Chromosomes plot
In the `Snakefile`, sliding windows are gerated, and the number of genes and repeat percentage within windows are calculated. The R script `plot_chromosomes.R`  is then called to generate the plot.

### pairwise synteny
The [MCscan](https://github.com/tanghaibao/jcvi/wiki/MCscan-(Python-version)) from the `jcvi` package was used to generate a pairwise synteny plot of the six chromosome-scale genomes.

First, we save the location of the gene annotation (`GFF`) and genome (`fasta`) files for the six genomes, which I name them R5, R0, R4, W4, and W7.

```
# GFF with annotations
GFF_R5=~/path/to/gff
GFF_R0=~/path/to/gff
GFF_R4=~/path/to/gff
GFF_W4=~/path/to/gff
GFF_W7=~/path/to/gff
```

```
# genome fasta files
FASTA_R5=~/path/to/fasta
FASTA_R0=~/path/to/fasta
FASTA_R4=~/path/to/fasta
FASTA_W4=~/path/to/fasta
FASTA_W7=~/path/to/fasta
```


Then, I obtain the `fasta` files with coding sequences for all of them. To do so, I use the [AGAT](https://github.com/NBISweden/AGAT) package.

```
# extract cds from GFF. Activate agat conda environment
agat_sp_extract_sequences.pl --type cds --gff $GFF_R5 --fasta $FASTA_R5 -o R5.cds
agat_sp_extract_sequences.pl --type cds --gff $GFF_R0 --fasta $FASTA_R0 -o R0.cds
agat_sp_extract_sequences.pl --type cds --gff $GFF_R4 --fasta $FASTA_R4 -o R4.cds
agat_sp_extract_sequences.pl --type cds --gff $GFF_W4 --fasta $FASTA_W4 -o W4.cds
agat_sp_extract_sequences.pl --type cds --gff $GFF_W7 --fasta $FASTA_W7 -o W7.cds
```

I obtain `bed` files from the `GFF` files using `jcvi`:

```
# extract bed files from GFF mRNA, name features by ID
python -m jcvi.formats.gff bed --type=mRNA --key=ID $GFF_R5 -o R5.bed
python -m jcvi.formats.gff bed --type=mRNA --key=ID $GFF_R0 -o R0.bed
python -m jcvi.formats.gff bed --type=mRNA --key=ID $GFF_R4 -o R4.bed
python -m jcvi.formats.gff bed --type=mRNA --key=ID $GFF_W4 -o W4.bed
python -m jcvi.formats.gff bed --type=mRNA --key=ID $GFF_W7 -o W7.bed
```

Next, I obtain pairwise synteny. Keep in mind the order of the comparisons.

```
# Pairwise synteny search
python -m jcvi.compara.catalog ortholog R5 R0
python -m jcvi.compara.catalog ortholog R0 W7
python -m jcvi.compara.catalog ortholog W7 W4
python -m jcvi.compara.catalog ortholog W4 R4
```

Next, I create proper anchor files:

```
python -m jcvi.compara.synteny screen --minspan=10 --simple R5.R0.anchors R5.R0.anchors.new
python -m jcvi.compara.synteny screen --minspan=10 --simple R0.W7.anchors R0.W7.anchors.new
python -m jcvi.compara.synteny screen --minspan=10 --simple W7.W4.anchors W7.W4.anchors.new
python -m jcvi.compara.synteny screen --minspan=10 --simple W4.R4.anchors W4.R4.anchors.new
```

The files `layout` and `seqids` are required to generate a plot. The `layout` file looks like this:

```
# y, xstart, xend, rotation, color, label, va,  bed
 .58,     .1,    .69,       0,      , R5, top, R5.bed
 .51,     .1,    .7,       0,      , R0, top, R0.bed
 .44,     .1,    .69,       0,      , W7, top, W7.bed
 .37,     .1,    .69,       0,      , W4, top, W4.bed
 .30,     .1,    .68,       0,      , R4, top, R4.bed
# edges
e, 0, 1, R5.R0.anchors.simple
e, 1, 2, R0.W7.anchors.simple
e, 2, 3, W7.W4.anchors.simple
e, 3, 4, W4.R4.anchors.simple
```

And the `seqids` file looks like:
```
CP090163.1,CP090164.1,CP090165.1,CP090166.1,CP090167.1,CP090168.1,CP090169.1,CP090170.1,CP090171.1,CP090172.1,CP090173.1,CP090174.1,CP090175.1,CP090176.1
chr1,chr2,chr3,chr4,chr5,chr6,chr7,chr8,chr9,chr10,chr11,chr12,chr13,chr14,chr15
chr1,chr2,chr3,chr4,chr5,chr6,chr7,chr8,chr9,chr10,chr11,chr12,chr13,chr15
chr1,chr2,chr3,chr4,chr5,chr6,chr7,chr8,chr9,chr10,chr11,chr12,chr13,chr15
chr1,chr2,chr3,chr4,chr5,chr6,chr7,chr8,chr9,chr10,chr11,chr12,chr13
```

Finally, to generate a plot:
```
python -m jcvi.graphics.karyotype seqids layout
```


