# pmean

![Version](https://img.shields.io/badge/version-1.0.0-blue)
![License](https://img.shields.io/badge/license-MIT-green)
![Stata](https://img.shields.io/badge/Stata-17+-orange)
![Status](https://img.shields.io/badge/status-active-success)
[![Install](https://img.shields.io/badge/install-pmean-blue)](https://raw.githubusercontent.com/ahmadNJU/stata-pmean/main/)

`pmean` is a Stata command for computing panel means and performing within–between decomposition in a unified and efficient framework.

It is designed for applied panel data analysis in economics and other social sciences fields.

---

## Features

* Overall (pooled) mean
* Cross-sectional (panel/id) mean
* Time mean
* Within-panel deviation (demeaning)
* Between-panel decomposition
* Time-specific deviation component
* Two-way demeaned transformation (TWFE-style)
* Supports multiple variables in a single call
* Generates labeled, publication-ready variables
* Summary table output via `table` option
* Export summary table using `save()`

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

## Basic Syntax

```stata
pmean varlist, id(panel_id) time(time_id) [table save(filename)]
```

---

## Example

```stata
sysuse auto, clear

* Create artificial panel structure
gen year = 2000 + mod(_n,5)
gen id = mod(_n,3)

* Apply pmean
pmean price mpg, id(id) time(year)

* Display summary table
pmean price mpg, id(id) time(year) table

* Save summary table
pmean price mpg, id(id) time(year) table save(summary.csv)

* Inspect generated variables
describe pm_*
```

---

## Output Variables

For each variable `x`, the command generates:

| Variable            | Description                    |
| ------------------- | ------------------------------ |
| `pm_overall_x`      | Overall mean                   |
| `pm_idmean_x`       | Mean within panel units        |
| `pm_timemean_x`     | Mean across time periods       |
| `pm_within_id_x`    | Deviation from panel (id) mean |
| `pm_between_id_x`   | Between-panel component        |
| `pm_between_time_x` | Time-specific deviation        |
| `pm_twfe_x`         | Two-way demeaned variable      |

All variables are automatically labeled for clarity and direct interpretation.

---

## Summary Table Output

Using the `table` option displays a compact summary table:

```stata
pmean price, id(id) time(year) table
```

The table includes:

* Number of observations (N)
* Mean, standard deviation
* Minimum and maximum values
* Number of panel units
* Number of time periods

To export the table:

```stata
pmean price, id(id) time(year) table save(summary.csv)
```

---

## Typical Use Cases

* Panel data descriptive analysis
* Within–between decomposition
* Preparing variables for fixed-effects models
* Cross-country or regional comparisons
* Environmental and energy datasets
* Growth and convergence analysis

---

## Repository Structure

```
stata-pmean/
│── pmean.ado
│── pmean.sthlp
│── pmean.pkg
│── stata.toc
│── README.md
│── LICENSE
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

School of Economics, Department of Industrial Economics
Nanjing University, China

Department of Economics
University of Sahiwal, Pakistan

---

## Citation

If you use this package in your research, please cite:

Nawaz, A. (2026). *pmean: Stata command for panel means and decomposition*. GitHub repository.
Available at: [https://github.com/ahmadNJU/stata-pmean](https://github.com/ahmadNJU/stata-pmean)

---

## Contributing

Feedback, suggestions, and contributions are welcome.
Please use GitHub Issues to report bugs or request features.

---
