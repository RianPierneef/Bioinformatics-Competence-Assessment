library(dada2)
packageVersion("dada2")
library(ShortRead)
packageVersion("ShortRead")
library(Biostrings)
packageVersion("Biostrings")
library(phyloseq)
packageVersion("phyloseq")

path <- getwd()
fnFs <- sort(list.files(".", pattern=".fastq", full.names = TRUE))
sample.names <- sapply(strsplit(basename(fnFs), ".fastq"), `[`, 1)
png(file="metagenomicsFastQC.png")
plotQualityProfile(fnFs)
dev.off()
fnFs.filtN <- file.path(path, "filtN", basename(fnFs))
filterAndTrim(fnFs, fnFs.filtN, maxN = 0, multithread = TRUE)
png(file="FiltNmetagenomicsFastQC.png")
plotQualityProfile(fnFs)
dev.off()
fnFs.filtQ <- file.path(path, "filtQ", basename(fnFs))
filterAndTrim(fnFs.filtN, fnFs.filtQ,
              maxN=0, maxEE=2, truncQ=2, rm.phix=FALSE,
              compress=TRUE, multithread=TRUE)
png(file="FiltQmetagenomicsFastQC.png")
plotQualityProfile(fnFs.filtQ)
dev.off()
dereps <- dada2:::derepFastq(fnFs.filtQ, verbose = TRUE)
err2 <- learnErrors(dereps, errorEstimationFunction=PacBioErrfun, BAND_SIZE=32, multithread=TRUE)
png(file="err2.png")
plotErrors(err2)
dev.off()
dd2 <- dada(dereps, err=err2, BAND_SIZE=32, multithread=TRUE)
st2 <- makeSequenceTable(dd2)
bim2 <- isBimeraDenovo(st2, minFoldParentOverAbundance=3.5, multithread=TRUE)
table(bim2)
saveRDS(st2, "st2.rds")
st2 <- readRDS("st2.rds")
ncol(st2)
sum(st2)
write.table(t(st2), "st2.txt", quote = FALSE)

#Run blast and filter for top hits
st2.nt.TopHits <- read.delim("~/RePSkills/5.AmpliconSequenceAnalysis/st2.nt.TopHits.txt", header=FALSE)
st2.nt.TopHits <- subset(st2.nt.TopHits, st2.nt.TopHits$V13!="Bacteria" & st2.nt.TopHits$V13!="N/A")
write.table(st2.nt.TopHits, "st2.nt.TopHits.noBac.txt", quote = FALSE)

