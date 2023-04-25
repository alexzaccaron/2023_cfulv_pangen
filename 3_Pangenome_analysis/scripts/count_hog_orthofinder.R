args = commandArgs(trailingOnly = T)


fname_in  = args[1]
fname_out = args[2]


tab = read.table(fname_in, sep ='\t', header = T, fill = T)

tab.ct = tab

taxa = colnames(tab)[4:ncol(tab)]
for(sp in taxa){
  for(i in 1:nrow(tab)){
    tab.ct[i, sp] = length(unlist( strsplit(tab[i, sp], " ")) )
  }
}

write.table(tab.ct, fname_out, quote = F, sep = '\t', row.names = F)
