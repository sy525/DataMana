
//////////////////////Project Start////////////////////////
clear
set more off
version 15
//////////////////////////////////////////////////////////


//////////////////////Package Install////////////////////////

*net install outreg2, from(http://fmwww.bc.edu/RePEc/bocode/o) 
*net install regplot, from(http://www.stata-journal.com/software/sj10-1/) 

//////////////////////////////////////////////////////////
*TITLE: Care Regime in China and India through the Lens of Eldercare 
//////////////////////////////////////////////////////////

/********************/
/* data cleaning*/
/********************/
*Note: index- policy sick leave, formal, finance, cross-time

//////////Household///////
* India Household level dataset
use "https://docs.google.com/uc?id=1tvry9-xRoWA-MHqCRmd96lcdNaLdh6uB&export=download",clear

save inho, replace
rename Q0602CA inforcare
rename Q0602CB infortime
sum inforcare infortime
codebook inforcare infortime
hist infortime,freq
gr export time1.png, replace
sum Q0615AA infortime

recode infortime (0/10=1 "1-10hours") (11/20=2 "11-20hours") (21/91=3 "21hours and over"),generate(rec_infortime)
sum infortime if rec_infortime==1
sum infortime if rec_infortime==2
sum infortime if rec_infortime==3

factor infortime inforcare Q0615AA, ipf factor(1)
rotate, varimax horst
predict factor1

  
* China household level data
use "https://docs.google.com/uc?id=13vILHi2nwGrpkLx8ifJf8eKSDRdtkxLb&export=download",clear
rename Q0602CA inforcare
rename Q0602CB infortime

save chho, replace
sum inforcare infortime
codebook inforcare infortime
hist infortime,freq
gr export time2.png, replace
sum Q0615AA infortime

recode infortime (0/10=1 "1-10hours") (11/20=2 "11-20hours") (21/91=3 "21hours and over"),generate(rec_infortime)
sum infortime if rec_infortime==1
sum infortime if rec_infortime==2
sum infortime if rec_infortime==3

factor infortime inforcare Q0615AA, ipf factor(1)
rotate, varimax horst
predict factor1

/// care giving time
sum Q8012
hist Q8012

sum Q8005AA Q8005AB Q8005AC Q8005AD
* need to make it to be dummy. (relationship with carers)

///ADL & IADL
sum Q2025-Q2045

////////////////////////////
*Outcome
*GDP per capita
*female employment rate
*Urbanization rate
*Rural Population

*Control
*Population

////////////////////////////


/********************/
/*descriptive statistics*/
/********************/

///Using outreg2 to export summary statistics of all variables in dataset.
outreg2 using desc.doc, replace sum(log) keep(Q0602CA Q0602CB)



/*****************/
/* Regression */
/*****************/

reg focare age sex income  education residence marital
outreg2 using care1.xls, replace
reg infocare age sex income  education residence marital
