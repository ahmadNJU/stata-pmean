version 17.0
clear all
set more off

* Balanced panel checks
clear
input id time x z
1 1 10 100
1 2 20 120
2 1 30 140
2 2 40 160
end

gen obsno = _n

pmean x z, id(id) time(time) table replace

assert obsno == _n

assert pm_overall_x == 25
assert pm_idmean_x == 15 if id == 1
assert pm_idmean_x == 35 if id == 2
assert pm_timemean_x == 20 if time == 1
assert pm_timemean_x == 30 if time == 2

assert pm_within_id_x == -5 if id == 1 & time == 1
assert pm_within_id_x == 5  if id == 1 & time == 2

assert pm_between_id_x == -10 if id == 1
assert pm_between_id_x == 10  if id == 2

assert pm_between_time_x == -5 if time == 1
assert pm_between_time_x == 5  if time == 2

assert pm_twfe_x == 0
assert r(overall_x) == 25
assert "`r(id)'" == "id"
assert "`r(time)'" == "time"
assert "`r(prefix)'" == "pm_"

assert pm_overall_z == 130
assert pm_idmean_z == 110 if id == 1
assert pm_idmean_z == 150 if id == 2

* Existing generated variables should require replace
capture noisily pmean x, id(id) time(time)
assert _rc == 110

* save() must be used with table
capture noisily pmean x, id(id) time(time) save(pmean_no_table.csv) replace
assert _rc == 198

* Exported table can be written with replace
capture erase pmean_test_summary.csv
pmean x, id(id) time(time) table save(pmean_test_summary.csv) replace
confirm file pmean_test_summary.csv
erase pmean_test_summary.csv

* Existing CSV file is not overwritten unless replace is specified
file open fh using pmean_existing.csv, write replace
file write fh "existing file" _n
file close fh
capture noisily pmean x, id(id) time(time) genprefix(qm_) table save(pmean_existing.csv)
assert _rc != 0
capture confirm variable qm_overall_x
assert _rc != 0
erase pmean_existing.csv

* Long generated names should fail clearly
clear
set obs 2
gen id = _n
gen time = _n
gen longvariablename123456 = _n
capture noisily pmean longvariablename123456, id(id) time(time)
assert _rc == 198

* String identifiers, missing identifiers, missing values, and if restrictions
clear
input str1 id str1 time x
"A" "1" 10
"A" "2" .
"B" "1" 30
"B" "2" 50
""  "1" 70
"C" ""  90
end

pmean x if id != "C", id(id) time(time) replace

assert pm_overall_x == 30 if id == "A" & time == "1"
assert pm_idmean_x == 10 if id == "A"
assert missing(pm_within_id_x) if id == "A" & time == "2"
assert missing(pm_overall_x) if id == ""
assert missing(pm_overall_x) if id == "C"

pmean x if id != "C", id(id) time(time) genprefix(my_) replace
confirm variable my_twfe_x

* No nonmissing analysis values in the requested sample should fail
clear
input id time x
1 1 .
1 2 .
end
capture noisily pmean x, id(id) time(time)
assert _rc == 2000

display as text "pmean tests completed successfully."
