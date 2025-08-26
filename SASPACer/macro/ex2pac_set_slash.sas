/*** HELP START ***//*

This is internal utility macro used in `%ex2pac`.

Purpose:
To switch separator character (slash or back slash) based on OS.

*//*** HELP END ***/

/*--macro used in ex2pac--*/
%macro ex2pac_set_slash(); /*switch slash character based on OS*/
  %if &SYSSCP. = WIN %then /*when Windows*/
    %do; \ %end;
  %else /*other than Windows*/
    %do; / %end;
%mend;
