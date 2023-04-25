args = commandArgs(trailingOnly = T)


#=== functions ==
classify_TE_or_simple <- function(gff){
  gff$repeat_type = "simple"
  gff[grep("Motif:rnd", gff$attr),'repeat_type'] = "TE"
  
  return(gff)
}

plot_genes <- function(gff, y){
  for(i in 1:nrow(gff)){
    if(gff[i, 'strand'] == '+'){
      x0=gff[i, 'start']
      y0=y
      x1=gff[i, 'end']-100
      y1=y
      x2=gff[i, 'end']
      y2=y+0.5
      x3=gff[i, 'end']-100
      y3=y+1
      x4=gff[i, 'start']
      y4=y+1
      polygon(c(x0, x1, x2, x3, x4), c(y0, y1, y2, y3, y4), col="cyan4", border = NA)
    }else{
      x0=gff[i, 'start']
      y0=y+0.5
      x1=gff[i, 'start']+100
      y1=y
      x2=gff[i, 'end']
      y2=y
      x3=gff[i, 'end']
      y3=y+1
      x4=gff[i, 'start']+100
      y4=y+1
      polygon(c(x0, x1, x2, x3, x4), c(y0, y1, y2, y3, y4), col="cyan4", border = NA)
    }
  }
}

plot_repeats <- function(gff, y){
  for(i in 1:nrow(gff)){
    x0 = gff[i, 'start']
    y0=y
    x1 = gff[i, 'end']
    y1=y+1
    
    gff = classify_TE_or_simple(gff)
    
    rect(x0, y0, x1, y1, border = NA, 
         col = ifelse(gff[i, 'repeat_type'] == "simple", "grey70", "grey40"))
  }
}

plot_color_scale <- function(){
  
  my.colors = colorRampPalette(c("chocolate1", "gold"))(10)
  
  plot(1, type="n", xlim=c(0, length(my.colors)+1), ylim=c(0,12), axes=F, xlab="", ylab="")
  for(i in 1:length(my.colors)){
    rect(i,1,i+1,2, col=rev(my.colors)[i], border = NA)
  }
  
}

get_nucmer_color <- function(pident){
  
  my.colors = colorRampPalette(c("chocolate1", "gold"))(10)
  col = my.colors[(pident-100)*-100]
  
  
  return(col)
  
  
  
}

plot_nucmer_hits <- function(coords){
  
  for(i in 1:nrow(coords)){
    
    x0=coords[i, 'refstart']
    y0=coords[i, 'ref_y']
    x1=coords[i, 'qrystart']
    y1=coords[i, 'qry_y']
    x2=coords[i, 'qryend']
    y2=coords[i, 'qry_y']
    x3=coords[i, 'refend']
    y3=coords[i, 'ref_y']
    x4=coords[i, 'refstart']
    y4=coords[i, 'ref_y']
    
    polygon(c(x0, x1, x2, x3, x4), c(y0, y1, y2, y3, y4), 
            col = "red", border = NA)
    #col=get_nucmer_color(coords[i, 'pident']), border = NA)
  }
  
}

#================








# columns of gff and fai file formats
gff_colnames = c("chr", "source", "feature", "start", "end", "score", "strand", "phase", "attr")
bed_colnames = c("chr", "start", "end", "name", "score", "strand")
#fai_colnames = c("seq", "length", "offset", "linebases", "linewidth")
nucmer_coords_colnames = c("refstart", "refend", "qrystart", "qryend", "ref_aln_len", "qry_aln_len", "pident", "ref", "qry")



# input arguments
#fname_tab.fai     = "data/disp_chr.fasta.fai"  # args[1]
fname_genes_R0.bed   = "data/R0_chr7_100k_genes.bed" # args[2]
fname_genes_W7.bed   = "data/W7_chr7_100k_genes.bed" # args[2]

fname_repeats_R0.gff   = "data/R0_chr7_100k_repeats.gff" # args[2]
fname_repeats_W7.gff   = "data/W7_chr7_100k_repeats.gff" # args[2]
fname_nucmer = "output/01nucmer/R0W7_100k.delta1.coords"





genes_R0.bed = read.table(fname_genes_R0.bed, col.names = bed_colnames, sep = '\t')
genes_W7.bed = read.table(fname_genes_W7.bed, col.names = bed_colnames, sep = '\t')

repeats_R0.gff = read.table(fname_repeats_R0.gff, col.names = gff_colnames, sep = '\t')
repeats_W7.gff = read.table(fname_repeats_W7.gff, col.names = gff_colnames, sep = '\t')

nucmer = read.table(fname_nucmer, col.names = nucmer_coords_colnames)





pdf("plots/R0W7_100k.pdf", width = 7, height = 4.5)

plot(1, type = 'n', axes = F, xlab = "", ylab = "", xlim=c(1,100000), ylim=c(0, 18))
axis(1)


chr_y = 10
plot_genes(genes_R0.bed, chr_y)
plot_repeats(repeats_R0.gff, chr_y-1)
rect(1, 9, 95103, 11)

chr_y = 5
plot_genes(genes_W7.bed, chr_y)
plot_repeats(repeats_W7.gff, chr_y-1)
rect(1, 4, 100365, 6)



nucmer$ref_y = 9
nucmer$qry_y = 6

plot_nucmer_hits(nucmer)


dev.off()




