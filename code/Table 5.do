capture log close
clear
cls
set more off

use "$path\Data\3GenPanel.dta" , clear

* Gen Family Income
gegen double inc_f2 = sum(ingocup), by(HH_ID n_ent) 
gen temp = inc_f2*(n_ent==1)
gegen inc_f2_p1=max(temp), by(ID)
drop temp*

* Keep Sample
reghdfe employed post_gm_died##o_le_5 /// 
if $ifs_mom, ///
absorb(ID yq_c#loc_group#sex yq_c#o_le_5#sex yq_c#gm_died#sex) cluster(HH_ID)
keep if e(sample)

gstats winsor ingocup, replace cut(5 95)
gstats winsor hrsocup, replace cut(0 95)
gstats winsor n_hij, replace cut(0 99) // six + children last bucket

foreach var in ingocup_cond_p1 hrsocup_cond_p1 {
local orig = subinstr("`var'","_cond","",.)
di "`orig'"
gen `var'= `orig' if `orig'>0
}

foreach x in time_cuidar_gm_p1 inc_f_p1 ingocup_cond_p1 hrsocup_cond_p1 inc_f2_p1 {
capture egen Z_`x' = std(`x')
}

eststo clear
local fe_text = subinstr("ID yq_c#loc_group#sex yq_c#o_le_5#sex yq_c#gm_died#sex","#","_",.)

foreach x in Z_time_cuidar_gm_p1 n_hij_p1 t_gk_p1 t_gk_u6_p1 t_gk_m_p1 d_gk_m_p1 Z_inc_f2_p1 Z_ingocup_cond_p1 Z_hrsocup_cond_p1 f_emp_p1 high_more_p1 coll_more_p1 {

reghdfe employed post_gm_died##o_le_5##c.`x' /// 
if $ifs_mom, ///
absorb(ID yq_c#loc_group#sex yq_c#o_le_5#sex yq_c#gm_died#sex) cluster(HH_ID)

nlcom   (d_gm_died :  _b[1.post_gm_died] ) ///
(d_gm_died_le :  _b[1.post_gm_died#1.o_le_5] ) ///
(d_gm_died_Het :   _b[1.post_gm_died#c.`x']) ///
(d_gm_died_le_Het :   _b[1.post_gm_died#1.o_le_5#c.`x']) , post

estadd local inter "`x'" , replace
estadd local cluster "HH" , replace
estadd local FE "`fe_text'", replace
estadd local SE "HH_ID", replace

eststo 
}

esttab  using "Tables/Table 5.csv",  ///
 star(* 0.10 ** 0.05 *** 0.01) replace wrap  se ///
 stats(N cluster FE SE inter, ///
 label("Sample Size" "Clustered SE" "Fixed Effects" "Clustered SE" "Het var"))  ///
 varwidth(45)  nonotes 

