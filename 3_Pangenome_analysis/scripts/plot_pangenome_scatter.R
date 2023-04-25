


library(ggplot2)
library(tidyr)


args = commandArgs(trailingOnly = TRUE)


count_core_pan_HOG <- function(combination, tab){
  
  tab.sub = tab[,combination]
  
  if(length(combination) > 1){
    arr = rowSums(is.na(tab.sub)) # count NAs in each row
    
    pan = sum(arr < ncol(tab.sub)) #if at least one not NA in HOG, then count as pangenome
    
    core = sum(arr == 0) #if no NAs, then HOG is core
    
    combination = paste0(combination, collapse = ',')
  }else{ # single genome
    count = sum(is.na(tab.sub))
    pan = nrow(tab) - count 
    core = pan
  }
  
  return(c(combination, pan, core))
  
}

get_median_values_pan_core <- function(res_table){
  
  res = NULL
  
  for(comb in as.numeric( names( table(res_table$comb_size) ) ) ){
    median_pan  = median(res_table[res_table$comb_size == comb,'pan'])
    median_core = median(res_table[res_table$comb_size == comb,'core'])
    
    res = rbind(res, cbind(comb, median_pan, median_core))
  }
  
  colnames(res) = c("comb_size", "Pan", "Core")
  res = as.data.frame(res)
  
  return(res)
}


# read table (N0.tsv)
tab = read.table(args[1], header = T, na.strings = "", sep = '\t')


# get the list of genomes in the table 
genomes = colnames(tab)
genomes = genomes[4:length(genomes)]

# start and empty table
res_table = NULL

# for each combination size of the genomes
for(i in 1:length(genomes)){
  # get combination
  combinations = combn(genomes, i)
  
  # for each combination
  for(j in 1:ncol(combinations)){
    #get combination of genomes
    combination = combinations[,j]
    # count core and pangenome (HOGs)
    res = count_core_pan_HOG(combination, tab)
    # bind to the results table
    res_table = rbind(res_table, c(i, res))
  }
  
}

# adjustments of the results table
colnames(res_table) = c("comb_size", "comb", "pan", "core")
res_table = as.data.frame(res_table)

res_table$comb_size = as.numeric(res_table$comb_size)
res_table$pan = as.numeric(res_table$pan)
res_table$core = as.numeric(res_table$core)

# convert to long format
res_table_long = gather(res_table, status, size, pan:core, factor_key=TRUE)


# get power law fit curve
# based on https://stackoverflow.com/questions/18305852/power-regression-in-r-similar-to-excel
medians = get_median_values_pan_core(res_table)
m_core <- lm(log(Core) ~ log(comb_size), data=medians)
m_pan <- lm(log(Pan) ~ log(comb_size), data=medians)
newdf <- data.frame(comb_size=seq(min(medians$comb_size), max(medians$comb_size), len=100))


# plot
pdf(args[2], width = 4, height = 5)
plot(1, type="n", ylim=c(14600,15200), xlim=c(1,5))

points(res_table_long[res_table_long$status == "pan", 'comb_size'],res_table_long[res_table_long$status == "pan", 'size'],
       pch = 16, col="firebrick")

points(res_table_long[res_table_long$status == "core", 'comb_size'],res_table_long[res_table_long$status == "core", 'size'],
       pch = 16, col="darkorange")

lines(newdf$comb_size, exp(predict(m_pan, newdf)), col="firebrick", lwd=1.5)
lines(newdf$comb_size, exp(predict(m_core, newdf)), col="darkorange", lwd=1.5)

text(4, 15150, substitute(b0*x^b1, list(b0=exp(coef(m_pan)[1]), b1=coef(m_pan)[2])), cex = 0.7)
text(4, 15100, substitute(plain("R-square: ") * r2, list(r2=summary(m_pan)$r.squared)), cex=0.7)

text(4, 14700, substitute(b0*x^b1, list(b0=exp(coef(m_core)[1]), b1=coef(m_core)[2])), cex = 0.7)
text(4, 14650, substitute(plain("R-square: ") * r2, list(r2=summary(m_core)$r.squared)), cex=0.7)

dev.off()



