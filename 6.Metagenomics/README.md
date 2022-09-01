Task

Shotgun metagenomics has broadened our understanding of microbial communities and their evolution within a well-defined habitat, ‘the microbiome’. This includes expanding current insights regarding plant-microbe interactions, soil microbial communities, and biogeochemical cycling in the oceans. These studies require the integration and application of various bioinformatics tools. Using any benchmarked, reproducible tool used for genome resolved metagenomics, analyse the provided dataset. By generating assembled contigs, provide output files showing an overview of MAGs (metagenome assembled genomes) meeting acceptable specifications for medium to high quality drafts.

Result

The script PipeLine.sh includes all code used to generate the results. In summary:

1. fastqc used to asses the raw read quality 
2. bbtools for quality filtering
3. fastqc to asses quality filtered reads
4. spades (--meta) de novo assembly of quality filtered reads
5. seqkit to filter for  contains >= 1,500bp, link: https://drive.google.com/drive/folders/1yY6MChoAWKkdhuxhGxDebPQ_pfqKLB19?usp=sharing
7. bbtools for depths
8. metabat2 to bin contigs (minimum contain length 1,500bp), link: https://drive.google.com/drive/folders/1DU41OFRGtGBuIP3HsJS6TzMsM-64bILQ?usp=sharing
9. checkm for bin quality assessment, i. e. CheckM.All.* 
9. awk to seperate High, Medium and Low Quality MAGs

Specifications for High, Medium and Low Quality MAGs (Bowers et al., 2017):

High: > 90% Completion and < 5% Contamination (CheckM.HighQual.txt and CheckM.HighQual.xlsx)
Medium: >= 50% Completion and < 10% Contamination (CheckM.MediumQual.txt and CheckM.MediumQual.xlsx)
Low: < 50% Completion and < 10% Contamination (CheckM.LowQual.txt and CheckM.LowQual.xlsx) 


Bowers, R.M., Kyrpides, N.C., Stepanauskas, R., Harmon-Smith, M., Doud, D., Reddy, T.B.K., Schulz, F., Jarett, J., Rivers, A.R., Eloe-Fadrosh, E.A. and Tringe, S.G., 2017. Minimum information about a single amplified genome (MISAG) and a metagenome-assembled genome (MIMAG) of bacteria and archaea. Nature biotechnology, 35(8), pp.725-731.


