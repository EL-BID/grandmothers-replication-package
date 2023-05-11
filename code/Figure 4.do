clear

set more off

use "$path\Data\3GenPanel.dta" , clear

keep if mom==1 | dad==1

reghdfe employed gm_died_?? gm_died_??_o_le_5 gm_died_??_mom gm_died_??_o_le_5_mom /// 
 if ($ifs_mom) | ($ifs_dad), ///
 absorb(ID  yq_c#loc_group#sex  yq_c#o_le_5#sex yq_c#gm_died#sex) cluster(HH_ID)

est sto Output_gm_5

est restore Output_gm_5

	
nlcom  	(gm_died_b4 :  _b[gm_died_b4] ) ///
	(gm_died_b3 :  _b[gm_died_b3] ) ///
	(gm_died_b2 :  _b[gm_died_b2] ) ///
	(gm_died_b1 :  0 ) ///
	(gm_died_a1 :  _b[gm_died_a1] ) ///
	(gm_died_a2 :  _b[gm_died_a2] ) ///
	(gm_died_a3 :  _b[gm_died_a3] ) ///
	(gm_died_a4 :  _b[gm_died_a4] ), post

est sto gm_died_total_5

est restore Output_gm_5

nlcom  	(gm_died_b4 :  _b[gm_died_b4_o_le_5] + _b[gm_died_b4]) ///
	(gm_died_b3 :  _b[gm_died_b3_o_le_5] + _b[gm_died_b3]) ///
	(gm_died_b2 :  _b[gm_died_b2_o_le_5] + _b[gm_died_b2]) ///
	(gm_died_b1 :   0 ) ///
	(gm_died_a1 :  _b[gm_died_a1_o_le_5] + _b[gm_died_a1]) ///
	(gm_died_a2 :  _b[gm_died_a2_o_le_5] + _b[gm_died_a2]) ///
	(gm_died_a3 :  _b[gm_died_a3_o_le_5] + _b[gm_died_a3]) ///
	(gm_died_a4 :  _b[gm_died_a4_o_le_5] + _b[gm_died_a4]),  post
	
	
est sto gm_died_dl_total_5

est restore Output_gm_5

nlcom  	(gm_died_b4 :  _b[gm_died_b4_mom] + _b[gm_died_b4]) ///
	(gm_died_b3 :  _b[gm_died_b3_mom] + _b[gm_died_b3]) ///
	(gm_died_b2 :  _b[gm_died_b2_mom] + _b[gm_died_b2]) ///
	(gm_died_b1 :   0 ) ///
	(gm_died_a1 :  _b[gm_died_a1_mom] + _b[gm_died_a1]) ///
	(gm_died_a2 :  _b[gm_died_a2_mom] + _b[gm_died_a2]) ///
	(gm_died_a3 :  _b[gm_died_a3_mom] + _b[gm_died_a3]) ///
	(gm_died_a4 :  _b[gm_died_a4_mom] + _b[gm_died_a4]), post
	
est sto gm_died_mom_total_5

est restore Output_gm_5

nlcom  	(gm_died_b4 :  _b[gm_died_b4] + _b[gm_died_b4_mom] +  _b[gm_died_b4_o_le_5] + _b[gm_died_b4_o_le_5_mom] ) ///
	(gm_died_b3 :  _b[gm_died_b3] + _b[gm_died_b3_mom] +  _b[gm_died_b3_o_le_5] + _b[gm_died_b3_o_le_5_mom] ) ///
	(gm_died_b2 :  _b[gm_died_b2] + _b[gm_died_b2_mom] +  _b[gm_died_b2_o_le_5] + _b[gm_died_b2_o_le_5_mom] ) ///
	(gm_died_b1 :   0 ) ///
	(gm_died_a1 :  _b[gm_died_a1] + _b[gm_died_a1_mom] +  _b[gm_died_a1_o_le_5] + _b[gm_died_a1_o_le_5_mom] ) ///
	(gm_died_a2 :  _b[gm_died_a2] + _b[gm_died_a2_mom] +  _b[gm_died_a2_o_le_5] + _b[gm_died_a2_o_le_5_mom] ) ///
	(gm_died_a3 :  _b[gm_died_a3] + _b[gm_died_a3_mom] +  _b[gm_died_a3_o_le_5] + _b[gm_died_a3_o_le_5_mom] ) ///
	(gm_died_a4 :  _b[gm_died_a4] + _b[gm_died_a4_mom] +  _b[gm_died_a4_o_le_5] + _b[gm_died_a4_o_le_5_mom] ), post
	
est sto gm_died_dl_mom_total_5

coefplot  (gm_died_total_5, label(Fathers, oldest child > 5 ) ) ///
	(gm_died_dl_total_5,  label(Fathers, oldest child {&le} 5 )  msymbol(S) )  ///
	(gm_died_mom_total_5, label(Mothers, oldest child > 5 )  msymbol(T) )  ///
	(gm_died_dl_mom_total_5,   label(Mothers, oldest child {&le} 5 ) msymbol(D) )   ///
      ,vertical yline(0) ///
      coeflabels(gm_died_b4 = "-4" gm_died_b3 = "-3" ///
	gm_died_b2 = "-2" gm_died_b1 = "-1" ///
	gm_died_a1 = "1" gm_died_a2="2" ///
	gm_died_a3 = "3" gm_died_a4="4" ///
	, wrap(25)) xtitle(Period Relative to Granmother's Death, size(5)) level(90 95) ciopts(recast(rcap)) legend(region(style(none)) colfirst size(3.5) /// 
	rows(2) ) ytitle("Double Difference" "Employment Rate relative to t=-1", size(4.5)) graphregion(color(white)) bgcolor(white) ///
	 ylab(, axis(1) nogrid angle(0)) name(ES_o_5_Dads_v_Moms_gm,replace)

graph export "Figures/Figure 4.pdf", replace



