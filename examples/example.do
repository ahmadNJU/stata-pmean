/********************************************************************
  pmean example file
  Version 2.0.0
********************************************************************/

clear all
set more off

*------------------------------------------------------------
* Example 1: two-dimensional panel decomposition
*------------------------------------------------------------

sysuse auto, clear

gen year = 2000 + mod(_n, 5)
gen id   = mod(_n, 3)

pmean price mpg, id(id) time(year) replace

describe pm_*
return list

*------------------------------------------------------------
* Example 2: three-dimensional panel decomposition
*------------------------------------------------------------

sysuse auto, clear

gen year   = 2000 + mod(_n, 5)
gen id     = mod(_n, 3)
gen sector = mod(_n, 4)

pmean price mpg weight, id(id) time(year) dim3(sector) replace

describe pm_*
list price pm_idmean_price pm_timemean_price pm_dim3mean_price pm_threefe_price in 1/10

* Summary table and CSV export
pmean price mpg, id(id) time(year) dim3(sector) table save(pmean_summary.csv) replace

*------------------------------------------------------------
* Example 3: full pairwise three-dimensional decomposition
*------------------------------------------------------------

pmean price, id(id) time(year) dim3(sector) full genprefix(p2_) replace

describe p2_*
list price p2_idtime_mean_price p2_iddim3_mean_price p2_timedim3_mean_price p2_threeway_price in 1/10

*------------------------------------------------------------
* Clean up example export file
*------------------------------------------------------------

capture erase pmean_summary.csv
