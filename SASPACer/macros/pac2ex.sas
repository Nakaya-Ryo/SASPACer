/*** HELP START ***//*

`%pac2ex` is a macro to convert package zip file into
excel file with package information.

### Parameters
	- `zip_path` : full path for package zip file

	- `xls_path` : full path for excel file to output

	- `kill` : Y for kill all datasets in WORK (default is N)

### Sample code

~~~sas
%pac2ex(
	zip_path=C:\Temp\packagename.zip,
	xls_path=C:\Temp\package_info.xlsx,
	kill=Y
)
~~~

### Note:
  Only tested in Windows.

---

*//*** HELP END ***/
%macro pac2ex(zip_path=, xls_path=,kill=N);

/* check if Excel file already exists. If yes, stop macro */
%if %sysfunc(fileexist(&xls_path)) %then %do;
    %put ERROR: Output Excel file &xls_path already exists. Aborting macro.;
    %return;
%end;

filename inzip zip "&zip_path";
libname xlout xlsx "&xls_path";


data _TMP01;
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
data _TMP01;
  set _TMP01;
  /* change to start with _ if starting with 0-9 or else(which cannot be used for the first letter in dataname) */
  if not missing(contname) and not ( 
       'A' <= upcase(substr(contname, 1, 1)) <= 'Z'
    or substr(contname, 1, 1) = '_'
  ) then contname = cats('_', contname);
run;
/* create contents dataset by memname */
data _null_;
  set _TMP01;
  if foldername in ("description","license") then do ;
	  call execute(
	    'data ' || strip(foldername) || '; length contents $32767; infile inzip("' || strip(memname) || '") lrecl=32767 truncover; input contents $char32767.; run;'
	  );
  end ;
  else do ;
	  call execute(
	    'data ' || strip(contname) || '; length contents $32767; infile inzip("' || strip(memname) || '") lrecl=32767 truncover; input contents $char32767.; run;'
	  );
  end ;
run;

/* Description */
data description1;
  set description;
/*  if index(contents, 'Type:') = 1 then flag = 1;*/
/*  if index(contents, 'Package:') = 1 then flag = 1;*/
/*  if index(contents, 'Title:') = 1 then flag = 1;*/
/*  if index(contents, 'Version:') = 1 then flag = 1;*/
/*  if index(contents, 'Author:') = 1 then flag = 1;*/
/*  if index(contents, 'Maintainer:') = 1 then flag = 1;*/
/*  if index(contents, 'License:') = 1 then flag = 1;*/
/*  if index(contents, 'Encoding:') = 1 then flag = 1;*/
/*  if index(contents, 'Required:') = 1 then flag = 1;*/
/*  if index(contents, 'ReqPackages:') = 1 then flag = 1;*/
  if contents =: 'Type' then flag = 1;
  if contents =: 'Package' then flag = 1;
  if contents =: 'Title' then flag = 1;
  if contents =: 'Version' then flag = 1;
  if contents =: 'Author' then flag = 1;
  if contents =: 'Maintainer' then flag = 1;
  if contents =: 'License' then flag = 1;
  if contents =: 'Encoding' then flag = 1;
  if contents =: 'Required' then flag = 1;
  if contents =: 'ReqPackages' then flag = 1;
  if flag=1 then output;
run;
data description2;
  set description1;
  colon_pos = index(contents, ':');
  if colon_pos > 0 then do;
    col1 = strip(substr(contents, 1, colon_pos-1));
    col2 = strip(substr(contents, colon_pos+1));
    output;
  end;
run;
data description_section;
  set description;
  retain flag 0;
  if contents =: 'DESCRIPTION START:' then flag = 1;
  else if contents =: 'DESCRIPTION END:' then flag = 0;
  else if flag = 1 then do;
    output;
  end;
run;
data combined;
  length all_contents $32767;
  retain all_contents '';
  set description_section end=eof;
  col1= "Description" ;

  if all_contents = '' then
    all_contents = contents;
  else
    all_contents = catx('0D0A'x, all_contents, contents); /* change line */
  if eof then output;
  keep col1 all_contents;
run;
data Final_description ;
	set description2 combined(rename=(all_contents=col2)) ;
	keep col1 col2 ;
run ;

/* License */
data Final_license;
  attrib col1 length=$10. col2 length=$32767. ; 
  retain col2 '';
  set license end=eof;
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
  set _tmp01;
  if not missing(contname) then do;
    call execute(cats('%pac2ex_contents(contents=', contname, ');'));
  end;
run;

/* get unique foldername */
proc sql noprint;
    select distinct foldername into :folders separated by ' '
    from _tmp01(where=(foldername not in ("description","license")));
quit;

/* output to sheets */
%pac2ex_folder2sheet
libname xlout clear;

proc export data=final_description(keep=col1 col2)
    outfile="&xls_path"
    dbms=xlsx
    replace 
    ;
    sheet="description";
	putnames=no ;
run;
proc export data=final_license(keep=col1 col2)
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
proc datasets library=WORK nolist kill ;
run ; quit ;
%end ;

%mend ;
