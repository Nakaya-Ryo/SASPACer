/*** HELP START ***//*

This is temporary macro used in %ex2pac.
(Called in %ex2pac_allsheet macro)

Purpose:
To create contents in xxx.sas reading excel sheet.

*//*** HELP END ***/

/*--macro used in ex2pac--*/
%macro ex2pac_allname(count=);
%do i = 1 %to &count. ;
	/* check if "body" is not blank in row of name&i */
	%let has_body = 0;
	proc sql noprint;
	    select count(*) into :has_body
	    from sheet
	    where name = "&&name&i.." and body ne "";
	quit;

	/* Case of body is not blank */
	%if &has_body > 0 %then %do;
		data _null_;
		    set sheet(where=(name="&&name&i.." and body ne ""));
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

		%let abort_file = 0;
		data _null_; /*check if external file exists*/
			set sheet(where=(name="&&name&i.." and location ne ""));
			rc = filename('loc', location);
			if fexist('loc') = 0 then do;
				put "ERROR: External SAS file not found: " location;
				call symputx('abort_file', 1, 'L'); /*abort flag*/
				stop;
			end;

		infile dummy filevar=location end=eof truncover;
		length line $500 all $32767;
		retain all "";
		do while (not eof);
			input line $char500.;
			all = catx('0A'x, all, line);
		end;
		call symputx('sas_code_text', all, 'L');
		run;

		%if &abort_file = 0 %then %do;
  			data _null_;
  				set sheet(where=(name="&&name&i.." and location ne ""));
				length code $32767;
				file "&packagepath.&slash.&&sheet&j..&slash.&&name&i...sas";
				put "/*** HELP START ***//*" ;
				put ;
				put help ;
				put ;
				put "*//*** HELP END ***/" ;
				put ;
				code = symget('sas_code_text');
				put code;
			run;
		%end;
	%end;
%end;
%mend;
