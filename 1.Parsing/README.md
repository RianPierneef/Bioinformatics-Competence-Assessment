1. Parsing

In the folder there is a fragment of an hmmsearch output file (hmmsearch.out). Parse the file using any method of your choice to generate a list of the top 10 hits with their descriptions and E-values, and provide the commands or code you used to do this. [10]

The TopTen.sh script was used to complete this task.
Running the script within the same folder as the hmm search.out file will print the top 10 hits to the console/shell. The hmm search.TopTen results file was obtained by redirecting the output.

Examples

sh TopTen.sh
sh TopTen.sh > hmmsearch.TopTen
