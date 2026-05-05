{smcl}
{* *! version 2.0.0  05may2026}{...}
{vieweralsosee "pmean GitHub" "https://github.com/ahmadNJU/stata-pmean"}{...}
{viewerjumpto "Syntax" "pmean##syntax"}{...}
{viewerjumpto "Description" "pmean##description"}{...}
{viewerjumpto "Generated variables" "pmean##generated"}{...}
{viewerjumpto "Options" "pmean##options"}{...}
{viewerjumpto "Formulas" "pmean##formulas"}{...}
{viewerjumpto "Large datasets" "pmean##large"}{...}
{viewerjumpto "Examples" "pmean##examples"}{...}
{viewerjumpto "Stored results" "pmean##results"}{...}
{viewerjumpto "Author" "pmean##author"}{...}
{viewerjumpto "Citation" "pmean##citation"}{...}

{title:Title}

{phang}
{bf:pmean} {hline 2} Panel means and decomposition for two-dimensional and three-dimensional panel data{p_end}

{marker syntax}{...}
{title:Syntax}

{pstd}
Two-dimensional panel data:{p_end}

{p 8 17 2}
{cmd:pmean} {it:varlist} [{it:if}] [{it:in}],
{cmd:id(}{it:varname}{cmd:)} {cmd:time(}{it:varname}{cmd:)}
[{cmd:genprefix(}{it:name}{cmd:)} {cmd:replace} {cmd:table} {cmd:save(}{it:filename}{cmd:)}]
{p_end}

{pstd}
Three-dimensional panel data:{p_end}

{p 8 17 2}
{cmd:pmean} {it:varlist} [{it:if}] [{it:in}],
{cmd:id(}{it:varname}{cmd:)} {cmd:time(}{it:varname}{cmd:)} {cmd:dim3(}{it:varname}{cmd:)}
[{cmd:genprefix(}{it:name}{cmd:)} {cmd:replace} {cmd:table} {cmd:save(}{it:filename}{cmd:)} {cmd:full}]
{p_end}

{marker description}{...}
{title:Description}

{pstd}
{cmd:pmean} generates commonly used panel-data transformations. In the two-dimensional
case, it creates the same seven variables used in earlier releases: the overall mean,
id mean, time mean, within-id deviation, between-id component, between-time component,
and two-way demeaned variable.{p_end}

{pstd}
When {cmd:dim3()} is specified, {cmd:pmean} also creates the third-dimension mean,
the third-dimension between component, and a three-way main-effect demeaned variable.
The third dimension can represent a sector, region, product group, industry, cohort,
or any other grouping variable observed alongside panel id and time.{p_end}

{pstd}
The command sample is defined by {it:if}, {it:in}, and observations with nonmissing
values of {cmd:id()}, {cmd:time()}, and, when supplied, {cmd:dim3()}. Missing values
of the analysis variables are handled variable by variable. Generated variables are
missing outside the command sample.{p_end}

{marker generated}{...}
{title:Generated variables}

{pstd}
For a variable {it:x}, the default two-dimensional generated variables are:{p_end}

{phang2}{cmd:pm_overall_}{it:x} {hline 2} Overall mean{p_end}
{phang2}{cmd:pm_idmean_}{it:x} {hline 2} Mean within panel units{p_end}
{phang2}{cmd:pm_timemean_}{it:x} {hline 2} Mean across time periods{p_end}
{phang2}{cmd:pm_within_id_}{it:x} {hline 2} Within-panel deviation{p_end}
{phang2}{cmd:pm_between_id_}{it:x} {hline 2} Between-panel component{p_end}
{phang2}{cmd:pm_between_time_}{it:x} {hline 2} Time-specific deviation component{p_end}
{phang2}{cmd:pm_twfe_}{it:x} {hline 2} Two-way demeaned variable using id and time{p_end}

{pstd}
With {cmd:dim3()}, the command additionally generates:{p_end}

{phang2}{cmd:pm_dim3mean_}{it:x} {hline 2} Mean within the third dimension{p_end}
{phang2}{cmd:pm_between_dim3_}{it:x} {hline 2} Third-dimension between component{p_end}
{phang2}{cmd:pm_threefe_}{it:x} {hline 2} Three-way main-effect demeaned variable{p_end}

{pstd}
With {cmd:full}, the command further generates pairwise cell means, pairwise interaction
components, and a full three-way residual component:{p_end}

{phang2}{cmd:pm_idtime_mean_}{it:x} {hline 2} Mean within id-time cells{p_end}
{phang2}{cmd:pm_iddim3_mean_}{it:x} {hline 2} Mean within id-dim3 cells{p_end}
{phang2}{cmd:pm_timedim3_mean_}{it:x} {hline 2} Mean within time-dim3 cells{p_end}
{phang2}{cmd:pm_idtime_comp_}{it:x} {hline 2} Id-time interaction component{p_end}
{phang2}{cmd:pm_iddim3_comp_}{it:x} {hline 2} Id-dim3 interaction component{p_end}
{phang2}{cmd:pm_timedim3_comp_}{it:x} {hline 2} Time-dim3 interaction component{p_end}
{phang2}{cmd:pm_threeway_}{it:x} {hline 2} Full three-way residual component{p_end}

