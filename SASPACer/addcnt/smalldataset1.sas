data myLib1.smallDataset1;
	do n = ., -1, 0, 1;
	m = put(n, fmtNum.);
	output;
	end;
run;