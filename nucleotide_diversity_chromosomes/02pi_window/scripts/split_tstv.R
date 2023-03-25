
#=== Functions ====
# function to classiy a muation into transition or transversion
classiy_ts_tv <- function(ref, alt){

  if(ref == "A"){
    if(alt == "A") return(NA)
    if(alt == "C") return('tv')
    if(alt == "G") return('ts')
    if(alt == "T") return('tv')
  }
  if(ref == "C"){
    if(alt == "A") return('tv')
    if(alt == "C") return(NA)
    if(alt == "G") return('tv')
    if(alt == "T") return('ts')
  }
  if(ref == "G"){
    if(alt == "A") return('ts')
    if(alt == "C") return('tv')
    if(alt == "G") return(NA)
    if(alt == "T") return('tv')
  }
  if(ref == "T"){
    if(alt == "A") return('tv')
    if(alt == "C") return('ts')
    if(alt == "G") return('tv')
    if(alt == "T") return(NA)
  }
}
#==================



args = commandArgs(trailingOnly = T)


in_fname  = args[1] # input genotype matrix
out_ts_fname = args[2] # output genotype matrix with transition
out_tv_fname = args[3] # output genotype matrix with transversion


# Read genotype matrix
gt_tab = read.table(in_fname, header = T)


gt_tab$type = NA


gt_tab[gt_tab$REF == "A" & gt_tab$ALT == "C", 'type'] = "tv"
gt_tab[gt_tab$REF == "A" & gt_tab$ALT == "G", 'type'] = "ts"
gt_tab[gt_tab$REF == "A" & gt_tab$ALT == "T", 'type'] = "tv"

gt_tab[gt_tab$REF == "C" & gt_tab$ALT == "A", 'type'] = "tv"
gt_tab[gt_tab$REF == "C" & gt_tab$ALT == "G", 'type'] = "tv"
gt_tab[gt_tab$REF == "C" & gt_tab$ALT == "T", 'type'] = "ts"

gt_tab[gt_tab$REF == "G" & gt_tab$ALT == "A", 'type'] = "ts"
gt_tab[gt_tab$REF == "G" & gt_tab$ALT == "C", 'type'] = "tv"
gt_tab[gt_tab$REF == "G" & gt_tab$ALT == "T", 'type'] = "tv"

gt_tab[gt_tab$REF == "T" & gt_tab$ALT == "A", 'type'] = "tv"
gt_tab[gt_tab$REF == "T" & gt_tab$ALT == "C", 'type'] = "ts"
gt_tab[gt_tab$REF == "T" & gt_tab$ALT == "G", 'type'] = "tv"


# split transitions and transversions into two tables
gt_tab_ts = gt_tab[gt_tab$type == "ts",]
gt_tab_tv = gt_tab[gt_tab$type == "tv",]


# remove column "type", no needed anymore
gt_tab_ts = gt_tab_ts[ , -which(names(gt_tab) %in% c("type"))]
gt_tab_tv = gt_tab_tv[ , -which(names(gt_tab) %in% c("type"))]


write.table(gt_tab_ts, out_ts_fname, quote = F, row.names = F, sep = '\t')
write.table(gt_tab_tv, out_tv_fname, quote = F, row.names = F, sep = '\t')





