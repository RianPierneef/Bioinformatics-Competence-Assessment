#Sample 20082D-01-05_S0 was run on lane 001 and the other samples on lane 004
#To produce a uniform and clean script, 20082D-01-05_S0_L001_*_001.fastq.gz was renamed to 20082D-01-05_S0_L004_*_001.fastq.gz

#HPC
export JAVA_HOME="/nscratch/packages/java/jre1.8.0_271/bin/"
export PATH=$JAVA_HOME:$PATH

module load fastqc-n/0.9
mkdir RawFastQC
for file in RawReads/*.fastq.gz
do
	fastqc -f fastq -o RawFastQC -t 12 $file
done

mkdir QCReads
for file1 in RawReads/*_L004_R1_001.fastq.gz
do
        file2=${file1/_L004_R1_001.fastq.gz/_L004_R2_001.fastq.gz}
        out1=${file1##RawReads/}
        out2=${file2##RawReads/}
        ~/bbmap/bbduk.sh ktrim=r ordered minlen=51 minlenfraction=0.33 mink=11 \
        tbo tpe rcomp=f k=23 ow=t hdist=1 ftm=5 zl=4 \
        in1=$file1 in2=$file2 \
        ref=~/bbmap/resources/adapters.fa \
        out1=QCReads/${out1%%_001.fastq.gz}_step1.fastq.gz \
        out2=QCReads/${out2%%_001.fastq.gz}_step1.fastq.gz
done

for file1 in QCReads/*_L004_R1_step1.fastq.gz
do
        file2=${file1/_L004_R1_step1.fastq.gz/_L004_R2_step1.fastq.gz}
        ~/bbmap/bbduk.sh maq=20 trimq=20 qtrim=rl ordered ow=t maxns=1 minlen=51 \
        minlenfraction=0.33 k=25 hdist=1 zl=4 cf=t \
        ref=~/bbmap/resources/sequencing_artifacts.fa.gz \
        in1=$file1 in2=$file2 \
        out1=${file1%%_step1.fastq.gz}_step2.fastq.gz \
        out2=${file2%%_step1.fastq.gz}_step2.fastq.gz
done

for file1 in QCReads/*_L004_R1_step2.fastq.gz
do
        file2=${file1/_L004_R1_step2.fastq.gz/_L004_R2_step2.fastq.gz}
        ~/bbmap/bbduk.sh ordered ow=t k=20 hdist=1 zl=4 in1=$file1 in2=$file2 \
        out1=${file1%%_step2.fastq.gz}_step3.fastq.gz \
        out2=${file2%%_step2.fastq.gz}_step3.fastq.gz \
        ref=~/bbmap/resources/short.fa
done

for file1 in QCReads/*_L004_R1_step3.fastq.gz
do
        file2=${file1/_L004_R1_step3.fastq.gz/_L004_R2_step3.fastq.gz}
        ~/bbmap/tadpole.sh in1=$file1 in2=$file2 \
        out1=${file1%%_step3.fastq.gz}_qc.fastq.gz \
        out2=${file2%%_step3.fastq.gz}_qc.fastq.gz mode=correct k=50
done

mkdir QCFastQC
for file in QCReads/*_qc.fastq.gz
do
        fastqc -f fastq -o QCFastQC -t 12 $file
done

rm QCReads/*step*

module load python-n/3.5.10
mkdir spadesAssemblies
for r1 in QCReads/*_R1_qc.fastq.gz
do
        r2=${r1/_R1_qc.fastq.gz/_R2_qc.fastq.gz}
        out=${r1##QCReads/}
        python3.5 ../SPAdes-3.15.3-Linux/bin/spades.py --meta -1 $r1 -2 $r2 \
        -t 12 -o spadesAssemblies/${out%%_L004_R1_qc.fastq.gz}
done

for file in spadesAssemblies/*/contigs.fasta
do
	out=${file##spadesAssemblies/}
	rsync -avh --progress $file contigs/${out%%/contigs.fasta}.fasta
done

mkdir contigs1500
for file in contigs/*.fasta
do
	seqkit seq -m 1500 $file > contigs1500/${file##contigs/}
done

#CHPC
#!/usr/bin/bash
#PBS -l select=1:ncpus=24
#PBS -l walltime=48:00:00
#PBS -q smp
#PBS -P CBBI1124
#PBS -o stdout.txt
#PBS -e stderr.txt
#PBS -N metabat
#PBS -M repierneef@live.com
#PBS -m abe

module load chpc/BIOMODULES
module load bbmap
module load samtools/1.10
module load MetaBAT/2.15
module load checkm

cd $PBS_O_WORKDIR

for contig in contigs1500/*.fasta
do
	reads=${contig##contigs1500}
        bbmap.sh in1=QCReads/${reads%%.fasta}_L004_R1_qc.fastq.gz \
	in2=QCReads/${reads%%.fasta}_L004_R2_qc.fastq.gz \
	out=${contig%%.fasta}.sam \
	covstats=${contig%%.fasta}_covstats.txt \
	ref=${contig} \
	bamscript=bs.sh
	sh bs.sh
	rm bs.sh
done

for bam in contigs1500/*_sorted.bam
do
	jgi_summarize_bam_contig_depths \
	--outputDepth ${bam%%_sorted.bam}.depth $bam
done

mkdir metaBins2
for contig in contigs1500/*.fasta
do
	out=${contig##contigs1500/}
	metabat2 -i $contig -a ${contig%%.fasta}.depth \
	-o metaBins2/${out%%.fasta}.metabat -t 24 -m 1500
done

rm metaBins2/*.lowDepth.fa
rm metaBins2/*.tooShort.fa

checkm lineage_wf -t 24 -x fa metaBins2 checkmBins
checkm qa -t 24 -o 2 --tab_table --file CheckM.All.txt checkmBins/lineage.ms checkmBins

awk 'NR==1' CheckM.All.txt > CheckM.HighQual.txt
awk -F '\t' ' $6 > 90 && $7 < 5 ' CheckM.All.txt >> CheckM.HighQual.txt
awk 'NR==1' CheckM.All.txt > CheckM.MedQual.txt
awk -F '\t' ' $6 >= 50 && $7 < 10 ' CheckM.All.txt >> CheckM.MedQual.txt
awk 'NR==1' CheckM.All.txt > CheckM.LowQual.txt
awk -F '\t' ' $6 < 50 && $7 < 10 ' CheckM.All.txt >> CheckM.LowQual.txt

