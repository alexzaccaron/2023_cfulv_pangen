

library('pegas')

# get arguments: output file
args = commandArgs(trailingOnly = T)

input_dir = args[1] # input directory with fasta files
fname_out = args[2] # output file



# ref: https://github.com/sophiadavid1/nucleotide_diversity_analysis/blob/master/step1_calculate_pi_values_for_five_STs_of_interest.R

#input directory containing fasta files 
file.names <- dir(input_dir, pattern=".fas")

# for each fasta file
for(fasta in file.names){
  # read fasta
  locus <- read.dna(paste0(input_dir, "/", fasta), format="fasta", as.matrix=FALSE)
  
  # calculate pi
  locus.pi <- nuc.div(locus)
  
  # append to output file
  write.table( 
    cbind(fasta, locus.pi), file=fname_out, col.names = F, row.names = F, quote = F, append = T)
}


sessionInfo()
