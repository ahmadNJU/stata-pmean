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
