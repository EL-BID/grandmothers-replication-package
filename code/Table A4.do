capture log close
clear
cls

set more off

use "$path\Data\3GenPanel.dta" , clear

* Keep relevant sample
reghdfe employed post_gm_died##o_le_5 ///
if $ifs_mom, ///
absorb(ID yq_c#loc_group#sex yq_c#o_le_5#sex yq_c#gm_died#sex)
keep if e(sample)

* Create Ratios
egen Z_EI_N_p0a5_20 = std(EI_N_p0a5_20)

gstats winsor ingocup, replace cut(5 95)
gegen mun_INC = mean(ingocup), by(mun_full)

* Generate working share of mother
gegen mun_sh_workmom = mean(employed), by(mun_full)
bys mun_full: gen mun_obs_1 = (_n==1)
eststo clear

* Interaction
local fe_text = subinstr("ID yq_c#loc_group#sex yq_c#o_le_5#sex yq_c#gm_died#sex","#","_",.)

reg EI_N_p0a5_20 mun_INC mun_sh_workmom if mun_obs_1==1 
local size = e(N)
capture predict EI_N_p0a5_20_r, resid
capture egen Z_EI_N_p0a5_20_r = std(EI_N_p0a5_20_r)


reghdfe employed post_gm_died##o_le_5##c.Z_EI_N_p0a5_20_r /// 
if $ifs_mom, ///
absorb( "ID yq_c#loc_group#sex yq_c#o_le_5#sex yq_c#gm_died#sex") cluster(HH_ID)

nlcom  	(d_gm_died :  _b[1.post_gm_died] ) ///
(d_gm_died_le :  _b[1.post_gm_died#1.o_le_5] ) ///
(d_gm_died_CC :   _b[1.post_gm_died#c.Z_EI_N_p0a5_20_r]) ///
(d_gm_died_le_CC :   _b[1.post_gm_died#1.o_le_5#c.Z_EI_N_p0a5_20_r]) , post

estadd local FS "`size'" , replace
estadd local inter "Z_EI_N`w'_p0a5_20_r" , replace
estadd local FS_YN "Y", replace
estadd local cluster "HH" , replace
estadd local FE "`fe_text'", replace
estadd local SE "HH_ID", replace

eststo 

reghdfe employed post_gm_died##o_le_5##c.Z_EI_N_p0a5_20 /// 
if $ifs_mom, ///
absorb( "ID yq_c#loc_group#sex yq_c#o_le_5#sex yq_c#gm_died#sex") cluster(HH_ID)

nlcom  	(d_gm_died :  _b[1.post_gm_died] ) ///
(d_gm_died_le :  _b[1.post_gm_died#1.o_le_5] ) ///
(d_gm_died_CC :   _b[1.post_gm_died#c.Z_EI_N_p0a5_20]) ///
(d_gm_died_le_CC :   _b[1.post_gm_died#1.o_le_5#c.Z_EI_N_p0a5_20]) , post

estadd local FS "-" , replace
estadd local inter "Z_EI_N_p0a5_20" , replace
estadd local FS_YN "N", replace
estadd local cluster "HH" , replace
estadd local FE "`fe_text'", replace
estadd local SE "HH_ID", replace

eststo 

esttab  using "Tables/Table A4.csv",  ///
	star(* 0.10 ** 0.05 *** 0.01) replace wrap nobaselevels se ///
	stats(N cluster FS inter FS_YN FE SE, ///
	label("Sample Size" "Clustered SE" "First Stage Sample Size" "Interaction" "First Stage" "Fixed Effects" "Clustered SE"))  ///
	varwidth(45)  nonotes 







