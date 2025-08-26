/*** HELP START ***//*

This is internal utility macro used in `%pac2ex`.

Purpose:
To create datasets by contents.

*//*** HELP END ***/

/*--macro used in pac2ex--*/
%macro pac2ex_contents(contents=) ;
data _PAC2EX_FINAL_&contents;
	attrib name      length=$32
		help      length=$32767
		body      length=$32767
		location  length=8;
  retain help body '' flag 0 afterflag 0;
  set _PAC2EX_&contents. end=eof;

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
