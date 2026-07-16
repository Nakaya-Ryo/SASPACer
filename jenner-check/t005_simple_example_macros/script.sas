/* jenner-check bundle: the macros and function embedded in Nakaya-Ryo/
   SASPACer's own SASPACer/addcnt/simple_example.xlsx -- the template excel
   file the README tells new users to try %ex2pac() against first ("you can
   test as is"). The macro/function bodies below are extracted verbatim from
   the xlsx's shared-strings table (myhello, myhello2, hellofun) and run in
   sequence exactly as SASPACer's %ex2pac_allname() would write them out as
   package members. Extracting the cell text out of the xlsx and running it
   directly is the substitution; every macro/function body is unmodified. */

/* --- simple_example.xlsx, "macro" sheet, member "myhello", unmodified --- */
%macro myhello() ;
%put "Hello, SAS world!" ;
%mend ;

/* --- simple_example.xlsx, "macro" sheet, member "myhello2", unmodified --- */
%macro myhello2(obj=) ;
%put "Hello, &obj.!" ;
%mend ;

/* --- simple_example.xlsx, "functions" sheet, member "hellofun", unmodified --- */
proc fcmp outlib=work.funcs.simple;
function hellofun(str $) $ 128;
  return(catx(" ", "Hello", str, "!!"));
endfunc;
run;
options cmplib=work.funcs;

%myhello()
%myhello2(obj=Taro)

data _null_;
	greeting = hellofun("Jenner");
	put greeting=;
run;
