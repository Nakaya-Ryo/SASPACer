/*** HELP START ***//*

This is internal utility macro used in `%ex2pac`.
(Called in `%ex2pac_allsheet` macro)

Purpose:
To create contents in xxx.sas reading excel sheet.

*//*** HELP END ***/

/*--macro used in ex2pac--*/
%macro ex2pac_allname(count=);
%local i;
%do i = 1 %to &count. ;
	/* check if "body" is not blank in row of name&i */
  %local has_body;
	%let has_body = 0;
	proc sql noprint;
	    select count(*) into :has_body
	    from work.sheet
	    where name = "&&name&i.." and body ne "";
	quit;

	/* Case of body is not blank */
	%if &has_body > 0 %then %do;
		data _null_;
		    set work.sheet(where=(name="&&name&i.." and body ne ""));
		    file "&packagepath.&slash.&&sheet&j..&slash.&&name&i...sas";
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

		data _null_; /*check if external file exists*/
			set work.sheet(where=(name="&&name&i.." and location ne ""));

			rc = filename('loc', location);
			if fexist('loc') = 0 then do;
				put "ERROR: External SAS file not found: " location;
				stop;
			end;

      file "&packagepath.&slash.&&sheet&j..&slash.&&name&i...sas";
      put "/*** HELP START ***//*" ;
  		put ;
  		put help ;
  		put ;
  		put "*//*** HELP END ***/" ;
  		put ;

      /* after grabbing code help text put fil content into sas file */
  		infile dummy filevar=location end=eof lrecl=32767;
  		do while (not eof);
  			input;
  			put _infile_;
  		end;
		run;

	%end;
%end;
%mend;
