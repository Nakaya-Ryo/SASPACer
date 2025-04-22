# SASPACer (latest version 0.0.3 on 20April2025)
A SAS package to help creating SAS packages

![logo](https://github.com/Nakaya-Ryo/SASPACer/blob/main/saspacer_logo_small.png)

(サスパッカー in the logo is SASPACer in Japanese. Shaping onigiri(rice ball) by hands can be a bit challenging for beginners, but using onigiri mold makes it easy to form and provides a great introduction. I hope the mold(SASPACer) will help users to create SAS packages.)

## %ex2pac() : excel to package
1. **Put information** of SAS package you want to create **into an excel file**
2. %ex2pac(excel_file, package_location, complete_generation) will convert the excel(Use template_package_meta.xlsx) into SAS package structure(folders and files) and %generatePackage() (optional) at the end
   

**This allows you to create SAS packages via simple format of excel!**

## version history
0.0.3(20April2025): Bugs fixed and enhanced documents (separated internal macros, fixed bugs, limitations and notes added)
0.0.2(20April2025): Minor updates<br>
0.0.1(13April2025): Initial version

## What is SAS Packages?
SASPACer is built on top of **SAS Packages framework(SPF)** created by Bartosz Jablonski.  
For more on SAS Packages framework, see [SAS_PACKAGES](https://github.com/yabwon/SAS_PACKAGES).<br>
You can also find more SAS Packages(SASPAC) in [SASPAC](https://github.com/SASPAC).

