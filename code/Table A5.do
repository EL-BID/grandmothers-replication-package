use "$path\Data\3GenPanel.dta" , clear

keep if gk==1 & obs_hh==5  & max_eda_gk<30 & t_dad_max<2  & miss_sex==0 & t_gm_died<2 & t_gd_died<2 & ( (t_gm_max == 1 & inrange(max_eda_gm,40,100) ) | (t_gd_max == 1 & inrange(max_eda_gd,40,100) ) )

est clear
foreach y in as_time_cuidar cuida  {
foreach u in 15 18 21 {
reghdfe `y' post_gm_died  /// 
if y_le_5 & inrange(max_eda,12,`u') & t_gk>1 & gm_le70, ///
absorb(ID yq_c loc_group )  cluster(HH_ID)

local var = subinstr("`y'","as_","",.)

sum `var' if e(sample)

estadd local mean_dep = r(mean)
estadd local FE "ID yq_c loc_group", replace
estadd local SE "HH_ID", replace
estadd local sample "y_le_5 & max_eda 12 to `u' & t_gk>1 & gm_le70", replace


eststo
}
}

esttab  using "Tables/Table A5.csv",  ///
	star(* 0.10 ** 0.05 *** 0.01) replace wrap nobaselevels se ///
	stats(N SE FE  mean_dep sample , ///
	label("Observations" "SE" "Fixed Effects" "Mean_Dep" "sample"))  ///
	varwidth(45)  nonotes 


