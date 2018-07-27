qqline2 <- function(x, y, probs = c(0.25, 0.75), qtype = 7, ...){
      stopifnot(length(probs) == 2)
      x2 <- quantile(x, probs, names=FALSE, type=qtype, na.rm = TRUE)
      y2 <- quantile(y, probs, names=FALSE, type=qtype, na.rm = TRUE)
      slope <- diff(y2)/diff(x2)
      int <- y2[1L] - slope*x2[1L]
      abline(int, slope, ...)
    }

leg_r2 <- function(k){
  legend(x = "topleft", bty = "n",
         legend = substitute(italic(y) == a + b %.% italic(x)*","~~italic(r)^2~"="~r2,
                             list(a = format(coef(k)[1], digits = 2),
                                  b = format(coef(k)[2], digits = 2),
                                  r2 = format(summary(k)$r.squared, digits = 3))))
}