{pstd}
All generated variables are stored in double precision and are labeled.{p_end}

{marker options}{...}
{title:Options}

{phang}
{cmd:id(}{it:varname}{cmd:)} specifies the panel identifier. This option is required.{p_end}

{phang}
{cmd:time(}{it:varname}{cmd:)} specifies the time identifier. This option is required.{p_end}

{phang}
{cmd:dim3(}{it:varname}{cmd:)} specifies the third panel dimension. When this option
is omitted, {cmd:pmean} runs in two-dimensional mode.{p_end}

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
N, mean, standard deviation, minimum, maximum, number of panel units, number of
time periods, and, in three-dimensional mode, number of third-dimension groups.{p_end}

{phang}
{cmd:save(}{it:filename}{cmd:)} saves the summary table as a CSV file. This option
requires {cmd:table}. If the file already exists, specify {cmd:replace}.{p_end}

{phang}
{cmd:full} adds pairwise means, pairwise interaction components, and the full three-way
residual component. This option is available only with {cmd:dim3()}. It creates more
variables and should be used only when those components are needed. {cmd:pairwise}
is accepted as a synonym for {cmd:full}.{p_end}

{marker formulas}{...}
{title:Formulas}

{pstd}
Let {it:x_it} denote a two-dimensional observation for unit {it:i} and time {it:t}.
The two-way demeaned variable is computed as:{p_end}

{p 8 8 2}
{it:x_it} - mean_i({it:x}) - mean_t({it:x}) + mean({it:x}).{p_end}

{pstd}
Let {it:x_itg} denote a three-dimensional observation for unit {it:i}, time {it:t},
and third dimension {it:g}. The three-way main-effect demeaned variable is computed as:{p_end}

{p 8 8 2}
{it:x_itg} - mean_i({it:x}) - mean_t({it:x}) - mean_g({it:x}) + 2*mean({it:x}).{p_end}

{pstd}
With {cmd:full}, the full three-way residual component is computed as:{p_end}

{p 8 8 2}
{it:x_itg} - mean_it({it:x}) - mean_ig({it:x}) - mean_tg({it:x}) + mean_i({it:x}) + mean_t({it:x}) + mean_g({it:x}) - mean({it:x}).{p_end}

{pstd}
These are descriptive marginal-mean decompositions. They are exact for balanced panels
under the usual marginal-mean interpretation. In unbalanced panels, they should be
interpreted as descriptive transformations rather than guaranteed replacements for full
high-dimensional fixed-effects residualization.{p_end}

{marker large}{...}
{title:Large datasets}

{pstd}
Version 2.0.0 reduces avoidable sorting. For each run, the command sorts once by each
required dimension and then processes all variables under that ordering. The {cmd:full}
option is kept optional because it adds seven more variables per input variable in
three-dimensional mode. For very large datasets, start with a small {it:varlist}, avoid
{cmd:full} unless needed, and use a shorter {cmd:genprefix()} if generated names are
too long.{p_end}

{marker examples}{...}
{title:Examples}

{pstd}
Two-dimensional use:{p_end}

{phang2}{cmd:. sysuse auto, clear}{p_end}
{phang2}{cmd:. gen year = 2000 + mod(_n, 5)}{p_end}
{phang2}{cmd:. gen id = mod(_n, 3)}{p_end}
{phang2}{cmd:. pmean price mpg, id(id) time(year) replace}{p_end}

{pstd}
Three-dimensional use:{p_end}

{phang2}{cmd:. gen sector = mod(_n, 4)}{p_end}
{phang2}{cmd:. pmean price mpg, id(id) time(year) dim3(sector) replace}{p_end}

{pstd}
Three-dimensional summary table and CSV export:{p_end}

{phang2}{cmd:. pmean price mpg, id(id) time(year) dim3(sector) table save(pmean_summary.csv) replace}{p_end}

{pstd}
Full pairwise three-dimensional decomposition:{p_end}

{phang2}{cmd:. pmean price, id(id) time(year) dim3(sector) full genprefix(p2_) replace}{p_end}

{pstd}
Stored results:{p_end}

{phang2}{cmd:. return list}{p_end}
{phang2}{cmd:. display r(overall_price)}{p_end}

{marker results}{...}
{title:Stored results}

{pstd}
{cmd:pmean} stores results in {cmd:r()}.{p_end}

{phang2}{cmd:r(varlist)} {hline 2} variables used{p_end}
{phang2}{cmd:r(id)} {hline 2} panel identifier{p_end}
{phang2}{cmd:r(time)} {hline 2} time variable{p_end}
{phang2}{cmd:r(dim3)} {hline 2} third-dimension variable, if specified{p_end}
{phang2}{cmd:r(prefix)} {hline 2} prefix used for generated variables{p_end}
{phang2}{cmd:r(generated)} {hline 2} list of generated variables{p_end}
{phang2}{cmd:r(mode)} {hline 2} {cmd:2D} or {cmd:3D}{p_end}
{phang2}{cmd:r(dimensions)} {hline 2} number of panel dimensions{p_end}
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
(Version 2.0.0) [Computer software]. GitHub repository.{p_end}

{title:License}

{pstd}
MIT License.{p_end}
