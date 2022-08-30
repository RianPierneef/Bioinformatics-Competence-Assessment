import sys, os
fin = open("st2.txt", "r")
count = 0
for line in fin:
	if len(line.split()) > 1:
		count = count + 1
		print ">"+str(count)
		print line.split()[0].strip()
fin.close()
