/********************************************************************
  pmean example file
  Version 2.0.2
********************************************************************/

clear all
set more off

*------------------------------------------------------------
* Example 1: two-dimensional panel decomposition
*           (Grunfeld investment panel, 10 firms x 20 years)
*------------------------------------------------------------

webuse grunfeld, clear
xtset company year

pmean invest mvalue, id(company) time(year) replace

describe pm_*
return list

*------------------------------------------------------------
* Example 2: listwise sample across multiple outcomes
*           (a common sample is enforced)
*------------------------------------------------------------

pmean invest mvalue kstock, id(company) time(year) listwise replace

*------------------------------------------------------------
* Example 3: three-dimensional panel decomposition
*           (Munnell public-capital panel:
*            48 states x 17 years x 9 BEA regions)
*------------------------------------------------------------

webuse productivity, clear
xtset state year
gen lngsp = ln(gsp)

pmean lngsp, id(state) time(year) dim3(region) replace

describe pm_*
list lngsp pm_idmean_lngsp pm_timemean_lngsp pm_dim3mean_lngsp pm_threefe_lngsp in 1/10

* Summary table and CSV export
pmean lngsp, id(state) time(year) dim3(region) table save(pmean_summary.csv) replace

*------------------------------------------------------------
* Example 4: full pairwise three-dimensional decomposition
*------------------------------------------------------------

* Note: -region- nests -state-, so pmean v2.0.2 prints an
* informational note that the id-by-region interaction is
* collinear with the between-region component.
pmean lngsp, id(state) time(year) dim3(region) full genprefix(p2_) replace

describe p2_*
list lngsp p2_idtime_mean_lngsp p2_iddim3_mean_lngsp p2_timedim3_mean_lngsp p2_threeway_lngsp in 1/10

*------------------------------------------------------------
* Clean up example export file
*------------------------------------------------------------

capture erase pmean_summary.csv
