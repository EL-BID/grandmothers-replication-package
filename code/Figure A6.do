set more off

use "$path\Data\3GenPanel.dta" , clear

keep if mom==1 | dad==1
drop if merge_eness==2

gen temp = hrsocup
replace temp=. if hrsocup==0
gstats winsor temp, cut(0 95) s(_5) by(mom year ent)
gen hrsocup_5 = temp_5
drop temp* 
replace hrsocup_5=hrsocup if hrsocup_5==.
gen asinh_hrsocup_5=asinh(hrsocup_5)
gen ln_hrsocup_5=ln(hrsocup_5+1)
gen asinh_hrsocup = asinh(hrsocup)
gen ln_hrsocup = ln(hrsocup+1)

gen temp = ingocup
replace temp=. if ingocup==0
gstats winsor temp, cut(5 95) s(_5) by(mom year ent)
gen ingocup_5 = temp_5
drop temp* 
replace ingocup_5=ingocup if ingocup_5==.
gen asinh_ingocup_5=asinh(ingocup_5)
gen ln_ingocup_5=ln(ingocup_5+1)
gen asinh_ingocup = asinh(ingocup)
gen ln_ingocup = ln(ingocup+1)



*****************************************************************************
* Panel A weekly - hrsocup
**********************************************************************************

reghdfe asinh_hrsocup_5 gm_died_?? gm_died_??_o_le_5 gm_died_?? gm_died_??_o_le_5 /// 
 if ($ifs_mom)  , ///
