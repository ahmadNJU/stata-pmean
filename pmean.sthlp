{smcl}
{title:pmean}

{p 4 4 2}
{cmd:pmean} computes panel means and performs within–between decomposition for panel data.

{title:Syntax}

{p 4 4 2}
{cmd:pmean} {it:varlist}, {cmd:id(}{it:varname}{cmd:)} {cmd:time(}{it:varname}{cmd:)}

{title:Description}

{p 4 4 2}
{cmd:pmean} generates the following variables for each input variable:

{p 8 8 2}- Overall mean
{p 8 8 2}- Panel (id) mean
{p 8 8 2}- Time mean
{p 8 8 2}- Within-panel deviation (from panel mean)
{p 8 8 2}- Between-panel component
{p 8 8 2}- Time-specific deviation
{p 8 8 2}- Two-way demeaned variable (removing both panel and time effects)

{p 4 4 2}
All generated variables are automatically labeled for ease of interpretation.

{title:Generated Variables}

{p 4 4 2}
For a variable {it:x}, the following variables are created:

{p 8 8 2}{cmd:pm_overall_x}       Overall mean  
{p 8 8 2}{cmd:pm_idmean_x}        Mean within panel units  
{p 8 8 2}{cmd:pm_timemean_x}      Mean across time periods  
{p 8 8 2}{cmd:pm_within_id_x}     Within-panel deviation  
{p 8 8 2}{cmd:pm_between_id_x}    Between-panel component  
{p 8 8 2}{cmd:pm_between_time_x}  Time-specific deviation  
{p 8 8 2}{cmd:pm_twfe_x}          Two-way demeaned variable  

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
School of Economics, Department of Industrial Economics, Nanjing University, Mainland China

Department of Economics, University of Sahiwal, Sahiwal Pakistan

{title:Citation}

{p 4 4 2}
If you use {cmd:pmean} in your research, please cite:

{p 4 4 2}
Nawaz, A. (2026). pmean: Stata command for panel means and decomposition. GitHub repository. Available at: https://github.com/ahmadNJU/stata-pmean

{title:Remarks}

{p 4 4 2}
The command is intended for descriptive analysis and transformation of panel data variables, and can be used in conjunction with fixed-effects models.
