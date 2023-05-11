use "$path\Data\ENESS.dta" , clear

keep if inlist(generations,2,3)

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


gen double P23_adj=.
* No access 1
replace P23_adj=1 if P23=="1" | P22=="2" | P22=="4" | P22=="6"   

* Don't Trust 2
replace P23_adj=2 if P23=="3"    

* Can't Afford 3
replace P23_adj=3 if P23=="7"   

* Can't Take/ Pick up 4
replace P23_adj=4 if P23=="5"   

* No need 5
replace P23_adj=5 if P23=="8"  

* Other 6
replace P23_adj=6 if P23=="9"  

label define Reasons 1 "No Access" 2 "Don't Trust" 3 "Can't Afford" 4 "Can't Take/Pickup" 5 "No need" 6 "Other"
label values P23_adj Reasons

label define Childcare 1 `""Public" "childcare ""' 2 `""Private" "childcare""' 3 "Grandmother " 4 `""Other" "family""' 5 `""At" "mother´s" "work ""' 6 "School " 7 `""Mom" "doesn´t" "work"' 8 "Other "
label values P22_adj Childcare

graph bar (percent) if P22_adj!=7 & P23_adj==5 , over(P22_adj, sort(1) descending label( labsize(4) )  ) ///
 ytitle(Percent, size(4)) ///
 legend( ring(0) bplacement(1))  ///
 graphregion(color(white)) bgcolor(white) ylab(,nogrid)

graph export "Figures/Figure A5.pdf", replace
 