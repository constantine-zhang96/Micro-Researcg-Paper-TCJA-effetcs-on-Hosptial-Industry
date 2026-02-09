import delimited using "data_all_years_cleaned.csv", clear
preserve

collapse (median) med_LOGFTE=logfteemployeesonpayroll, by(year for_profit)

twoway (line med_LOGFTE year if for_profit==0, lwidth(medthick)) (scatter med_LOGFTE year if for_profit==0, msymbol(O)) (line med_LOGFTE year if for_profit==1, lwidth(medthick)) (scatter med_LOGFTE year if for_profit==1, msymbol(O)) ,  yscale(range(5 6.5)) ylabel(5(0.5)6.5) ytitle("Log of FTE Employees on Payroll") title("(Figure 1) Parallel Trends Check for log(FTE Employees)") legend(order(1 "Non-profit" 3 "For-profit") rows(1))

restore

estpost summarize fteemployeesonpayroll totalsalariesfromworksheeta numberofbeds totaldischargestitlexviii totalcosts, detail

esttab ., cells("mean sd min max p50")  label title("Descriptive Statistics of Numeric Hospital Variables") nonumber nomtitle

preserve

keep if inlist(year, 2017, 2019)

drop post

gen post = (year==2019)

eststo base19: reg logfteemployeesonpayroll i.post##i.for_profit

restore

drop post

preserve

keep if inlist(year, 2017, 2020)

gen post = (year==2020)

eststo base20: reg logfteemployeesonpayroll i.post##i.for_profit

restore

preserve

keep if inlist(year, 2017, 2021)

gen post = (year==2021)

eststo base21: reg logfteemployeesonpayroll i.post##i.for_profit

restore

preserve

keep if inlist(year, 2017, 2022)

gen post = (year==2022)

eststo base22: reg logfteemployeesonpayroll i.post##i.for_profit

restore

esttab base19 base20 base21 base22, cells(b(fmt(4)) se(par fmt(4))) star(* 0.10 ** 0.05 *** 0.01) stats(N r2, fmt(0 4)) label

preserve

keep if inlist(year, 2017, 2019)

gen post = (year==2019)

eststo control19: reg logfteemployeesonpayroll i.post##i.for_profit numberofbeds totaldischargestitlexviii urban

restore

preserve

keep if inlist(year, 2017, 2020)

gen post = (year==2020)

eststo control20: reg logfteemployeesonpayroll i.post##i.for_profit numberofbeds totaldischargestitlexviii urban

restore

preserve

keep if inlist(year, 2017, 2021)

gen post = (year==2021)

eststo control21: reg logfteemployeesonpayroll i.post##i.for_profit numberofbeds totaldischargestitlexviii urban

restore

preserve

keep if inlist(year, 2017, 2022)

gen post = (year==2022)

eststo control22: reg logfteemployeesonpayroll i.post##i.for_profit numberofbeds totaldischargestitlexviii urban

restore

esttab control19 control20 control21 control22, cells(b(fmt(2)) se(par fmt(2))) star(* 0.10 ** 0.05 *** 0.01) stats(N r2, fmt(0 3)) label

preserve

keep if inlist(year, 2017, 2019)

gen post = (year==2019)

eststo fix19: areg logfteemployeesonpayroll i.post##i.for_profit totaldischargestitlexviii urban , absorb(statecode) vce(robust)

restore

preserve

keep if inlist(year, 2017, 2020)

gen post = (year==2020)

eststo fix20: areg logfteemployeesonpayroll i.post##i.for_profit totaldischargestitlexviii urban , absorb(statecode) vce(robust)

restore

preserve

keep if inlist(year, 2017, 2021)

gen post = (year==2021)

eststo fix21: areg logfteemployeesonpayroll i.post##i.for_profit totaldischargestitlexviii urban , absorb(statecode) vce(robust)

restore

preserve

keep if inlist(year, 2017, 2022)

gen post = (year==2022)

eststo fix22: areg logfteemployeesonpayroll i.post##i.for_profit totaldischargestitlexviii urban , absorb(statecode) vce(robust)

restore

esttab fix19 fix20 fix21 fix22, cells(b(fmt(2)) se(par fmt(2))) star(* 0.10 ** 0.05 *** 0.01) stats(N r2, fmt(0 3)) label

preserve

keep if inlist(year, 2017, 2019)

sort hospitalname year

by hospitalname: gen d_LOGFTE = logfteemployeesonpayroll[_n] - logfteemployeesonpayroll[_n-1]

by hospitalname: gen d_beds = log(numberofbeds) - log(numberofbeds[_n-1])

by hospitalname: gen d_discharges = log(totaldischargestitlexviii) - log(totaldischargestitlexviii[_n-1])

by hospitalname: gen d_urban = urban - urban[_n-1]

by hospitalname: keep if _n == 2

eststo diff19: reg d_LOGFTE for_profit d_beds d_discharges d_urban

restore

preserve

keep if inlist(year, 2017, 2020)

sort hospitalname year

by hospitalname: gen d_LOGFTE = logfteemployeesonpayroll[_n] - logfteemployeesonpayroll[_n-1]

by hospitalname: gen d_beds = log(numberofbeds) - log(numberofbeds[_n-1])

by hospitalname: gen d_discharges = log(totaldischargestitlexviii) - log(totaldischargestitlexviii[_n-1])

by hospitalname: gen d_urban = urban - urban[_n-1]

by hospitalname: keep if _n == 2

eststo diff20: reg d_LOGFTE for_profit d_beds d_discharges d_urban

restore

preserve

keep if inlist(year, 2017, 2021)

sort hospitalname year

by hospitalname: gen d_LOGFTE = logfteemployeesonpayroll[_n] - logfteemployeesonpayroll[_n-1]

by hospitalname: gen d_beds = log(numberofbeds) - log(numberofbeds[_n-1])

by hospitalname: gen d_discharges = log(totaldischargestitlexviii) - log(totaldischargestitlexviii[_n-1])

by hospitalname: gen d_urban = urban - urban[_n-1]

by hospitalname: keep if _n == 2

eststo diff21: reg d_LOGFTE for_profit d_beds d_discharges d_urban

restore

preserve

keep if inlist(year, 2017, 2022)

sort hospitalname year

by hospitalname: gen d_LOGFTE = logfteemployeesonpayroll[_n] - logfteemployeesonpayroll[_n-1]

by hospitalname: gen d_beds = log(numberofbeds) - log(numberofbeds[_n-1])

by hospitalname: gen d_discharges = log(totaldischargestitlexviii) - log(totaldischargestitlexviii[_n-1])

by hospitalname: gen d_urban = urban - urban[_n-1]

by hospitalname: keep if _n == 2

eststo diff22: reg d_LOGFTE for_profit d_beds d_discharges d_urban

restore

esttab diff19 diff20 diff21 diff22, cells(b(fmt(2)) se(par fmt(2))) star(* 0.10 ** 0.05 *** 0.01) stats(N r2, fmt(0 3)) label




