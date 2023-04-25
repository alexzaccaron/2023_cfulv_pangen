# 4 Synteny analysis reveals large-scale chromosomal structural variations in *C. fulvum*

## Confirmation of large-scale structural variations with Hi-C
To do so, Hi-C data for *C. fulvum* isolate Race 5 was obtaned from NCBI (SRR16292147). The script `hic_to_map.sh` was used to map the reads, count interaction frequency, and output a `.hic` file that can be opened with [Juicebox](https://github.com/aidenlab/Juicebox/wiki/Download). The script `hic_to_map.sh` was designed to run on a SLURM system, and requires samblaster, juicebox_scripts, matlock, and 3d-dna (see [here](https://github.com/phasegenomics/juicebox_scripts)).


