﻿# Documentation for the `SASPACer` package.
  
----------------------------------------------------------------
 
 *SASPACer to create SAS package using meta excel file* 
  
----------------------------------------------------------------
 
### Version information:
  
- Package: SASPACer
- Version: 0.0.1
- Generated: 2025-04-18T16:25:00
- Author(s): Ryo Nakaya (nakaya.ryou@gmail.com)
- Maintainer(s): Ryo Nakaya (nakaya.ryou@gmail.com)
- License: MIT
- File SHA256: `F*2DADD4E4B8243B353174C200908B95924405B45067ADDA64293804CB7462F01B` for this version
- Content SHA256: `C*52522B2D882826755C8FE37CE0A22C32827F9245188D4679F6FA8C6102166B58` for this version
  
---
 
# The `SASPACer` package, version: `0.0.1`;
  
---
 

### SASPACer ###
This is a package easily to create SAS packages.
Only you need is to fill package information in the template excel.
SASPACer has a function(ex2pac) to convert excel with package information into
SAS package folders and files.

  
---
 
  
---
 
Required SAS Components: 
  - Base SAS Software
  
---
 
 
--------------------------------------------------------------------
 
*SAS package generated by SAS Package Framework, version `20241207`*
 
--------------------------------------------------------------------
 
# The `SASPACer` package content
The `SASPACer` package consists of the following content:
 
1. [`%ex2pac()` macro ](#ex2pac-macros-1 )
  
 
2. [License note](#license)
  
---
 
## `%ex2pac()` macro <a name="ex2pac-macros-1"></a> ######

%ex2pac is a macro to convert excel with package information into
SAS package folders and files.

- Parameters
	excel_file :
		full path for excel file which contains package information
	package_location :
		location where package files to be stored.
		Subfolder named package name will be created under the location.

- Excel file to read
	Easy to understand the structure. Take a look at it anyway.
	In sheets like macros, %ex2pac uses body information if body column is filled,
	while refers file in location column if body column is blank.
	(This is a situation where macros(or other files) were already created somewhere in a file and
	would like to use it instead of copying contents in body column of the excel.)

- Flow of the macro
	1. Create package subfolder in the location.
		Name of the subfolder will be set as the package name.
	2. Create description.sas
	3. Create license.sas
	4. Create subfolders like 01_formats, 02_functions, etc. in reference to
		the excel sheet names.
	5. Create sas files based on information described in each excel sheet
	6. Run %generatePackages()

- Sample code
%ex2pac(
	excel_file=C:\Temp\template_package_meta.xlsx,
	package_location=C:\Temp\SAS_PACKAGES\packages) ;


  
---
 
  
---
 
# License <a name="license"></a> ######
 
	Copyright (c) [2025] [Ryo Nakaya]

  Permission is hereby granted, free of charge, to any person obtaining a copy  
  of this software and associated documentation files (the "Software"), to deal 
  in the Software without restriction, including without limitation the rights  
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell     
  copies of the Software, and to permit persons to whom the Software is         
  furnished to do so, subject to the following conditions:                      
                                                                                
  The above copyright notice and this permission notice shall be included       
  in all copies or substantial portions of the Software.                        
                                                                                
  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR    
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,      
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE   
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER        
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE 
  SOFTWARE.                                                                 
 
  
---
 
