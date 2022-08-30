Task

Write a command line program to prompt a user for a protein input file and an E-value cutoff, and then run a remote BLAST at the NCBI, and return the top 10 hits. Show your code and results.

Result

The python script Blaster.py requests a user to specify an input file and E-value cut-off. This will then run a remote BLAST at the NCBI with the specified E-value cut-ff. The results are printed to the screen and written to an appropriate file.

Results for E-value cut-off 0.001, 0.01, 0.1, 1.0 and 10 are included here.

Examples

python Blaster.py 
Please enter the name/path of your file: NC_012920.1.fasta
Please enter an e-value cut-off: 0.001
Below are the top ten hits: 

                                                                   Score     E     Max
Sequences producing significant alignments:                       (Bits)  Value  Ident

YP_003024026.1 NADH dehydrogenase subunit 1 [Homo sapiens]         620     0.0    100%        
ABO39218.1 NADH dehydrogenase subunit 1 [Homo sapiens]             619     0.0    100%        
AFF88970.1 NADH dehydrogenase subunit 1 [Homo sapiens]             619     0.0    100%        
ABB51437.1 NADH dehydrogenase subunit 1 [Homo sapiens]             619     0.0    100%        
AFF65934.1 NADH dehydrogenase subunit 1 [Homo sapiens]             619     0.0    100%        
ACN37766.1 NADH dehydrogenase subunit 1 [Homo sapiens]             619     0.0    100%        
AAX15342.1 NADH dehydrogenase subunit 1 [Homo sapiens]             619     0.0    100%        
ABO39697.1 NADH dehydrogenase subunit 1 [Homo sapiens]             619     0.0    100%        
ACR08827.1 NADH dehydrogenase subunit 1 [Homo sapiens]             619     0.0    100%        
ATP02506.1 NADH dehydrogenase subunit 1 [Homo sapiens]             619     0.0    100%        

The results have also been written to: NC_012920.1_blastP_0.001.txt
