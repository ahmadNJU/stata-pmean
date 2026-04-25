*! version 1.1.0  25apr2026  Ahmad Nawaz

program define pmean, rclass
    version 17.0

    /*
    --------------------------------------------------------------------
    pmean: Panel means and within–between decomposition

    Features:
        - Overall, panel, and time means
        - Within and between decomposition
        - Two-way demeaned variables
        - Summary table output
        - r-class returns

    Author: Ahmad Nawaz
    --------------------------------------------------------------------
    */

    syntax varlist(min=1 numeric) [if] [in], ///
        ID(varname) TIME(varname) ///
        [GENprefix(string) REPLACE TABLE SAVE(string)]

    if "`genprefix'" == "" local genprefix "pm_"

    tempvar touse
    mark `touse' `if' `in'

    local created_vars ""

    quietly {
        foreach var of varlist `varlist' {

            local vlab : variable label `var'
            if "`vlab'" == "" local vlab "`var'"

            * Overall mean
            capture drop `genprefix'overall_`var'
            egen `genprefix'overall_`var' = mean(`var') if `touse'
            label var `genprefix'overall_`var' "Overall mean of `vlab'"
            summarize `var' if `touse'
            return scalar overall_`var' = r(mean)

            * Panel mean
            capture drop `genprefix'idmean_`var'
            bysort `id': egen `genprefix'idmean_`var' = mean(`var') if `touse'
            label var `genprefix'idmean_`var' ///
                "Mean of `vlab' within panel units (`id')"

            * Time mean
            capture drop `genprefix'timemean_`var'
            bysort `time': egen `genprefix'timemean_`var' = mean(`var') if `touse'
            label var `genprefix'timemean_`var' ///
                "Mean of `vlab' across time periods (`time')"

            * Within
            capture drop `genprefix'within_id_`var'
            gen double `genprefix'within_id_`var' = ///
                `var' - `genprefix'idmean_`var'
            label var `genprefix'within_id_`var' ///
                "Within-panel deviation of `vlab'"

            * Between id
            capture drop `genprefix'between_id_`var'
            gen double `genprefix'between_id_`var' = ///
                `genprefix'idmean_`var' - `genprefix'overall_`var'
            label var `genprefix'between_id_`var' ///
                "Between-panel component of `vlab'"

            * Between time
            capture drop `genprefix'between_time_`var'
            gen double `genprefix'between_time_`var' = ///
                `genprefix'timemean_`var' - `genprefix'overall_`var'
            label var `genprefix'between_time_`var' ///
                "Time-specific deviation of `vlab'"

            * TWFE
            capture drop `genprefix'twfe_`var'
            gen double `genprefix'twfe_`var' = ///
                `var' ///
                - `genprefix'idmean_`var' ///
                - `genprefix'timemean_`var' ///
                + `genprefix'overall_`var'
            label var `genprefix'twfe_`var' ///
                "Two-way demeaned `vlab'"

            local created_vars "`created_vars' ///
                `genprefix'overall_`var' ///
                `genprefix'idmean_`var' ///
                `genprefix'timemean_`var' ///
                `genprefix'within_id_`var' ///
                `genprefix'between_id_`var' ///
                `genprefix'between_time_`var' ///
                `genprefix'twfe_`var'"
        }
    }

    * -------------------------------
    * Summary table
    * -------------------------------
    if "`table'" != "" {

        tempname results
        tempfile summary_table

        postfile `results' str32 variable ///
            double N mean sd min max ///
            double panels periods ///
            using `summary_table', replace

        foreach var of varlist `varlist' {

            quietly summarize `var' if `touse'

            tempvar tag_id tag_time
            quietly egen `tag_id' = tag(`id') if `touse' & !missing(`var')
            quietly egen `tag_time' = tag(`time') if `touse' & !missing(`var')

            quietly count if `tag_id' == 1
            local npanels = r(N)

            quietly count if `tag_time' == 1
            local nperiods = r(N)

            post `results' ///
                ("`var'") ///
                (r(N)) ///
                (r(mean)) ///
                (r(sd)) ///
                (r(min)) ///
                (r(max)) ///
                (`npanels') ///
                (`nperiods')
        }

        postclose `results'

        preserve
            use `summary_table', clear
            format mean sd min max %12.4f
            format N panels periods %12.0f
            list, noobs abbreviate(20)

            if "`save'" != "" {
                export delimited using "`save'", replace
                di as text "pmean: summary table saved to `save'"
            }
        restore
    }

    * Return metadata
    return local varlist "`varlist'"
    return local id "`id'"
    return local time "`time'"
    return local prefix "`genprefix'"
    return local generated "`created_vars'"

    di as text "pmean: variables created with prefix `genprefix'"
end
