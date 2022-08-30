#HPC environment
export JAVA_HOME="/nscratch/packages/java/jre1.8.0_271/bin/"
export PATH=$JAVA_HOME:$PATH

module load fastqc-n/0.9
mkdir RawFastQC
for file in RawReads/*.fastq
do
	fastqc -f fastq -o RawFastQC $file
done

mkdir QCReads
for file1 in RawReads/*_MG1655_50x_R1.fastq
do
        file2=${file1/_MG1655_50x_R1.fastq/_MG1655_50x_R2.fastq}
        out1=${file1##RawReads/}
        out2=${file2##RawReads/}
        ~/bbmap/bbduk.sh ktrim=r ordered minlen=51 minlenfraction=0.33 mink=11 \
        tbo tpe rcomp=f k=23 ow=t hdist=1 ftm=5 zl=4 \
        in1=$file1 in2=$file2 \
        ref=~/bbmap/resources/adapters.fa \
        out1=QCReads/${out1%%.fastq}_step1.fastq \
        out2=QCReads/${out2%%.fastq}_step1.fastq
done

for file1 in QCReads/*_R1_step1.fastq
do
        file2=${file1/_R1_step1.fastq/_R2_step1.fastq}
        ~/bbmap/bbduk.sh maq=20 trimq=20 qtrim=rl ordered ow=t maxns=1 minlen=51 \
        minlenfraction=0.33 k=25 hdist=1 zl=4 cf=t \
        ref=~/bbmap/resources/sequencing_artifacts.fa.gz \
        in1=$file1 in2=$file2 \
        out1=${file1%%_step1.fastq}_step2.fastq \
        out2=${file2%%_step1.fastq}_step2.fastq
done

for file1 in QCReads/*_R1_step2.fastq
do
        file2=${file1/_R1_step2.fastq/_R2_step2.fastq}
        ~/bbmap/bbduk.sh ordered ow=t k=20 hdist=1 zl=4 in1=$file1 in2=$file2 \
        out1=${file1%%_step2.fastq}_step3.fastq \
        out2=${file2%%_step2.fastq}_step3.fastq \
        ref=~/bbmap/resources/short.fa
done

for file1 in QCReads/*_R1_step3.fastq
do
        file2=${file1/_R1_step3.fastq/_R2_step3.fastq}
        ~/bbmap/tadpole.sh in1=$file1 in2=$file2 \
        out1=${file1%%_step3.fastq}_qc.fastq \
        out2=${file2%%_step3.fastq}_qc.fastq mode=correct k=50
done

mkdir QCFastQC
for file in QCReads/*_qc.fastq
do
        fastqc -f fastq -o QCFastQC $file
done

rm QCReads/*step*

module load python-n/3.5.10
mkdir spadesAssemblies
for r1 in QCReads/*_R1_qc.fastq
do
        r2=${r1/_R1_qc.fastq/_R2_qc.fastq}
        out=${r1##QCReads/}
        python3.5 ../SPAdes-3.15.3-Linux/bin/spades.py --isolate -1 $r1 -2 $r2 \
        -t 12 -o spadesAssemblies/${out%%_R1_qc.fastq}
done

#Local environment
multiqc RawFastQC -o RawMultiQC
multiqc QCFastQC -o QCMultiQC
source ~/anaconda3/bin/activate
conda activate quast
for file in spadesAssemblies/*/contigs.fasta
do
	out=${file##spadesAssemblies/}
	quast -o ${out%%/contigs.fasta}Quast $file
done
conda deactivate
conda deactivate

#KBase: https://www.kbase.us/
Import from Staging Area
Assess Genome Quality with CheckM - v1.0.18
Classify Microbes with GTDB-Tk - v1.7.0
