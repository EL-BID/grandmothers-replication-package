
clear
cls

set more off

	 
use "$path\Data\3GenPanel.dta" , clear

	keep if merge_eness_format == 3

	* Keep relevant sample
	reghdfe employed post_gm_died##o_le_5 ///
	if $ifs_mom, ///
	absorb(ID yq_c#loc_group#sex yq_c#o_le_5#sex yq_c#gm_died#sex)
	keep if e(sample)

	replace ingocup = . if ingocup ==  0 
	gstats winsor ingocup, replace cut(5 95)

	gegen loc_INC = mean(ingocup), by(loc)
	* Generate working share of mother
	gegen loc_sh_workmom = mean(employed), by(loc)
	* First observation of locality
	bys loc: gen loc_obs_1 = (_n==1)

	gquantiles q_pobtot_2020 = pobtot_20_loc, xtile nq(5)
	gquantiles q_loc_INC = loc_INC, xtile nq(5)
	gquantiles q_loc_sh_workmom = loc_sh_workmom, xtile nq(5)

	eststo clear

	gquantiles dec_pobtot_2020 = pobtot_20_loc, xtile nq(10)
	gquantiles dec_loc_INC = loc_INC, xtile nq(10)
	gquantiles dec_loc_sh_workmom = loc_sh_workmom, xtile nq(10)


	local fe_text = subinstr("ID yq_c#loc_group#sex yq_c#o_le_5#sex yq_c#gm_died#sex","#","_",.)


	reg Z_pago_hora_es i.q_loc_INC loc_sh_workmom i.q_pobtot_2020 if loc_obs_1==1 
	gen sample_es = e(sample)


	eststo clear
	foreach x in pago_hora_con pago_hora pago_con pago   {

	reg Z_`x'_es i.q_loc_INC loc_sh_workmom i.q_pobtot_2020 if loc_obs_1==1 
	local size = e(N)
	capture predict `x'_es_r, resid
	capture egen Z_`x'_es_r = std(`x'_es_r)
	 
	reghdfe employed post_gm_died##o_le_5##c.Z_`x'_es_r /// 
	if $ifs_mom, ///
	absorb(ID yq_c#loc_group#sex yq_c#o_le_5#sex yq_c#gm_died#sex) cluster(HH_ID)

	nlcom  	(d_gm_died :  _b[1.post_gm_died] ) ///
	(d_gm_died_le :  _b[1.post_gm_died#1.o_le_5] ) ///
	(d_gm_died_CC_es :   _b[1.post_gm_died#c.Z_`x'_es_r]) ///
	(d_gm_died_le_CC_es :   _b[1.post_gm_died#1.o_le_5#c.Z_`x'_es_r]) , post

	estadd local FS "`size'" , replace
	estadd local inter "Z_`x'_es_r" , replace
	estadd local FS_YN "Y", replace
	estadd local cluster "HH" , replace
	estadd local FE "`fe_text'", replace
	estadd local SE "HH_ID", replace

	eststo 

	reghdfe employed post_gm_died##o_le_5##c.Z_`x'_es /// 
	if $ifs_mom, ///
	absorb(ID yq_c#loc_group#sex yq_c#o_le_5#sex yq_c#gm_died#sex) cluster(HH_ID)

	nlcom  	(d_gm_died :  _b[1.post_gm_died] ) ///
	(d_gm_died_le :  _b[1.post_gm_died#1.o_le_5] ) ///
	(d_gm_died_CC_es :   _b[1.post_gm_died#c.Z_`x'_es]) ///
	(d_gm_died_le_CC_es :   _b[1.post_gm_died#1.o_le_5#c.Z_`x'_es]) , post

	estadd local FS "-" , replace
	estadd local inter "Z_`x'_es" , replace
	estadd local FS_YN "N", replace
	estadd local cluster "HH" , replace
	estadd local FE "`fe_text'", replace
	estadd local SE "HH_ID", replace

	eststo 
	}

	esttab  using "Tables/Table A3.csv",  ///
		star(* 0.10 ** 0.05 *** 0.01) replace wrap nobaselevels se ///
		stats(N cluster FS inter FS_YN FE SE, ///
		label("Sample Size" "Clustered SE" "First Stage Sample Size" "Interaction" "First Stage" "Fixed Effects" "Clustered SE"))  ///
		varwidth(45)  nonotes 
