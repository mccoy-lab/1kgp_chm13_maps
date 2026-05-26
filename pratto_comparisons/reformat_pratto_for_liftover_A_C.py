names = ["A", "C"]
cols = [16, 18]

for i in range(len(cols)):

	target_col = cols[i]

	out_name = f"liftover_input_A_C/{names[i]}_hotspots_hg19.txt"
	out = open(out_name, "w")

	f = open("1256442_datafiles1.txt", "r")

	counter = 0 

	for l in f:
		if not l.startswith("#"):

			vals = [l.strip().split()[x] for x in [0, 1, 2, target_col]]
			if counter == 0:
				out.write("\t".join(vals) + "\n")
				counter += 1
			elif vals[3] != "0":
				out.write("\t".join(vals) + "\n")
		
	out.close()		

	f.close()