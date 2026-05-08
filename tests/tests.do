/********************************************************************
  pmean test file
  Version 2.0.2
********************************************************************/

version 15.1
clear all
set more off
set seed 12345

*------------------------------------------------------------
* 1. Backward-compatible two-dimensional formulas
*------------------------------------------------------------

clear
input id time x y
1 1 10 1
1 2 20 2
2 1 30 3
2 2 40 4
end

pmean x y, id(id) time(time) replace
local mode = r(mode)
local dims = r(dimensions)

assert abs(pm_overall_x - 25) < 1e-10
assert abs(pm_idmean_x - 15) < 1e-10 if id == 1
assert abs(pm_idmean_x - 35) < 1e-10 if id == 2
assert abs(pm_timemean_x - 20) < 1e-10 if time == 1
assert abs(pm_timemean_x - 30) < 1e-10 if time == 2
assert abs(pm_within_id_x + 5) < 1e-10 if id == 1 & time == 1
assert abs(pm_within_id_x - 5) < 1e-10 if id == 1 & time == 2
assert abs(pm_between_id_x + 10) < 1e-10 if id == 1
assert abs(pm_between_id_x - 10) < 1e-10 if id == 2
assert abs(pm_between_time_x + 5) < 1e-10 if time == 1
assert abs(pm_between_time_x - 5) < 1e-10 if time == 2
assert abs(pm_twfe_x) < 1e-10

assert abs(pm_overall_y - 2.5) < 1e-10
assert abs(pm_twfe_y) < 1e-10
assert `dims' == 2
assert "`mode'" == "2D"

* Existing generated variables should require replace
capture noisily pmean x, id(id) time(time)
assert _rc == 110

* save() should require table
capture noisily pmean x, id(id) time(time) save(pmean_should_not_exist.csv) replace
assert _rc == 198
capture erase pmean_should_not_exist.csv

* full should require dim3()
capture noisily pmean x, id(id) time(time) full replace
assert _rc == 198

*------------------------------------------------------------
* 2. Explicit additive-identity check (2D)
*------------------------------------------------------------

gen identity2d = pm_overall_x + pm_between_id_x + pm_between_time_x + pm_twfe_x - x
summarize identity2d
assert abs(r(mean)) < 1e-10
assert abs(r(sd))   < 1e-10
drop identity2d

*------------------------------------------------------------
* 3. Three-dimensional main-effect decomposition
*------------------------------------------------------------

clear
input id time sector x
1 1 1 111
1 1 2 112
1 2 1 121
1 2 2 122
2 1 1 211
2 1 2 212
2 2 1 221
2 2 2 222
end

pmean x, id(id) time(time) dim3(sector) replace
local mode = r(mode)
local dims = r(dimensions)
local dim3 = r(dim3)

assert abs(pm_overall_x - 166.5) < 1e-10
assert abs(pm_idmean_x - 116.5) < 1e-10 if id == 1
assert abs(pm_idmean_x - 216.5) < 1e-10 if id == 2
assert abs(pm_timemean_x - 161.5) < 1e-10 if time == 1
assert abs(pm_timemean_x - 171.5) < 1e-10 if time == 2
assert abs(pm_dim3mean_x - 166) < 1e-10 if sector == 1
assert abs(pm_dim3mean_x - 167) < 1e-10 if sector == 2
assert abs(pm_between_dim3_x + 0.5) < 1e-10 if sector == 1
assert abs(pm_between_dim3_x - 0.5) < 1e-10 if sector == 2
assert abs(pm_threefe_x) < 1e-10
assert `dims' == 3
assert "`mode'" == "3D"
assert "`dim3'" == "sector"

*------------------------------------------------------------
* 4. Explicit additive-identity check (3D main effects)
*------------------------------------------------------------

gen identity3main = pm_overall_x + pm_between_id_x + pm_between_time_x ///
                  + pm_between_dim3_x + pm_threefe_x - x
summarize identity3main
assert abs(r(mean)) < 1e-10
assert abs(r(sd))   < 1e-10
drop identity3main

*------------------------------------------------------------
* 5. Full pairwise three-dimensional decomposition + identity
*------------------------------------------------------------

pmean x, id(id) time(time) dim3(sector) full replace

assert abs(pm_idtime_mean_x - 111.5) < 1e-10 if id == 1 & time == 1
assert abs(pm_iddim3_mean_x - 116) < 1e-10 if id == 1 & sector == 1
assert abs(pm_timedim3_mean_x - 161) < 1e-10 if time == 1 & sector == 1
assert abs(pm_idtime_comp_x) < 1e-10
assert abs(pm_iddim3_comp_x) < 1e-10
assert abs(pm_timedim3_comp_x) < 1e-10
assert abs(pm_threeway_x) < 1e-10

* Full ANOVA identity
gen identity3full = pm_overall_x + pm_between_id_x + pm_between_time_x ///
                  + pm_between_dim3_x + pm_idtime_comp_x ///
                  + pm_iddim3_comp_x + pm_timedim3_comp_x ///
                  + pm_threeway_x - x
summarize identity3full
assert abs(r(mean)) < 1e-10
assert abs(r(sd))   < 1e-10
drop identity3full

