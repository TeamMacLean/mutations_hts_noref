library(tcltk2)

# a function to get hypothetical density using ordered ratios
get_density = function(x, y){
  ylim = round(y*10)
  hypothetical = rep(1, sum(ylim))
  index = 1
  for (i in 1:length(x)) {
    if (ylim[i] > 0) {
      number = index + ylim[i] - 1
      hypothetical[index:number] = rep(x[i], ylim[i])
      index = index + ylim[i]
    }
  }
  hypothetical
}

# create empty data frame to store params information
coeffs = data.frame(iteration=character(),
                      intercept=numeric(),
                      first=numeric(),
                      second=numeric(),
                      third=numeric(),
                      fourth=numeric(),
                      stringsAsFactors=FALSE)

## read all files in iterations folder
## and read each file and store params to "coeffs" dataframe
dir = "../vars_infrags"
filelist = list.files(dir, "^genome_")
numfiles = length(filelist)
pb = tkProgressBar(title="Progress bar of iteration data processing", min=0, max=numfiles, width=500)

for (i in 1:numfiles) {
  filename = paste(dir, filelist[i], sep='/')
  newdf <- read.delim(file=filename, header = TRUE, stringsAsFactors=FALSE)
  iteration = gsub("_varinfo.txt$", "", filelist[i])
  # set positions from lengths of fragments
  newdf$position = cumsum(newdf$length)

  # select fragments with variants
  withvars = subset(newdf, numhm + numht > 0)
  withvars$ratio = (withvars$numhm + 0.5)/(withvars$numht + 0.5)
  hypden = get_density(withvars$position, withvars$ratio)

  # get density using a bandwidth of 0.5 Mb and find the peak ratio location
  kde = density(hypden, bw=500000)
  index = match(max(kde$y), kde$y)
  peak = kde$x[index]

  # select fragments 5 Mb either side of the peak
  DT = subset(withvars, position >= peak - 5000000 & position <= peak + 5000000)
  lmfit4 <- lm(DT$ratio ~ poly(DT$position, 4, raw=TRUE))
  pars = as.data.frame(lmfit4$coefficients)[,1]

  coeffs[i,] = c(iteration, pars)
  setTkProgressBar(pb, i)
}
close(pb)

# save all iterations params from poly fit to a file
write.table(selected, file="params_polyfit_all_iterations.txt", sep="\t", row.names = FALSE)
