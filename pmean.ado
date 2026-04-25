*! version 1.0.0  25apr2026  Ahmad Nawaz

program define pmean
    version 17.0

    /*
    --------------------------------------------------------------------
    pmean: Panel means and within–between decomposition

    Computes:
        - Overall mean
        - Cross-sectional mean
        - Time mean
        - Within and between components
        - Two-way demeaned variable

    Author: Ahmad Nawaz
    --------------------------------------------------------------------
    */

    syntax varlist(min=1 numeric) [if] [in], ///
        ID(varname) TIME(varname) ///
        [GENprefix(string) REPLACE]

    if "`genprefix'" == "" local genprefix "pm_"

    tempvar touse
    mark `touse' `if' `in'

    quietly {
        foreach var of varlist `varlist' {

            local vlab : variable label `var'
            if "`vlab'" == "" local vlab "`var'"

            capture drop `genprefix'overall_`var'
            egen `genprefix'overall_`var' = mean(`var') if `touse'
            label variable `genprefix'overall_`var' "Overall mean of `vlab'"

            capture drop `genprefix'idmean_`var'
            bysort `id': egen `genprefix'idmean_`var' = mean(`var') if `touse'
            label variable `genprefix'idmean_`var' "Average of `vlab' within `id'"

            capture drop `genprefix'timemean_`var'
            bysort `time': egen `genprefix'timemean_`var' = mean(`var') if `touse'
            label variable `genprefix'timemean_`var' "Mean of `vlab' in each `time' period"

            capture drop `genprefix'within_id_`var'
            gen double `genprefix'within_id_`var' = `var' - `genprefix'idmean_`var'
            label variable `genprefix'within_id_`var' "Deviation of `vlab' from its `id' mean"

            capture drop `genprefix'between_id_`var'
            gen double `genprefix'between_id_`var' = `genprefix'idmean_`var' - `genprefix'overall_`var'
            label variable `genprefix'between_id_`var' "Between-`id' component of `vlab'"

            capture drop `genprefix'between_time_`var'
            gen double `genprefix'between_time_`var' = `genprefix'timemean_`var' - `genprefix'overall_`var'
            label variable `genprefix'between_time_`var' "Time-specific deviation of `vlab' from overall mean"

            capture drop `genprefix'twfe_`var'
            gen double `genprefix'twfe_`var' = `var' - `genprefix'idmean_`var' - `genprefix'timemean_`var' + `genprefix'overall_`var'
            label variable `genprefix'twfe_`var' "Two-way demeaned `vlab' (`id' & `time')"
        }
    }

    di as text "pmean: variables created with prefix `genprefix'"
end
