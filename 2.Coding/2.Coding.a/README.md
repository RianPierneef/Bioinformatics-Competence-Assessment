Task

Write a command line programme that prompts a user for a DNA input file, and a n-mer number, and then reports the number of times each n-mer is found in the DNA sequence. Show your code and results.

Result

The python script nMer.py requests a user to specify an input file and n-mer size. The results are printed to the screen and written to an appropriate file.

Results for n-mer sizes 1-5 are included here.

Examples

python nMer.py

Please enter the name/path of your file: NC_012920.1.fasta

Please enter a nMer length/size: 1

#OfTimesFound	nMer
5124 	A
5181 	C
4094 	T
2169 	G
1 	N

The results have also been written to: NC_012920.1_nMer_1.txt
