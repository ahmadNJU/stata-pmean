*! version 1.2.0  27apr2026  Ahmad Nawaz

program define pmean, rclass sortpreserve
    version 17.0

    /*
    --------------------------------------------------------------------
    pmean: Panel means and within-between decomposition

    Features:
        - Overall, panel, and time means
        - Within and between decomposition
        - Two-way demeaned variables
        - Summary table output
        - r-class returns

    Author: Ahmad Nawaz
    License: MIT
    --------------------------------------------------------------------
    */

    syntax varlist(numeric min=1) [if] [in], ///
        ID(varname) TIME(varname) ///
        [GENprefix(name) REPLACE TABLE SAVE(string asis)]

    if "`genprefix'" == "" {
        local genprefix "pm_"
    }

    tempvar touse
    marksample touse, novarlist
    markout `touse' `id' `time'

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
            display as error "output file cannot be created. Specify replace if the file already exists."
            exit _rc
        }
    }

    local created_vars ""

    foreach var of varlist `varlist' {

        quietly count if `touse' & !missing(`var')
        if r(N) == 0 {
            display as error "`var' has no nonmissing observations in the requested sample."
            exit 2000
        }

        local v_overall      "`genprefix'overall_`var'"
        local v_idmean       "`genprefix'idmean_`var'"
        local v_timemean     "`genprefix'timemean_`var'"
        local v_within       "`genprefix'within_id_`var'"
        local v_between_id   "`genprefix'between_id_`var'"
        local v_between_time "`genprefix'between_time_`var'"
        local v_twfe         "`genprefix'twfe_`var'"

        local newvars "`v_overall' `v_idmean' `v_timemean' `v_within' `v_between_id' `v_between_time' `v_twfe'"

        foreach newvar of local newvars {
            capture confirm name `newvar'
            if _rc {
                display as error "generated variable name `newvar' is invalid or too long."
                display as error "Use a shorter genprefix() or rename `var'."
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

        local newvars "`v_overall' `v_idmean' `v_timemean' `v_within' `v_between_id' `v_between_time' `v_twfe'"

        if "`replace'" != "" {
            foreach newvar of local newvars {
                capture drop `newvar'
            }
        }

        quietly egen double `v_overall' = mean(`var') if `touse'
        label variable `v_overall' "Overall mean of `var'"

        quietly summarize `var' if `touse', meanonly
        local overall_`var' = r(mean)

        quietly egen double `v_idmean' = mean(`var') if `touse', by(`id')
        label variable `v_idmean' "Mean of `var' within panel units (`id')"

        quietly egen double `v_timemean' = mean(`var') if `touse', by(`time')
        label variable `v_timemean' "Mean of `var' across time periods (`time')"

        quietly generate double `v_within' = `var' - `v_idmean' if `touse'
        label variable `v_within' "Within-panel deviation of `var'"

        quietly generate double `v_between_id' = `v_idmean' - `v_overall' if `touse'
        label variable `v_between_id' "Between-panel component of `var'"

        quietly generate double `v_between_time' = `v_timemean' - `v_overall' if `touse'
        label variable `v_between_time' "Time-specific deviation of `var'"

        quietly generate double `v_twfe' = `var' - `v_idmean' - `v_timemean' + `v_overall' if `touse'
        label variable `v_twfe' "Two-way demeaned `var'"

        local created_vars "`created_vars' `newvars'"
    }

    if "`table'" != "" {

        tempname results
        tempfile summary_table

        postfile `results' str32 variable ///
            double N mean sd min max panels periods ///
            using `summary_table', replace

        foreach var of varlist `varlist' {

            quietly summarize `var' if `touse'

            local N    = r(N)
            local mean = r(mean)
            local sd   = r(sd)
            local min  = r(min)
            local max  = r(max)

            tempvar tag_id tag_time
            quietly egen `tag_id' = tag(`id') if `touse' & !missing(`var')
            quietly egen `tag_time' = tag(`time') if `touse' & !missing(`var')

            quietly count if `tag_id' == 1
            local npanels = r(N)

            quietly count if `tag_time' == 1
            local nperiods = r(N)

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

        postclose `results'

        preserve
            quietly use `summary_table', clear

            label variable variable "Variable"
            label variable N        "N"
            label variable mean     "Mean"
            label variable sd       "Std. dev."
            label variable min      "Min."
            label variable max      "Max."
            label variable panels   "Panels"
            label variable periods  "Periods"

            format mean sd min max %12.4f
            format N panels periods %12.0f

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
    return local prefix "`genprefix'"
    return local generated "`created_vars'"

    foreach var of varlist `varlist' {
        return scalar overall_`var' = `overall_`var''
    }

    display as text "pmean: variables created with prefix `genprefix'"
end
