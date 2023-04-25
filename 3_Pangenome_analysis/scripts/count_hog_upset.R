

#install.packages('UpSetR')
library(UpSetR)

tab = read.table("N0_cont.tsv", header = T)

tab = tab[4:ncol(tab)]

# replace values greater than 1.
tab[tab > 1] = 1


pdf("upset.pdf", width = 6.8, height = 4)
upset(tab, 
      #sets = rev(c("PB655_01_combined_filt_aa", "PB655_02_combined_filt_aa", "R5_combined_filt_aa", "PB655_03_combined_filt_aa", "PB655_04_combined_filt_aa")),
      sets = rev(c("R5_combined_filt_aa", "PB655_01_combined_filt_aa", "PB655_02_combined_filt_aa", "PB655_03_combined_filt_aa", "PB655_04_combined_filt_aa")),
      keep.order = T)
dev.off()
