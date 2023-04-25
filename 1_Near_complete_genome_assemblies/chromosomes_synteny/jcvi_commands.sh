



# GFF with annotations
GFF_R5=~/Desktop/fulvum_hifi/fulvum_hifi_annot/analysis/19combined_annot/R5/R5_combined_filt.gff
GFF_R0=~/Desktop/fulvum_hifi/fulvum_hifi_annot/analysis/19combined_annot/R0/PB655_01_combined_filt_orffinder.gff
GFF_R4=~/Desktop/fulvum_hifi/fulvum_hifi_annot/analysis/19combined_annot/R4/v2/PB655_02_combined_filt.gff
GFF_W4=~/Desktop/fulvum_hifi/fulvum_hifi_annot/analysis/19combined_annot/W4/PB655_03_combined_filt.gff
GFF_W7=~/Desktop/fulvum_hifi/fulvum_hifi_annot/analysis/19combined_annot/W7/PB655_04_combined_filt.gff

# genome fasta files
FASTA_R5=~/Desktop/fulvum_hifi/fulvum_hifi_annot/analysis/19combined_annot/R5/GCA_020509005.2_Cfulv_R5_v5_genomic.fasta
FASTA_R0=~/Desktop/fulvum_hifi/fulvum_hifi_annot/analysis/19combined_annot/R0/PB655_01_Race0.bp.p_ctg_sorted_edited.fasta
FASTA_R4=~/Desktop/fulvum_hifi/fulvum_hifi_annot/analysis/19combined_annot/R4/v2/PB655_02_Race4.bp.p_ctg_sorted_edited.fasta
FASTA_W4=~/Desktop/fulvum_hifi/fulvum_hifi_annot/analysis/19combined_annot/W4/PB655_03_W4_chr2_8_fixed_edited.fasta
FASTA_W7=~/Desktop/fulvum_hifi/fulvum_hifi_annot/analysis/19combined_annot/W7/PB655_04_W7.bp.p_ctg_sorted_edited.fasta


# extract cds from GFF. Activate agat conda environment
conda activate agat

agat_sp_extract_sequences.pl --type cds --gff $GFF_R5 --fasta $FASTA_R5 -o R5.cds
agat_sp_extract_sequences.pl --type cds --gff $GFF_R0 --fasta $FASTA_R0 -o R0.cds
agat_sp_extract_sequences.pl --type cds --gff $GFF_R4 --fasta $FASTA_R4 -o R4.cds
agat_sp_extract_sequences.pl --type cds --gff $GFF_W4 --fasta $FASTA_W4 -o W4.cds
agat_sp_extract_sequences.pl --type cds --gff $GFF_W7 --fasta $FASTA_W7 -o W7.cds



# in my case, I have a conda environment called jcvi with jcvi installed
# activate it
conda activate jcvi

# extract bed files from GFF mRNA, name features by ID
python -m jcvi.formats.gff bed --type=mRNA --key=ID $GFF_R5 -o R5.bed
python -m jcvi.formats.gff bed --type=mRNA --key=ID $GFF_R0 -o R0.bed
python -m jcvi.formats.gff bed --type=mRNA --key=ID $GFF_R4 -o R4.bed
python -m jcvi.formats.gff bed --type=mRNA --key=ID $GFF_W4 -o W4.bed
python -m jcvi.formats.gff bed --type=mRNA --key=ID $GFF_W7 -o W7.bed



# Pairwise synteny search
python -m jcvi.compara.catalog ortholog R5 R0
python -m jcvi.compara.catalog ortholog R0 W7
python -m jcvi.compara.catalog ortholog W7 W4
python -m jcvi.compara.catalog ortholog W4 R4


python -m jcvi.compara.synteny screen --minspan=10 --simple R5.R0.anchors R5.R0.anchors.new
python -m jcvi.compara.synteny screen --minspan=10 --simple R0.W7.anchors R0.W7.anchors.new
python -m jcvi.compara.synteny screen --minspan=10 --simple W7.W4.anchors W7.W4.anchors.new
python -m jcvi.compara.synteny screen --minspan=10 --simple W4.R4.anchors W4.R4.anchors.new


python -m jcvi.graphics.karyotype seqids layout

