# load libraries and data
library(ggplot2)
library(quantchem)
source('~/git-hub-repos/shyamrallapalli/mutations_hts_noref/lib/zero_ratio_adj.R')


frags <- read.delim(file="fragments_with_mut_ids.txt", header = TRUE)
colnames(frags) <- c("iterations", "fragment")

dir = getwd()
dir = paste(dir, "vars_infrags", sep='/')
dir.create("barplots_selected")
## read all files in a folder and store to a dataframe
filelist = list.files(dir, "^genome_")
#for (i in 1:length(filelist)) {
for (i in 1:10) {
  filename = paste(dir, filelist[i], sep='/')
  newdf <- read.delim(file=filename, header = TRUE)
  newdf$vars = newdf$numhm + newdf$numht
  selected = subset(newdf, vars > 0)
  selected$position <- cumsum(selected$length)
  selected <- re_zero_ratio(selected, 0.5)
  selected$adjratio <- selected$ratio/selected$length

  iteration = gsub("_varinfo.txt$", "", filelist[i])
  fragid = as.character(frags[which(frags$iterations == iteration),]$fragment)
  selected = within(selected, {
    color=ifelse(fragment==fragid, "red", "black")
    width=ifelse(fragment==fragid, 30, 0.5)})

  selected2 <- selected
  selected2[selected2$ratio < 3,]$ratio <- 0
  selected3 <- selected
  selected3[selected3$ratio < 5,]$ratio <- 0

  # print non-normalized ratios, ratios >= 3 and ratio >= 5
  # and length-normalized ratio barplots
  filename1 = paste("barplots_selected/ratio_", filelist[i], "_barplot.pdf", sep='')
  pdf(filename1,width=6,height=8)
  par(mfrow=c(4,1), mar=c(1,2,1,0.5))
  barplot(selected$ratio, width=selected$width, col=selected$color, border=selected$color, main="ratios")
  barplot(selected2$ratio, width=selected$width, col=selected$color, border=selected$color, main="ratios >= 3")
  barplot(selected3$ratio, width=selected$width, col=selected$color, border=selected$color, main="ratios >= 5")
  barplot(selected$adjratio, width=selected$width, col=selected$color, border=selected$color, main="adj ratios")
  dev.off()

  # qunatchem fit to combined data and save curves to pdf
#  fit = lmcal(selected$position, selected$ratio)

#  filename2 = paste(filelist[i], "_quantchem_fitplot.pdf", sep='')
#  pdf(filename2,width=7,height=7)
#  par(mfrow=c(4,5))
#  plot(fit, type = "curve", xlab = "position", ylab = "ratio")
#  dev.off()

}
