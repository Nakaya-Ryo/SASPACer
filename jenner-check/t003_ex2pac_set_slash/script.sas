/* jenner-check bundle: Nakaya-Ryo/SASPACer's %ex2pac_set_slash() macro
   (SASPACer/macro/ex2pac_set_slash.sas), reproduced unmodified. It is the
   small internal utility %ex2pac() calls to pick a path separator based on
   &SYSSCP -- backslash on Windows, forward slash everywhere else. This
   bundle calls it directly and prints the separator Jenner's host resolves
   to, plus a demonstration of exactly how %ex2pac() consumes it in
   ex2pac.sas: building a package path by concatenating a base folder, the
   separator, and a package name via catx(). */

/* --- SASPACer/macro/ex2pac_set_slash.sas, unmodified (switches separator
   character based on OS) --- */
%macro ex2pac_set_slash();
  %if &SYSSCP. = WIN %then
    %do; \ %end;
  %else
    %do; / %end;
%mend;
/* --- end ex2pac_set_slash.sas --- */

%let slash = %ex2pac_set_slash();

%put NOTE: SYSSCP resolved to &SYSSCP..;
%put NOTE: ex2pac_set_slash() returned separator: [&slash.];

/* Same use SASPACer's %ex2pac() makes of the separator in ex2pac.sas:
   building the package subfolder path with catx() and the resolved slash. */
data _null_;
	base_path = "SAS_PACKAGES/packages";
	packagename = "SASPACer";
	full_path = catx("&slash.", base_path, packagename);
	put "NOTE: full_path = " full_path;
run;
