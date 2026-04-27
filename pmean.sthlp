{smcl}
{* *! version 1.2.0  27apr2026}{...}
{title:pmean}

{p 4 4 2}
{cmd:pmean} computes panel means and performs within-between decomposition for two-dimensional panel data.

{title:Syntax}

{p 4 4 2}
{cmd:pmean} {it:varlist} [{it:if}] [{it:in}], {cmd:id(}{it:varname}{cmd:)} {cmd:time(}{it:varname}{cmd:)}
[{cmd:genprefix(}{it:name}{cmd:)} {cmd:replace} {cmd:table} {cmd:save(}{it:filename}{cmd:)}]

{title:Description}

{p 4 4 2}
{cmd:pmean} generates commonly used transformations for panel data analysis.
For each numeric variable in {it:varlist}, it creates the overall mean, id mean, time mean,
within-id deviation, between-id component, between-time component, and a two-way demeaned variable.

{p 4 4 2}
The command sample is defined by {it:if}, {it:in}, and observations with nonmissing values of
{cmd:id()} and {cmd:time()}. Missing values of the analysis variables are handled variable by variable.
Generated variables are missing outside the command sample.

{title:Generated variables}

{p 4 4 2}
For a variable {it:x}, the default generated variables are:

{p 8 8 2}{cmd:pm_overall_x}       Overall mean
{p 8 8 2}{cmd:pm_idmean_x}        Mean within panel units
{p 8 8 2}{cmd:pm_timemean_x}      Mean across time periods
{p 8 8 2}{cmd:pm_within_id_x}     Within-panel deviation
{p 8 8 2}{cmd:pm_between_id_x}    Between-panel component
{p 8 8 2}{cmd:pm_between_time_x}  Time-specific deviation component
{p 8 8 2}{cmd:pm_twfe_x}          Two-way demeaned variable

{p 4 4 2}
All generated variables are stored in double precision and labeled.

{title:Options}

{p 4 4 2}
{cmd:genprefix(}{it:name}{cmd:)} specifies the prefix used for generated variables. The default is {cmd:pm_}.
Generated variable names are checked before any variables are created. If a name is too long or otherwise invalid,
use a shorter prefix or rename the source variable.

{p 4 4 2}
{cmd:replace} allows {cmd:pmean} to overwrite previously generated variables with the same names.
If {cmd:save()} is specified, {cmd:replace} also permits overwriting an existing CSV file.

{p 4 4 2}
{cmd:table} displays a compact summary table for each variable. The table reports N, mean, standard deviation,
minimum, maximum, number of panel units, and number of time periods.

{p 4 4 2}
{cmd:save(}{it:filename}{cmd:)} saves the summary table as a CSV file. This option requires {cmd:table}.
If the file already exists, specify {cmd:replace}.

{title:Formula}

{p 4 4 2}
For variable {it:x}, the two-way demeaned variable is computed as

{p 8 8 2}
{it:x_it} - mean_i({it:x}) - mean_t({it:x}) + mean({it:x}).

{p 4 4 2}
This is a descriptive two-way demeaning formula. It is exact for balanced panels under the usual marginal-mean
interpretation. In unbalanced panels, it should be interpreted as a descriptive transformation rather than a guaranteed
replacement for full fixed-effects residualization.

{title:Examples}

{p 4 4 2}
{cmd:. sysuse auto, clear}

{p 4 4 2}
{cmd:. gen year = 2000 + mod(_n, 5)}

{p 4 4 2}
{cmd:. gen id = mod(_n, 3)}

{p 4 4 2}
{cmd:. pmean price mpg, id(id) time(year) replace}

{p 4 4 2}
{cmd:. pmean price mpg, id(id) time(year) table save(pmean_summary.csv) replace}

{p 4 4 2}
{cmd:. return list}

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
