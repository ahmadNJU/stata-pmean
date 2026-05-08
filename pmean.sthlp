{smcl}
{* *! version 2.0.1  08may2026}{...}
{vieweralsosee "pmean GitHub" "https://github.com/ahmadNJU/stata-pmean"}{...}
{viewerjumpto "Syntax" "pmean##syntax"}{...}
{viewerjumpto "Description" "pmean##description"}{...}
{viewerjumpto "Generated variables" "pmean##generated"}{...}
{viewerjumpto "Options" "pmean##options"}{...}
{viewerjumpto "Formulas" "pmean##formulas"}{...}
{viewerjumpto "Edge cases" "pmean##edge"}{...}
{viewerjumpto "Large datasets" "pmean##large"}{...}
{viewerjumpto "Examples" "pmean##examples"}{...}
{viewerjumpto "Stored results" "pmean##results"}{...}
{viewerjumpto "What's new" "pmean##changelog"}{...}
{viewerjumpto "Authors" "pmean##author"}{...}
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
[{cmd:genprefix(}{it:name}{cmd:)} {cmd:replace} {cmd:listwise} {cmd:table} {cmd:save(}{it:filename}{cmd:)}]
{p_end}

{pstd}
Three-dimensional panel data:{p_end}

{p 8 17 2}
{cmd:pmean} {it:varlist} [{it:if}] [{it:in}],
{cmd:id(}{it:varname}{cmd:)} {cmd:time(}{it:varname}{cmd:)} {cmd:dim3(}{it:varname}{cmd:)}
[{cmd:genprefix(}{it:name}{cmd:)} {cmd:replace} {cmd:listwise} {cmd:table} {cmd:save(}{it:filename}{cmd:)} {cmd:full}]
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
of the analysis variables are handled variable by variable, unless the {cmd:listwise}
option is specified. Generated variables are missing outside the command sample.{p_end}

{marker generated}{...}
{title:Generated variables}

{pstd}
For a variable {it:x}, the default two-dimensional generated variables are:{p_end}

{phang2}{cmd:pm_overall_}{it:x} {hline 2} Grand mean over the estimation sample{p_end}
{phang2}{cmd:pm_idmean_}{it:x} {hline 2} Unit mean (time-averaged within each id){p_end}
{phang2}{cmd:pm_timemean_}{it:x} {hline 2} Period mean (averaged across units within each time){p_end}
{phang2}{cmd:pm_within_id_}{it:x} {hline 2} One-way within deviation from the id mean{p_end}
{phang2}{cmd:pm_between_id_}{it:x} {hline 2} Between-id component: id mean minus grand mean{p_end}
{phang2}{cmd:pm_between_time_}{it:x} {hline 2} Between-time component: time mean minus grand mean{p_end}
{phang2}{cmd:pm_twfe_}{it:x} {hline 2} Two-way demeaned variable (residual after id and time means){p_end}

{pstd}
With {cmd:dim3()}, the command additionally generates:{p_end}

{phang2}{cmd:pm_dim3mean_}{it:x} {hline 2} Group mean within each dim3 category{p_end}
{phang2}{cmd:pm_between_dim3_}{it:x} {hline 2} Between-dim3 component: dim3 mean minus grand mean{p_end}
{phang2}{cmd:pm_threefe_}{it:x} {hline 2} Three-way main-effect demeaned variable (id, time, dim3 means out){p_end}

{pstd}
With {cmd:full}, the command further generates pairwise cell means, pairwise interaction
components, and a full three-way residual component:{p_end}

{phang2}{cmd:pm_idtime_mean_}{it:x} {hline 2} Cell mean within each (id, time) pair{p_end}
{phang2}{cmd:pm_iddim3_mean_}{it:x} {hline 2} Cell mean within each (id, dim3) pair{p_end}
{phang2}{cmd:pm_timedim3_mean_}{it:x} {hline 2} Cell mean within each (time, dim3) pair{p_end}
{phang2}{cmd:pm_idtime_comp_}{it:x} {hline 2} Id-by-time interaction component{p_end}
{phang2}{cmd:pm_iddim3_comp_}{it:x} {hline 2} Id-by-dim3 interaction component{p_end}
{phang2}{cmd:pm_timedim3_comp_}{it:x} {hline 2} Time-by-dim3 interaction component{p_end}
{phang2}{cmd:pm_threeway_}{it:x} {hline 2} Full three-way ANOVA residual (saturated decomposition){p_end}

{pstd}
All generated variables are stored in double precision and are labeled. Variable
{it:names} are unchanged from earlier releases; in version 2.0.1 only the variable
{it:labels} were sharpened for clarity.{p_end}

{marker options}{...}
{title:Options}

{phang}
{cmd:id(}{it:varname}{cmd:)} specifies the panel identifier. This option is required.{p_end}

{phang}
{cmd:time(}{it:varname}{cmd:)} specifies the time identifier. This option is required.{p_end}

