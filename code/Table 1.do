clear all
set more off

use "$path\Data\3GenPanel.dta" , clear

keep if sec_gen==1

*************************************************************************
* Panel A. Mothers
*************************************************************************
eststo clear
reghdfe employed post_gm_died##gm_died##o_le_5 /// 
if $ifs_mom, ///
absorb(ID yq_c#loc_group#sex yq_c#o_le_5#sex yq_c#gm_died#sex)  cluster(HH_ID)	
capture drop sample
gen sample = e(sample)

foreach FE in "ID yq_c#loc_group#sex yq_c#o_le_5#sex yq_c#gm_died#sex" "ID year#loc_group#sex yq_c#o_le_5#sex yq_c#gm_died#sex" "ID yq_c#loc_group#sex yq_c#gm_died#sex" "ID yq_c#loc_group#sex yq_c#o_le_5#sex" "ID yq_c#o_le_5#sex yq_c#gm_died#sex" "ID yq_c#loc_group#sex" "ID yq_c#gm_died#sex" "ID  yq_c#o_le_5#sex"  "ID" "yq_c#loc_group#sex eda_cat5#sex t_gk_max#t_sec_gen_max#sex#t_ind_max inc_f_cat10#sex edu_max#sex" "yq_c#loc_group#sex" {
	
local FE_text = subinstr("`FE'","#","_",.)
	
reghdfe employed post_gm_died##gm_died##o_le_5 /// 
if $ifs_mom & sample==1, ///
absorb(`FE')  cluster(HH_ID)	
	estadd local FE "`FE_text'" , replace	
	estadd local Cluster "HH", replace
eststo
}
	
esttab using "Tables/Table 1A.csv", star(* 0.10 ** 0.05 *** 0.01) replace se wrap label nomtitles collabels(none) stats(FE Cluster N)  nonotes keep(1.post_gm_died 1.post_gm_died#1.o_le_5)

***************************************************************
* Panel B. Mothers and Fathers
***************************************************************
eststo clear
reghdfe employed post_gm_died##gm_died##o_le_5##mom /// 
if $ifs_mom | $ifs_dad , ///
absorb(ID yq_c#loc_group#sex yq_c#o_le_5#sex yq_c#gm_died#sex)  cluster(HH_ID)	
capture drop sample
gen sample = e(sample)

foreach FE in "ID yq_c#loc_group#sex yq_c#o_le_5#sex yq_c#gm_died#sex" "ID year#loc_group#sex yq_c#o_le_5#sex yq_c#gm_died#sex" "ID yq_c#loc_group#sex yq_c#gm_died#sex" "ID yq_c#loc_group#sex yq_c#o_le_5#sex" "ID yq_c#o_le_5#sex yq_c#gm_died#sex" "ID yq_c#loc_group#sex" "ID yq_c#gm_died#sex" "ID  yq_c#o_le_5#sex"  "ID" "yq_c#loc_group#sex eda_cat5#sex t_gk_max#t_sec_gen_max#sex#t_ind_max inc_f_cat10#sex edu_max#sex" "yq_c#loc_group#sex"{
	
local FE_text = subinstr("`FE'","#","_",.)
	
reghdfe employed post_gm_died##gm_died##o_le_5##mom /// 
if $ifs_mom | $ifs_dad & sample==1, ///
absorb(`FE')  cluster(HH_ID)	
	estadd local FE "`FE_text'" , replace	
	estadd local Cluster "HH", replace
eststo
}
	
esttab using "Tables/Table 1B.csv", star(* 0.10 ** 0.05 *** 0.01) replace se wrap label nomtitles collabels(none) stats(FE Cluster N)  nonotes keep(1.post_gm_died 1.post_gm_died#1.o_le_5 1.post_gm_died#1.mom 1.post_gm_died#1.o_le_5#1.mom)
