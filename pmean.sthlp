{smcl}
{title:pmean}

{p 4 4 2}
{cmd:pmean} computes panel means and performs within-between decomposition for panel data.

{title:Syntax}

{p 4 4 2}
{cmd:pmean} {it:varlist}, {cmd:id(}{it:varname}{cmd:)} {cmd:time(}{it:varname}{cmd:)}
[{cmd:genprefix(}{it:string}{cmd:)} {cmd:replace} {cmd:table} {cmd:save(}{it:filename}{cmd:)}]

{title:Description}

{p 4 4 2}
{cmd:pmean} generates commonly used transformations for panel data analysis.

{p 8 8 2}- Overall mean
{p 8 8 2}- Panel/id mean
{p 8 8 2}- Time mean
{p 8 8 2}- Within-panel deviation
{p 8 8 2}- Between-panel component
{p 8 8 2}- Time-specific deviation
{p 8 8 2}- Two-way demeaned variable

{title:Generated Variables}

{p 4 4 2}
For a variable {it:x}, the default generated variables are:

{p 8 8 2}{cmd:pm_overall_x}       Overall mean
{p 8 8 2}{cmd:pm_idmean_x}        Mean within panel units
{p 8 8 2}{cmd:pm_timemean_x}      Mean across time periods
{p 8 8 2}{cmd:pm_within_id_x}     Within-panel deviation
{p 8 8 2}{cmd:pm_between_id_x}    Between-panel component
{p 8 8 2}{cmd:pm_between_time_x}  Time-specific deviation
{p 8 8 2}{cmd:pm_twfe_x}          Two-way demeaned variable

{title:Options}

{p 4 4 2}
{cmd:genprefix(}{it:string}{cmd:)} specifies a prefix for generated variables. The default is {cmd:pm_}.

{p 4 4 2}
{cmd:replace} allows {cmd:pmean} to overwrite previously generated variables with the same names.

{p 4 4 2}
{cmd:table} displays a compact summary table for each variable.

{p 4 4 2}
{cmd:save(}{it:filename}{cmd:)} saves the summary table as a CSV file. This option is used with {cmd:table}.

{title:Example}

{p 4 4 2}
{cmd:. sysuse auto, clear}

{p 4 4 2}
{cmd:. gen year = 2000 + mod(_n,5)}

{p 4 4 2}
{cmd:. gen id = mod(_n,3)}

{p 4 4 2}
{cmd:. pmean price mpg, id(id) time(year) table replace}

{title:Stored results}

{p 4 4 2}
{cmd:pmean} stores results in {cmd:r()}.

{p 8 8 2}{cmd:r(varlist)}     Variables used
{p 8 8 2}{cmd:r(id)}          Panel identifier
{p 8 8 2}{cmd:r(time)}        Time variable
{p 8 8 2}{cmd:r(prefix)}      Prefix used for generated variables
{p 8 8 2}{cmd:r(generated)}   List of generated variables
{p 8 8 2}{cmd:r(overall_x)}   Overall mean of variable {it:x}

{title:Author}

{p 4 4 2}
Ahmad Nawaz

{p 4 4 2}
School of Economics, Nanjing University, China

{p 4 4 2}
Department of Economics, University of Sahiwal, Pakistan

{title:Citation}

{p 4 4 2}
If you use {cmd:pmean} in your research, please cite:

{p 4 4 2}
Nawaz, A. (2026). pmean: Stata command for panel means and decomposition. GitHub repository.

{title:License}

{p 4 4 2}
MIT License.
