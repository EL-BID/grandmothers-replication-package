cls
use "$path\Data\ENESS.dta" , clear

keep if inlist(generations ,2,3)
gen gen3_flag = (generations==3)

gen double P22_adj=.
* Public Childcare provision 1
replace P22_adj=1 if P22=="01" | P22=="02" | P22=="03" | P22=="04" | P22=="05" | P22=="07"   

* Private Childcare provision 2
replace P22_adj=2 if P22=="06" | P22=="08"    

* Grandmother 3
replace P22_adj=3 if (P22=="09"&year==2009) | (P22=="10"&year==2013)

* Other Family Member 4
replace P22_adj=4 if (P22=="10"&year==2009) | (P22=="11"&year==2013) | (P22=="09"&year==2013)

* Goes to Work with Mother 5
replace P22_adj=5 if (P22=="12"&year==2009) | (P22=="13"&year==2013)

* Goes to School 6
replace P22_adj=6 if (P22=="14"&year==2009) | (P22=="15"&year==2013)

* Mom doen't work 7 
replace P22_adj=7 if (P22=="00"&year==2009) | (P22=="00"&year==2013)

* Other 8 Non Family Member or Alone
replace P22_adj=8 if (P22=="11"&year==2009) | (P22=="12"&year==2013) | (P22=="13"&year==2009) | (P22=="14"&year==2013)


label define Childcare 1 `""Public" "childcare ""' 2 `""Private" "childcare""' 3 "Grandmother " 4 `""Other" "family""' 5 `""At" "mother´s" "work ""' 6 "School " 7 `""Mom" "doesn´t" "work"' 8 "Other "
label values P22_adj Childcare

separate P22_adj, by(gen3_flag)
// separate P23_adj, by(year)

* Graph 1 
gen factor=FACTOR
replace factor=FAC_ENESS if factor==.

	graph bar if P22_adj!=7 & P22_adj!=5 [pw=factor], over(P22_adj, sort(1) descending label(labsize(3.7))) blabel(bar, format(%3.1f)) ///
	 ytitle(Percent, size(5)) ///
	 graphregion(color(white)) bgcolor(white) ylab(,nogrid)
	 
	graph export "Figures/Figure A1A.pdf", replace
 
* Graph 2 

	* Not considering kids that go to work with their mothers and mother that dont work
	graph bar (percent) P22_adj1 P22_adj0 if P22_adj!=7 & P22_adj!=5 [pw=factor], over(P22_adj, sort(1) descending label(labsize(3.7))) blabel(bar, format(%3.1f)) ///
	  ytitle(Percent, size(5)) ylabel(,nogrid)  ///
	 legend( region(lcolor(white)) label(1 "3-Generation Households") label(2 "2-Generation Households")  ring(0)  position(1) rows(2))  graphregion(color(white)) bgcolor(white)
	 
	graph export "Figures/Figure A1B.pdf", replace

* Graph 3
preserve
	keep if P22_adj!=7 & P22_adj!=5 & P22_adj!=.
	tabulate P22_adj, generate(C)
	gcollapse (mean) C? [pw=factor], by(EDA)

	destring(EDA), replace

	graph twoway (connected C3 EDA) (connected C5 EDA, msymbol(S)) , ytitle(Percent, size(5)) xtitle(Age of Child, size(5))  ///
	 legend( label(1 "Grandmother") label(2 "School") region(style(none)) size(4) )  xlab(0(1)6) ylab(0(.1).6) ///
	 graphregion(color(white)) bgcolor(white) ylab(,nogrid angle(0)) 

	graph export "Figures/Figure A1C.pdf", replace




