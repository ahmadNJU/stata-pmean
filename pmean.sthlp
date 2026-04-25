{smcl}
{title:pmean}

{p 4 4 2}
{cmd:pmean} computes panel means and performs within–between decomposition for panel data.

{title:Syntax}

{p 4 4 2}
{cmd:pmean} {it:varlist}, {cmd:id(}{it:varname}{cmd:)} {cmd:time(}{it:varname}{cmd:)}

{title:Description}

{p 4 4 2}
{cmd:pmean} generates commonly used transformations for panel data analysis, including:

{p 8 8 2}- Overall (pooled) mean
{p 8 8 2}- Cross-sectional (panel/id) mean
{p 8 8 2}- Time mean
{p 8 8 2}- Within-panel deviation
{p 8 8 2}- Between-panel component
{p 8 8 2}- Time-specific deviation
{p 8 8 2}- Two-way demeaned variable (removing both panel and time effects)

{p 4 4 2}
The generated variables are automatically labeled for ease of interpretation and use in empirical analysis.

{title:Example}

{p 4 4 2}
{cmd:. sysuse auto, clear}

{p 4 4 2}
{cmd:. gen year = 2000 + mod(_n,5)}
{cmd:. gen id = mod(_n,3)}

{p 4 4 2}
{cmd:. pmean price, id(id) time(year)}

{title:Author}

{p 4 4 2}
Ahmad Nawaz  
Lecturer in Economics  
University of Sahiwal, Pakistan  

{title:Citation}

{p 4 4 2}
If you use {cmd:pmean} in your research, please cite:

{p 4 4 2}
Nawaz, A. (2026). pmean: Stata command for panel means and decomposition. GitHub repository.

{title:Remarks}

{p 4 4 2}
This command is intended for descriptive analysis and variable transformation in panel datasets, and can be used in conjunction with fixed-effects and related econometric models.
