{smcl}
{title:pmean}

{p 4 4 2}
{cmd:pmean} computes panel means and decomposition components.

{title:Syntax}
{p 4 4 2}
{cmd:pmean} varlist, {cmd:id(varname)} {cmd:time(varname)}

{title:Description}
Computes:
- Overall mean
- Cross-sectional mean
- Time mean
- Within and between components
- Two-way demeaned variable

{title:Example}
{cmd:. sysuse auto}
{cmd:. gen year = 2000 + mod(_n,5)}
{cmd:. gen id = mod(_n,3)}
{cmd:. pmean price, id(id) time(year)}

{title:Author}
Ahmad Nawaz
