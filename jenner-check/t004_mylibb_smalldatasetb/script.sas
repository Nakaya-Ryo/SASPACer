/* jenner-check bundle: three pieces of Nakaya-Ryo/SASPACer's own example
   package content, reproduced and run together in the order SASPACer's
   %ex2pac() would assemble them from template_package.xlsx
   (SASPACer/addcnt/mylibb.sas, SASPACer/addcnt/smalldatasetb.sas, and the
   `fmtNum` format body embedded as a "formats" sheet cell in
   template_package.xlsx). SASPACer ships these as separate excel-cell /
   file fragments meant to be concatenated into one package member at
   generation time; concatenating them is the first substitution. The
   second: mylibb.sas assigns its library via the LIBNAME() DATA step
   function (Jenner does not yet implement that function form), so the
   equivalent LIBNAME statement stands in for it below -- same libref,
   same physical path, same engine, just the statement form of the
   identical assignment. smalldatasetb.sas and the format are unmodified. */

/* --- "formats" sheet body cell, template_package.xlsx, unmodified --- */
proc format;
value fmtNum low -< 0 = "negative" 0 = "zero" 0 <- high = "positive" other = "missing" ;
run;

/* --- SASPACer/addcnt/mylibb.sas: same library assignment via the
   LIBNAME statement (Jenner does not yet implement the LIBNAME() DATA
   step function mylibb.sas calls) --- */
libname myLibB "%sysfunc(pathname(work))";

/* --- SASPACer/addcnt/smalldatasetb.sas, unmodified --- */
data myLibB.smallDatasetB;
	do n = ., -1, 0, 1;
	m = put(n, fmtNum.);
	output;
	end;
run;

title "myLibB.smallDatasetB -- SASPACer's own addcnt/smalldatasetb.sas example, run unmodified";
proc print data=myLibB.smallDatasetB noobs;
	var n m;
run;
