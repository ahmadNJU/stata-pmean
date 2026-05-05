*! version 2.0.0  05may2026  Ahmad Nawaz

program define pmean, rclass sortpreserve
    version 17.0

    /*
    --------------------------------------------------------------------
    pmean: Panel means and within-between decomposition

    Version 2.0.0 supports both two-dimensional and three-dimensional
    panel data. The command keeps the two-dimensional output from earlier
    releases and adds third-dimension means and three-way decomposition
    when dim3() is specified.

    Author: Ahmad Nawaz
    License: MIT
    --------------------------------------------------------------------
    */

    syntax varlist(numeric min=1) [if] [in], ///
        ID(varname) TIME(varname) ///
        [DIM3(varname) GENprefix(name) REPLACE TABLE SAVE(string asis) FULL PAIRwise]

    if "`genprefix'" == "" {
        local genprefix "pm_"
    }

    if "`pairwise'" != "" {
        local full "full"
    }

    local hasdim3 = ("`dim3'" != "")
    local ndims = cond(`hasdim3', 3, 2)

    if "`id'" == "`time'" {
        display as error "id() and time() must specify different variables."
        exit 198
    }

    if `hasdim3' {
        if "`dim3'" == "`id'" | "`dim3'" == "`time'" {
            display as error "dim3() must be different from id() and time()."
            exit 198
        }
    }

    if "`full'" != "" & !`hasdim3' {
        display as error "full requires dim3()."
        exit 198
    }

    tempvar touse
    marksample touse, novarlist
    markout `touse' `id' `time'
    if `hasdim3' {
        markout `touse' `dim3'
    }

    quietly count if `touse'
    if r(N) == 0 {
        error 2000
    }

    if `"`save'"' != "" & "`table'" == "" {
        display as error "save() requires the table option."
        exit 198
    }

    if `"`save'"' != "" & "`replace'" == "" {
        capture confirm new file `save'
        if _rc {
            local rc = _rc
            display as error "output file cannot be created. Specify replace if the file already exists."
            exit `rc'
        }
    }

    local all_newvars ""
    local toadd 0

    foreach var of varlist `varlist' {

        quietly count if `touse' & !missing(`var')
        if r(N) == 0 {
            display as error "`var' has no nonmissing observations in the requested sample."
            exit 2000
        }

        local v_overall       "`genprefix'overall_`var'"
        local v_idmean        "`genprefix'idmean_`var'"
        local v_timemean      "`genprefix'timemean_`var'"
        local v_within        "`genprefix'within_id_`var'"
        local v_between_id    "`genprefix'between_id_`var'"
        local v_between_time  "`genprefix'between_time_`var'"
        local v_twfe          "`genprefix'twfe_`var'"

        local newvars "`v_overall' `v_idmean' `v_timemean' `v_within' `v_between_id' `v_between_time' `v_twfe'"

        if `hasdim3' {
            local v_dim3mean       "`genprefix'dim3mean_`var'"
            local v_between_dim3   "`genprefix'between_dim3_`var'"
            local v_threefe        "`genprefix'threefe_`var'"

            local newvars "`newvars' `v_dim3mean' `v_between_dim3' `v_threefe'"

            if "`full'" != "" {
                local v_idtime_mean   "`genprefix'idtime_mean_`var'"
                local v_iddim3_mean   "`genprefix'iddim3_mean_`var'"
                local v_timedim3_mean "`genprefix'timedim3_mean_`var'"
                local v_idtime_comp   "`genprefix'idtime_comp_`var'"
                local v_iddim3_comp   "`genprefix'iddim3_comp_`var'"
                local v_timedim3_comp "`genprefix'timedim3_comp_`var'"
                local v_threeway      "`genprefix'threeway_`var'"

                local newvars "`newvars' `v_idtime_mean' `v_iddim3_mean' `v_timedim3_mean'"
                local newvars "`newvars' `v_idtime_comp' `v_iddim3_comp' `v_timedim3_comp' `v_threeway'"
            }
        }

        foreach newvar of local newvars {
            capture confirm name `newvar'
            if _rc {
                display as error "generated variable name `newvar' is invalid or too long."
                display as error "Use a shorter genprefix() or rename `var'."
                exit 198
            }

            if "`newvar'" == "`id'" | "`newvar'" == "`time'" | ("`dim3'" != "" & "`newvar'" == "`dim3'") {
                display as error "generated variable name `newvar' conflicts with an identifier variable."
                exit 198
            }

            if strpos(" `varlist' ", " `newvar' ") {
                display as error "generated variable name `newvar' conflicts with an input variable."
                exit 198
            }

            if "`replace'" == "" {
                capture confirm new variable `newvar'
                if _rc {
                    display as error "`newvar' already exists. Use option replace to overwrite."
                    exit 110
                }
            }

            capture confirm variable `newvar'
            if _rc {
                local toadd = `toadd' + 1
            }
        }

        local all_newvars "`all_newvars' `newvars'"
    }

    if c(k) + `toadd' > c(maxvar) {
        display as error "not enough variable slots are available for the requested output."
        display as error "Current variables: " c(k) "; new variables needed: `toadd'; maxvar: " c(maxvar)
        display as error "Use fewer input variables, omit full, or increase maxvar if your Stata edition allows it."
        exit 900
    }

    local all_newvars : list retokenize all_newvars

    if "`replace'" != "" {
        foreach newvar of local all_newvars {
            capture drop `newvar'
        }
    }

    quietly {

        foreach var of varlist `varlist' {
            local v_overall "`genprefix'overall_`var'"

            egen double `v_overall' = mean(`var') if `touse'
            label variable `v_overall' "Overall mean of `var'"

            summarize `var' if `touse', meanonly
            local overall_`var' = r(mean)
        }

        sort `id'
        foreach var of varlist `varlist' {
            local v_idmean "`genprefix'idmean_`var'"
            by `id': egen double `v_idmean' = mean(`var') if `touse'
            label variable `v_idmean' "Mean of `var' within panel units (`id')"
        }

        sort `time'
        foreach var of varlist `varlist' {
            local v_timemean "`genprefix'timemean_`var'"
            by `time': egen double `v_timemean' = mean(`var') if `touse'
            label variable `v_timemean' "Mean of `var' across time periods (`time')"
        }

        if `hasdim3' {
            sort `dim3'
            foreach var of varlist `varlist' {
                local v_dim3mean "`genprefix'dim3mean_`var'"
                by `dim3': egen double `v_dim3mean' = mean(`var') if `touse'
                label variable `v_dim3mean' "Mean of `var' within third dimension (`dim3')"
            }

            if "`full'" != "" {
                sort `id' `time'
                foreach var of varlist `varlist' {
                    local v_idtime_mean "`genprefix'idtime_mean_`var'"
                    by `id' `time': egen double `v_idtime_mean' = mean(`var') if `touse'
                    label variable `v_idtime_mean' "Mean of `var' within id-time cells"
                }

                sort `id' `dim3'
                foreach var of varlist `varlist' {
                    local v_iddim3_mean "`genprefix'iddim3_mean_`var'"
                    by `id' `dim3': egen double `v_iddim3_mean' = mean(`var') if `touse'
                    label variable `v_iddim3_mean' "Mean of `var' within id-dim3 cells"
                }

                sort `time' `dim3'
                foreach var of varlist `varlist' {
                    local v_timedim3_mean "`genprefix'timedim3_mean_`var'"
                    by `time' `dim3': egen double `v_timedim3_mean' = mean(`var') if `touse'
                    label variable `v_timedim3_mean' "Mean of `var' within time-dim3 cells"
                }
            }
        }

        foreach var of varlist `varlist' {
            local v_overall      "`genprefix'overall_`var'"
            local v_idmean       "`genprefix'idmean_`var'"
            local v_timemean     "`genprefix'timemean_`var'"
            local v_within       "`genprefix'within_id_`var'"
            local v_between_id   "`genprefix'between_id_`var'"
            local v_between_time "`genprefix'between_time_`var'"
            local v_twfe         "`genprefix'twfe_`var'"

            generate double `v_within' = `var' - `v_idmean' if `touse'
            label variable `v_within' "Within-panel deviation of `var'"

            generate double `v_between_id' = `v_idmean' - `v_overall' if `touse'
            label variable `v_between_id' "Between-panel component of `var'"

            generate double `v_between_time' = `v_timemean' - `v_overall' if `touse'
            label variable `v_between_time' "Time-specific deviation of `var'"

            generate double `v_twfe' = `var' - `v_idmean' - `v_timemean' + `v_overall' if `touse'
            label variable `v_twfe' "Two-way demeaned `var' using id and time"

            local newvars "`v_overall' `v_idmean' `v_timemean' `v_within' `v_between_id' `v_between_time' `v_twfe'"

            if `hasdim3' {
                local v_dim3mean      "`genprefix'dim3mean_`var'"
                local v_between_dim3  "`genprefix'between_dim3_`var'"
                local v_threefe       "`genprefix'threefe_`var'"

                generate double `v_between_dim3' = `v_dim3mean' - `v_overall' if `touse'
                label variable `v_between_dim3' "Third-dimension component of `var'"

                generate double `v_threefe' = `var' - `v_idmean' - `v_timemean' - `v_dim3mean' + 2*`v_overall' if `touse'
                label variable `v_threefe' "Three-way main-effect demeaned `var'"

                local newvars "`newvars' `v_dim3mean' `v_between_dim3' `v_threefe'"

                if "`full'" != "" {
                    local v_idtime_mean   "`genprefix'idtime_mean_`var'"
                    local v_iddim3_mean   "`genprefix'iddim3_mean_`var'"
                    local v_timedim3_mean "`genprefix'timedim3_mean_`var'"
                    local v_idtime_comp   "`genprefix'idtime_comp_`var'"
                    local v_iddim3_comp   "`genprefix'iddim3_comp_`var'"
                    local v_timedim3_comp "`genprefix'timedim3_comp_`var'"
                    local v_threeway      "`genprefix'threeway_`var'"

                    generate double `v_idtime_comp' = `v_idtime_mean' - `v_idmean' - `v_timemean' + `v_overall' if `touse'
                    label variable `v_idtime_comp' "Id-time interaction component of `var'"

                    generate double `v_iddim3_comp' = `v_iddim3_mean' - `v_idmean' - `v_dim3mean' + `v_overall' if `touse'
                    label variable `v_iddim3_comp' "Id-dim3 interaction component of `var'"

                    generate double `v_timedim3_comp' = `v_timedim3_mean' - `v_timemean' - `v_dim3mean' + `v_overall' if `touse'
                    label variable `v_timedim3_comp' "Time-dim3 interaction component of `var'"

                    generate double `v_threeway' = `var' - `v_idtime_mean' - `v_iddim3_mean' - `v_timedim3_mean' + `v_idmean' + `v_timemean' + `v_dim3mean' - `v_overall' if `touse'
                    label variable `v_threeway' "Full three-way residual component of `var'"

                    local newvars "`newvars' `v_idtime_mean' `v_iddim3_mean' `v_timedim3_mean'"
                    local newvars "`newvars' `v_idtime_comp' `v_iddim3_comp' `v_timedim3_comp' `v_threeway'"
                }
            }

            local created_vars "`created_vars' `newvars'"
        }
    }

    if "`table'" != "" {

        tempname results
        tempfile summary_table

        local postvars "str32 variable double N mean sd min max panels periods"
        if `hasdim3' {
            local postvars "`postvars' dim3groups"
        }

        postfile `results' `postvars' using `summary_table', replace

        foreach var of varlist `varlist' {

            quietly summarize `var' if `touse'

            local N    = r(N)
            local mean = r(mean)
            local sd   = r(sd)
            local min  = r(min)
            local max  = r(max)

            tempvar tag_id tag_time tag_dim3
            quietly egen byte `tag_id' = tag(`id') if `touse' & !missing(`var')
            quietly egen byte `tag_time' = tag(`time') if `touse' & !missing(`var')

            quietly count if `tag_id' == 1
            local npanels = r(N)

            quietly count if `tag_time' == 1
            local nperiods = r(N)

            if `hasdim3' {
                quietly egen byte `tag_dim3' = tag(`dim3') if `touse' & !missing(`var')
                quietly count if `tag_dim3' == 1
                local ngroups3 = r(N)

                post `results' ///
                    ("`var'") ///
                    (`N') ///
                    (`mean') ///
                    (`sd') ///
                    (`min') ///
                    (`max') ///
                    (`npanels') ///
                    (`nperiods') ///
                    (`ngroups3')
            }
            else {
                post `results' ///
                    ("`var'") ///
                    (`N') ///
                    (`mean') ///
                    (`sd') ///
                    (`min') ///
                    (`max') ///
                    (`npanels') ///
                    (`nperiods')
            }
        }

        postclose `results'

        preserve
            quietly use `summary_table', clear

            label variable variable   "Variable"
            label variable N          "N"
            label variable mean       "Mean"
            label variable sd         "Std. dev."
            label variable min        "Min."
            label variable max        "Max."
            label variable panels     "Panels"
            label variable periods    "Periods"
            if `hasdim3' {
                label variable dim3groups "Dim3 groups"
            }

            format mean sd min max %12.4f
            format N panels periods %12.0f
            if `hasdim3' {
                format dim3groups %12.0f
            }

            list, noobs abbreviate(20)

            if `"`save'"' != "" {
                if "`replace'" != "" {
                    export delimited using `save', replace
                }
                else {
                    export delimited using `save'
                }
                display as text "pmean: summary table saved."
            }
        restore
    }

    local created_vars : list retokenize created_vars

    return local varlist "`varlist'"
    return local id "`id'"
    return local time "`time'"
    return local dim3 "`dim3'"
    return local prefix "`genprefix'"
    return local generated "`created_vars'"
    return local mode "`ndims'D"
    return scalar dimensions = `ndims'

    foreach var of varlist `varlist' {
        return scalar overall_`var' = `overall_`var''
    }

    if `hasdim3' {
        if "`full'" != "" {
            display as text "pmean: 3D variables and full pairwise components created with prefix `genprefix'"
        }
        else {
            display as text "pmean: 3D variables created with prefix `genprefix'"
        }
    }
    else {
        display as text "pmean: 2D variables created with prefix `genprefix'"
    }
end
