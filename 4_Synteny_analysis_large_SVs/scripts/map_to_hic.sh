#!/bin/bash
#SBATCH -D /home/azacca/projects/fulvum_hifi_hic_major_sv/
#SBATCH --partition=med
#SBATCH --job-name=hic
#SBATCH --nodes=1
#SBATCH --ntasks=16
#SBATCH --mem=48G
#SBATCH --time=10:00:00
#SBATCH --output=output/R0/hic_to_map.out
#SBATCH --error=output/R0/hic_to_map.err


module load bwa/0.7.17.r1188
module load samtools/1.9
module load python3/3.6.1


#==== AUX TOOLS ====
SAMBLASTER=/home/azacca/programs/samblaster/samblaster
JB_SCRIPTS=/home/azacca/programs/juicebox_scripts/juicebox_scripts/
MATLOCK=/home/azacca/programs/matlock/bin/matlock
DNA3D=/home/azacca/programs/3d-dna


#=== INPUT =====
#Hi-C R1 and R2 reads
R1=data/SRR16292147_1.fastq.gz 
R2=data/SRR16292147_2.fastq.gz

#assembly fasta
FASTA=data/PB655_03_W4_chr2_8_fixed_edited.fasta


#=== OUTPUT =====
OUTBAM=output/W4/hic_mapped.bam
AGP=output/W4/ref.agp
ASSEMBLY=output/W4/ref.assembly
LINKS=output/W4/hic_links.txt


#---
#indexing assembly
bwa index $FASTA
#1) mapping
#2) flagging PCR duplicates
#3) removing unampped reads, not primary and supplementary alignments
bwa mem -t 12 -5SP $FASTA  $R1  $R2 | \
	$SAMBLASTER                 | \
	samtools view -@ 4 -S -h -b -F 2316 > $OUTBAM
#---

#---
python $JB_SCRIPTS/makeAgpFromFasta.py $FASTA $AGP
python $JB_SCRIPTS/agp2assembly.py $AGP $ASSEMBLY
#---

#---
$MATLOCK bam2 juicer $OUTBAM $LINKS
sort -k2,2 -k6,6 -o $LINKS $LINKS
#---

#creates a .hic file
$DNA3D/visualize/run-assembly-visualizer.sh -p false $ASSEMBLY $LINKS


