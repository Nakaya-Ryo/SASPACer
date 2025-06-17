# SASPACer (latest version 0.0.5 on 14June2025)
A SAS package to help creating SAS packages

![logo](https://github.com/Nakaya-Ryo/SASPACer/blob/main/saspacer_logo_small.png)

**"サスパッカー"** in the logo stands for **SASPACer** in Japanese. The package is to help creating SAS packages. <br>Shaping onigiri(rice ball) by hands can be a bit challenging for beginners, but using onigiri mold makes it easy to form and provides a great introduction. Hope the mold(SASPACer) will help you to create your SAS package.

## %ex2pac() : excel to package
1. **Put information** of SAS package you want to create **into an excel file** <br>(you can find template file in ./SASPACer/addcnt)
![excel](./excel_image.png)
2. %ex2pac(excel_file, package_location, complete_generation) will convert the excel into SAS package structure(folders and files) and execute %generatePackage() (optional) to package zip file

Sample code:
~~~sas
%ex2pac(
	excel_file=C:\Temp\template_package.xlsx,   /* Path of input excel file */
	package_location=C:\Temp\SAS_PACKAGES\packages,   /* Output path */
	complete_generation=Y)   /* Set Y(default) to execute %generagePackage() for completion */
~~~
**This allows you to create SAS packages via simple format of excel!**

## %pac2ex() : package to excel
Under construction, stay tuned!

## How to use SASPACer? (quick start)
Create directory for your packages and assign a fileref to it.
~~~sas
filename packages "\path\to\your\packages";
~~~
 
Enable the SAS Packages Framework (if you have not done it yet):
~~~sas
%include packages(SPFinit.sas)
~~~
 
(If you don't have SAS Packages Framework installed follow the [instruction](https://github.com/yabwon/HoW-SASPackages/blob/main/Share%20your%20code%20with%20SAS%20Packages%20-%20a%20Hands-on-Workshop.md#how-to-install-the-sas-packages-framework).)
 
 
When you have SAS Packages Framework enabled, run the following to install and load the package:
 
~~~sas
 
/* Install and load SASPACer */
%installPackage(SASPACer, sourcePath=https://github.com/Nakaya-Ryo/SASPACer/raw/main/)   /* Install SASPACer to your place */
%loadPackage(SASPACer)
 
/* Enjoy SASPACer😄 */
%ex2pac(
  excel_file=C:\Temp\simple_example.xlsx,
  package_location=C:\Temp\SAS_PACKAGES\packages,
  complete_generation=Y
)
~~~
You can learn from the following training materials by Bartosz Jablonski for source files and folders structure of SAS packages.  
[My first SAS Package -a How To](https://github.com/yabwon/SAS_PACKAGES/blob/main/SPF/Documentation/SAS(r)%20packages%20-%20the%20way%20to%20share%20(a%20how%20to)-%20Paper%204725-2020%20-%20extended.pdf)   
[SAS Packages - The Way To Share (a How To)](https://github.com/yabwon/SAS_PACKAGES/blob/main/SPF/Documentation/SAS(r)%20packages%20-%20the%20way%20to%20share%20(a%20how%20to)-%20Paper%204725-2020%20-%20extended.pdf)

## Version history
0.0.5(14June2025)	: easyArch=1 was set in %generatePackage() used in complete_generation=Y  
0.0.4(29May2025)	: Codes were brushed up and enhanced documents  
0.0.3(20April2025)	: Bugs fixed and enhanced documents (separated internal macros, fixed bugs, limitations and notes added)  
0.0.2(20April2025)	: Minor updates  
0.0.1(13April2025)	: Initial version

## What is SAS Packages?
SASPACer is built on top of **SAS Packages framework(SPF)** developed by Bartosz Jablonski.  
For more information about SAS Packages framework, see [SAS_PACKAGES](https://github.com/yabwon/SAS_PACKAGES).  
You can also find more SAS Packages(SASPACs) in [SASPAC](https://github.com/SASPAC).


