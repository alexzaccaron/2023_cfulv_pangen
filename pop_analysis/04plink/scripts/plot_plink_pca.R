#install.packages("tidyverse")

library(tidyverse)
library(ggrepel)


args = commandArgs(trailingOnly = TRUE)
fname_eigenvec = args[1]
fname_eigenval = args[2]
fname_plot     = args[3]
pca      = read_table(fname_eigenvec, col_names = FALSE)
eigenval = scan(fname_eigenval)


# sort out the pca data
# remove nuisance column
pca = pca[,-1]

# set names
names(pca)[1] = "ind"
names(pca)[2:ncol(pca)] = paste0("PC", 1:(ncol(pca)-1))


pve = data.frame(PC = 1:15, pve = eigenval/sum(eigenval)*100)


# plot pca
pdf(fname_plot, width = 5, height = 4)
ggplot(pca, aes(PC1, PC2)) + 
  geom_point(size = 2) +
  xlab(paste0("PC1 (", signif(pve$pve[1], 3), "%)")) + ylab(paste0("PC2 (", signif(pve$pve[2], 3), "%)"))+
  theme_classic() +
  geom_label_repel(aes(label = ind),
                   box.padding   = 0.35, 
                   point.padding = 0.5,
                   cex = 2,
                   segment.color = 'grey50',
                   max.overlaps=50)
dev.off()

