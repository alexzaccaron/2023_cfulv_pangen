


#== In/out file names
fname_snpeff_snps   = "output/01snpeff/snps_summary.genes.txt" 
fname_snpeff_indels = "output/01snpeff/indels_summary.genes.txt"
fname_lof_snps_genes   = "output/02lof_genes/lof_snps_genes.txt" 
fname_lof_indels_genes = "output/02lof_genes/lof_indels_genes.txt"
#==



#== Read
snpeff_snps   = read.table(fname_snpeff_snps, header = T, sep='\t', skip = 1, comment.char="$")
snpeff_indels = read.table(fname_snpeff_indels, header = T, sep='\t', skip = 1, comment.char="$")
#==



#== 
# get genes that have loss-of-function snps
lof_snps_genes = subset(snpeff_snps,
                      variants_effect_start_lost > 0  |
                      variants_effect_stop_gained > 0 |
                      variants_effect_stop_lost > 0
                       )



# get genes that have loss-of-function indels
lof_indels_genes = subset(snpeff_indels,
                      variants_effect_frameshift_variant > 0
                       )
#==



#== Write
write.table(lof_snps_genes[,c( 'GeneId', 'variants_effect_start_lost', 'variants_effect_stop_gained', 'variants_effect_stop_lost')], 
            fname_lof_snps_genes, sep = '\t', quote=F, row.names=F, col.names=T)
write.table(lof_indels_genes[,c( 'GeneId', 'variants_effect_frameshift_variant')],
            fname_lof_indels_genes, sep = '\t', quote=F, row.names=F, col.names=T)
#==





