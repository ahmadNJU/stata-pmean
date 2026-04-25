clear
sysuse auto
gen year = 2000 + mod(_n,5)
gen id = mod(_n,3)
pmean price, id(id) time(year)
