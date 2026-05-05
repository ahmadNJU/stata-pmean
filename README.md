# pmean

![Version](https://img.shields.io/badge/version-2.0.0-blue)
![License](https://img.shields.io/badge/license-MIT-green)
![Stata](https://img.shields.io/badge/Stata-17+-orange)
![Status](https://img.shields.io/badge/status-active-success)
[![Install](https://img.shields.io/badge/install-pmean-blue)](https://raw.githubusercontent.com/ahmadNJU/stata-pmean/main/)

`pmean` is a Stata command for computing panel means and performing within-between decomposition in a unified framework.

Version 2.0.0 supports both two-dimensional and three-dimensional panel data. It keeps the earlier two-dimensional output and adds third-dimension means, third-dimension components, and three-way decomposition when `dim3()` is specified.

The command is designed for applied panel data analysis in economics and related social sciences.

---

## What is new in version 2.0.0

Version 2.0.0 is a major feature release.

Main changes:

* Adds three-dimensional panel support through `dim3()`.
* Keeps the existing two-dimensional syntax and generated variables from earlier releases.
* Adds `pm_dim3mean_*`, `pm_between_dim3_*`, and `pm_threefe_*` for three-dimensional panels.
* Adds optional `full` decomposition for pairwise cell means, pairwise interaction components, and a full three-way residual component.
* Processes all variables under each required sort order to reduce repeated sorting on large datasets.
* Checks the number of required output variables against available Stata variable slots before creating output.
* Keeps strict sample handling, preserved sort order, double precision output, safer replacement behavior, and table export behavior introduced in version 1.2.0.

---

## Features

* Overall pooled mean
* Panel/id mean
* Time mean
* Third-dimension mean with `dim3()`
* Within-panel deviation
* Between-panel component
* Time-specific component
* Third-dimension component
* Two-way demeaned transformation
* Three-way main-effect demeaned transformation
* Optional full three-dimensional decomposition
* Support for multiple variables in a single call
* Labeled double-precision generated variables
* Summary table output via `table`
* Export summary table using `save()`
* Results returned via `r()` for programmatic use

---

## Installation

Install directly from GitHub:

```stata
net install pmean, from("https://raw.githubusercontent.com/ahmadNJU/stata-pmean/main/")
```

To update the package:

```stata
net install pmean, from("https://raw.githubusercontent.com/ahmadNJU/stata-pmean/main/") replace
```

---

## Syntax

Two-dimensional panel data:

```stata
pmean varlist [if] [in], id(panel_id) time(time_id) [genprefix(prefix) replace table save(filename)]
```

Three-dimensional panel data:

```stata
pmean varlist [if] [in], id(panel_id) time(time_id) dim3(third_id) [genprefix(prefix) replace table save(filename) full]
```

Required options:

* `id(varname)` specifies the panel identifier.
* `time(varname)` specifies the time identifier.

Optional arguments:

* `dim3(varname)` specifies the third dimension, such as sector, region, product group, industry, or cohort.
* `genprefix(prefix)` specifies the prefix for generated variables. The default is `pm_`.
* `replace` overwrites existing generated variables with the same names. If `save()` is also specified, it also permits overwriting the exported CSV file.
* `table` displays a compact summary table.
* `save(filename)` saves the summary table as a CSV file. This option requires `table`.
* `full` adds pairwise cell means, pairwise interaction components, and the full three-way residual component. `pairwise` is accepted as a synonym.

---

## Examples

### Two-dimensional use

```stata
sysuse auto, clear

* Create artificial panel structure
gen year = 2000 + mod(_n, 5)
gen id = mod(_n, 3)

* Basic two-dimensional decomposition
pmean price mpg, id(id) time(year) replace

describe pm_*
return list
```

### Three-dimensional use

```stata
sysuse auto, clear

* Create artificial three-dimensional panel structure
gen year = 2000 + mod(_n, 5)
gen id = mod(_n, 3)
gen sector = mod(_n, 4)

* Three-dimensional decomposition
pmean price mpg weight, id(id) time(year) dim3(sector) replace

describe pm_*
list price pm_idmean_price pm_timemean_price pm_dim3mean_price pm_threefe_price in 1/10
```

### Summary table and export

```stata
pmean price mpg, id(id) time(year) dim3(sector) table save(pmean_summary.csv) replace
```

### Full three-dimensional decomposition

```stata
pmean price, id(id) time(year) dim3(sector) full genprefix(p2_) replace

describe p2_*
```

---

## Output variables

For each variable `x`, the two-dimensional command generates:

| Variable | Description |
| --- | --- |
| `pm_overall_x` | Overall mean |
| `pm_idmean_x` | Mean within panel units |
| `pm_timemean_x` | Mean across time periods |
| `pm_within_id_x` | Deviation from panel/id mean |
| `pm_between_id_x` | Between-panel component |
| `pm_between_time_x` | Time-specific component |
| `pm_twfe_x` | Two-way demeaned variable using id and time |

With `dim3()`, the command additionally generates:

| Variable | Description |
| --- | --- |
| `pm_dim3mean_x` | Mean within the third dimension |
| `pm_between_dim3_x` | Third-dimension component |
| `pm_threefe_x` | Three-way main-effect demeaned variable |

With `dim3()` and `full`, the command further generates:

| Variable | Description |
| --- | --- |
| `pm_idtime_mean_x` | Mean within id-time cells |
| `pm_iddim3_mean_x` | Mean within id-dim3 cells |
| `pm_timedim3_mean_x` | Mean within time-dim3 cells |
| `pm_idtime_comp_x` | Id-time interaction component |
| `pm_iddim3_comp_x` | Id-dim3 interaction component |
| `pm_timedim3_comp_x` | Time-dim3 interaction component |
| `pm_threeway_x` | Full three-way residual component |

All generated variables use double precision and are labeled.

---

## Formula notes

For a two-dimensional observation `x_it`, the two-way demeaned variable is computed as:

```text
x_it - mean_i(x) - mean_t(x) + mean(x)
```

For a three-dimensional observation `x_itg`, the three-way main-effect demeaned variable is computed as:

```text
x_itg - mean_i(x) - mean_t(x) - mean_g(x) + 2*mean(x)
```

With `full`, the full three-way residual component is computed as:

```text
x_itg - mean_it(x) - mean_ig(x) - mean_tg(x)
      + mean_i(x) + mean_t(x) + mean_g(x) - mean(x)
```

These are descriptive marginal-mean decompositions. They are exact for balanced panels under the usual marginal-mean interpretation. In unbalanced panels, they should be interpreted as descriptive transformations rather than guaranteed replacements for full high-dimensional fixed-effects residualization.

---

## Large dataset notes

Version 2.0.0 is written for large applied datasets.

* It avoids repeated sorting by sorting once by each required dimension and processing all variables under that ordering.
* It checks generated variable names and available Stata variable slots before creating output.
* It keeps `full` optional because full decomposition adds seven more generated variables per input variable.
* It preserves the user's original sort order after completion.

Memory use depends on the number of observations and the number of generated variables. In three-dimensional mode, the default output creates 10 double variables per input variable. With `full`, it creates 17 double variables per input variable. For very large datasets, run the command on a focused `varlist`, use `full` only when needed, and use a short `genprefix()` if variable names become too long.

---

## Summary table output

Using the `table` option displays a compact summary table:

```stata
pmean price, id(id) time(year) dim3(sector) table replace
```

The table includes:

* Number of observations (`N`)
* Mean and standard deviation
* Minimum and maximum values
* Number of panel units
* Number of time periods
* Number of third-dimension groups when `dim3()` is specified

To export the table:

```stata
pmean price, id(id) time(year) dim3(sector) table save(summary.csv) replace
```

`save()` must be used with `table`. If the output file already exists, specify `replace`.

---

## Stored results

`pmean` stores results in `r()`.

Examples:

```stata
return list
display r(overall_price)
```

Returned elements include:

* `r(varlist)` — variables used
* `r(id)` — panel identifier
* `r(time)` — time variable
* `r(dim3)` — third-dimension variable, if specified
* `r(prefix)` — prefix used for generated variables
* `r(generated)` — list of generated variables
* `r(mode)` — `2D` or `3D`
* `r(dimensions)` — number of panel dimensions
* `r(overall_x)` — overall mean of variable `x`

---

## Repository structure

```text
stata-pmean/
│── pmean.ado
│── pmean.sthlp
│── pmean.pkg
│── stata.toc
│── README.md
│── LICENSE
│── CITATION.cff
│── RELEASE_NOTES_v2.0.0.md
│
├── examples/
│   └── example.do
│
└── tests/
    └── test.do
```

---

## License

This project is licensed under the MIT License.

---

## Author

**Ahmad Nawaz**

School of Economics  
Nanjing University, Nanjing China

Department of Economics  
University of Sahiwal, Sahiwal Pakistan

---

## Citation

If you use this package in your research, please cite the version used in your analysis.

For version 2.0.0 before the Zenodo DOI is minted:

Nawaz, A. (2026). *pmean: Stata command for panel means and decomposition* (Version 2.0.0) [Computer software]. GitHub. https://github.com/ahmadNJU/stata-pmean/releases/tag/v2.0.0

After Zenodo archives the GitHub release, cite the version DOI assigned to version 2.0.0.

Previous releases:

Nawaz, A. (2026). *pmean: Stata command for panel means and decomposition* (Version 1.2.0) [Computer software]. Zenodo. https://doi.org/10.5281/zenodo.19787933

Nawaz, A. (2026). *pmean: Stata command for panel means and decomposition* (Version 1.1.1) [Computer software]. Zenodo. https://doi.org/10.5281/zenodo.19752279

---

## Contributing

Feedback, suggestions, and contributions are welcome. Please use GitHub Issues to report bugs or request features.
