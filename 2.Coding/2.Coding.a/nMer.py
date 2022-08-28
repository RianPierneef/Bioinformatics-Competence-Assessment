import sys, os
userFile = raw_input("Please enter the name/path of your file: ")
assert os.path.exists(userFile), "Unfortunately I did not find the file name/path, "+str(userFile)
fin = open(userFile, "r")
nSize = int(raw_input("Please enter a nMer length/size: "))
seQs = []
for line in fin:
    if ">" not in line:
        seQs.append(line.strip())
fin.close()
seQs = "".join(seQs)
nMers = []
numnMers = len(seQs) - nSize + 1
for i in range(numnMers):
        nMer = seQs[i:i + nSize]
        nMers.append(nMer)
fout = open(userFile.rsplit(".", 1)[0]+"_nMer_"+str(nSize)+".txt", "w")
print "#OfTimesFound\tnMer"
fout.write("#OfTimesFound\tnMer\n")
for nMer in set(nMers):
    print nMers.count(nMer), "\t", nMer
    fout.write(str(nMers.count(nMer))+"\t"+nMer+"\n")
fout.close()
print "The results have also been written to: "+userFile.rsplit(".", 1)[0]+"_nMer_"+str(nSize)+".txt"
