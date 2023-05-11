set more off

use "$path\Data\3GenPanel.dta" , clear

keep if (dad==1 | mom==1) & inrange(max_eda,21,50) & max_eda_gk<30 & miss_sex==0

*****************************************************
* Panel A Mothers 
****************************************************

	local if_reg = "$ifs_mom"
	local regressors post_gm_died post_gm_died_o_le_5	
	
	eststo clear

	* Base
	eststo: reghdfe employed `regressors' /// 
	if `if_reg', ///
	absorb(ID yq_c#loc_group#sex yq_c#o_le_5#sex yq_c#gm_died#sex)  cluster(HH_ID)	

		estadd local model "Base" , replace	

	********************************************************

	* UnBalanced
	local if_unb = subinstr("`if_reg'","& obs_hh==5 ","",.)
	eststo: reghdfe employed `regressors' /// 
	if `if_unb', ///
	absorb(ID yq_c#loc_group#sex yq_c#o_le_5#sex yq_c#gm_died#sex)  cluster(HH_ID)	

		estadd local model "unbalanced" , replace	
		
	********************************************************
	
	* any # grandmother
	local if_any_N_gp = subinstr("`if_reg'","t_gm_max == 1 & ","",.)
	local if_any_N_gp = subinstr("`if_any_N_gp'","t_gd_max == 1 & ","",.)
	eststo: reghdfe employed `regressors' /// 
	if `if_any_N_gp', ///
	absorb(ID yq_c#loc_group#sex yq_c#o_le_5#sex yq_c#gm_died#sex)  cluster(HH_ID)	

		estadd local model "any_N_gp" , replace
		
	********************************************************

	* any # parents
	local if_any_N_parents = subinstr("`if_reg'","& t_mom_max<2","",.)
	local if_any_N_parents = subinstr("`if_any_N_parents'","& t_dad_max<2","",.)
	eststo: reghdfe employed `regressors' /// 
	if `if_any_N_parents', ///
	absorb(ID yq_c#loc_group#sex yq_c#o_le_5#sex yq_c#gm_died#sex)  cluster(HH_ID)	

		estadd local model "any_N_parents" , replace

	
	********************************************************
	
	* Any Work
	eststo: reghdfe any_work `regressors' /// 
	if `if_reg', ///
	absorb(ID yq_c#loc_group#sex yq_c#o_le_5#sex yq_c#gm_died#sex)  cluster(HH_ID)	

		estadd local model "any_work" , replace	
	
	********************************************************

	* Any Work
	eststo: reghdfe any_paidwork `regressors' /// 
	if `if_reg', ///
	absorb(ID yq_c#loc_group#sex yq_c#o_le_5#sex yq_c#gm_died#sex)  cluster(HH_ID)	

		estadd local model "any_paidwork" , replace	
	
	
	********************************************************
	
	* Young GM
	foreach var in `regressors' {
	foreach pre in gm_le60 gm_le70 {
	capture gen `pre'_`var' = `pre'*`var'
	}
	}
	foreach pre in gm_le60 gm_le70 {
	local regressors_`pre' = subinstr("`regressors'","post","`pre'_post",.)
	eststo: reghdfe employed `regressors_`pre'' /// 
	if `if_reg', ///
	absorb(ID yq_c#loc_group#sex yq_c#o_le_5#sex yq_c#gm_died#sex)  cluster(HH_ID)
	estadd local model "`pre'" , replace	
	}
	
	********************************************************
	
	* Weights
	eststo: reghdfe employed `regressors' [pw=fac] /// 
	if `if_reg', ///
	absorb(ID yq_c#loc_group#sex yq_c#o_le_5#sex yq_c#gm_died#sex)  cluster(HH_ID)	

		estadd local model "Weights" , replace	
		
	*******************************************************
	
	* Youngest Child
	local regressors post_gm_died post_gm_died_y_le_5
	eststo: reghdfe employed `regressors' /// 
	if `if_reg', ///
	absorb(ID yq_c#loc_group#sex yq_c#y_le_5#sex yq_c#gm_died#sex)  cluster(HH_ID)
	
	estadd local model "youngest" , replace	
	
	********************************************************
	
	* Double Diff - Sample where mother died
	local regressors post_gm_died post_gm_died_o_le_5	
	eststo: reghdfe employed `regressors' /// 
	if (`if_reg') & gm_died==1, ///
	absorb(ID yq_c#loc_group#sex)  cluster(HH_ID)	
	estadd local model "DD yq_loc_group_sex" , replace


esttab using "Tables/Table 6A.csv", ///
	star(* 0.10 ** 0.05 *** 0.01) replace se ///
	stats(N model) 

********************************************
* Panel B Mothers and Fathers 
**********************************************
		
	local if_reg = "($ifs_mom) | ($ifs_dad)"

	eststo clear
	local regressors post_gm_died post_gm_died_o_le_5 post_gm_died_mom post_gm_died_o_le_5_mom

	
	* Base
	eststo: reghdfe employed `regressors' /// 
	if `if_reg', ///
	absorb(ID yq_c#loc_group#sex yq_c#o_le_5#sex yq_c#gm_died#sex)  cluster(HH_ID)	

		estadd local model "Base" , replace	
		
	********************************************************
	
	* UnBalanced
	local if_unb = subinstr("`if_reg'","& obs_hh==5 ","",.)
	eststo: reghdfe employed `regressors' /// 
	if `if_unb', ///
	absorb(ID yq_c#loc_group#sex yq_c#o_le_5#sex yq_c#gm_died#sex)  cluster(HH_ID)	

		estadd local model "unbalanced" , replace	
	
	********************************************************
	
	* any # grandmother
	local if_any_N_gp = subinstr("`if_reg'","t_gm_max == 1 & ","",.)
	local if_any_N_gp = subinstr("`if_any_N_gp'","t_gd_max == 1 & ","",.)
	eststo: reghdfe employed `regressors' /// 
	if `if_any_N_gp', ///
	absorb(ID yq_c#loc_group#sex yq_c#o_le_5#sex yq_c#gm_died#sex)  cluster(HH_ID)	

		estadd local model "any_N_gp" , replace
	
	********************************************************

	* any # parents
	local if_any_N_parents = subinstr("`if_reg'","& t_mom_max<2","",.)
	local if_any_N_parents = subinstr("`if_any_N_parents'","& t_dad_max<2","",.)
	eststo: reghdfe employed `regressors' /// 
	if `if_any_N_parents', ///
	absorb(ID yq_c#loc_group#sex yq_c#o_le_5#sex yq_c#gm_died#sex)  cluster(HH_ID)	

		estadd local model "any_N_parents" , replace
	
	
	********************************************************
	
	* Any Work
	eststo: reghdfe any_work `regressors' /// 
	if `if_reg', ///
	absorb(ID yq_c#loc_group#sex yq_c#o_le_5#sex yq_c#gm_died#sex)  cluster(HH_ID)	

		estadd local model "any_work" , replace	
	
	********************************************************

	* Any Work
	eststo: reghdfe any_paidwork `regressors' /// 
	if `if_reg', ///
	absorb(ID yq_c#loc_group#sex yq_c#o_le_5#sex yq_c#gm_died#sex)  cluster(HH_ID)	

		estadd local model "any_paidwork" , replace	
	
	********************************************************
	
	* Young GM
	foreach var in `regressors' {
	foreach pre in gm_le60 gm_le70 {
	capture gen `pre'_`var' = `pre'*`var'
	}
	}
	foreach pre in gm_le60 gm_le70 {
	local regressors_`pre' = subinstr("`regressors'","post","`pre'_post",.)
	eststo: reghdfe employed `regressors_`pre'' /// 
	if `if_reg', ///
	absorb(ID yq_c#loc_group#sex yq_c#o_le_5#sex yq_c#gm_died#sex)  cluster(HH_ID)
	estadd local model "`pre'" , replace	
	}
		
	********************************************************
	
		* Weights
	eststo: reghdfe employed `regressors' [pw=fac] /// 
	if `if_reg', ///
	absorb(ID yq_c#loc_group#sex yq_c#o_le_5#sex yq_c#gm_died#sex)  cluster(HH_ID)	

		estadd local model "Weights" , replace	
	
	********************************************************

	* Youngest Child
	local regressors post_gm_died post_gm_died_y_le_5 post_gm_died_mom post_gm_died_y_le_5_mom
	eststo: reghdfe employed `regressors' /// 
	if `if_reg', ///
	absorb(ID yq_c#loc_group#sex yq_c#y_le_5#sex yq_c#gm_died#sex)  cluster(HH_ID)
	
	estadd local model "youngest" , replace	
	
********************************************************
	
	* Double Diff - Sample where mother died
	local regressors post_gm_died post_gm_died_o_le_5 post_gm_died_mom post_gm_died_o_le_5_mom

	eststo: reghdfe employed `regressors' /// 
	if (`if_reg') & gm_died==1, ///
	absorb(ID yq_c#loc_group#sex)  cluster(HH_ID)	
	estadd local model "DD yq_loc_group_sex" , replace



esttab using "Tables/Table 6B.csv", ///
	star(* 0.10 ** 0.05 *** 0.01) replace se ///
	stats(N model) 

