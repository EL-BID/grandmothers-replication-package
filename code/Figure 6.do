clear

set more off

use "$path\Data\3GenPanel.dta" , clear

keep if mom==1 | dad==1

****************************************************************************
* Panel A: Grandfather's Death - Mother's Sample
****************************************************************************

reghdfe employed gd_died_?? gd_died_??_o_le_5 gd_died_?? gd_died_??_o_le_5 /// 
 if $ifs_mom , ///
 absorb(ID  yq_c#loc_group#sex  yq_c#o_le_5#sex yq_c#gd_died#sex ) cluster(HH_ID)

est sto Output_gd_5

est restore Output_gd_5

nlcom  	(gd_died_b4 :  _b[gd_died_b4_o_le_5] ) ///
	(gd_died_b3 :  _b[gd_died_b3_o_le_5] ) ///
	(gd_died_b2 :  _b[gd_died_b2_o_le_5] ) ///
	(gd_died_b1 :   0 ) ///
	(gd_died_a1 :  _b[gd_died_a1_o_le_5] ) ///
	(gd_died_a2 :  _b[gd_died_a2_o_le_5] ) ///
	(gd_died_a3 :  _b[gd_died_a3_o_le_5] ) ///
	(gd_died_a4 :  _b[gd_died_a4_o_le_5] ), post

est sto gd_died_DD_5

coefplot gd_died_DD_5, vertical  yline(0) legend(region(style(none)) off) ///
      coeflabels(gd_died_b4 = "-4" gd_died_b3 = "-3" ///
	gd_died_b2 = "-2" gd_died_b1 = "-1" ///
	gd_died_a1 = "1" gd_died_a2="2" ///
	gd_died_a3 = "3" gd_died_a4="4") ///
	 xtitle(Period Relative to Grandfather's Death, size(5)) ciopts(recast(rcap)) level(90 95) mlabel format(%9.2f)  mlabposition(3) mlabgap(*2) ///
	 ytitle("Triple Difference" "Employment Rate relative to t=-1", size(4.5)) graphregion(color(white)) bgcolor(white) ///
	 ylab(, nogrid) name(ES_DD_o_5_Mothers_gd,replace)
	 
graph export "Figures/Figure 6A.pdf", replace 

**************************************************************************
* Panel B: Grandmother's Death - Fathers Sample
**************************************************************************

reghdfe employed gm_died_?? gm_died_??_o_le_5 gm_died_?? gm_died_??_o_le_5 /// 
 if $ifs_dad , ///
 absorb(ID  yq_c#loc_group#sex  yq_c#o_le_5#sex yq_c#gm_died#sex ) cluster(HH_ID)

est sto Output_gm_5

est restore Output_gm_5

nlcom  	(gm_died_b4 :  _b[gm_died_b4_o_le_5] ) ///
	(gm_died_b3 :  _b[gm_died_b3_o_le_5] ) ///
	(gm_died_b2 :  _b[gm_died_b2_o_le_5] ) ///
	(gm_died_b1 :   0 ) ///
	(gm_died_a1 :  _b[gm_died_a1_o_le_5] ) ///
	(gm_died_a2 :  _b[gm_died_a2_o_le_5] ) ///
	(gm_died_a3 :  _b[gm_died_a3_o_le_5] ) ///
	(gm_died_a4 :  _b[gm_died_a4_o_le_5] ), post


est sto gm_died_DD_5

coefplot gm_died_DD_5, vertical  yline(0) legend(region(style(none)) off) ///
      coeflabels(gm_died_b4 = "-4" gm_died_b3 = "-3" ///
	gm_died_b2 = "-2" gm_died_b1 = "-1" ///
	gm_died_a1 = "1" gm_died_a2="2" ///
	gm_died_a3 = "3" gm_died_a4="4") ///
	 xtitle(Period Relative to Grandmother's Death, size(5)) ciopts(recast(rcap)) level(90 95) mlabel format(%9.2f)  mlabposition(3) mlabgap(*2) ///
	 ytitle("Triple Difference" "Employment Rate relative to t=-1", size(4.5)) graphregion(color(white)) bgcolor(white) ///
	 ylab(, nogrid) name(ES_DD_o_5_Fathers_gm,replace)
	 
graph export "Figures/Figure 6B.pdf", replace 