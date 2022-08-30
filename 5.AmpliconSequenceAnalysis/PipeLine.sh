#Local environment
cat metagenomics.fastq | awk '{if(NR%4==1) {printf(">%s\n",substr($0,2));} else if(NR%4==2) print;}' > metagenomics.fasta

#HPC environment
#!/usr/bin/bash
#PBS -l select=1:ncpus=24
#PBS -l walltime=48:00:00
#PBS -q smp
#PBS -P CBBI1124
#PBS -o stdout.txt
#PBS -e stderr.txt
#PBS -N blast
#PBS -M repierneef@live.com
#PBS -m abe

module load chpc/BIOMODULES
module load ncbi-blast-2.12.0+

cd $PBS_O_WORKDIR
#BLAST nt db
blastn -query metagenomics.fasta -db nt \
	-outfmt "6 qseqid sseqid pident length mismatch gapopen \
	qstart qend sstart send evalue bitscore sskingdoms stitle" \
	-out metagenomics.nt.txt -num_threads 24 -evalue 1e-5

#BLAST mito db
#https://ftp.ncbi.nlm.nih.gov/blast/db/mito.tar.gz
blastn -query metagenomics.fasta -db mito/mito \
	-outfmt "6 qseqid sseqid pident length mismatch gapopen \
	qstart qend sstart send evalue bitscore sskingdoms stitle" \
	-out metagenomics.mito.txt -num_threads 24 -evalue 1e-5

#Local environment
awk '!a[$1]++' metagenomics.nt.txt > metagenomics.nt.TopHits.txt
awk '!a[$1]++' metagenomics.mito.txt > metagenomics.mito.TopHits.txt

blast.R

#dada2 protocol
dada2.R
python asv2fasta.py > st2.fasta

awk '!a[$1]++' st2.mito.txt > st2.mito.TopHits.txt
awk '!a[$1]++' st2.nt.txt > st2.nt.TopHits.txt

dada2.R



