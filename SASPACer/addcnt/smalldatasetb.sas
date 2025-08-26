data myLibB.smallDatasetB;
	do n = ., -1, 0, 1;
	m = put(n, fmtNum.);
	output;
	end;
run;