* Summary table export in 3D mode
tempfile pmtable
pmean x, id(id) time(time) dim3(sector) table save(`pmtable') replace
confirm file `pmtable'

* Custom prefix
pmean x, id(id) time(time) dim3(sector) genprefix(p2_) replace
confirm variable p2_threefe_x

*------------------------------------------------------------
* 6. Missing identifiers are excluded from the command sample
*------------------------------------------------------------

clear
input id time sector x
1 1 1 10
1 2 1 20
. 1 1 30
2 . 1 40
2 2 . 50
end

pmean x, id(id) time(time) dim3(sector) replace

assert abs(pm_overall_x - 15) < 1e-10 if !missing(id, time, sector)
assert missing(pm_overall_x) if missing(id) | missing(time) | missing(sector)
assert missing(pm_threefe_x) if missing(id) | missing(time) | missing(sector)

* if restriction
pmean x if id == 1, id(id) time(time) dim3(sector) genprefix(s_) replace
assert abs(s_overall_x - 15) < 1e-10 if id == 1
assert missing(s_overall_x) if id != 1

*------------------------------------------------------------
* 7. NEW in 2.0.1: listwise option enforces a common sample
*------------------------------------------------------------

clear
input id time x y
1 1 10  1
1 2 20  .
2 1 30  3
2 2 40  4
end

* Without listwise, x is averaged over all 4 obs;
* y over the 3 non-missing obs.
pmean x y, id(id) time(time) replace
assert abs(pm_overall_x - 25)        < 1e-10        // mean of (10,20,30,40)
assert abs(pm_overall_y - 8/3)       < 1e-10        // mean of (1,3,4)

* With listwise, x is averaged only over obs where BOTH x and y are
* non-missing -- that excludes (id=1, time=2).
pmean x y, id(id) time(time) listwise replace
assert abs(pm_overall_x - 80/3) < 1e-10             // mean of (10,30,40)
assert abs(pm_overall_y - 8/3)  < 1e-10             // mean of (1,3,4)
assert missing(pm_overall_x) if id == 1 & time == 2 // dropped under listwise
assert missing(pm_overall_y) if id == 1 & time == 2

*------------------------------------------------------------
* 8. NEW in 2.0.1: nested dim3 detection (informational note)
*    -- should not error; computation should still satisfy
*       the additive identity.
*------------------------------------------------------------

clear
input id time region x
1 1 1 10
1 2 1 12
2 1 1 20
2 2 1 22
3 1 2 30
3 2 2 32
4 1 2 40
4 2 2 42
end

* region nests id (each id has a unique region). pmean prints a note.
pmean x, id(id) time(time) dim3(region) full replace

* Identity still holds.
gen ident = pm_overall_x + pm_between_id_x + pm_between_time_x ///
          + pm_between_dim3_x + pm_idtime_comp_x ///
          + pm_iddim3_comp_x + pm_timedim3_comp_x ///
          + pm_threeway_x - x
summarize ident
assert abs(r(mean)) < 1e-10
assert abs(r(sd))   < 1e-10
drop ident

* Verify the algebraic consequence of nesting:
*   pm_iddim3_comp_x == -pm_between_dim3_x
gen check_nest = pm_iddim3_comp_x + pm_between_dim3_x
summarize check_nest
assert abs(r(mean)) < 1e-10
assert abs(r(sd))   < 1e-10
drop check_nest

*------------------------------------------------------------
* 9. String identifiers and string third dimension
*------------------------------------------------------------

clear
input str1 firm int year str1 sector double x
"A" 2020 "M" 1
"A" 2021 "M" 3
"B" 2020 "S" 5
"B" 2021 "S" 7
end

pmean x, id(firm) time(year) dim3(sector) replace
assert abs(pm_overall_x - 4) < 1e-10
assert abs(pm_idmean_x - 2) < 1e-10 if firm == "A"
assert abs(pm_idmean_x - 6) < 1e-10 if firm == "B"
assert !missing(pm_threefe_x)

*------------------------------------------------------------
* 10. No observations in sample
*------------------------------------------------------------

capture noisily pmean x if year < 1900, id(firm) time(year) dim3(sector) replace
assert _rc == 2000

*------------------------------------------------------------
* 11. Large-data smoke test + identity check
*------------------------------------------------------------

clear
set obs 100000

gen long id = floor((_n - 1)/20) + 1
gen int time = mod(_n - 1, 10) + 1
gen byte sector = mod(_n - 1, 5) + 1
gen double x = id*0.01 + time + sector + runiform()
gen double z = 2*x

pmean x z, id(id) time(time) dim3(sector) replace
local mode = r(mode)
local dims = r(dimensions)
assert `dims' == 3
assert "`mode'" == "3D"
assert !missing(pm_threefe_x) if !missing(x)
assert !missing(pm_threefe_z) if !missing(z)

* Identity (3D main effects) on a large dataset
gen ident_large = pm_overall_x + pm_between_id_x + pm_between_time_x ///
                + pm_between_dim3_x + pm_threefe_x - x
summarize ident_large
assert abs(r(mean)) < 1e-8
assert abs(r(max))  < 1e-8
assert abs(r(min))  < 1e-8
drop ident_large

* Keep a concise success message
display as text "pmean 2.0.2: all 11 test blocks passed."
