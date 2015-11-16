# load libraries and data
library(ggplot2)
library(quantchem)
source('~/git-hub-repos/shyamrallapalli/mutations_hts_noref/lib/zero_ratio_adj.R')


frags <- read.delim(file="fragments_with_mut_ids.txt", header = TRUE)
colnames(frags) <- c("iterations", "fragment")

dir = getwd()
dir = paste(dir, "vars_infrags", sep='/')
dir.create("barplots_frag2bins")
## read all files in a folder and store to a dataframe
filelist = list.files(dir, "^genome_")
#for (i in 1:length(filelist)) {
for (i in 1:10) {
  filename = paste(dir, filelist[i], sep='/')
  newdf <- read.delim(file=filename, header = TRUE)
  newdf$vars = newdf$numhm + newdf$numht
  selected = subset(newdf, vars > 0)

  # fragments pooled to a near 500kb chunks and plotted
  rollingdf1 = data.frame(length=numeric(),
    numhm=numeric(),
    numht=numeric(),
    stringsAsFactors=FALSE)

  dflength = nrow(selected)
  lenbin = 500000
  len = 0
  hm = 0
  ht = 0
  x = 1
  for (j in 1:dflength){
    len = len + selected$length[j]
    hm = hm + selected$numhm[j]
    ht = ht + selected$numht[j]
    if (len >= lenbin) {
      rollingdf1[x, ] = c(len, hm, ht)
      len = 0
      hm = 0
      ht = 0
      x = x + 1
    }
    else if (j == dflength){
      rollingdf1[x, ] = c(len, hm, ht)
    }
  }
  rollingdf1 <- re_zero_ratio(rollingdf1, 0.5)

  # print models to pdf
  filename1 = paste("barplots_frag2bins/chunks_", filelist[i], ".pdf", sep='')
  pdf(filename1,width=6,height=4)
  barplot(rollingdf1$ratio)
  dev.off()

# fragments pooled to a near 500kb sliding chunks and plotted
    rollingdf2 = data.frame(length=numeric(),
    numhm=numeric(),
    numht=numeric(),
    stringsAsFactors=FALSE)

  len = 0
  hm = 0
  ht = 0
  x = 1
  j = 1
  while (j <= dflength){
    len = len + selected$length[j]
    hm = hm + selected$numhm[j]
    ht = ht + selected$numht[j]
    i = j + 1
    if (len >= lenbin) {
      rollingdf2[x, ] = c(len, hm, ht)
      len = 0
      hm = 0
      ht = 0
      x = x + 1
      j = x
    }
    else if (j == dflength){
      rollingdf2[x, ] = c(len, hm, ht)
    }
  }
  rollingdf2 <- re_zero_ratio(rollingdf2, 0.5)

  # print models to pdf
  filename2 = paste("barplots_frag2bins/slidingwindow_", filelist[i], ".pdf", sep='')
  pdf(filename2,width=6,height=4)
  barplot(rollingdf2$ratio)
  dev.off()

}
