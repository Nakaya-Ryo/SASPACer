# SASPACer (latest version 0.3.6 on 16Oct2025)
A SAS package to help creating SAS packages

![logo](https://github.com/Nakaya-Ryo/SASPACer/blob/main/saspacer_logo_small.png)
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<img src="https://github.com/Nakaya-Ryo/SASPACer/blob/main/onigiri.png?raw=true" alt="onigiri" width="300"/>

**"サスパッカー"** in the logo stands for **SASPACer** in Japanese. The package is to help creating SAS packages. <br>Shaping onigiri(rice ball) by hands can be a bit challenging for beginners, but using onigiri mold makes it easy to form and provides a great introduction. Hope the mold(SASPACer) will help you to create your SAS package.

## %ex2pac() : excel to package
1. **Put information** of SAS package you want to create **into an excel spreadsheet** <br>(you can find template files in ./SASPACer/addcnt (simple_example.xlsx for simple example you can test as is, and template_package.xlsx for template contents for reference))
![excel](./excel_image.png)
2. %ex2pac() will convert the excel spreadsheet into SAS package structure(folders and files) and execute %generatePackage() (optional) for package zip file

Sample code:
~~~sas
%ex2pac(
	excel_file=C:\Temp\template_package.xlsx,		/* Path of input excel file */
	package_location=C:\Temp\SAS_PACKAGES\packages,		/* Output path */
	complete_generation=Y)					/* Set Y(default) to execute %generagePackage() for completion */
~~~
This allows you to create SAS packages via simple format of excel!  
You can learn from the following training materials by Bartosz Jablonski for source files and folders structure of SAS packages.  
[My first SAS Package -a How To](https://github.com/yabwon/SAS_PACKAGES/blob/main/SPF/Documentation/SAS(r)%20packages%20-%20the%20way%20to%20share%20(a%20how%20to)-%20Paper%204725-2020%20-%20extended.pdf)   
[SAS Packages - The Way To Share (a How To)](https://github.com/yabwon/SAS_PACKAGES/blob/main/SPF/Documentation/SAS(r)%20packages%20-%20the%20way%20to%20share%20(a%20how%20to)-%20Paper%204725-2020%20-%20extended.pdf)  

## %pac2ex() : package to excel  
It's very simple. You can convert package zip file into excel file with package information.   

Sample code:
~~~sas
%pac2ex(
	zip_path=C:\Temp\packagename.zip,		/* Path of package zip file */
	xls_path=C:\Temp\package_info.xlsx,		/* Output excel path */
	overwrite=N,				/* Set N not to overwrite (default is Y) */
	kill=Y)						/* Set Y to delete all datasets in PAC2EX lib in WORK (default is N) */
~~~

## Version history  
0.3.6(16October2025) : Modified template_package.xlsx in addcnt to have template help   
0.3.5(4October2025) : Added tests to source package and added test_example.xlsx in addcnt    
0.3.4(2September2025) : Modified to allow at most 32bytes name of contents(macros) in %pac2ex  
0.3.3(28August2025)	: Modified to allow not having license sheet in %ex2pac  
0.3.2(26August2025)	: Minor updates in %pac2ex  
0.3.1(26August2025)	: Polished overall codes. Added overwrite= argument in %pac2ex  
0.3.0(18August2025)	: AdditionalContents(addcnt) was modified (changed folder name in excel from "macros" to "macro")  
0.2.3(6August2025)	: AdditionalContents(addcnt) was modified  
0.2.2(4August2025)	: Polished code in %ex2pac()  
0.2.1(29July2025)	: Changed excel engine to xlsx engine in %pac2ex()  
0.2.0(17July2025)	: Added %pac2ex()  
0.1.1(9July2025)	: Minor updates in excel templates and cosmetic change in license(no change in contents)  
0.1.0(29June2025)	: Modified logic (overwriting existing package folder -> Stop with error message to clear up the existing package folder(user should empty the existing folder first))  
0.0.5(14June2025)	: easyArch=1 was set in %generatePackage() used in complete_generation=Y  
0.0.4(29May2025)	: Codes were brushed up and enhanced documents  
0.0.3(20April2025)	: Bugs fixed and enhanced documents (separated internal macros, fixed bugs, limitations and notes added)  
0.0.2(20April2025)	: Minor updates  
0.0.1(13April2025)	: Initial version

---

## What is SAS Packages?

The package is built on top of **SAS Packages Framework(SPF)** developed by Bartosz Jablonski.

For more information about the framework, see [SAS Packages Framework](https://github.com/yabwon/SAS_PACKAGES).

You can also find more SAS Packages (SASPacs) in the [SAS Packages Archive(SASPAC)](https://github.com/SASPAC).

## How to use SAS Packages? (quick start)

### 1. Set-up SAS Packages Framework

First, create a directory for your packages and assign a `packages` fileref to it.

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~sas
filename packages "\path\to\your\packages";
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Secondly, enable the SAS Packages Framework.
(If you don't have SAS Packages Framework installed, follow the instruction in 
[SPF documentation](https://github.com/yabwon/SAS_PACKAGES/tree/main/SPF/Documentation) 
to install SAS Packages Framework.)

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~sas
%include packages(SPFinit.sas)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


### 2. Install SAS package

Install SAS package you want to use with the SPF's `%installPackage()` macro.

- For packages located in **SAS Packages Archive(SASPAC)** run:
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~sas
  %installPackage(packageName)
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- For packages located in **PharmaForest** run:
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~sas
  %installPackage(packageName, mirror=PharmaForest)
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- For packages located at some network location run:
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~sas
  %installPackage(packageName, sourcePath=https://some/internet/location/for/packages)
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  (e.g. `%installPackage(ABC, sourcePath=https://github.com/SomeRepo/ABC/raw/main/)`)


### 3. Load SAS package

Load SAS package you want to use with the SPF's `%loadPackage()` macro.

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~sas
%loadPackage(packageName)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


### Enjoy!

---
