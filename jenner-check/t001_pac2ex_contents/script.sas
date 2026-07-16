/* jenner-check bundle: exercises Nakaya-Ryo/SASPACer's %pac2ex_contents macro
   (SASPACer/macro/pac2ex_contents.sas) byte-for-byte -- the internal utility
   %pac2ex() uses to turn a raw line-by-line read of a package .sas file into
   a single row with name/help/body columns, splitting the HELP-comment block
   from the code body.

   %pac2ex() normally builds PAC2EX.<contents> itself by reading a member out
   of a package zip with an `infile inzip(...)` step (see pac2ex.sas). Here we
   seed that same input shape directly: a PAC2EX.f2 dataset whose `contents`
   column holds SASPACer's own addcnt/f2.sas (one of the sample package
   contents shipped in template_package.xlsx) preceded by the HELP markers
   %pac2ex() itself writes ahead of a member's body, line by line, exactly as
   %pac2ex()'s zip-scan step would have produced it. That is the only
   substitution -- %pac2ex_contents itself is reproduced unmodified below
   (the runner has no way to ship a sibling %include file, so it is inlined
   instead of %included). */

data PAC2EX.f2;
	length contents $32767;
	input contents $char200.;
	datalines;
/*** HELP START ***//*
F2(n) is an user-defined function to output n+2 value.
(No need to write location column if content is written in body column.)
*//*** HELP END ***/
function F2(n);
	return (n+2);
endsub;
;
run;

/* --- SASPACer/macro/pac2ex_contents.sas, unmodified --- */
%macro pac2ex_contents(contents=) ;
data PAC2EX.&contents;
	attrib name      length=$32
		help      length=$32767
		body      length=$32767
		location  length=8;
  retain help body '' flag 0 afterflag 0;
  set PAC2EX.&contents. end=eof;

  name = "&contents" ;
  location = "" ;

  if index(contents, '/*** HELP START ***/') > 0 then
    flag = 1;
  else if index(contents, '/*** HELP END ***/') > 0 then do;
    flag = 0;
    afterflag = 1;
  end;
  else if flag=1 then do;
    if help = '' then help = contents;
    else help = catx('0D0A'x, help, contents);
  end;
  else if afterflag=1 then do;
    if body = '' then body = contents;
    else body = catx('0D0A'x, body, contents);
  end;

  if eof then output;
  keep name help body location ;
run;
%mend ;
/* --- end pac2ex_contents.sas --- */

%pac2ex_contents(contents=f2)

title "PAC2EX.f2 after pac2ex_contents -- SASPACer own addcnt/f2.sas split into help/body";
proc print data=PAC2EX.f2 noobs;
	var name;
run;

proc sql;
	select name, length(help) as help_len, length(body) as body_len, body
	from PAC2EX.f2;
quit;
