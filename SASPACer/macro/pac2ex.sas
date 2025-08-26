/*** HELP START ***//*

`%pac2ex` is a macro to convert package zip file into
excel file with package information.

### Parameters

  - `zip_path` : full path for package zip file
  - `xls_path` : full path for excel file to output
  - `overwrite` : N for not overwriting (default is Y)
  - `kill` : Y for kill all datasets in WORK (default is N)

### Flow of the `%pac2ex` macro

  1. Scan package ZIP contents
  2. Read each ZIP entry line-by-line into _PAC2EX_xxx datasets
  3. Process DESCRIPTION and LICENSE
  4. Process macros/contents calling `%pac2ex_contents`
  5. Export to Excel sheets calling `%pac2ex_folder2sheet`

### Sample code

~~~sas
%pac2ex(
  zip_path=C:\Temp\packagename.zip,
  xls_path=C:\Temp\package_info.xlsx,
  overwrite=Y,
  kill=Y
)
~~~

### Note:

Only tested in Windows.

---
*//*** HELP END ***/

%macro pac2ex(zip_path=, xls_path=, overwrite=Y, kill=N);

/* check if Excel file already exists. If yes and overwrite ne Y, stop macro */
%if %sysfunc(fileexist(&xls_path)) %then %do;
    %if &overwrite ne Y %then %do;
        %put ERROR: Output Excel file &xls_path already exists. Aborting macro.;
        %return;
    %end;
    %else %do;
        %put NOTE: File &xls_path already exists. Deleting before overwrite.;
        filename delfile "&xls_path";
        data _null_;
            if fexist("delfile") then rc=fdelete("delfile");
        run;
        filename delfile clear;
    %end;
%end;

filename inzip zip "&zip_path";
libname xlout xlsx "&xls_path";


data _PAC2EX_TMP01;
  length memname $256 ;
  fid = dopen("inzip");

  if fid = 0 then do;
    putlog "ERROR: Cannot open zip file";
    stop;
  end;

  do i = 1 to dnum(fid);
    memname = dread(fid, i);
	putlog memname ;

    /* target: start with "_" and .sas file */
    if substr(trim(left(memname)),1,1)="_"
       and lowcase(scan(memname, -1, '.')) = 'sas' then do;

      /* extract contents name from file name */
      foldername = substr(scan(memname, 1, '.'),1); /*folder name*/
	  contname = scan(memname,-2, ".") ; /*contents name*/
	  output ;
	  end ;
	  else if scan(memname, 1, ".") in ("description", "license") then do ;
		foldername = trim(left(scan(memname, 1, "."))) ;
		output ;
	  end ;
    end ;
  rc = dclose(fid);
run ;
data _PAC2EX_TMP01;
  set _PAC2EX_TMP01;
  /* change to start with _ if starting with 0-9 or else(which cannot be used for the first letter in dataname) */
  if not missing(contname) and not ( 
       'A' <= upcase(substr(contname, 1, 1)) <= 'Z'
    or substr(contname, 1, 1) = '_'
  ) then contname = cats('_', contname);
run;
/* create contents dataset by memname */
data _null_;
  set _PAC2EX_TMP01;
  if foldername in ("description","license") then do ;
	  call execute(
	    'data ' || '_PAC2EX_' || strip(foldername) || '; length contents $32767; infile inzip("' || strip(memname) || '") lrecl=32767 truncover; input contents $char32767.; run;'
	  );
  end ;
  else do ;
	  call execute(
	    'data ' || '_PAC2EX_' || strip(contname) || '; length contents $32767; infile inzip("' || strip(memname) || '") lrecl=32767 truncover; input contents $char32767.; run;'
	  );
  end ;
run;

/* Description */
data _PAC2EX_DESCRIPTION1;
  set _PAC2EX_DESCRIPTION ;
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
data _PAC2EX_DESCRIPTION2;
  set _PAC2EX_DESCRIPTION1;
  colon_pos = index(contents, ':');
  if colon_pos > 0 then do;
    col1 = strip(scan(contents, 1, ":"));
    col2 = strip(scan(contents, 2, ":"));
    output;
  end;
run;
data _PAC2EX_DESCRIPTION_SECTION;
  set _PAC2EX_DESCRIPTION;
  retain flag 0;
  if contents =: 'DESCRIPTION START:' then flag = 1;
  else if contents =: 'DESCRIPTION END:' then flag = 0;
  else if flag = 1 then do;
    output;
  end;
run;
data _PAC2EX_COMBINED;
  length all_contents $32767;
  retain all_contents '';
  set _PAC2EX_DESCRIPTION_SECTION end=eof;
  col1= "Description" ;

  if all_contents = '' then
    all_contents = contents;
  else
    all_contents = catx('0D0A'x, all_contents, contents); /* change line */
  if eof then output;
  keep col1 all_contents;
run;
data _PAC2EX_FINAL_DESCRIPTION ;
	set _PAC2EX_DESCRIPTION2 _PAC2EX_COMBINED(rename=(all_contents=col2)) ;
	keep col1 col2 ;
run ;

/* License */
data _PAC2EX_FINAL_LICENSE ;
  attrib col1 length=$10. col2 length=$32767. ; 
  retain col2 '';
  set _PAC2EX_LICENSE end=eof;
  col1= "License" ;

  if col2 = '' then
    col2 = contents;
  else
    col2 = catx('0D0A'x, col2, contents); /* change line */
  if eof then output;
  keep col1 col2;
run;

/* macros and other contents (running pac2ex_contents macro) */
data _null_;
  set _PAC2EX_TMP01;
  if not missing(contname) then do;
    call execute(cats('%pac2ex_contents(contents=', contname, ');'));
  end;
run;

/* get unique foldername */
proc sql noprint;
    select distinct foldername into :folders separated by ' '
    from _PAC2EX_TMP01(where=(foldername not in ("description","license")));
quit;

/* output to sheets */
%pac2ex_folder2sheet()
libname xlout clear;

proc export data=_PAC2EX_FINAL_DESCRIPTION(keep=col1 col2)
    outfile="&xls_path"
    dbms=xlsx
    replace 
    ;
    sheet="description";
	putnames=no ;
run;
proc export data=_PAC2EX_FINAL_LICENSE(keep=col1 col2)
    outfile="&xls_path"
    dbms=xlsx
	replace
    ;
    sheet="license";
	putnames=no ;
run;

/* delete backup file if exists */
filename bakfile "&xls_path..bak";
data _null_;
  if fexist('bakfile') then
    rc = fdelete('bakfile');
run;
filename bakfile clear;

%if &kill=Y %then %do ;
proc datasets library=WORK nolist ;
  delete _PAC2EX_: ;
run ; quit ;
%end ;

%mend ;
