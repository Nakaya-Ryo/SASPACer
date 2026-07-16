/* jenner-check bundle: exercises the DESCRIPTION/LICENSE parsing block that
   Nakaya-Ryo/SASPACer's %pac2ex() macro runs (SASPACer/macro/pac2ex.sas,
   the "Description" and "License" sections). %pac2ex() normally reaches this
   code after unzipping a package and reading description.sas / license.txt
   member-by-member with `infile inzip(...) ... input contents $char32767.`.

   Here PAC2EX.DESCRIPTION and PAC2EX.LICENSE are seeded directly with
   SASPACer's OWN description.sas and license.txt content (verbatim, line by
   line) -- the same shape the zip-scan step would have produced -- so the
   parsing DATA steps below run against real package metadata instead of an
   invented sample. Every DATA step from pac2ex.sas's Description/License
   section is reproduced unmodified. */

data PAC2EX.DESCRIPTION;
	length contents $32767;
	input contents $char200.;
	datalines;
Type: Package
Package: SASPACer
Title: SASPACer to create SAS package using excel file
Version: 0.3.6
Author: Ryo Nakaya (nakaya.ryou@gmail.com)
Maintainer: Ryo Nakaya (nakaya.ryou@gmail.com)
License: MIT
Encoding: UTF8
Required: "Base SAS Software", "SAS/access interface to PC files"
DESCRIPTION START:
SASPACer is a package for easily creating SAS packages.
All you need is to fill package information in the template excel file.
`SASPACer` has a macro(`%ex2pac()`) to convert excel into SAS package files.
macro(`%pac2ex()`) can convert package zip file into excel file.
DESCRIPTION END:
;
run;

data PAC2EX.LICENSE;
	length contents $32767;
	input contents $char200.;
	datalines;
Copyright (c) [2025] [Ryo Nakaya]
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY.
;
run;

/* --- SASPACer/macro/pac2ex.sas, "Description" section, unmodified --- */
data PAC2EX.DESCRIPTION1;
  set PAC2EX.DESCRIPTION ;
  c = compress(upcase(contents));
  drop c;

  if c IN: ('TYPE:'
           'PACKAGE:'
           'TITLE:'
           'VERSION:'
           'AUTHOR:'
           'MAINTAINER:'
           'LICENSE:'
           'ENCODING:'
           'REQUIRED:'
           'REQPACKAGES:')
  then output;
run;
data PAC2EX.DESCRIPTION2;
  set PAC2EX.DESCRIPTION1;
  colon_pos = index(contents, ':');
  if colon_pos > 0 then do;
    col1 = strip(scan(contents, 1, ":"));
    col2 = strip(scan(contents, 2, ":"));
    output;
  end;
run;
data PAC2EX.DESCRIPTION_SECTION;
  set PAC2EX.DESCRIPTION;
  retain flag 0;
  if contents =: 'DESCRIPTION START:' then flag = 1;
  else if contents =: 'DESCRIPTION END:' then flag = 0;
  else if flag = 1 then do;
    output;
  end;
run;
data PAC2EX.COMBINED;
  length all_contents $32767;
  retain all_contents '';
  set PAC2EX.DESCRIPTION_SECTION end=eof;
  col1= "Description" ;

  if all_contents = '' then
    all_contents = contents;
  else
    all_contents = catx('0D0A'x, all_contents, contents); /* change line */
  if eof then output;
  keep col1 all_contents;
run;
data PAC2EX.DESCRIPTION_FINAL ;
	set PAC2EX.DESCRIPTION2 PAC2EX.COMBINED(rename=(all_contents=col2)) ;
	keep col1 col2 ;
run ;

/* --- SASPACer/macro/pac2ex.sas, "License" section, unmodified --- */
data PAC2EX.LICENSE_FINAL ;
  attrib col1 length=$10. col2 length=$32767. ;
  retain col2 '';
  set PAC2EX.LICENSE end=eof;
  col1= "License" ;

  if col2 = '' then
    col2 = contents;
  else
    col2 = catx('0D0A'x, col2, contents); /* change line */
  if eof then output;
  keep col1 col2;
run;
/* --- end pac2ex.sas excerpt --- */

title "PAC2EX.DESCRIPTION_FINAL -- key/value rows parsed out of SASPACer's own description.sas";
proc print data=PAC2EX.DESCRIPTION_FINAL noobs;
	var col1 col2;
run;

title "PAC2EX.LICENSE_FINAL -- SASPACer's own license.txt collapsed to one row";
proc print data=PAC2EX.LICENSE_FINAL noobs;
	var col1;
	var col2 / style={cellwidth=200px};
run;
