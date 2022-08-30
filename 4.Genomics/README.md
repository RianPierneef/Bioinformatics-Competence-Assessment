Task

Perform an assembly of the bacterial raw Illumina reads provided in the MiSeq E. coli fastq files using software of your choice. Perform an assessment of the reads and the assembly quality and comment on this. Show your commands and results.

Result

The script PipeLine.sh includes all code used to generate the results. In summary:

1. fastqc used to asses the raw read quality, i. e. MiSeq_Ecoli_MG1655_50x_R1_fastqc.html, MiSeq_Ecoli_MG1655_50x_R2_fastqc.html 
2. bbtools for quality filtering
3. fastqc to asses quality filtered reads, i. e. MiSeq_Ecoli_MG1655_50x_R1_qc_fastqc.html, MiSeq_Ecoli_MG1655_50x_R2_qc_fastqc.html
4. spades de novo assembly of quality filtered reads, i. e. contigs.fasta
5. multiqc used to concatenate raw fastqc reports, i. e. RawMultiQC.html
6. multiqc used to concatenate quality filtered fastqc reports, i. e. QCMultiQC.html
7. quast for assembly statistics, i. e. QuastReport.html, QuastReport.pdf
8. checkm for genome quality assessment, i. e. CheckM_summary_table.tsv 
9. gtdb-tk implemented for taxonomic classification, i. e. GTDB-Tk.csv

Discussion

From the raw fastqc reports Sample MiSeq_Ecoli_MG1655_50x was sequenced on an Illumina platform and produced 773,279 paired-end reads (151 bp). Theoretical coverage was calculated as 46.70605x (151*2*773279/5000000) and 51.89561x (151*2*773279/4500000). The raw reads had relatively good quality but was still subjected to quality filtering. Quality filtering retained high quality information and resulted in 662,081 paired-end reads being retained (51 - 150 bp).   De novo assembly produced a total of 199 contigs of which 88 were larger than 500 bp. The largest contig was 264,991 bp in length. The N50 is 125,603 bp and L50 13. The total length range of +- 4.5 Mb falls within the estimated genome sizes of E. coli (4.5 - 5.5 Mb) and is aligned with 50x coverage of a 4.5 Mb genome. This is definitely not the best assembly but acceptable. Better assembly may have been produced using a longer sequencing product, e. g. 300 bp, and maybe more data than 50x specified.

What is perhaps more important than the assembly statistics are the genome quality assessment indicators completeness and contamination.

CheckM results indicate 99.96% completeness and 0.08% contamination. These values are great and indicates a near complete genome with little contamination.

GTDB-Tk taxonomic classification: d__Bacteria;p__Proteobacteria;c__Gammaproteobacteria;o__Enterobacterales;f__Enterobacteriaceae;g__Escherichia;s__Escherichia flexneri




