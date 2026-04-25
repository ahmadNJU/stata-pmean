{smcl}
{title:pmean}

{p 4 4 2}
{cmd:pmean} computes panel means and performs within–between decomposition.

{title:Syntax}

{p 4 4 2}
{cmd:pmean} {it:varlist}, {cmd:id(}{it:varname}{cmd:)} {cmd:time(}{it:varname}{cmd:)} [{cmd:table} {cmd:save(}{it:filename}{cmd:)}]

{title:Description}

{p 4 4 2}
Generates:

{p 8 8 2}- Overall mean
{p 8 8 2}- Panel (id) mean
{p 8 8 2}- Time mean
{p 8 8 2}- Within-panel deviation
{p 8 8 2}- Between-panel component
{p 8 8 2}- Time-specific deviation
{p 8 8 2}- Two-way demeaned variable

{title:Options}

{p 4 4 2}
{cmd:table} displays summary statistics for each variable.

{p 4 4 2}
{cmd:save(filename)} saves the summary table as CSV.

{title:Example}

{p 4 4 2}
{cmd:. sysuse auto, clear}

{p 4 4 2}
{cmd:. gen year = 2000 + mod(_n,5)}
{cmd:. gen id = mod(_n,3)}

{p 4 4 2}
{cmd:. pmean price, id(id) time(year) table}

{title:Author}

{p 4 4 2}
Ahmad Nawaz  
University of Sahiwal, Pakistan  

{title:Citation}

{p 4 4 2}
Nawaz, A. (2026). pmean: Stata command for panel means and decomposition. GitHub repository.
