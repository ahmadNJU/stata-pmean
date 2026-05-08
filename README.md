# pmean

[![Stata](https://img.shields.io/badge/Stata-15.1%2B-blue)](https://www.stata.com/)
[![Version](https://img.shields.io/badge/version-2.0.2-blue)](https://github.com/ahmadNJU/stata-pmean/releases)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.19752278.svg)](https://doi.org/10.5281/zenodo.19752278)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)

`pmean` is a Stata user-written command for two- and three-dimensional panel means and decomposition. It generates marginal means, between/within components, and (optionally) full ANOVA-style interaction components for balanced and unbalanced panels.

## Description

In the two-dimensional case, `pmean` creates seven variables: the overall mean, id mean, time mean, within-id deviation, between-id component, between-time component, and two-way demeaned variable.

When `dim3()` is specified, `pmean` also creates the third-dimension mean, the third-dimension between component, and a three-way main-effect demeaned variable. With the `full` option, it additionally produces three pairwise cell means, three pairwise interaction components, and a full three-way residual.

The third dimension can represent a sector, region, product group, industry, cohort, or any other grouping variable observed alongside panel id and time. Variables are stored in double precision and labeled. Returned scalars include the overall mean of each input variable.

## Installation

From within Stata:

```stata
net install pmean, from("https://raw.githubusercontent.com/ahmadNJU/stata-pmean/main") replace
```

After installation, type `help pmean` for the full reference.

## Quick start

Two-dimensional panel data (Grunfeld investment panel):

```stata
webuse grunfeld, clear
xtset company year
pmean invest mvalue, id(company) time(year) replace
```

Three-dimensional panel data (Munnell public-capital panel; `gsp` is already log-transformed in this dataset):

```stata
webuse productivity, clear
xtset state year
pmean gsp, id(state) time(year) dim3(region) replace
```

Full pairwise three-dimensional decomposition:

```stata
pmean gsp, id(state) time(year) dim3(region) full genprefix(p2_) replace
```

## What's new in v2.0.2

Version 2.0.2 is a documentation-and-quality release. It is fully backward compatible with v2.0.1: variable names, returned scalars, and existing do-files continue to work without modification.

- Variable **labels** sharpened for clarity (variable **names** unchanged).
- New `listwise` option that requires the variables in `varlist` to be jointly non-missing within the estimation sample.
- Informational note when `dim3()` is nested within `id()` (or vice versa). The id-by-dim3 interaction component is collinear with a main effect in that case; the additive identity still holds and `pmean` does not error.
- Sharpened discussion of unbalanced panels in the help file. The three additive identities (2D, 3D main effects, and full 3-way ANOVA) hold *exactly* observation-by-observation in any panel; what fails in unbalanced panels is component orthogonality, the additive variance decomposition, and equivalence with the OLS residual from `reghdfe x, absorb(id time)`. Reference added to Wansbeek and Kapteyn (1989, *Journal of Econometrics* 41: 341-361).
- Help-file examples updated to use built-in panel datasets (`webuse grunfeld`, `webuse productivity`) instead of fabricating panels from `sysuse auto`.
- New demonstration do-file `pmean_demo.do` shipped with the package, with five figures for the two-dimensional run and five figures for the three-dimensional run, each illustrating a specific generated variable.
- Edge-case behavior (single-id panels, single-period samples, nested third dimensions) documented in the help file.
- Second author added: Jianghuai Zheng.

## Documentation

After installation, type `help pmean` in Stata for the full reference, including syntax, options, formulas, edge cases, and stored results.

## Files in this repository

| File | Description |
|---|---|
| `pmean.ado` | The Stata command. |
| `pmean.sthlp` | Help file. |
| `pmean.pkg` | Package descriptor. |
| `stata.toc` | Table of contents for `net install`. |
| `example.do` | Short usage examples. |
| `tests.do` | Test suite. |
| `CHANGELOG.md` | Version history. |
| `LICENSE` | MIT license. |

## Authors

Ahmad Nawaz, School of Economics, Department of Industrial Economics, Nanjing University, Nanjing 210093, China; Department of Economics, University of Sahiwal, Sahiwal 57000, Pakistan.

Jianghuai Zheng, School of Economics, Department of Industrial Economics, Nanjing University, Nanjing 210093, China.

## Citation

If you use `pmean` in your research, please cite the **specific version** you used so that your analysis is reproducible. For version 2.0.2:

> Nawaz, A., & Zheng, J. (2026). *pmean: Stata command for panel means and decomposition* (Version 2.0.1) [Computer software]. Zenodo. https://doi.org/10.5281/zenodo.20075556

All releases of `pmean` are also accessible through a single concept DOI that always resolves to the latest version: [10.5281/zenodo.19752278](https://doi.org/10.5281/zenodo.19752278). Use this one for general references where you do not need to pin a specific version.

## License

MIT License.
