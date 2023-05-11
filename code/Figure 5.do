clear

set more off

use "$path\Data\3GenPanel.dta" , clear

reghdfe employed post_gm_died##gm_died##o_le_5##gm_m_side /// 
if $ifs_mom, ///
absorb(ID yq_c#loc_group#sex yq_c#o_le_5#sex yq_c#gm_died#sex)  cluster(HH_ID)	

coefplot, graphregion(color(white))  bgcolor(white)  xline(0)  drop(_cons) ///
 ciopts(recast(rcap)) level(90 95) mlabel mlabsize(4) format(%9.2f) mlabposition(12) mlabgap(*2) ///
	xtitle("Δ in Employment" "Probability, Marginal", size(4) ) legend( off)   grid(none) ///
	coeflabels(post_gm_died = "Mothers" ///
	1.post_gm_died = "Post x GM died" 1.post_gm_died#1.o_le_5 = "Post x GM died x Oldest GC at most 5 yo" ///
	1.post_gm_died#1.gm_m_side = "Post x GM died x Mother's side GM" /// 
	1.post_gm_died#1.o_le_5#1.gm_m_side = "Post x GM died x Oldest GC at most 5 yo x Mother's side GM" /// 
	,  labsize(3.5) )  

	graph export "Figures/Figure 5A.pdf",  replace
	
	nlcom  	(d_gm_death :  _b[1.post_gm_died] ) ///
		(d_gm_death_o_l :    _b[1.post_gm_died] + _b[1.post_gm_died#1.o_le_5] ) ///
		(d_gm_death_gm_s :    _b[1.post_gm_died] + _b[1.post_gm_died#1.gm_m_side] ) ///
		(d_gm_death_o_l_gm_s :  _b[1.post_gm_died] + _b[1.post_gm_died#1.o_le_5] + _b[1.post_gm_died#1.o_le_5#1.gm_m_side] ), post 

coefplot, graphregion(color(white))  bgcolor(white)  xline(0)  drop(_cons) ///
 ciopts(recast(rcap)) level(90 95) mlabel mlabsize(4) format(%9.2f) mlabposition(12) mlabgap(*2) ///
	xtitle("Δ in Employment" "Probability, Total", size(4) ) legend( off)  grid(none) ///
	coeflabels( post_gm_died = "Mothers" ///
	d_gm_death = "Post x GM died" d_gm_death_o_l = "Post x GM died x Oldest GC <= 5" ///
	d_gm_death_gm_s = "Post x GM died x Mother's side GM" /// 
	d_gm_death_o_l_gm_s = "Post x GM died x Oldest GC at most 5 yo x Mother's side GM" /// 
	, labsize(3.5) )
	
	graph export "Figures/Figure 5B.pdf",  replace
	

