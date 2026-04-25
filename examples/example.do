clear
sysuse auto, clear

* Create artificial panel structure
gen year = 2000 + mod(_n, 5)
gen id = mod(_n, 3)

* Basic use
pmean price, id(id) time(year)

describe pm_*

* Use with summary table
pmean price mpg weight, id(id) time(year) table

* Save summary table
pmean price mpg, id(id) time(year) table save(pmean_summary.csv)

* Check returned results
return list
display r(overall_price)
