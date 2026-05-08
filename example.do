/********************************************************************
  pmean example file
  Version 2.0.2

  This file demonstrates the main features of -pmean- on two
  Stata-supplied panel datasets:

      webuse grunfeld       (10 firms x 20 years; 2D)
      webuse productivity   (48 states x 17 years x 9 BEA regions; 3D)

  Once -pmean- is installed (via SSC or net install from this repo),
  open this do-file and step through it.
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

* Inspect a few of the new returns introduced in v2.0.2:
display "r(N)       = " r(N)
display "r(cmd)     = " r(cmd)
display "r(cmdline) = " r(cmdline)

*------------------------------------------------------------
* Example 2: listwise sample across multiple outcomes
*           (a common sample is enforced)
*------------------------------------------------------------

pmean invest mvalue kstock, id(company) time(year) listwise replace

*------------------------------------------------------------
* Example 3: three-dimensional panel decomposition
*           (Munnell public-capital panel:
*            48 states x 17 years x 9 BEA regions)
*
*    Note: -gsp-, -private-, -emp-, -public-, etc. in the
*    productivity dataset are already log-transformed by
*    Stata; do NOT re-log them.
*------------------------------------------------------------

webuse productivity, clear
xtset state year

pmean gsp, id(state) time(year) dim3(region) replace

describe pm_*
list gsp pm_idmean_gsp pm_timemean_gsp pm_dim3mean_gsp pm_threefe_gsp in 1/10

* Summary table and CSV export
pmean gsp, id(state) time(year) dim3(region) table save(pmean_summary.csv) replace

*------------------------------------------------------------
* Example 4: full pairwise three-dimensional decomposition
*------------------------------------------------------------

* Note: -region- nests -state-, so pmean v2.0.2 prints an
* informational note that the id-by-region interaction is
* collinear with the between-region component. The additive
* identity still holds.
pmean gsp, id(state) time(year) dim3(region) full genprefix(p2_) replace

describe p2_*
list gsp p2_idtime_mean_gsp p2_iddim3_mean_gsp p2_timedim3_mean_gsp p2_threeway_gsp in 1/10

*------------------------------------------------------------
* Clean up example export file
*------------------------------------------------------------

capture erase pmean_summary.csv
