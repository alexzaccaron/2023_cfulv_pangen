
#== files column names
fai_colnames = c("seq", "length", "offset", "linebases", "linewidth")
bed_windows_genes_colnames = c("chr", "start", "end", "count", "strain")
bed_windows_repeats_colnames = c("chr", "start", "end", "count", "bp_cov", "size", "cov", "strain")
#==


#== input
windows_genes   = NULL
windows_repeats = NULL

for(file in list.files("output/01files/", pattern = "genes.bed", full.names = T) ) {
  tmp.read = read.table(file, col.names = bed_windows_genes_colnames)
  windows_genes = rbind(windows_genes, tmp.read)
}

for(file in list.files("output/01files/", pattern = "repeats.bed", full.names = T) ) {
  tmp.read = read.table(file, col.names = bed_windows_repeats_colnames)
  windows_repeats = rbind(windows_repeats, tmp.read)
}
#==




#== Parse
windows_genes[windows_genes$count > 20, 'count'] = 20 # max count of 20. Only few windows with count > 20
windows_repeats$cov = round(windows_repeats$cov*100) # convert to percentage
#==



draw_tracks <- function(genes, repeats, x_pos){
  
  # color scales
  genes_col_arr = colorRampPalette(c("white", "red"))(20)
  repet_col_arr = colorRampPalette(c("white", "grey20"))(100)
  track_wid = 0.6
  
  
  left_end  = x_pos - track_wid
  right_end = x_pos + track_wid
  
  for(i in 1:nrow(genes)){
    win_start = genes[i, 'start']
    win_end   = genes[i, 'end']
    
    rect(left_end, win_start, x_pos, win_end, border = NA, col = genes_col_arr[genes[i, 'count']] )
    rect(x_pos, win_start, right_end, win_end, border = NA, col = repet_col_arr[repeats[i, 'cov']] )
  }
  
  rect(left_end, 1, right_end, max(genes$end), lwd=0.4)
  
}
draw_scale <- function(){
  genes_col_arr = colorRampPalette(c("white", "red"))(20)
  repet_col_arr = colorRampPalette(c("white", "grey20"))(100)
  
  plot(1, type="n", xlim=c(0,101), ylim=c(0,15), axes = F, xlab="", ylab="")
  for(i in 1:20){
    rect(i, 0, i+1, 1, lwd=NA, col=genes_col_arr[i])
  }
  
  for(i in 1:100){
    rect(i, 3, i+1, 4, lwd=NA, col=repet_col_arr[i])
  }
  
}



pdf("chromosomes.pdf", width = 10, height = 5)
plot(1, type="n", xlim=c(0,150), ylim=c(0, 12000000), axes = F, xlab="", ylab="")
axis(2)

offset = 1.5
x_pos =  1
chromosomes = c("chr1", "chr2", "chr3", "chr4", "chr5", "chr6", "chr7", "chr8", "chr9", "chr10", "chr11", "chr12", "chr13", "chr14", "chr15")


for(chromo in  chromosomes ){
  
  x_pos = x_pos + offset
  
  for( str in c("R5", "R0", "W7", "W4", "R4")){ # splicily specifying strains, stead of names(table(windows_genes$strain))
    gene_track_plot   = subset(windows_genes,   chr == chromo & strain == str)
    repeat_track_plot   = subset(windows_repeats, chr == chromo & strain == str)
    
    if(nrow(gene_track_plot) > 0){
      draw_tracks(gene_track_plot, repeat_track_plot, x_pos)
      
      x_pos = x_pos+1.6
    }
    
  }
  
}

draw_scale()

dev.off()















