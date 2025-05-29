data myLib1.biggerDataset;
	do i = ., -1e6 to 1e6;
		j = put(i, fmtNum.);
		k = ranuni(17);
	output;
	end;
run;