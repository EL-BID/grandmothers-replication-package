
clear
cls
set more off

use "$path\Data\3GenPanel.dta" , clear

keep if gd==1 | gm==1
bys ID (n_ent): keep if _n==1

keep if $ifs 

replace gm_died=0 if gm!=1
replace gd_died=0 if gd!=1

* Generate Age Category
egen agecat = cut(eda), at(0,40,50,60,70,80,120)
label define age 0 "Age≤39" 40 "40≤Age≤49" 50 "50≤Age≤59" 60 "60≤Age≤69" 70 "70≤Age≤79" 80 "Age≥80"
label values agecat age

graph bar (sum) gm_died gd_died, over(agecat, label(labsize(3))) ///
ytitle("# of Deaths of Grandparents") b1title("Age of Grandparent") ///
legend(region(style(none)) label(1 "Death of Grandmother") label(2 "Death of Grandfather") ) ///
graphregion(color(white)) bgcolor(white) ylab(,nogrid)

graph export "Figures/Figure A3.pdf", replace