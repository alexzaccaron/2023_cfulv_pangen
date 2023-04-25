# 1 Near complete genome assemblies of five isolates of *C. fulvum*

## Genome assembly
The PacBio HiFi reads of *C. fulvum* isolates 0WU, Race 4, 2 4 5 9 11 IPO, and 2 4 9 11 were assembled with Canu v2.2 with parameter `-pacbio-hifi`:

```
canu \
   -p {samplename} \
   -d output/{samplename} \
   genomeSize=70m \
   maxThreads=12  \
   -pacbio-hifi {input} > {log} 2>&1
```

## Identify chromosomes
To identify the chromosomes, the assemblies were aligned with the 14 chromosomes of *C. fulvum* isolate Race 5 (GCA_020509005.2). First, the alignments were obtained with NUCmer from MUMmer v4:

```
nucmer -t 8 --prefix={prefix} {input.ref} {input.qry}
```

The resulting `{prefix}.delta` was filtered to keep only the best one-to-one alignments:

```
delta-filter -1 {prefix}.delta > {prefix}.delta1
```

Dot plots were then generated:
```
mummerplot -p {prefix} --color --png {prefix}.delta1
```

And alignment coordinates inspected:
```
show-coords {prefix}.delta1
```

## Comparison of homologous chromosomes (Fig 1A)
I wanted to compare homologous chromosomes from the five isolates by visualizing them next to each other. To make the plot more informative, I added gene density and repetitive DNA content across the chromosomes. To make the plot, I used a Snakemake pipeline that taskes as input the gene annotation in `bed` format, the `gff` with the repeats output from RepeatMasker, and `.fai` files of the genome assemblies obtained with `samtools faidx`.

The Snakemake pipeline essentially uses a sliding window to calculate the number of genes and repeat content within each window, and call the R script `scripts/plot_chromosomes.R` to make the plot

## Chromosomes syntenty (Fig 1B)
Pairwse synteny plot of the chromosomes was obtained with [MCscan](https://github.com/tanghaibao/jcvi/wiki/MCscan-(Python-version)) from [JCVI](https://github.com/tanghaibao/jcvi). The synteny plot is based on one-to-one orthologs of the genes.

I started with the `GFF` and `fasta` files for the five isolates:

| isolate | GFF | FASTA |
|--|-----|--------|
| Race5 | GFF_R5 | FASTA_R5 |
| 0WU | GFF_R0 | FASTA_R0 |
| Race4 | GFF_R4 | FASTA_R4 |
| 245911 IPO | GFF_W4 | FASTA_W4 |
| 25911 | GFF_W7 | FASTA_W7 |


First, coding sequences are extracted from the gene annotation and assembliy files using `AGAT`:
```
agat_sp_extract_sequences.pl --type cds --gff $GFF_R5 --fasta $FASTA_R5 -o R5.cds
agat_sp_extract_sequences.pl --type cds --gff $GFF_R0 --fasta $FASTA_R0 -o R0.cds
agat_sp_extract_sequences.pl --type cds --gff $GFF_R4 --fasta $FASTA_R4 -o R4.cds
agat_sp_extract_sequences.pl --type cds --gff $GFF_W4 --fasta $FASTA_W4 -o W4.cds
agat_sp_extract_sequences.pl --type cds --gff $GFF_W7 --fasta $FASTA_W7 -o W7.cds
```

Then, `bed` files with the gene annotation are extracted from `GFF` mRNA. Note that features are named using the `ID` tag from `GFF`. The `jcvi.formats.gff` script is from `JCVI` toolkit.
```
python -m jcvi.formats.gff bed --type=mRNA --key=ID $GFF_R5 -o R5.bed
python -m jcvi.formats.gff bed --type=mRNA --key=ID $GFF_R0 -o R0.bed
python -m jcvi.formats.gff bed --type=mRNA --key=ID $GFF_R4 -o R4.bed
python -m jcvi.formats.gff bed --type=mRNA --key=ID $GFF_W4 -o W4.bed
python -m jcvi.formats.gff bed --type=mRNA --key=ID $GFF_W7 -o W7.bed
```

Now, search orthologs to infer synteny:
```
python -m jcvi.compara.catalog ortholog R5 R0
python -m jcvi.compara.catalog ortholog R0 W7
python -m jcvi.compara.catalog ortholog W7 W4
python -m jcvi.compara.catalog ortholog W4 R4
```

Generate new anchor files for the plot:
```
python -m jcvi.compara.synteny screen --minspan=10 --simple R5.R0.anchors R5.R0.anchors.new
python -m jcvi.compara.synteny screen --minspan=10 --simple R0.W7.anchors R0.W7.anchors.new
python -m jcvi.compara.synteny screen --minspan=10 --simple W7.W4.anchors W7.W4.anchors.new
python -m jcvi.compara.synteny screen --minspan=10 --simple W4.R4.anchors W4.R4.anchors.new
```

TO make the plot, call:
```
python -m jcvi.graphics.karyotype seqids layout
```

Note that I am using `seqids` and `layout`, which are configuration files. The `seqids` has the names of the chromosomes. Mine looks like (their order is important):
```
CP090163.1,CP090164.1,CP090165.1,CP090166.1,CP090167.1,CP090168.1,CP090169.1,CP090170.1,CP090171.1,CP090172.1,CP090173.1,CP090174.1,CP090175.1,CP090176.1
chr1,chr2,chr3,chr4,chr5,chr6,chr7,chr8,chr9,chr10,chr11,chr12,chr13,chr14,chr15
chr1,chr2,chr3,chr4,chr5,chr6,chr7,chr8,chr9,chr10,chr11,chr12,chr13,chr15
chr1,chr2,chr3,chr4,chr5,chr6,chr7,chr8,chr9,chr10,chr11,chr12,chr13,chr15
chr1,chr2,chr3,chr4,chr5,chr6,chr7,chr8,chr9,chr10,chr11,chr12,chr13
```

Mine `layout` looks like:
```
# y, xstart, xend, rotation, color, label, va,  bed
 .54,     .1,    .69,       0,      , R5, top, R5.bed
 .48,     .1,    .7,       0,      , R0, top, R0.bed
 .42,     .1,    .69,       0,      , W7, top, W7.bed
 .36,     .1,    .69,       0,      , W4, top, W4.bed
 .30,     .1,    .68,       0,      , R4, top, R4.bed
# edges
e, 0, 1, R5.R0.anchors.simple
e, 1, 2, R0.W7.anchors.simple
e, 2, 3, W7.W4.anchors.simple
e, 3, 4, W4.R4.anchors.simple
```




