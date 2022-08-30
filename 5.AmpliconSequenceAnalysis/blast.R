#Mito db
mito <- read.delim("~/RePSkills/5.AmpliconSequenceAnalysis/metagenomics.mito.TopHits.txt", header=FALSE)
mito.otu <- t(data.matrix(xtabs(~V2, data=mito)))
#Dilution curves
library("vegan")
packageVersion("vegan")
S <- specnumber(mito.otu)
raremax <- min(rowSums(mito.otu))
Srare <- rarefy(mito.otu, raremax)
Srare[1]
Srrare <- rrarefy(mito.otu, raremax)
length(Srrare)
Sdrare <- drarefy(mito.otu, raremax)
length(Sdrare)
png("rarecurve.mito.otu.png")
rarecurve(mito.otu)
dev.off()
diversity(mito.otu)
diversity(mito.otu, "simpson")
diversity(mito.otu, "inv")

#Nt db
nt <- read.delim("~/RePSkills/5.AmpliconSequenceAnalysis/metagenomics.nt.TopHits.txt", header=FALSE)
nt <- subset(nt, nt$V13!="Bacteria" & nt$V13!="N/A")
nt.otu <- t(data.matrix(xtabs(~V2, data=nt)))
#Dilution curves
library("vegan")
packageVersion("vegan")
S <- specnumber(nt.otu)
raremax <- min(rowSums(nt.otu))
Srare <- rarefy(nt.otu, raremax)
Srare[1]
Srrare <- rrarefy(nt.otu, raremax)
length(Srrare)
Sdrare <- drarefy(nt.otu, raremax)
length(Sdrare)
png("rarecurve.nt.otu.png")
rarecurve(nt.otu)
dev.off()
diversity(nt.otu)
diversity(nt.otu, "simpson")
diversity(nt.otu, "inv")

