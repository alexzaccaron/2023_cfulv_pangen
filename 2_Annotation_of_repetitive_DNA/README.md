# 2 Annotation of repetitive DNA indicates no major differences in transposable element content among five *C. fulvum* genomes

## Obtain repeat libraries
Repeat libraries constructed with RepeatModeler

```
#where RM is installed
export PATH=$PATH:~/programs/RepeatModeler-2.0.2a/

#call to build database and build the repeat libraries
BuildDatabase -name <name> <genome.fasta> 
RepeatModeler -database <name> -pa 16 -LTRStruct >& run.out
```

## Mask the genome
Once the repeat libraries were obtained, RepeatMasker was used to mask the genome. GFF and alignment files are produced. The alignment files are used in the next step

```
RepeatMasker -xsmall -lib <input.library> -gff -s -a -pa 4 <genome.fasta> 
```

## Parse RepeatMasker output

To parse the alignments file, we use the `parseRM.pl` script from [Parsing-RepeatMasker-Outputs](https://github.com/4ureliek/Parsing-RepeatMasker-Outputs).

```
perl parseRM.pl \
   --in <input.aling>        \
   --land 50,1               \
   --parse                   \
   --fa                      \
   --nrem                    \
   --rlib <input.library>    \
   -v
```

The output of `parseRM.pl` has many files. The file `*parseRM.summary.tab` shows the amount of bases covered by classes and families of repeats. The file `*parseRM.all-repeats.tab` shows information for each repeat family, including divergence.
