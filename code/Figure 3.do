clear

set more off

use "$path\Data\3GenPanel.dta" , clear


keep if sec_gen==1

reghdfe employed post_gm_died##b11.max_eda_gk_3 ///
if $ifs_mom, absorb(ID yq_c#loc_group#sex yq_c#max_eda_gk_3#sex yq_c#gm_died#sex) cluster(HH_ID)

nlcom  	(k1 :  _b[1.post_gm_died#1.max_eda_gk_3] ) ///
	(k2 :  _b[1.post_gm_died#2.max_eda_gk_3] ) ///
	(k3 :  _b[1.post_gm_died#3.max_eda_gk_3] ) ///
	(k11 : 0 ) , post

est sto post_gm_died

coefplot post_gm_died, vertical yline(0) legend(off) ///
      coeflabels(k1="<4" k2="4-5" k3="6-10"   /// 
      k11=">10", labsize(4)) ///
	 xtitle(Oldest Child Age, size(4)) ciopts(recast(rcap)) level(90 95)  mlabel mlabsize(4) format(%9.2f)  mlabposition(3) mlabgap(*2) ///
	 ytitle("Triple Difference" "Employment Rate relative to Age=11+", size(4)) graphregion(color(white)) bgcolor(white) ///
	 ylab(, nogrid)


graph export "Figures/Figure 3.pdf", replace
	 