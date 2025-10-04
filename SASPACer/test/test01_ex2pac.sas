/*** HELP START ***//*

### Purpose:
- Unit test for the %ex2pac() macro

### Expected result:  
- A package folder with source files and package zip file is to be created in the location successfully.  
- A warning, which states no license.sas in source but it is within SPF rule and license.sas, will be generated with MIT in zip.  
- Error wil be expected if there is an existing folder for package. Need not to have the folder to avoid error.  

### Notes:
- **simple_example.xlsx needs to be placed** in a folder in advance to run the test.
- **Folder for the package should not exist** when the test is run, otherwise test will stop not to overwrite the existing folder.
- The test assumed Windows system, while linux system can be tested separately.
- Users who want to run the test in their own environment, change paths in parameters accordingly.

*//*** HELP END ***/

%ex2pac(
	excel_file=C:\Temp\SAS_PACKAGES\packages\SASPACer\addcnt\simple_example.xlsx,
	package_location=C:\Temp,
	complete_generation=Y)
