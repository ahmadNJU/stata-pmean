clear
input id time x
1 1 10
1 2 20
2 1 30
2 2 40
end

pmean x, id(id) time(time) table

* Check generated variables
assert pm_overall_x == 25
assert pm_idmean_x == 15 if id == 1
assert pm_idmean_x == 35 if id == 2
assert pm_timemean_x == 20 if time == 1
assert pm_timemean_x == 30 if time == 2

* Check decomposition
assert pm_within_id_x == -5 if id == 1 & time == 1
assert pm_within_id_x == 5  if id == 1 & time == 2
assert pm_between_id_x == -10 if id == 1
assert pm_between_id_x == 10  if id == 2
assert pm_between_time_x == -5 if time == 1
assert pm_between_time_x == 5  if time == 2

* Check two-way demeaned component
assert pm_twfe_x == 0

* Check r-class return
assert r(overall_x) == 25

* Check save option
pmean x, id(id) time(time) table save(test_summary.csv)
confirm file test_summary.csv

erase test_summary.csv
