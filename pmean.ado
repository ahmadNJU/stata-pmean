*! version 1.1.0  25apr2026  Ahmad Nawaz

program define pmean, rclass
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
        [GENprefix(string) REPLACE TABLE SAVE(string asis)]

    if "`genprefix'" == "" local genprefix "pm_"

    tempvar touse
    mark `touse' `if' `in'

    local created_vars ""

    quietly {
        foreach var of varlist `varlist' {

            local vlab : variable label `var'
            if "`vlab'" == "" local vlab "`var'"

            local v_overall      "`genprefix'overall_`var'"
            local v_idmean       "`genprefix'idmean_`var'"
            local v_timemean     "`genprefix'timemean_`var'"
            local v_within       "`genprefix'within_id_`var'"
            local v_between_id   "`genprefix'between_id_`var'"
            local v_between_time "`genprefix'between_time_`var'"
            local v_twfe         "`genprefix'twfe_`var'"

            if "`replace'" != "" {
                capture drop `v_overall'
                capture drop `v_idmean'
                capture drop `v_timemean'
                capture drop `v_within'
                capture drop `v_between_id'
                capture drop `v_between_time'
                capture drop `v_twfe'
            }
            else {
                foreach newvar in `v_overall' `v_idmean' `v_timemean' `v_within' `v_between_id' `v_between_time' `v_twfe' {
                    capture confirm new variable `newvar'
                    if _rc {
                        di as error "`newvar' already exists. Use option replace to overwrite."
                        exit 110
                    }
                }
            }

            egen `v_overall' = mean(`var') if `touse'
            label var `v_overall' "Overall mean of `vlab'"

            summarize `var' if `touse', meanonly
            return scalar overall_`var' = r(mean)

            bysort `id': egen `v_idmean' = mean(`var') if `touse'
            label var `v_idmean' "Mean of `vlab' within panel units (`id')"

            bysort `time': egen `v_timemean' = mean(`var') if `touse'
            label var `v_timemean' "Mean of `vlab' across time periods (`time')"

            gen double `v_within' = `var' - `v_idmean'
            label var `v_within' "Within-panel deviation of `vlab'"

            gen double `v_between_id' = `v_idmean' - `v_overall'
            label var `v_between_id' "Between-panel component of `vlab'"

            gen double `v_between_time' = `v_timemean' - `v_overall'
            label var `v_between_time' "Time-specific deviation of `vlab'"

            gen double `v_twfe' = `var' - `v_idmean' - `v_timemean' + `v_overall'
            label var `v_twfe' "Two-way demeaned `vlab'"

            local created_vars "`created_vars' `v_overall' `v_idmean' `v_timemean' `v_within' `v_between_id' `v_between_time' `v_twfe'"
        }
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
            quietly {
                use `summary_table', clear
            }

            format mean sd min max %12.4f
            format N panels periods %12.0f

            list, noobs abbreviate(20)

            if "`save'" != "" {
                export delimited using "`save'", replace
                di as text "pmean: summary table saved to `save'"
            }
        restore
    }

    return local varlist "`varlist'"
    return local id "`id'"
    return local time "`time'"
    return local prefix "`genprefix'"
    return local generated "`created_vars'"

    di as text "pmean: variables created with prefix `genprefix'"
end
