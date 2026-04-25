*! version 1.0.1  25apr2026  Ahmad Nawaz

program define pmean
    version 17.0

    /*
    --------------------------------------------------------------------
    pmean: Panel means and within–between decomposition

    Computes:
        - Overall mean
        - Panel (id) mean
        - Time mean
        - Within-panel deviation
        - Between-panel component
        - Time-specific deviation
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

            * Overall mean
            capture drop `genprefix'overall_`var'
            egen `genprefix'overall_`var' = mean(`var') if `touse'
            label var `genprefix'overall_`var' ///
                "Overall mean of `vlab'"

            * Panel (id) mean
            capture drop `genprefix'idmean_`var'
            bysort `id': egen `genprefix'idmean_`var' = mean(`var') if `touse'
            label var `genprefix'idmean_`var' ///
                "Mean of `vlab' within panel units (`id')"

            * Time mean
            capture drop `genprefix'timemean_`var'
            bysort `time': egen `genprefix'timemean_`var' = mean(`var') if `touse'
            label var `genprefix'timemean_`var' ///
                "Mean of `vlab' across time periods (`time')"

            * Within-panel deviation
            capture drop `genprefix'within_id_`var'
            gen double `genprefix'within_id_`var' = ///
                `var' - `genprefix'idmean_`var'
            label var `genprefix'within_id_`var' ///
                "Within-panel deviation of `vlab' (from panel mean)"

            * Between-panel component
            capture drop `genprefix'between_id_`var'
            gen double `genprefix'between_id_`var' = ///
                `genprefix'idmean_`var' - `genprefix'overall_`var'
            label var `genprefix'between_id_`var' ///
                "Between-panel component of `vlab'"

            * Time-specific deviation
            capture drop `genprefix'between_time_`var'
            gen double `genprefix'between_time_`var' = ///
                `genprefix'timemean_`var' - `genprefix'overall_`var'
            label var `genprefix'between_time_`var' ///
                "Time-specific deviation of `vlab'"

            * Two-way demeaned variable
            capture drop `genprefix'twfe_`var'
            gen double `genprefix'twfe_`var' = ///
                `var' ///
                - `genprefix'idmean_`var' ///
                - `genprefix'timemean_`var' ///
                + `genprefix'overall_`var'
            label var `genprefix'twfe_`var' ///
                "Two-way demeaned `vlab' (panel and time effects removed)"
        }
    }

    di as text "pmean: variables created with prefix `genprefix'"
end
