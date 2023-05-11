* Run do files
clear all
global path: di subinstr("`c(pwd)'","\Code","",.)
cd "$path"

* To run the following do files first run these globals
global ifs = "obs_hh==5 & max_eda>=21 & t_mom_max<2 & max_eda_gk<30"
global ifs_dad = "dad==1 & obs_hh==5 & inrange(max_eda,21,50) & max_eda_gk<30 & t_dad_max<2 & miss_sex==0 & t_gm_died<2 & t_gd_died<2 & ( (t_gm_max == 1 & inrange(max_eda_gm,40,100) ) | (t_gd_max == 1 & inrange(max_eda_gd,40,100) ) )"  
global ifs_mom = "mom==1 & obs_hh==5 & inrange(max_eda,21,50) & max_eda_gk<30 & t_mom_max<2 & miss_sex==0 & t_gm_died<2 & t_gd_died<2 & ( (t_gm_max == 1 & inrange(max_eda_gm,40,100) ) | (t_gd_max == 1  & inrange(max_eda_gd,40,100) ) ) "

 
do "Code/Figure 1 3-Gen.do" 
do "Code/Figure 2.do" 
do "Code/Figure 3.do" 
do "Code/Figure 4.do" 
do "Code/Figure 5.do" 
do "Code/Figure 6.do" 
do "Code/Figure A1.do"
do "Code/Figure A2.do"
do "Code/Figure A3.do"
do "Code/Figure A4.do"
do "Code/Figure A5.do" 
do "Code/Figure A6.do"
do "Code/Table 1.do" 
do "Code/Table 2.do" 
do "Code/Table 3.do" 
do "Code/Table 4.do" 
do "Code/Table 5.do" 
do "Code/Table 6.do" 
do "Code/Table A2.do" 
do "Code/Table A3.do" 
do "Code/Table A4.do" 
do "Code/Table A5.do" 

 
 

 
 
 
 



