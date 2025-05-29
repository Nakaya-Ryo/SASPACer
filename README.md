# SASPACer (latest version 0.0.4 on 29May2025)
A SAS package to help creating SAS packages

![logo](https://github.com/Nakaya-Ryo/SASPACer/blob/main/saspacer_logo_small.png)

"サスパッカー" in the logo stands for **SASPACer** in Japanese. The package is to help creating SAS packages. <br>Shaping onigiri(rice ball) by hands can be a bit challenging for beginners, but using onigiri mold makes it easy to form and provides a great introduction. I hope the mold(SASPACer) will help you to create your SAS package.

## %ex2pac() : excel to package
1. **Put information** of SAS package you want to create **into an excel file** <br>(you can find template file in ./SASPACer/addcnt)
2. %ex2pac(excel_file, package_location, complete_generation) will convert the excel into SAS package structure(folders and files) and execute %generatePackage() (optional) to package zip file

Sample code:
~~~sas
%ex2pac(
	excel_file=C:\Temp\template_package_meta.xlsx,   /* Path of input excel file */
	package_location=C:\Temp\SAS_PACKAGES\packages,   /* Output path */
	complete_generation=Y)   /* Set Y(default) to execute %generagePackage() for completion */
~~~
**This allows you to create SAS packages via simple format of excel!**

## %pac2ex() : package to excel
Under construction, stay tuned!

## Version history
0.0.4(29May2025)	: Codes were brushed up and enhanced documents 
0.0.3(20April2025)	: Bugs fixed and enhanced documents (separated internal macros, fixed bugs, limitations and notes added)  
0.0.2(20April2025)	: Minor updates  
0.0.1(13April2025)	: Initial version

## What is SAS Packages?
SASPACer is built on top of **SAS Packages framework(SPF)** developed by Bartosz Jablonski.  
For more information about SAS Packages framework, see [SAS_PACKAGES](https://github.com/yabwon/SAS_PACKAGES).<br>
You can also find more SAS Packages(SASPACs) in [SASPAC](https://github.com/SASPAC).

## How to use SASPACer? (quick start)
~~~sas
/* Preparation to use SPF(core of SASPAC) */
filename packages "/path/to/your/folder";   /* OK for Win/Unix/Linux */
filename SPFinit url "https://raw.githubusercontent.com/yabwon/SAS_PACKAGES/main/SPF/SPFinit.sas";   /* SPF */
%include SPFinit;   /* include SPF */

/* Install and load SASPACer */
%installPackage(SASPACer, sourcePath=https://github.com/Nakaya-Ryo/SASPACer/raw/main/)   /* Install SASPACer to your place */
%loadPackage(SASPACer)

/* Enjoy SASPACer😁 */
%ex2pac(
	excel_file=C:\Temp\template_package_meta.xlsx,
	package_location=C:\Temp\SAS_PACKAGES\packages,
	complete_generation=Y
)
~~~

