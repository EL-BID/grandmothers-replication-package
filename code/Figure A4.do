cls
clear all

use "$path\Data\ENESS.dta" , clear

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

graph bar (percent) , over(P23_adj, label( labsize(3)) sort(1) descending) ///
 ytitle(Percent) ///
 legend( ring(0) bplacement(1)) ///
 graphregion(color(white)) bgcolor(white) ylab(,nogrid)
 
 graph export "Figures/Figure A4.pdf", replace
