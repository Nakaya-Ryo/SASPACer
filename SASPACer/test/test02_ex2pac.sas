/*** HELP START ***//*

### Purpose:
- Unit test for the %ex2pac() macro

### Expected result:  
- A package folder with source files is to be created (but zip file will not be created) in the location successfully.
- Error wil be expected if there is an existing folder for package. Need not to have the folder to avoid error.  
- mcrTwo.sas with help information added will be created in the source reading original mcrTwo.sas in addcnt.

### Notes:
- **test_example.xlsx needs to be placed** in a folder in advance to run the test.
- **Folder for the package should not exist** when the test is run, otherwise test will stop not to overwrite the existing folder.
- The test assumed Windows system, while linux system can be tested separately.
- Users who want to run the test in their own environment, change paths in parameters and in test_example.xlsx accordingly.

*//*** HELP END ***/

%ex2pac(
	excel_file=C:\Temp\SAS_PACKAGES\packages\SASPACer\addcnt\test_example.xlsx,
	package_location=C:\Temp,
	complete_generation=N)
