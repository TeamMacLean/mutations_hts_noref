## funcation to adjust zeros with selected quantity to calculate ratio
## for contigs/scaffolds with zero variants ratio value is set to zero
re_zero_ratio = function(df, number){
  df$ratio <- df$numhm/df$numht
  for (i in 1:nrow(df)) {
    if (df$numhm[i] == 0 && df$numht[i] == 0) {
      df$ratio[i] = 0
    }
    else {
      df$ratio[i] = (number + df$numhm[i])/(number + df$numht[i])
    }
  }
  df
}
