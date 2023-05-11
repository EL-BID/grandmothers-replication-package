
set more off

use "$path\Data\3GenPanel.dta" , clear

keep if mom==1 | dad==1
est clear

foreach y in ingocup hrsocup  {

gstats winsor `y', cut(5 95) s(_5) by(mom year ent)
gen asinh_`y'_5=asinh(`y'_5)
gen asinh_`y' = asinh(`y')
}

* Full-time
eststo: reghdfe full_time post_gm_died post_gm_died_o_le_5 /// 
if $ifs_mom , ///
absorb(ID yq_c#loc_group#sex yq_c#o_le_5#sex yq_c#gm_died#sex)  cluster(HH_ID)	

	estadd local Cluster "HH" , replace	
	estadd local Sample "", replace

* Part-time
foreach cond in "" "& employed_p1==1" "& part_time_t2_p1==1" "& full_time_p1==1" {
eststo: reghdfe part_time_t2 post_gm_died post_gm_died_o_le_5 /// 
if $ifs_mom `cond', ///
absorb(ID yq_c#loc_group#sex yq_c#o_le_5#sex yq_c#gm_died#sex)  cluster(HH_ID)	

	estadd local Cluster "HH" , replace	
	estadd local Sample "`cond'", replace
}


foreach y in hrsocup ingocup   {
foreach cond in "" "& employed==1" {

eststo: reghdfe asinh_`y'_5 post_gm_died post_gm_died_o_le_5 /// 
if $ifs_mom `cond', ///
absorb(ID yq_c#loc_group#sex yq_c#o_le_5#sex yq_c#gm_died#sex) cluster(HH_ID)
	
	estadd local Sample "`cond'"
	estadd local Cluster "HH" , replace	
}
}

esttab using "Tables/Table 2.csv", star(* 0.10 ** 0.05 *** 0.01) replace se wrap nobaselevels stats(Cluster Sample N, label("Household-level clustered SE" "Sample"))varwidth(40) keep(post_gm_died post_gm_died_o_le_5) nonotes 



