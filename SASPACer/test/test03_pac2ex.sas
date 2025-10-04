/*** HELP START ***//*

### Purpose:
- Unit test for the %pac2ex() macro

### Expected result:  
- Macro will be aborted with error stating existence of output excel file since overwrite=N.

### Notes:
- simplepackage.zip used in the test should be placed beforehand. Meanwhile, it can be coordinated by running test01_ex2pac.sas
  in test before the test and test01_ex2pac.sas would create simplapackage.zip.  .
- The test assumed Windows system, while linux system can be tested separately.
- Users who want to run the test in their own environment, change paths in parameters accordingly.

*//*** HELP END ***/

%pac2ex(
  zip_path=C:\Temp\SimplePackage\simplepackage.zip,
  xls_path=C:\Temp\simplepackage_info.xlsx,
  overwrite=N,
  kill=Y
)
