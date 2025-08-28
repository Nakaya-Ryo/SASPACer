Type: Package
Package: SASPACer
Title: SASPACer to create SAS package using excel file
Version: 0.3.3
Author: Ryo Nakaya (nakaya.ryou@gmail.com)
Maintainer: Ryo Nakaya (nakaya.ryou@gmail.com)
License: MIT
Encoding: UTF8
Required: "Base SAS Software", "SAS/access interface to PC files"
           
DESCRIPTION START:

### SASPACer ###

This is a package for easily creating SAS packages.

All you need is to fill package information in the template excel 
(you can find it in additional contents).
`SASPACer` has a macro(`%ex2pac()`) to convert excel with package information into
SAS package folders and files, and generate SAS package using the `%generatePackage()`
macro (the generation is optional but executed by default).

macro(`%pac2ex()`) can convert package zip file into excel file with package information as well.

list of macros:  
- `%ex2pac()`  
- `%pac2ex()`  

### References ###
1. Bartosz Jablonski, "My First SAS Package - a How To", SGF Proceedings, Paper 1079-2021, 
   https://communities.sas.com/t5/SAS-Global-Forum-Proceedings/My-First-SAS-Package-A-How-To/ta-p/726319
   https://communities.sas.com/kntur85557/attachments/kntur85557/proceedings-2021/59/1/Paper_1079-2021.pdf

---

DESCRIPTION END:
