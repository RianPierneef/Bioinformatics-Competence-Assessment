library(ggplot2)
graphnums <- read.delim("graphnums.tab")
png("graphnums.png")
ggplot(graphnums, aes(x=Theoretical, y=Experimental, color=Category)) + 
  geom_point() +
  geom_abline(intercept = 0, slope = 1)
dev.off()