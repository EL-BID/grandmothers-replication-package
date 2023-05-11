clear
cls

set more off
use "$path\Data\3GenPanel.dta" , clear

**********************************************
* Motherhood Penaly - 3 Generation households
**********************************************

preserve

bys ID (n_ent): keep if _n==1
keep if sex==2

gen hij = (n_hij>0) if n_hij!=.
egen agecat = cut(eda), at(0,20,30,40,50,60,70,100)

gcollapse (mean) employed (semean) se_employed=employed, by(agecat hij)
gen w_u = employed + 1.96*se_employed
gen w_l = employed - 1.96*se_employed

drop if agecat==.
gen x =_n
replace x=x[_n-1] if mod(x,2)==0 


twoway (scatter employed x if hij==1, msymbol(S) msize(large)) ///
       (rcap w_u w_l x if hij==1) ///
       (scatter employed x if hij==0, msymbol(Oh) msize(large)) ///
       (rcap w_u w_l x if hij==0),  ///
	xtitle("Age",size(5)) ///
	xlabel(1 "≤20" 3 "20-30" 5 "30-40" 7 "40-50" 9 "50-60" 11 "60-70" 13 "≥70") ///
	legend(region(style(none)) order(1 "With Kids" 3 "Without Kids" ) row(1) size(5) ) ///
	ytitle("Employment Rate (Women)", size(5)) ///
	graphregion(color(white)) bgcolor(white) ylab(,nogrid)
	graph export "Figures/Figure 1A.pdf", replace
restore

**********************************************
* Gender Gap - 3 Generation households
**********************************************


preserve 
drop if merge_eness == 2
bys ID (n_ent): keep if _n==1

egen agecat = cut(eda), at(0,20,30,40,50,60,70,100)

gcollapse (mean) employed (semean) se_employed=employed, by(agecat sex)
gen w_u = employed + 1.96*se_employed
gen w_l = employed - 1.96*se_employed

drop if agecat==.
gen x =_n
replace x=x[_n-1] if mod(x,2)==0 

twoway (scatter employed x if sex==2, msymbol(S) msize(large)) ///
       (rcap w_u w_l x if sex==2) ///
       (scatter employed x if sex==1, msymbol(Oh) msize(large)) ///
       (rcap w_u w_l x if sex==1),  ///
	xtitle("Age",size(5)) ///
	xlabel(1 "≤20" 3 "20-30" 5 "30-40" 7 "40-50" 9 "50-60" 11 "60-70" 13 "≥70") ///
	legend(region(style(none)) order(1 "Women" 3 "Men" ) row(1) size(5)) ///
	ytitle("Employment Rate",size(5)) ///
	graphregion(color(white)) bgcolor(white) ylab(,nogrid)
	
	graph export "Figures/Figure 1B.pdf", replace 
restore







