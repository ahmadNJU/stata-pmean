# pmean

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.19787933.svg)](https://doi.org/10.5281/zenodo.19787933)
![Version](https://img.shields.io/badge/version-1.2.0-blue)
![License](https://img.shields.io/badge/license-MIT-green)
![Stata](https://img.shields.io/badge/Stata-17+-orange)
![Status](https://img.shields.io/badge/status-active-success)
[![Install](https://img.shields.io/badge/install-pmean-blue)](https://raw.githubusercontent.com/ahmadNJU/stata-pmean/main/)

`pmean` is a Stata command for computing panel means and performing within-between decomposition in a unified framework.

It is designed for applied panel data analysis in economics and related social sciences.

---

## What is new in version 1.2.0

Version 1.2.0 is a production-hardening release of the existing two-dimensional command. The formulas and generated variable names remain unchanged, but the command is safer for applied use.

Main changes:

* Uses a stricter command sample based on `if`, `in`, and nonmissing `id()` and `time()` values.
* Preserves the user's original sort order after the command runs.
* Uses double precision for all generated means and decomposed variables.
* Checks generated variable names before creating variables and gives clearer errors for names that are invalid or too long.
* Prevents generated variable names from conflicting with variables in the input `varlist`.
* Requires `save()` to be used together with `table`.
* Uses `replace` consistently: it overwrites existing generated variables and, when `save()` is specified, also allows overwriting an existing CSV file.
* Adds stronger examples and tests, including missing identifiers, string identifiers, existing output variables, file export checks, and custom prefixes.

---

## Features

* Overall pooled mean
* Cross-sectional panel/id mean
* Time mean
* Within-panel deviation
* Between-panel component
* Time-specific deviation component
* Two-way demeaned transformation
* Supports multiple variables in a single call
* Generates labeled variables
* Summary table output via `table`
* Export summary table using `save()`
* Returns results via `r()` for programmatic use

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

```stata
pmean varlist [if] [in], id(panel_id) time(time_id) [genprefix(prefix) replace table save(filename)]
```

Required options:

* `id(varname)` specifies the panel identifier.
* `time(varname)` specifies the time identifier.

Optional arguments:

* `genprefix(prefix)` specifies the prefix for generated variables. The default is `pm_`.
* `replace` overwrites existing generated variables with the same names. If `save()` is also specified, it also permits overwriting the exported CSV file.
* `table` displays a compact summary table.
* `save(filename)` saves the summary table as a CSV file. This option requires `table`.

---

## Example

```stata
sysuse auto, clear

* Create artificial panel structure
gen year = 2000 + mod(_n, 5)
gen id = mod(_n, 3)

* Basic use
pmean price, id(id) time(year) replace

describe pm_*

* Multiple variables and summary table
pmean price mpg weight, id(id) time(year) table replace

* Save summary table
pmean price mpg, id(id) time(year) table save(pmean_summary.csv) replace

* Access returned results
return list
display r(overall_price)
```

---

## Output Variables

For each variable `x`, the command generates:

| Variable | Description |
| --- | --- |
| `pm_overall_x` | Overall mean |
| `pm_idmean_x` | Mean within panel units |
| `pm_timemean_x` | Mean across time periods |
| `pm_within_id_x` | Deviation from panel/id mean |
| `pm_between_id_x` | Between-panel component |
| `pm_between_time_x` | Time-specific deviation component |
| `pm_twfe_x` | Two-way demeaned variable |

All generated variables use double precision and are labeled.

---

## Summary Table Output

Using the `table` option displays a compact summary table:

```stata
pmean price, id(id) time(year) table replace
```

The table includes:

* Number of observations (`N`)
* Mean and standard deviation
* Minimum and maximum values
* Number of panel units
* Number of time periods

To export the table:

```stata
pmean price, id(id) time(year) table save(summary.csv) replace
```

`save()` must be used with `table`. If the output file already exists, specify `replace`.

---

## Stored Results

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
* `r(prefix)` — prefix used for generated variables
* `r(generated)` — list of generated variables
* `r(overall_x)` — overall mean of variable `x`

---

## Notes on the command sample

The command sample is defined by `if`, `in`, and observations with nonmissing `id()` and `time()` values. Missing values of the analysis variables are handled variable by variable by Stata's mean calculations.

Generated variables are missing outside the command sample. When an analysis variable is missing, transformations that depend directly on the original value, such as the within-panel deviation and two-way demeaned variable, are also missing.

---

## Formula note

For variable `x`, the two-way demeaned variable is computed as

```text
x_it - mean_i(x) - mean_t(x) + mean(x)
```

This is a descriptive two-way demeaning formula. It is exact for balanced panels under the usual marginal-mean decomposition. In unbalanced panels, it should be interpreted as a descriptive transformation rather than a guaranteed replacement for full fixed-effects residualization.

---

## Typical Use Cases

* Panel data descriptive analysis
* Within-between decomposition
* Preparing descriptive transformations before fixed-effects models
* Cross-country, regional, firm, household, or sector comparisons
* Environmental, energy, growth, and convergence datasets

---

## Repository Structure

```text
stata-pmean/
│── pmean.ado
│── pmean.sthlp
│── pmean.pkg
│── stata.toc
│── README.md
│── LICENSE
│── CITATION.cff
│
├── examples/
├── tests/
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

For version 1.2.0:

Nawaz, A. (2026). *pmean: Stata command for panel means and decomposition* (Version 1.2.0) [Computer software]. Zenodo. https://doi.org/10.5281/zenodo.19787933

Previous release:

Nawaz, A. (2026). *pmean: Stata command for panel means and decomposition* (Version 1.1.1) [Computer software]. Zenodo. https://doi.org/10.5281/zenodo.19752279

---

## Contributing

Feedback, suggestions, and contributions are welcome. Please use GitHub Issues to report bugs or request features.
