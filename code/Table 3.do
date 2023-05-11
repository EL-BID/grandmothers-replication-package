clear
cls

set more off

use "$path\Data\3GenPanel.dta" , clear

keep if merge_denue == 3 & merge_mun==3

reghdfe employed post_gm_died##o_le_5 ///
if $ifs_mom, ///
absorb(ID yq_c#loc_group#sex yq_c#o_le_5#sex yq_c#gm_died#sex)
keep if e(sample)

* Generate working share of mother
gegen mun_sh_workmom = mean(employed), by(mun_full)
bys mun_full: gen mun_obs_1 = (_n==1)
eststo clear

replace ingocup = . if ingocup ==  0 // to calculate income conditional on working
gstats winsor ingocup, replace cut(5 95)
gegen mun_INC = mean(ingocup), by(mun_full)

gquantiles q_pobtot_20 = pobtot_20_mun, xtile nq(5)
gquantiles q_mun_INC = mun_INC, xtile nq(5)

local fe_text = subinstr("`fe'","#","_",.)

foreach w in "_624411" "_624412"  {
reg n`w'_p0a5_20 i.q_mun_INC mun_sh_workmom i.q_pobtot_20 if mun_obs_1==1 
local size = e(N)
predict n`w'_p0a5_20_r, resid
egen Z_n`w'_p0a5_20_r = std(n`w'_p0a5_20_r)
egen Z_n`w'_p0a5_20 = std(n`w'_p0a5_20)


reghdfe employed post_gm_died##o_le_5##c.Z_n`w'_p0a5_20_r /// 
if $ifs_mom, ///
absorb("ID yq_c#loc_group#sex yq_c#o_le_5#sex yq_c#gm_died#sex" ) cluster(HH_ID)

nlcom  	(d_gm_died :  _b[1.post_gm_died] ) ///
(d_gm_died_le :  _b[1.post_gm_died#1.o_le_5] ) ///
(d_gm_died_CC`w' :   _b[1.post_gm_died#c.Z_n`w'_p0a5_20_r]) ///
(d_gm_died_le_CC`w' :   _b[1.post_gm_died#1.o_le_5#c.Z_n`w'_p0a5_20_r]) , post

estadd local FS "`size'" , replace
estadd local inter "Z_n`w'_p0a5_20_mun_r" , replace
estadd local FS_YN "Y", replace
estadd local cluster "HH" , replace
estadd local FE "`fe_text'", replace
estadd local SE "`se'", replace

eststo 
}

foreach w in "_624411" "_624412"  {

reghdfe employed post_gm_died##o_le_5##c.Z_n`w'_p0a5_20 /// 
if $ifs_mom, ///
absorb("ID yq_c#loc_group#sex yq_c#o_le_5#sex yq_c#gm_died#sex" ) cluster(HH_ID)

nlcom  	(d_gm_died :  _b[1.post_gm_died] ) ///
(d_gm_died_le :  _b[1.post_gm_died#1.o_le_5] ) ///
(d_gm_died_CC`w' :   _b[1.post_gm_died#c.Z_n`w'_p0a5_20]) ///
(d_gm_died_le_CC`w' :   _b[1.post_gm_died#1.o_le_5#c.Z_n`w'_p0a5_20]) , post

estadd local FS "-" , replace
estadd local inter "Z_n`w'_p0a5_20_mun" , replace
estadd local FS_YN "N", replace
estadd local cluster "HH" , replace
estadd local FE "`fe_text'", replace
estadd local SE "HH_ID", replace

eststo 
}

reghdfe employed post_gm_died##o_le_5##c.Z_n_624411_p0a5_20_r post_gm_died##o_le_5##c.Z_n_624412_p0a5_20_r /// 
if $ifs_mom, ///
absorb("ID yq_c#loc_group#sex yq_c#o_le_5#sex yq_c#gm_died#sex" ) cluster(HH_ID)

nlcom  	(d_gm_died :  _b[1.post_gm_died] ) ///
(d_gm_died_le :  _b[1.post_gm_died#1.o_le_5] ) ///
(d_gm_died_CC_624411 :   _b[1.post_gm_died#c.Z_n_624411_p0a5_20_r]) ///
(d_gm_died_le_CC_624411 :   _b[1.post_gm_died#1.o_le_5#c.Z_n_624411_p0a5_20_r]) ///
(d_gm_died_CC_624412 :   _b[1.post_gm_died#c.Z_n_624412_p0a5_20_r]) ///
(d_gm_died_le_CC_624412 :   _b[1.post_gm_died#1.o_le_5#c.Z_n_624412_p0a5_20_r]) , post

estadd local FS "`size'" , replace
estadd local inter "Z_n`w'_p0a5_20_mun_r" , replace
estadd local FS_YN "Y", replace
estadd local cluster "HH" , replace
estadd local FE "`fe_text'", replace
estadd local SE "HH_ID", replace

eststo 

reghdfe employed post_gm_died##o_le_5##c.Z_n_624411_p0a5_20 post_gm_died##o_le_5##c.Z_n_624412_p0a5_20 /// 
if $ifs_mom, ///
absorb("ID yq_c#loc_group#sex yq_c#o_le_5#sex yq_c#gm_died#sex" ) cluster(HH_ID)

nlcom  	(d_gm_died :  _b[1.post_gm_died] ) ///
(d_gm_died_le :  _b[1.post_gm_died#1.o_le_5] ) ///
(d_gm_died_CC_624411 :   _b[1.post_gm_died#c.Z_n_624411_p0a5_20]) ///
(d_gm_died_le_CC_624411 :   _b[1.post_gm_died#1.o_le_5#c.Z_n_624411_p0a5_20]) ///
(d_gm_died_CC_624412 :   _b[1.post_gm_died#c.Z_n_624412_p0a5_20]) ///
(d_gm_died_le_CC_624412 :   _b[1.post_gm_died#1.o_le_5#c.Z_n_624412_p0a5_20]) , post

estadd local FS "-" , replace
estadd local inter "Z_n_p0a5_20" , replace
estadd local FS_YN "N", replace
estadd local cluster "HH" , replace
estadd local FE "`fe_text'", replace
estadd local SE "HH_ID", replace

eststo 
	
esttab  using "Tables/Table 3.csv",  ///
	star(* 0.10 ** 0.05 *** 0.01) replace wrap nobaselevels se ///
	stats(N cluster FS inter FS_YN FE SE, ///
	label("Sample Size" "Clustered SE" "First Stage Sample Size" "Interaction" "First Stage" "Fixed Effects" "Clustered SE"))  ///
	varwidth(45)  nonotes 


