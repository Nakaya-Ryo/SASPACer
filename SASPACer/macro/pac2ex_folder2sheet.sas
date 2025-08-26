/*** HELP START ***//*

This is internal utility macro used in `%pac2ex`.

Purpose:
To output contents into excel sheet.

*//*** HELP END ***/

/*--macro used in pac2ex--*/
%macro pac2ex_folder2sheet() ;
    %local i nfolders fname sheet contnames nmacros j macroj setstmt;
    %let nfolders = %sysfunc(countw(&folders, %str( )));

    %do i = 1 %to &nfolders;
        %let fname = %scan(&folders, &i, %str( ));
        %let sheet = %sysfunc(compress(&fname));

        /* obtain contname for foldername */
        proc sql noprint;
            select contname into :contnames separated by ' '
            from _PAC2EX_TMP01
            where foldername = "&fname" and not missing(contname);
        quit;

        /* constructing set */
        %let nmacros = %sysfunc(countw(&contnames, %str( )));
        %let setstmt = ;
        %do j = 1 %to &nmacros;
            %let macroj = %scan(&contnames, &j, %str( ));
            %let setstmt = &setstmt _PAC2EX_FINAL_&macroj;
        %end;
		
		/* output */
        data xlout.&sheet;
            set &setstmt;
        run;
    %end;
%mend;