absorb(ID yq_c#loc_group#sex yq_c#o_le_5#sex yq_c#gm_died#sex) cluster(HH_ID)

est sto Output_5

nlcom  	(gm_died_b3 :  _b[gm_died_b3_o_le_5] ) ///
	(gm_died_b2 :  _b[gm_died_b2_o_le_5] ) ///
	(gm_died_b1 :   0 ) ///
	(gm_died_a1 :  _b[gm_died_a1_o_le_5] ) ///
	(gm_died_a2 :  _b[gm_died_a2_o_le_5] ) ///
	(gm_died_a3 :  _b[gm_died_a3_o_le_5] ) , post

est sto gm_died_dl_5_3

coefplot gm_died_dl_5_3, vertical  yline(0) legend(region(style(none)) off) ///
      coeflabels(gm_died_b3 = "-3" ///
	gm_died_b2 = "-2" gm_died_b1 = "-1" ///
	gm_died_a1 = "1" gm_died_a2="2" ///
	gm_died_a3 = "3" ) ///
	 xtitle(Period Relative to Grandmother's Death, size(5)) ciopts(recast(rcap)) level(90 95) mlabel format(%9.2f)  mlabposition(3) mlabgap(*2) ///
	 ytitle("Triple Difference" "IHS Weekly Hours relative to t=-1", size(5)) graphregion(color(white)) bgcolor(white) ///
	 ylab(, nogrid) 
	 
graph export "Figures/Figure A6A1.pdf", replace

******************************************************************************
* Panel A monthly
**********************************************************************************
eststo clear

reghdfe asinh_ingocup_5 gm_died_?? gm_died_??_o_le_5 gm_died_?? gm_died_??_o_le_5 /// 
 if $ifs_mom, ///
absorb(ID yq_c#loc_group#sex yq_c#o_le_5#sex yq_c#gm_died#sex) cluster(HH_ID)

est sto Output_5

nlcom  	(gm_died_b3 :  _b[gm_died_b3_o_le_5] ) ///
	(gm_died_b2 :  _b[gm_died_b2_o_le_5] ) ///
	(gm_died_b1 :   0 ) ///
	(gm_died_a1 :  _b[gm_died_a1_o_le_5] ) ///
	(gm_died_a2 :  _b[gm_died_a2_o_le_5] ) ///
	(gm_died_a3 :  _b[gm_died_a3_o_le_5] ) , post

est sto gm_died_dl_5_3

coefplot gm_died_dl_5_3, vertical  yline(0) legend(region(style(none)) off) ///
      coeflabels(gm_died_b3 = "-3" ///
	gm_died_b2 = "-2" gm_died_b1 = "-1" ///
	gm_died_a1 = "1" gm_died_a2="2" ///
	gm_died_a3 = "3" ) ///
	 xtitle(Period Relative to Grandmother's Death, size(5)) ciopts(recast(rcap)) level(90 95) mlabel format(%9.2f)  mlabposition(3) mlabgap(*2) ///
	 ytitle("Triple Difference" "IHS Monthly Income relative to t=-1", size(5)) graphregion(color(white)) bgcolor(white) ///
	 ylab(, nogrid) 
	 
graph export "Figures/Figure A6A2.pdf", replace

********************************************************************************
* Panel B weekly
**********************************************************************************

reghdfe ln_hrsocup_5 gm_died_?? gm_died_??_o_le_5 gm_died_?? gm_died_??_o_le_5 /// 
 if  $ifs_mom, ///
absorb(ID yq_c#loc_group#sex yq_c#o_le_5#sex yq_c#gm_died#sex) cluster(HH_ID)

est sto Output_5

nlcom  	(gm_died_b3 :  _b[gm_died_b3_o_le_5] ) ///
	(gm_died_b2 :  _b[gm_died_b2_o_le_5] ) ///
	(gm_died_b1 :   0 ) ///
	(gm_died_a1 :  _b[gm_died_a1_o_le_5] ) ///
	(gm_died_a2 :  _b[gm_died_a2_o_le_5] ) ///
	(gm_died_a3 :  _b[gm_died_a3_o_le_5] ) , post

est sto gm_died_dl_5_3

coefplot gm_died_dl_5_3, vertical  yline(0) legend(region(style(none)) off) ///
      coeflabels(gm_died_b3 = "-3" ///
	gm_died_b2 = "-2" gm_died_b1 = "-1" ///
	gm_died_a1 = "1" gm_died_a2="2" ///
	gm_died_a3 = "3" ) ///
	 xtitle(Period Relative to Grandmother's Death, size(5)) ciopts(recast(rcap)) level(90 95) mlabel format(%9.2f)  mlabposition(3) mlabgap(*2) ///
	 ytitle("Triple Difference" "NL Weekly Hours relative to t=-1", size(5)) graphregion(color(white)) bgcolor(white) ///
	 ylab(, nogrid) 
	 
graph export "Figures/Figure A6B1.pdf", replace

********************************************************************************
* Panel B monthly 
**********************************************************************************

reghdfe ln_ingocup_5 gm_died_?? gm_died_??_o_le_5 gm_died_?? gm_died_??_o_le_5 /// 
 if $ifs_mom, ///
absorb(ID yq_c#loc_group#sex yq_c#o_le_5#sex yq_c#gm_died#sex) cluster(HH_ID)

est sto Output_5

nlcom  	(gm_died_b3 :  _b[gm_died_b3_o_le_5] ) ///
	(gm_died_b2 :  _b[gm_died_b2_o_le_5] ) ///
	(gm_died_b1 :   0 ) ///
	(gm_died_a1 :  _b[gm_died_a1_o_le_5] ) ///
	(gm_died_a2 :  _b[gm_died_a2_o_le_5] ) ///
	(gm_died_a3 :  _b[gm_died_a3_o_le_5] ) , post

est sto gm_died_dl_5_3

coefplot gm_died_dl_5_3, vertical  yline(0) legend(region(style(none)) off) ///
      coeflabels(gm_died_b3 = "-3" ///
	gm_died_b2 = "-2" gm_died_b1 = "-1" ///
	gm_died_a1 = "1" gm_died_a2="2" ///
	gm_died_a3 = "3" ) ///
	 xtitle(Period Relative to Grandmother's Death, size(5)) ciopts(recast(rcap)) level(90 95) mlabel format(%9.2f)  mlabposition(3) mlabgap(*2) ///
	 ytitle("Triple Difference" "NL Monthly Income relative to t=-1", size(5)) graphregion(color(white)) bgcolor(white) ///
	 ylab(, nogrid) 
	 
graph export "Figures/Figure A6B2.pdf", replace

**********************************************************************************
* Panel C weekly
**********************************************************************************

reghdfe hrsocup_5 gm_died_?? gm_died_??_o_le_5 gm_died_?? gm_died_??_o_le_5 /// 
 if $ifs_mom, ///
absorb(ID yq_c#loc_group#sex yq_c#o_le_5#sex yq_c#gm_died#sex) cluster(HH_ID)

est sto Output_5

nlcom  	(gm_died_b3 :  _b[gm_died_b3_o_le_5] ) ///
	(gm_died_b2 :  _b[gm_died_b2_o_le_5] ) ///
	(gm_died_b1 :   0 ) ///
	(gm_died_a1 :  _b[gm_died_a1_o_le_5] ) ///
	(gm_died_a2 :  _b[gm_died_a2_o_le_5] ) ///
	(gm_died_a3 :  _b[gm_died_a3_o_le_5] ) , post

est sto gm_died_dl_5_3

coefplot gm_died_dl_5_3, vertical  yline(0) legend(region(style(none)) off) ///
      coeflabels(gm_died_b3 = "-3" ///
	gm_died_b2 = "-2" gm_died_b1 = "-1" ///
	gm_died_a1 = "1" gm_died_a2="2" ///
	gm_died_a3 = "3" ) ///
	 xtitle(Period Relative to Grandmother's Death, size(5)) ciopts(recast(rcap)) level(90 95) mlabel format(%9.2f)  mlabposition(3) mlabgap(*2) ///
	 ytitle("Triple Difference" "Weekly Hours relative to t=-1", size(5)) graphregion(color(white)) bgcolor(white) ///
	 ylab(, nogrid) 
	 
graph export "Figures/Figure A6C1.pdf", replace

**********************************************************************************
* Panel C monthly 
**********************************************************************************
reghdfe ingocup_5 gm_died_?? gm_died_??_o_le_5 gm_died_?? gm_died_??_o_le_5 /// 
 if $ifs_mom, ///
absorb(ID yq_c#loc_group#sex yq_c#o_le_5#sex yq_c#gm_died#sex) cluster(HH_ID)

est sto Output_5

nlcom  	(gm_died_b3 :  _b[gm_died_b3_o_le_5] ) ///
	(gm_died_b2 :  _b[gm_died_b2_o_le_5] ) ///
	(gm_died_b1 :   0 ) ///
	(gm_died_a1 :  _b[gm_died_a1_o_le_5] ) ///
	(gm_died_a2 :  _b[gm_died_a2_o_le_5] ) ///
	(gm_died_a3 :  _b[gm_died_a3_o_le_5] ) , post

est sto gm_died_dl_5_3

coefplot gm_died_dl_5_3, vertical  yline(0) legend(region(style(none)) off) ///
      coeflabels(gm_died_b3 = "-3" ///
	gm_died_b2 = "-2" gm_died_b1 = "-1" ///
	gm_died_a1 = "1" gm_died_a2="2" ///
	gm_died_a3 = "3" ) ///
	 xtitle(Period Relative to Grandmother's Death, size(5)) ciopts(recast(rcap)) level(90 95) mlabel format(%9.2f)  mlabposition(3) mlabgap(*2) ///
	 ytitle("Triple Difference" "Monthly Income relative to t=-1", size(5)) graphregion(color(white)) bgcolor(white) ///
	 ylab(, nogrid) 
	 
graph export "Figures/Figure A6C2.pdf", replace

