## funcation to replace zeros with selected quantity and calculate ratio 
## for contigs/scaffolds with zero variants, replacing denominator (heterozygote) value
## with one to give zero value for such contigs
re_zero_ratio = function(df, number){
  for (i in 1:nrow(df)) {
    if (df$numhm[i] == 0 && df$numht[i] == 0) {
      df$numht[i] = 1
      #df$numhm[i] = number
    }
    else {
      df$numhm[i] = number + df$numhm[i]
      df$numht[i] = number + df$numht[i]
    }
  }
  df$ratio <- df$numhm/df$numht
  df
}
