clear
cls

set more off

use "$path\Data\3GenPanel.dta" , clear

keep if merge_eness_format == 3 & merge_loc==3 

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

* Locality size
gegen pobtot_2020_min = min(pobtot_20_loc), by(ID)

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

foreach v in _pr _pu {
reg Z_pago_hora`v' i.q_loc_INC loc_sh_workmom i.q_pobtot_2020 if loc_obs_1==1 
gen sample`v' = e(sample)
}

eststo clear
foreach x in pago_hora  pago   {
foreach v in _pr _pu {
	
reg Z_`x'`v' i.q_loc_INC loc_sh_workmom i.q_pobtot_2020 if loc_obs_1==1 
local size = e(N)
capture predict `x'`v'_r, resid
capture egen Z_`x'`v'_r = std(`x'`v'_r)
 
reghdfe employed post_gm_died##o_le_5##c.Z_`x'`v'_r /// 
if $ifs_mom, ///
absorb("ID yq_c#loc_group#sex yq_c#o_le_5#sex yq_c#gm_died#sex") cluster(HH_ID)

nlcom  	(d_gm_died :  _b[1.post_gm_died] ) ///
(d_gm_died_le :  _b[1.post_gm_died#1.o_le_5] ) ///
(d_gm_died_CC`v' :   _b[1.post_gm_died#c.Z_`x'`v'_r]) ///
(d_gm_died_le_CC`v' :   _b[1.post_gm_died#1.o_le_5#c.Z_`x'`v'_r]) , post

estadd local FS "`size'" , replace
estadd local inter "Z_`x'`v'_r" , replace
estadd local FS_YN "Y", replace
estadd local cluster "HH" , replace
estadd local FE "`fe_text'", replace
estadd local SE "HH_ID", replace

eststo 

reghdfe employed post_gm_died##o_le_5##c.Z_`x'`v' /// 
if $ifs_mom, ///
absorb("ID yq_c#loc_group#sex yq_c#o_le_5#sex yq_c#gm_died#sex") cluster(HH_ID)

nlcom  	(d_gm_died :  _b[1.post_gm_died] ) ///
(d_gm_died_le :  _b[1.post_gm_died#1.o_le_5] ) ///
(d_gm_died_CC`v' :   _b[1.post_gm_died#c.Z_`x'`v']) ///
(d_gm_died_le_CC`v' :   _b[1.post_gm_died#1.o_le_5#c.Z_`x'`v']) , post

estadd local FS "-" , replace
estadd local inter "Z_`x'`v'`z'`s'" , replace
estadd local FS_YN "N", replace
estadd local cluster "HH" , replace
estadd local FE "`fe_text'", replace
estadd local SE "HH_ID", replace

eststo 
}

reghdfe employed post_gm_died##o_le_5##c.Z_`x'_pr_r post_gm_died##o_le_5##c.Z_`x'_pu_r  /// 
if $ifs_mom, ///
absorb("ID yq_c#loc_group#sex yq_c#o_le_5#sex yq_c#gm_died#sex") cluster(HH_ID)

nlcom  	(d_gm_died :  _b[1.post_gm_died] ) ///
(d_gm_died_le :  _b[1.post_gm_died#1.o_le_5] ) ///
(d_gm_died_CC_pr :   _b[1.post_gm_died#c.Z_`x'_pr_r]) ///
(d_gm_died_le_CC_pr :   _b[1.post_gm_died#1.o_le_5#c.Z_`x'_pr_r]) ///
(d_gm_died_CC_pu :   _b[1.post_gm_died#c.Z_`x'_pu`s'_r]) ///
(d_gm_died_le_CC_pu :   _b[1.post_gm_died#1.o_le_5#c.Z_`x'_pu_r]) , post

estadd local FS "`size'" , replace
estadd local inter "Z_`x'_r" , replace
estadd local FS_YN "Y", replace
estadd local cluster "HH" , replace
estadd local FE "`fe_text'", replace
estadd local SE "HH_ID", replace

eststo 


reghdfe employed post_gm_died##o_le_5##c.Z_`x'_pr post_gm_died##o_le_5##c.Z_`x'_pu /// 
if $ifs_mom, ///
absorb("ID yq_c#loc_group#sex yq_c#o_le_5#sex yq_c#gm_died#sex") cluster(HH_ID)

nlcom  	(d_gm_died :  _b[1.post_gm_died] ) ///
(d_gm_died_le :  _b[1.post_gm_died#1.o_le_5] ) ///
(d_gm_died_CC_pr :   _b[1.post_gm_died#c.Z_`x'_pr]) ///
(d_gm_died_le_CC_pr :   _b[1.post_gm_died#1.o_le_5#c.Z_`x'_pr]) ///
(d_gm_died_CC_pu :   _b[1.post_gm_died#c.Z_`x'_pu]) ///
(d_gm_died_le_CC_pu :   _b[1.post_gm_died#1.o_le_5#c.Z_`x'_pu]) , post

estadd local FS "-" , replace
estadd local inter "Z_`x'" , replace
estadd local FS_YN "N", replace
estadd local cluster "HH" , replace
estadd local FE "`fe_text'", replace
estadd local SE "HH_ID", replace

eststo 

}

esttab  using "Tables/Table 4.csv",  ///
	star(* 0.10 ** 0.05 *** 0.01) replace wrap nobaselevels se ///
	stats(N cluster FS inter FS_YN FE SE, ///
	label("Sample Size" "Clustered SE" "First Stage Sample Size" "Interaction" "First Stage" "Fixed Effects" "Clustered SE"))  ///
	varwidth(45)  nonotes 
