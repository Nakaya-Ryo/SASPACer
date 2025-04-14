/*** HELP START ***//*

%ex2pac is a macro to convert excel with package information into
SAS package folders and files.

- Parameters
	excel_file :
		full path for excel file which contains package information
	package_location :
		location where package files to be stored.
		Subfolder named package name will be created under the location.

- Excel file to read
	Easy to understand the structure. Take a look at it anyway.
	In sheets like macros, %ex2pac uses body information if body column is filled,
	while refers file in location column if body column is blank.
	(This is a situation where macros(or other files) were already created somewhere in a file and
	would like to use it instead of copying contents in body column of the excel.)

- Flow of the macro
	1. Create package subfolder in the location.
		Name of the subfolder will be set as the package name.
	2. Create description.sas
	3. Create license.sas
	4. Create subfolders like 01_formats, 02_functions, etc. in reference to
		the excel sheet names.
	5. Create sas files based on information described in each excel sheet
	6. Run %generatePackages()

- Sample code
%ex2pac(
	excel_file=C:\Temp\template_package_meta.xlsx,
	package_location=C:\Temp\SAS_PACKAGES\packages) ;


*//*** HELP END ***/

%macro ex2pac(excel_file=, package_location=) ;

/* Create package folder */
proc import
	datafile="&excel_file."
    out=description
    dbms=xlsx
    replace;
    sheet="description";
    getnames=no;
run;
data _null_ ;
	set description ;
	where A="Package" ;
	call symputx("packagename", B) ;
run ;

data _null_;
  length rc fileref $8 base_path $512;

  base_path = "&package_location.";

  /* Assign a fileref to the base path */
  rc = filename(fileref, base_path);

  /* Check if the subfolder already exists */
  if fexist(fileref) then do;
    put "NOTE: Base folder exists. Checking subfolder...";

    /* Combine base path and subfolder name */
    rc = filename('subfldr', catx('\', base_path, "&packagename"));
    if fexist('subfldr') then do;
	  full_path = catx('\', base_path, "&packagename");
	  call symputx("packagepath", full_path);
      put "NOTE: Subfolder already exists. Process aborted.";
      stop;
    end;
  end;

  /* Create the subfolder */
  rc = dcreate("&packagename", base_path);
  if rc = '' then
    put "ERROR: Failed to create subfolder.";
  else
    put "NOTE: Subfolder successfully created: " rc;

  full_path = catx('\', base_path, "&packagename");
  call symputx("packagepath", full_path);
run;

/* Create Description */
proc import
	datafile="&excel_file."
    out=description
    dbms=xlsx
    replace;
    sheet="description";
    getnames=no;
run;
data _null_;
    set description;
    file "&packagepath./description.sas";

    /* output to .sas file */
    if A ne "Description" then put A ": " B ;
    if _n_ = 10 then do;
        put;
        put "DESCRIPTION START:";
    end;
	if A = "Description" then put B ;
	if _n_=11 then put "DESCRIPTION END:" ;
run;

/* Create License */
proc import
	datafile="&excel_file."
    out=license
    dbms=xlsx
    replace;
    sheet="license";
    getnames=no;
run;
data _null_;
    set license;
    file "&packagepath./license.sas";
    /* output to .sas file */
    put B ;
run;

/* Create folders(formats, macros, etc.) */
libname myxls xlsx "&excel_file.";
proc contents data=myxls._all_ out=sheet_list(keep=memname) noprint;
run;
proc sort data=sheet_list(where=(memname not in ("DESCRIPTION","LICENSE"))) nodupkey ; by memname ; run ;
data sheet_list ;
	set sheet_list ;
	sheet=lowcase(memname) ;
	drop memname ;
run ;
libname myxls clear;

data _null_;
    set sheet_list;
    length folder_name $300;
    folder_name = cats("&packagepath./", strip(sheet));
    if fileexist(folder_name) = 0 then 
        rc = dcreate(strip(sheet), "&packagepath.");
run;

/* Create files in folders */
data _null_;/*put sheet names in macro variables*/
    set sheet_list nobs=n;
    call symputx(cats('sheet', _n_), sheet);/* ex. sheet1 = 01_libname */
    call symputx('count_sheet', n);/* number of sheets */
run;

%macro allsheet() ;
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
	    array vars {*} _character_ _numeric_;
	    if cmiss(of vars[*]) < dim(vars);/* To remove records with all null */
	run;
	data _null_;/*put each value in "name" column into macro variables */
	    set sheet nobs=n;
	    call symputx(cats('name', _n_), name);/* ex. name1 = mylib1 */
	    call symputx('count', n);/*number of records*/
	run;
	
	%macro allname();
	%do i = 1 %to &count. ;
		/* check if "body" is not blank in row of name&i */
		%let has_body = 0;
		proc sql noprint;
		    select count(*) into :has_body
		    from sheet
		    where name = "&&name&i.." and body is not null and body ne "";
		quit;

		/* Case of body is not blank */
		%if &has_body > 0 %then %do;
			data _null_;
			    set sheet(where=(name="&&name&i.." and body ne ""));
			    file "&packagepath./&&sheet&j../&&name&i...sas";
			    put "/*** HELP START ***//*" ;
			    put ;
			    put help ;
			    put ;
			    put "*//*** HELP END ***/" ;
			    put ;
			    put body ;
			run;
		%end;
		/* Case of body is blank (expect to have "location" instead) */
		%else %do;
			data _null_;
			    set sheet(where=(name="&&name&i.." and location ne ""));
			    infile dummy filevar=location end=eof truncover;
			    length line $500 all $32767;
			    retain all "";
			    do while (not eof);
			        input line $char500.;
			        all = catx('0A'x, all, line);/*put every line with newline character*/
			    end;
			    call symputx('sas_code_text', all);/*all contents in the sas file*/
			run;
			data _null_;
			    set sheet(where=(name="&&name&i.." and location ne ""));	
			    length code $32767;
			    file "&packagepath./&&sheet&j../&&name&i...sas";
			    put "/*** HELP START ***//*" ;
			    put ;
			    put help ;
			    put ;
			    put "*//*** HELP END ***/" ;
			    put ;
			    code = symget("sas_code_text"); 
			    put code;/* Contents in sas file(in location) is set */
			run;
		%end;
	%end;
	%mend;
	%allname();
%end ;
%mend ;
%allsheet();

%generatePackage(filesLocation=&packagepath. ,markdownDoc=1) /*Generate package*/

%mend ;
