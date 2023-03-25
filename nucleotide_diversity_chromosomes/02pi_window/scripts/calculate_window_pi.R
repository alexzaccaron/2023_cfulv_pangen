
#=== Functions ====
calc_gt_pi <- function(gt_tab, w_size){
  
  if(nrow(gt_tab) == 0) return(0)
  
  # get only the genotypes
  gt = gt_tab[,-1:-4]
  
  # indices of possible combinations
  comb_index = combn(ncol(gt), 2)
  
  count_diff = 0
  
  # for each possible combination
  for(i in 1:ncol(comb_index)){
    
    # sequence A
    A = gt[,comb_index[1, i]]
    # sequence B
    B = gt[,comb_index[2, i]]
    
    count_diff = count_diff + sum(A != B)
  }
  
  # divide by number possible combinations
  pi = count_diff/choose(ncol(gt), 2)
  
  # divide by size of window
  pi = pi / w_size
  
  return(pi)
  
}

get_gt_window <- function(gt_tab, start, end){
 
  gt = gt_tab[gt_tab$POS >= start & gt_tab$POS < end,]
  
  return(gt)
}


get_chr_size <- function( CHROMO, fname_fai ){
   
   fai = read.table(fname_fai, col.names = c("name", "length", "offset", "linebases", "linewidth"))

   size = fai[fai$name == CHROMO, 'length']

   return(size)
}


#==================



args = commandArgs(trailingOnly = T)


in_fname  = args[1] # input genotype matrix
in_fname_fai = args[2] # input faidx fai to get chromo size
out_fname = args[3] # output table with pi values


# Read genotype matrix
gt_tab = read.table(in_fname, header = T)

# add ref genotype
gt_tab$REF = 0


res = NULL # results table

for( chr in names(table(gt_tab$CHROM))){
  
  gt_tab_chr = gt_tab[gt_tab$CHROM == chr,]
  gt_tab_chr = gt_tab_chr[!is.na(gt_tab_chr$REF),] # remove NAs?

  # start window
  w_start = 1
  w_size = 20000
  w_step = 20000
  
  # last SNP position
  last_pos = get_chr_size( chr,  in_fname_fai)
  
  
  
  while(w_start < last_pos){
    w_end = w_start + w_size
    
    w_gt = get_gt_window(gt_tab_chr, w_start, w_end)
    
    w_pi = calc_gt_pi(w_gt, w_size)
    
    res = rbind(res, c(chr, w_start, w_end, w_pi))
    w_start = w_start + w_step
    
  }
}


res = as.data.frame(res)
colnames(res) = c("chr", "start", "end", "pi")

write.table(res, out_fname, quote = F, row.names = F, sep = '\t')



