/*** HELP START ***//*

This is temporary macro used in %ex2pac.

Purpose:
To create sheets.

*//*** HELP END ***/

/*--macro used in ex2pac--*/
%macro ex2pac_allsheet(count_sheet=) ;
%do j = 1 %to &count_sheet. ;
	proc import
		datafile="&excel_file."
	    out=sheet
	    dbms=xlsx
	    replace;
	    sheet="&&sheet&j..";/*read sheet in excel*/
	    getnames=yes;
	run;
	data sheet;
	    set sheet;
	    array vars {*} _character_;
	    if cmiss(of vars[*]) < dim(vars);/* To remove records with all null */
	run;
	data _null_;/*put each value in "name" column into macro variables */
	    call symputx('count', n, 'L');/*number of records*/
		set sheet nobs=n;
	    call symputx(cats('name', _n_), name, 'L');/* ex. name1 = mylib1 */
	run;
	%ex2pac_allname(count=&count.);
%end ;
%mend ;
