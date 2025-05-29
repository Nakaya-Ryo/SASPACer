/*** HELP START ***//*

This is internal utility macro used in `%ex2pac`.

Purpose:
To switch sepalator character (slash or back slash) based on OS.

*//*** HELP END ***/

/*--macro used in ex2pac--*/
%macro ex2pac_set_slash(); /*switch slash character based on OS*/
  %global slash;
  %if %index(%upcase(&SYSSCP), WIN) > 0 %then /*when Windows*/
    %let slash = \;
  %else /*other than Windows*/
    %let slash = /;
%mend;
