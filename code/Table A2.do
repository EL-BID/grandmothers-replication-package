set more off

use "$path\Data\3GenPanel.dta" , clear

 keep if (mom==1) & inrange(max_eda,21,50)  & max_eda_gk<30 & miss_sex==0


	local if_reg = "($ifs_mom) | ($ifs_dad)"

	eststo clear

	local regressors post_gm_died post_gm_died_o_le_5

	* Base
	reghdfe employed `regressors' /// 
	if `if_reg', ///
	absorb(ID yq_c#loc_group#sex yq_c#o_le_5#sex yq_c#gm_died#sex)  cluster(HH_ID)	
	
	gen sample = e(sample)
	
	********************************************************
	* UnBalanced
	local if_unb = subinstr("`if_reg'","& obs_hh==5 ","",.)
	reghdfe employed `regressors' /// 
	if `if_unb', ///
	absorb(ID yq_c#loc_group#sex yq_c#o_le_5#sex yq_c#gm_died#sex)  cluster(HH_ID)	

	gen sample_unbalanced = e(sample)
	
	********************************************************
	
	* any # grandmother
	local if_any_N_gp = subinstr("`if_reg'","t_gm_max == 1 & ","",.)
	local if_any_N_gp = subinstr("`if_any_N_gp'","t_gd_max == 1 & ","",.)
	reghdfe employed `regressors' /// 
	if `if_any_N_gp', ///
	absorb(ID yq_c#loc_group#sex yq_c#o_le_5#sex yq_c#gm_died#sex)  cluster(HH_ID)	

	gen sample_any_gm = e(sample)
	
	********************************************************

	* any # parents
	local if_any_N_parents = subinstr("`if_reg'","& t_mom_max<2","",.)
	local if_any_N_parents = subinstr("`if_any_N_parents'","& t_dad_max<2","",.)
	reghdfe employed `regressors' /// 
	if `if_any_N_parents', ///
	absorb(ID yq_c#loc_group#sex yq_c#o_le_5#sex yq_c#gm_died#sex)  cluster(HH_ID)	

	gen sample_any_p = e(sample)
	


foreach sample in sample sample_unbalanced sample_any_gm sample_any_p {
preserve
keep if `sample'
gen n = 1
replace anios_esc = . if anios_esc==99
gen formal = (emp_ppal==2)
gcollapse (sum) n (mean) employed any_work any_paidwork eda n_hij hrsocup ing_x_hrs ingocup formal t_ind_max, by(mom)
list
tempfile f_`sample'
save `f_`sample''
restore
}


preserve
clear
gen sample = ""
foreach sample in sample sample_unbalanced sample_any_gm sample_any_p {
append using `f_`sample''
replace sample = "`sample'" if _n==_N
}

export excel using "Tables/Tabla A2.xlsx", replace firstrow(variables)

restore