{phang}
{cmd:dim3(}{it:varname}{cmd:)} specifies the third panel dimension. When this option
is omitted, {cmd:pmean} runs in two-dimensional mode. When {cmd:dim3()} is constant
within each panel id (i.e., the third dimension is nested within the panel), {cmd:pmean}
prints an informational note and proceeds; the id-by-dim3 interaction component is
collinear with the between-dim3 component in that case but the additive identity
still holds.{p_end}

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
{cmd:listwise} restricts the estimation sample to observations that are jointly
non-missing on every variable in {it:varlist}. By default, missingness is handled
variable by variable, so different generated variables can be defined on slightly
different observation sets. Use {cmd:listwise} when you want a common sample across
all variables (for example, when comparing transformed variables in the same
regression).{p_end}

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
The three additive identities (2D, 3D main effects, and full 3-way ANOVA) hold
{it:exactly} at every observation in any panel, balanced or unbalanced. What balance
buys is (i) mutual orthogonality of the components, (ii) an additive decomposition
of Var({it:x}) into between- and within-components, and (iii) numerical equivalence
between {cmd:pm_twfe_}{it:x} and the OLS residual from
{cmd:reghdfe} {it:x}, {cmd:absorb(}{it:id time}{cmd:)}. In unbalanced panels these
three properties fail, although the additive identity itself remains exact at the
observation level. See Wansbeek and Kapteyn (1989, {it:Journal of Econometrics} 41:
341-361) for a formal treatment of the unbalanced case.{p_end}

{marker edge}{...}
{title:Edge cases}

{phang}
{bf:Single observation per unit.} If a panel id has only one observation in the
estimation sample, the within-id deviation is identically zero for that
observation.{p_end}

{phang}
{bf:Single time period.} If only one time period is observed in the sample, the
between-time component is identically zero.{p_end}

{phang}
{bf:Nested third dimension.} When {cmd:dim3()} is constant within each panel id
(for example, region nesting state), the id-by-dim3 cell mean equals the id mean
and the id-by-dim3 interaction component is collinear with the between-dim3 main
effect. {cmd:pmean} detects this and prints an informational note. The additive
identity still holds.{p_end}

{phang}
{bf:Missingness.} By default, missingness on the analysis variables is handled
per-variable inside each {cmd:egen} call, so different generated variables can be
defined on slightly different observation sets. Use the {cmd:listwise} option to
require joint non-missingness across all variables in {it:varlist}.{p_end}

{marker large}{...}
{title:Large datasets}

{pstd}
Version 2.0.0 onward reduces avoidable sorting. For each run, the command sorts once
by each required dimension and then processes all variables under that ordering. The
{cmd:full} option is kept optional because it adds seven more variables per input
variable in three-dimensional mode. For very large datasets, start with a small
{it:varlist}, avoid {cmd:full} unless needed, and use a shorter {cmd:genprefix()} if
generated names are too long.{p_end}

{marker examples}{...}
{title:Examples}

{pstd}
Two-dimensional use with the Grunfeld investment panel:{p_end}

{phang2}{cmd:. webuse grunfeld, clear}{p_end}
{phang2}{cmd:. xtset company year}{p_end}
{phang2}{cmd:. pmean invest mvalue, id(company) time(year) replace}{p_end}

{pstd}
Three-dimensional use with the Munnell public-capital panel:{p_end}

{phang2}{cmd:. webuse productivity, clear}{p_end}
{phang2}{cmd:. xtset state year}{p_end}
{phang2}{cmd:. gen lngsp = ln(gsp)}{p_end}
{phang2}{cmd:. pmean lngsp, id(state) time(year) dim3(region) replace}{p_end}

{pstd}
Three-dimensional summary table and CSV export:{p_end}

{phang2}{cmd:. pmean lngsp, id(state) time(year) dim3(region) table save(pmean_summary.csv) replace}{p_end}

{pstd}
Full pairwise three-dimensional decomposition:{p_end}

{phang2}{cmd:. pmean lngsp, id(state) time(year) dim3(region) full genprefix(p2_) replace}{p_end}

{pstd}
Listwise sample across multiple outcomes:{p_end}

{phang2}{cmd:. pmean invest mvalue kstock, id(company) time(year) listwise replace}{p_end}

{pstd}
Stored results:{p_end}

{phang2}{cmd:. return list}{p_end}
{phang2}{cmd:. display r(overall_lngsp)}{p_end}

{pstd}
A complete demonstration with figures is provided in the file {bf:pmean_demo.do}
shipped with the package. After installation, type:{p_end}

{phang2}{cmd:. doedit pmean_demo.do}{p_end}

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

{marker changelog}{...}
{title:What's new in 2.0.1}

{pstd}
Version 2.0.1 is a documentation-and-quality release. It is fully backward
compatible with 2.0.0: variable names, returned scalars, and existing do-files
continue to work without modification.{p_end}

{phang2}* Variable {it:labels} sharpened for clarity (names unchanged).{p_end}
{phang2}* New {cmd:listwise} option for a common sample across all variables.{p_end}
{phang2}* Informational note when {cmd:dim3()} is nested within {cmd:id()} (or vice versa).{p_end}
{phang2}* Sharpened discussion of unbalanced panels in the {help pmean##formulas:Formulas} section.{p_end}
{phang2}* Help-file examples updated to use built-in panel datasets.{p_end}

{marker author}{...}
{title:Authors}

{pstd}
Ahmad Nawaz{p_end}

{pstd}
School of Economics, Nanjing University, China{p_end}

{pstd}
Department of Economics, University of Sahiwal, Pakistan{p_end}

{pstd}
Jianghuai Zheng{p_end}

{pstd}
School of Economics, Nanjing University, China{p_end}

{marker citation}{...}
{title:Citation}

{pstd}
If you use {cmd:pmean} in your research, please cite the version used in your analysis.{p_end}

{pstd}
Nawaz, A. and Zheng, J. (2026). {it:pmean: Stata command for panel means and decomposition}
(Version 2.0.1) [Computer software]. GitHub repository.{p_end}

{title:License}

{pstd}
MIT License.{p_end}
