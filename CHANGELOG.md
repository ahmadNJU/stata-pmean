# Changelog

All notable changes to `pmean` are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/), and this project adheres to [Semantic Versioning](https://semver.org/).

## [2.0.2] - 2026-05-08

A documentation-and-quality release. Fully backward compatible with 2.0.0.

### Added

- New `listwise` option that requires the variables in `varlist` to be jointly non-missing within the estimation sample. By default, missingness is still handled per-variable.
- Informational note when `dim3()` is nested within `id()` (or vice versa), warning that the id-by-dim3 interaction component is collinear with a main effect in that case. The additive identity still holds and `pmean` does not error.

### Changed

- All 17 generated variable **labels** rewritten for clarity. **Variable names are unchanged**, preserving full backward compatibility.
- Help-file discussion of unbalanced panels sharpened: the three additive identities (2D, 3D main effects, and full 3-way ANOVA) hold exactly observation-by-observation in any panel; what fails in unbalanced panels is component orthogonality, the additive variance decomposition, and numerical equivalence with the OLS residual from `reghdfe x, absorb(id time)`.
- Reference added to Wansbeek and Kapteyn (1989, *Journal of Econometrics* 41: 341-361) for the unbalanced-panel theory.
- Help-file examples updated to use built-in panel datasets (`webuse grunfeld`, `webuse productivity`) instead of fabricating panels from `sysuse auto` with `mod(_n, ...)`.
- `example.do` rewritten to use built-in panel datasets and to demonstrate the new `listwise` option.

### Documented

- Edge-case behavior: single-id panels, single-period samples, nested third dimensions, per-variable vs. listwise missingness.
- Behavior of `by g: egen y = mean(x) if touse` (per-group mean over `touse==1` observations; missing on `touse==0` observations).

### Backward compatibility

- Variable names are unchanged.
- All v2.0.0 do-files continue to work without modification.

## [2.0.0] - 2026-04-28

Three-dimensional release.

### Added

- Three-dimensional panel decomposition via the `dim3()` option. Adds three new generated variables in 3D mode: `pm_dim3mean_x`, `pm_between_dim3_x`, and `pm_threefe_x`.
- Optional `full` (synonym `pairwise`) for the full ANOVA-style decomposition with three pairwise cell means, three pairwise interaction components, and a three-way residual.
- `table` summary option and `save()` CSV export.
- Returned scalar `r(overall_x)` for each input variable.
- `r(mode)` returning `2D` or `3D`.

## [1.x] - earlier

- Two-dimensional panel means and decomposition (id mean, time mean, within-id deviation, between-id component, between-time component, two-way demeaned variable).
