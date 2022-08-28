import sys, os, Bio
from Bio.Blast import NCBIWWW
from Bio import SeqIO
userFile = raw_input("Please enter the name/path of your file: ")
assert os.path.exists(userFile), "Unfortunately I did not find the file name/path, "+str(userFile)
fin = open(userFile, "r")
eCut = float(raw_input("Please enter an e-value cut-off: "))
seq = SeqIO.read(fin, "fasta")
fin.close()
result_handle = NCBIWWW.qblast("blastp", "nr", seq.format("fasta"),
                               format_type="Text", expect=eCut, hitlist_size=10)
output = result_handle.read()
fout = open(userFile.rsplit(".", 1)[0]+"_blastP_"+str(eCut)+".txt", "w")
fout.write(output)
fout.close()
print "Below are the top ten hits: \n"
os.system("awk '/Score     E     Max/{x=NR+13}(NR<=x){print}' "+userFile.rsplit(".", 1)[0]+"_blastP_"+str(eCut)+".txt")
print "The results have also been written to: "+userFile.rsplit(".", 1)[0]+"_blastP_"+str(eCut)+".txt"
