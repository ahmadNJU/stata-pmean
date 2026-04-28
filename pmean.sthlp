{smcl}
{* *! version 1.2.0  28apr2026}{...}
{vieweralsosee "pmean GitHub" "https://github.com/ahmadNJU/stata-pmean"}{...}
{viewerjumpto "Syntax" "pmean##syntax"}{...}
{viewerjumpto "Description" "pmean##description"}{...}
{viewerjumpto "Generated variables" "pmean##generated"}{...}
{viewerjumpto "Options" "pmean##options"}{...}
{viewerjumpto "Formula" "pmean##formula"}{...}
{viewerjumpto "Examples" "pmean##examples"}{...}
{viewerjumpto "Stored results" "pmean##results"}{...}
{viewerjumpto "Author" "pmean##author"}{...}
{viewerjumpto "Citation" "pmean##citation"}{...}

{title:Title}

{phang}
{bf:pmean} {hline 2} Panel means and within-between decomposition for two-dimensional panel data{p_end}

{marker syntax}{...}
{title:Syntax}

{p 8 17 2}
{cmd:pmean} {it:varlist} [{it:if}] [{it:in}],
{cmd:id(}{it:varname}{cmd:)} {cmd:time(}{it:varname}{cmd:)}
[{cmd:genprefix(}{it:name}{cmd:)} {cmd:replace} {cmd:table} {cmd:save(}{it:filename}{cmd:)}]
{p_end}

{marker description}{...}
{title:Description}

{pstd}
{cmd:pmean} generates commonly used transformations for panel data analysis.
For each numeric variable in {it:varlist}, it creates the overall mean, id mean,
time mean, within-id deviation, between-id component, between-time component,
and a two-way demeaned variable.{p_end}

{pstd}
The command sample is defined by {it:if}, {it:in}, and observations with
nonmissing values of {cmd:id()} and {cmd:time()}. Missing values of the analysis
variables are handled variable by variable. Generated variables are missing outside
the command sample.{p_end}

{marker generated}{...}
{title:Generated variables}

{pstd}
For a variable {it:x}, the default generated variables are:{p_end}

{phang2}{cmd:pm_overall_}{it:x} {hline 2} Overall mean{p_end}
{phang2}{cmd:pm_idmean_}{it:x} {hline 2} Mean within panel units{p_end}
{phang2}{cmd:pm_timemean_}{it:x} {hline 2} Mean across time periods{p_end}
{phang2}{cmd:pm_within_id_}{it:x} {hline 2} Within-panel deviation{p_end}
{phang2}{cmd:pm_between_id_}{it:x} {hline 2} Between-panel component{p_end}
{phang2}{cmd:pm_between_time_}{it:x} {hline 2} Time-specific deviation component{p_end}
{phang2}{cmd:pm_twfe_}{it:x} {hline 2} Two-way demeaned variable{p_end}

{pstd}
All generated variables are stored in double precision and are labeled.{p_end}

{marker options}{...}
{title:Options}

{phang}
{cmd:id(}{it:varname}{cmd:)} specifies the panel identifier. This option is required.{p_end}

{phang}
{cmd:time(}{it:varname}{cmd:)} specifies the time identifier. This option is required.{p_end}

{phang}
{cmd:genprefix(}{it:name}{cmd:)} specifies the prefix used for generated variables.
The default is {cmd:pm_}. Generated variable names are checked before any variables
are created. If a name is too long or otherwise invalid, use a shorter prefix or
rename the source variable.{p_end}

{phang}
{cmd:replace} allows {cmd:pmean} to overwrite previously generated variables with
the same names. If {cmd:save()} is specified, {cmd:replace} also permits overwriting
an existing CSV file.{p_end}

{phang}
{cmd:table} displays a compact summary table for each variable. The table reports
N, mean, standard deviation, minimum, maximum, number of panel units, and number
of time periods.{p_end}

{phang}
{cmd:save(}{it:filename}{cmd:)} saves the summary table as a CSV file. This option
requires {cmd:table}. If the file already exists, specify {cmd:replace}.{p_end}

{marker formula}{...}
{title:Formula}

{pstd}
For variable {it:x}, the two-way demeaned variable is computed as:{p_end}

{p 8 8 2}
{it:x_it} - mean_i({it:x}) - mean_t({it:x}) + mean({it:x}).{p_end}

{pstd}
This is a descriptive two-way demeaning formula. It is exact for balanced panels
under the usual marginal-mean interpretation. In unbalanced panels, it should be
interpreted as a descriptive transformation rather than a guaranteed replacement for
full fixed-effects residualization.{p_end}

{marker examples}{...}
{title:Examples}

{phang2}{cmd:. sysuse auto, clear}{p_end}
{phang2}{cmd:. gen year = 2000 + mod(_n, 5)}{p_end}
{phang2}{cmd:. gen id = mod(_n, 3)}{p_end}
{phang2}{cmd:. pmean price mpg, id(id) time(year) replace}{p_end}
{phang2}{cmd:. pmean price mpg, id(id) time(year) table save(pmean_summary.csv) replace}{p_end}
{phang2}{cmd:. return list}{p_end}

{marker results}{...}
{title:Stored results}

{pstd}
{cmd:pmean} stores results in {cmd:r()}.{p_end}

{phang2}{cmd:r(varlist)} {hline 2} variables used{p_end}
{phang2}{cmd:r(id)} {hline 2} panel identifier{p_end}
{phang2}{cmd:r(time)} {hline 2} time variable{p_end}
{phang2}{cmd:r(prefix)} {hline 2} prefix used for generated variables{p_end}
{phang2}{cmd:r(generated)} {hline 2} list of generated variables{p_end}
{phang2}{cmd:r(overall_}{it:x}{cmd:)} {hline 2} overall mean of variable {it:x}{p_end}

{marker author}{...}
{title:Author}

{pstd}
Ahmad Nawaz{p_end}

{pstd}
School of Economics, Nanjing University, China{p_end}

{pstd}
Department of Economics, University of Sahiwal, Pakistan{p_end}

{marker citation}{...}
{title:Citation}

{pstd}
If you use {cmd:pmean} in your research, please cite the version used in your analysis.{p_end}

{pstd}
Nawaz, A. (2026). {it:pmean: Stata command for panel means and decomposition}
(Version 1.2.0) [Computer software]. Zenodo.
{browse "https://doi.org/10.5281/zenodo.19787933":https://doi.org/10.5281/zenodo.19787933}{p_end}

{title:License}

{pstd}
MIT License.{p_end}
