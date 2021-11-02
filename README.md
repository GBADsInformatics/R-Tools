[![CC BY-NC-SA 4.0][cc-by-nc-sa-shield]][cc-by-nc-sa]

# R Tools
R tools to access, use, and visualize data

# Files
## GBADsAPI.R 

*Description* 
R code to access GBADs Public API. Currently supported - livestock population numbers from OIE and FAOSTAT QCL dataset 

*Dependencies* 
library(RCurl)
library(httr)

*Functions* 
1. `get_all_tables`
* Lists all available tables in the API 

2. `livestock_population` 
* Accepts `year`, `country`, `species`, `source` and `destfile` as parameters where source is either oie or faostat
* Default destination file for downloaded data is output.csv



This work is licensed under a
[Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License][cc-by-nc-sa].

[![CC BY-NC-SA 4.0][cc-by-nc-sa-image]][cc-by-nc-sa]

[cc-by-nc-sa]: http://creativecommons.org/licenses/by-nc-sa/4.0/
[cc-by-nc-sa-image]: https://licensebuttons.net/l/by-nc-sa/4.0/88x31.png
[cc-by-nc-sa-shield]: https://img.shields.io/badge/License-CC%20BY--NC--SA%204.0-lightgrey.svg
