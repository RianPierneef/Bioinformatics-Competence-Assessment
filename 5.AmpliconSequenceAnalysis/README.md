Task

Please find Illumina output for PCR amplified fragments of algae mitochondrial DNA in the file metagenomics.fastq. Perform binning of the reads (identify taxonomic units in the sample) and estimate statistical parameters of the sample: the expected species richness of the sample and an alpha-diversity index of the algaeal species (Shannon index or any other indices).

Result

The metagenomics.fastq file was converted to a fasta file. This was then compared against the NCBI nt and mito (mitochondrial) databases. Commands in the PipeLine.sh script. Results for both databases were filtered for the top hits and further processed using the blast.R script. Resulting hit subject kingdoms were filtered for "Eukaryota" and the vegan package used to estimate statistical parameters and indices.

NCBI mito database:

Expected species richness = 87 (rarecurve.mito.otu.png and outputs from blast.R script)

Shannon: 2.818445
Simpson: 0.8962468
Inverse simpson: 9.638258

NCBI nt database:

Expected species richness = 93 (rarecurve.nt.otu.png and outputs from blast.R script)

Shannon: 2.352334
Simpson: 0.8149179
Inverse simpson: 5.403007

Files descriptions:

PipeLine.sh: Convert fastq to fasta, blast and filter for top hits
blast.R: Rscript to for blast results
dada2.R: Please see comment below
err2.png: dada2 protocol figure
*metagenomicsFastQC.png: dada2 protocol fastqc reports
metagenomics.fasta: fasta file for blast (from metagenomics.fastq)
Metagenomics.*.TopHits.txt: metagenomics.fasta top hits used as input for blast.R
rarecurve.*.otu.png: rarefaction curves for both the mito and nt database results
st.rds: dada2 protocol object. Sequence table
st2.txt: dada2 ASV sequence table
st2.fasta: dada2 ASV fasta file
asv2fasta.py: Convert asv text file to fasta

Comment
The metagenomics.fastq dataset seemed to have originated from a PacBio sequencing platform and as such the dada2 approach was also incorporated as a test. The metagenomics.fastq file was used throughout. Interestingly the entire metagenomics.fastq file was binned into 18 Amplicon Sequence Variants (ASV) totalling 2,220 sequences. The ASV sequence table was converted into a fasta file and also compared against the nt and mito NCBI databases using same command as in the PipeLine.sh script with st2.fasta as the query. Conversion was done using the asv2fasta.py script (python asv2fasta.py > st2.fasta).

These results were filtered for the top hits and Bacteria excluded (nt database). This resulted in the retention of only 5 of the ASVs (st2.nt.TopHits.noBac.txt).
  
