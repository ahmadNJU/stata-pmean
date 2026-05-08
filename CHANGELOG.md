## [2.0.2] - 2026-05-08

An SSC-conformance and quality release. Fully backward compatible with 2.0.1: variable names, generated outputs, and existing do-files continue to work without modification.

### Added

- New returned scalar `r(N)`: number of observations in the estimation sample. Standard SSC convention; useful for downstream programs that test sample size after `pmean`.
- New returned macro `r(cmd) = "pmean"`: standard convention for r-class commands; lets other tools detect that `pmean` was the most recent command.
- New returned macro `r(cmdline)`: stores the command exactly as the user typed it; useful for replication and audit trails.
- New "References" section in the help file with full bibliographic citations for Wansbeek and Kapteyn (1989), Mundlak (1978), and Correia (2016).
- New "Also see" section in the help file referencing `xtreg`, `xtsum`, `xtdescribe`, `egen`, `pwmean`, and `reghdfe` (if installed). The `pwmean` reference includes a contextual note distinguishing descriptive panel decomposition (`pmean`) from inferential pairwise mean comparison (`pwmean`).
- Tests for the new returned values; encode-first workflow test for string identifiers.

### Changed

- **Stata version requirement reduced from 17.0 to 15.1.** None of the operations used by `pmean` require Stata 16 or 17 features; lowering the requirement broadens the user audience to all Stata 15.1+ users.
- Shebang line revised to canonical SSC form: `*! pmean v2.0.2 ANAW-JZ 8may2026`.
- Variable name validation now explicitly rejects names exceeding 32 characters with a clear error message before any variable is created.
- Help-file examples updated: removed the redundant `gen lngsp = ln(gsp)` step from the productivity-panel examples (the `gsp` variable is already log-transformed in Stata's shipped dataset).

### Documented

- Behavior of generated variables on observations excluded by the `listwise` option: they remain missing by design, consistent with Stata's standard handling of `if touse` in `egen`.
- Compatibility with `set varabbrev off` (verified under both Stata 17 and the explicit `version 15.1` block).

### Backward compatibility

- Variable names unchanged.
- All previously returned scalars and macros unchanged.
- All v2.0.1 do-files continue to work without modification.
- Mathematical behavior of all 17 generated decomposition variables unchanged; the additive identities remain exact at every observation in any panel, balanced or unbalanced.

### Distribution

- Submitted to the SSC archive (Boston College Department of Economics).
- GitHub release tagged `v2.0.2`.
- Zenodo version DOI: 10.5281/zenodo.XXXXXXXX.
