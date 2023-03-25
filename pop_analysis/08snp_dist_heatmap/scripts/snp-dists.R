

library(gplots)

my_palette <- colorRampPalette(c("white", "red"))(n = 299)


args = commandArgs(trailingOnly = T)

in_file  = args[1]
out_file = args[2]

snp_dist = read.table(in_file, sep = '\t', header = T)
strain_order = c("0WU", "W7", "W9", "W20", "W10", "W12", "R4", "W8", "W4", "W15", "CFR5", "W14a", "W13", "W18", "CF-Nango", "CF301")


rownames(snp_dist) = snp_dist[,1]
snp_dist = snp_dist[,-1]
colnames(snp_dist) = rownames(snp_dist)


snp_dist = snp_dist[strain_order,strain_order]


snp_dist = as.matrix(snp_dist)


pdf(out_file, width = 6.5, height = 6)
heatmap.2(snp_dist,
          Rowv = F,
          Colv = F,
          dendrogram = "none",
          trace = "none",
          key = F,
          col = my_palette,
          cellnote = round(snp_dist/1000, digits = 2),
          notecol = "black",
          notecex = 0.6
          )
dev.off()