/*** HELP START ***//*

`%ex2pac` is a macro to convert excel file with package information into
SAS package folders and files.

### Parameters

  - `excel_file` : full path for excel file which contains package information

  - `package_location` : location where package files to be stored.
                               Subfolder named package name will be created
                               under the location.

  - `complete_generation` (default=Y) : If user want to create only package structure, 
                                        please change complete_generation=N.
                                        By default, `%ex2pac` execute `%generatePackage()` 
                                        to create .zip and .md.


### Excel file to read

  Easy to understand the structure. Take a look anyway.
  In sheets like macros, the `%ex2pac` uses body information if body column is filled,
  while refers file in location column if body column is blank.
  (This is a situation where macros(or other files) were already created somewhere in a file and
  would like to use it instead of copying contents in body column of the excel.)


### Flow of the `%ex2pac` macro

  1. Create package subfolder in the location.
     Name of the subfolder will be set as the package name.
  2. Create description.sas
  3. Create license.sas
  4. Create subfolders like 01_formats, 02_functions, etc. in reference to
     the excel sheet names.
  5. Create sas files based on information described in each excel sheet
  6. Run `%generatePackages()`

### Sample code

~~~sas
%ex2pac(
  excel_file=C:\Temp\template_package.xlsx,
  package_location=C:\Temp\SAS_PACKAGES\packages,
  complete_generation=Y)
~~~

### Note:

  1. `%ex2pac` expects the operating system to be either Windows or a non-Windows environment
  (such as Linux, Unix, etc.). The `&SYSSCP` macro variable is used to identify the current OS.
  2. Libref named `e2p_xls` and `XLSCHK` are used in the macro.
  3. Max length of 32767 bytes is the limit in both cells in excel and reference file(.sas) in location column
  due to limitations in excel cell max length and max length of SAS variables used in the macro.

---

*//*** HELP END ***/

%macro ex2pac(excel_file=, package_location=, complete_generation=Y) / minoperator;

/* Call macro to switch separator by OS(Win or other) */
%local slash ;
%let slash=%ex2pac_set_slash() ;

/* Check if excel file exists */
data _null_;
	length excel $2048 rc 8;
	excel = symget("excel_file");
	rc = filename('fileref', excel);
	if fexist('fileref') = 0 then do;
		put "ERROR: Excel file not found. Stopping macro.";
		call symputx('abort_flag', 1, 'L');
	end;
	else call symputx('abort_flag', 0, 'L');
run;
%if &abort_flag = 1 %then %do;
	%put ERROR: Macro aborted due to missing Excel file.;
	%return;
%end;

/* Check if package_location folder exists */
data _null_;
	length loc $2048 rc 8;
	loc = symget("package_location");

	rc = filename('mypath', loc);
	did = dopen('mypath');

	if did = 0 then do;
		put "ERROR: Folder does not exist: " loc;
		call symputx('abort_folder', 1, 'L');
	end;
	else do;
		rc = dclose(did); /* cleanup */
		call symputx('abort_folder', 0, 'L');
	end;
run;
%if &abort_folder = 1 %then %do;
	%put ERROR: Macro aborted due to missing folder.;
	%return;
%end;

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
	call symputx("packagename", B, 'L') ;
run ;

data _null_;
	length rc1 did 8. rc2 full_path $512;

	base_path = "&package_location.";
	full_path = catx("&slash.", base_path, "&packagename");

	rc1 = filename("subfldr", full_path);
	did = dopen("subfldr");

	/*Create subfolder*/
	if did > 0 then do;
	    n = dnum(did); /*number of members in the folder*/
		if n > 0 then do;
			put "ERROR: There are files and/or folders in the package folder: " full_path ".";
			put "ERROR: Please make sure the package folder is empty, and then re-run SASPACer.";
			call symputx("abort_flag", 1, 'L');
		end;
		else do;
			put "NOTE: Package folder already exists but empty. SASPACer will use the folder.";
			call symputx("abort_flag", 0, 'L');
		end;
		rc1 = dclose(did);
		call symputx("packagepath", full_path, 'L');
		stop;
	end;
	else do ;
	    call symputx("abort_flag", 0, 'L');
		rc2 = dcreate("&packagename", base_path);
		if rc2 = '' then put "ERROR: Failed to create package folder.";
		else put "NOTE: Package folder was successfully created: ";
	end ;
	call symputx("packagepath", full_path, 'L');
run;

%if &abort_flag. %then %do; /*abort the macro if there is existing non-empty folder*/
  %put ERROR: Aborted the macro.;
  %return;
%end;

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
    file "&packagepath.&slash.description.sas";

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
libname XLSCHK xlsx "&excel_file."; /*check if license sheet exists*/
proc sql;
  create table _TMP_XLS as
  select memname
  from sashelp.vtable
  where libname="XLSCHK";
quit;

%let license_flag = N ;
data _null_ ;
	set _TMP_XLS ;
	if upcase(memname) = "LICENSE" then call symputx('license_flag', 'Y') ;
run ;

%if &license_flag. = Y %then %do ;
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
	    file "&packagepath.&slash.license.sas";
	    /* output to .sas file */
	    put B ;
	run;
%end ;
libname XLSCHK clear ;

/* Create folders(formats, macros, etc.) */
libname e2p_xls xlsx "&excel_file.";
proc contents data=e2p_xls._all_ out=sheet_list(keep=memname) noprint;
run;
proc sort data=sheet_list(where=(memname not in ("DESCRIPTION","LICENSE"))) nodupkey ; by memname ; run ;
data sheet_list ;
	set sheet_list ;
	sheet=lowcase(memname) ;
	drop memname ;
run ;
libname e2p_xls clear;

data _null_;
    set sheet_list;
    length folder_name $300;
    folder_name = cats("&packagepath.&slash.", strip(sheet));
    if fileexist(folder_name) = 0 then 
        rc = dcreate(strip(sheet), "&packagepath.");
run;

/* Create files in folders */
data _null_;/*put sheet names in macro variables*/
    set sheet_list nobs=n;
    call symputx(cats('sheet', _n_), sheet, 'L');/* ex. sheet1 = 01_libname */
    call symputx('count_sheet', n, 'L');/* number of sheets */
run;

%ex2pac_allsheet(count_sheet=&count_sheet.)

/*Generate package*/
%if %superq(complete_generation) in (Y y) %then %do ;
	%generatePackage(filesLocation=&packagepath. ,markdownDoc=1,easyArch=1)
%end ;
%else %do ;
	%put NOTE: Only package structure was created. Please create package file(.zip and .md) using %nrstr(%generatePackage()) macro. ;
%end ;
%mend ;
