* Shibin Yan, Spring 2021
* Revised: Spring 2021

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
/* Variables 
Independent Variables: care regimes (informal care, leave arrangement, financing and services)

Dependent Variables: life expectancy at birth, health, SWB,burden of dieases,
female employment rate, GDP per capita, poverty rate, education attainment

Control Variables: gender, marital status, household size
*/

/* Data Description 
Data came from Study on Global ageing and Adult Health (SAGE), released by 
The World Health Organization (WHO) in 2012. SAGE is a longitudinal, 
multidisciplinary and cross-national study collecting data on adults aged 50 years 
and older from nationally representative samples in China, Ghana, India, Mexico, 
Russian Federation, and South Africa. It is the only available international survey 
that provides reliable, valid and comparable data on levels of health on a range of 
key domains for older adult populations in China and India (Chatterji et al.,2013). 
At present, two waves of the survey are available: 2000-2004 and 2007-2010. The study
employs data from the first wave that was conducted from 2007 to 2010 at the household
and individual levels. 
*/

/* Research Questions
What are the typologies of care regime that China and India belong to ?
What is the social and economic effect of different typologies on social development in both nations?
*/

/* Datasets (wave1)
China Individual: 
use "https://docs.google.com/uc?id=1kaqikeaFHR3tw1jZPhdWeaHGPnphlZfx&export=download",clear
China Household:
use "https://docs.google.com/uc?id=13vILHi2nwGrpkLx8ifJf8eKSDRdtkxLb&export=download",clear
India Individual: 
use "https://docs.google.com/uc?id=1YWYC2DZbVEZVeT3QvOANTH0mnJ5d7RG8&export=download",clear
India Household:
use "https://docs.google.com/uc?id=1tvry9-xRoWA-MHqCRmd96lcdNaLdh6uB&export=download",clear
*/

/* Definition of Aging Population
According to SAGE, aging population in all six SAGE countries is defined as people aged 50 and over.
The definition is different from the one used in the developed countries, like US-- defined as older 
adult aged 60 or 65 and over. One reason for the differences is that life expectancy at birth in 
develping countries as of 2010 was 12 years lower, on average, than in more developed countries. 
*/

/********************/
/* data cleaning */
/********************/
/*- China -*/
/*merge*/
/* based on the connection between HHID in the household level dataset and ID in 
the individual level dataset, we can merge the china's hosehold level data with 
the individual level data. */
use "https://docs.google.com/uc?id=1kaqikeaFHR3tw1jZPhdWeaHGPnphlZfx&export=download",clear
g HHID = substr(ID,1,8)
save caind, replace
use "https://docs.google.com/uc?id=13vILHi2nwGrpkLx8ifJf8eKSDRdtkxLb&export=download",clear
merge 1:m HHID using caind
save comcha,replace
list HHID if _merge==1

*rename variables
rename Q0602CA inforcare
rename Q0602CB infortime
rename Q5002 formalcare
rename Q1514A pension
rename Q1514B medical
rename Q1514E nobenefit
rename Q0829 housespend
rename Q5005 inpatinet
rename Q5008 typeinpa
rename Q5026 outpatient
rename Q5028 typeoutpa
rename Q5013 inpasatis
rename Q5034 outpasatis
rename Q1009 gender 
rename Q1503 employment 
rename Q1011 age
rename Q1012 marital
rename Q1016 education
rename Q2000 health
rename Q7010 SWB
rename Q0401 familysize
rename Q0001 country

* flip the health variable, make 5 the best outcome of health, 1 the worst outcome. rev_health is recode variable of health.
recode health (5=1 "very bad") (4=2 "bad")(3=3 "so so")(2=4 "good") (1=5 "very good")(8 9 .=.),gen(rev_health) 
recode infortime (0/10=1 "1-10hours") (11/20=2 "11-20hours") (21/91=3 "21hours and over"),generate(rec_infortime)

* recode the value of Q5010 (inpatient care payment sources)
generate Q5010=1 if Q5010_1==1
replace Q5010=2 if Q5010_2==1
replace Q5010=3 if Q5010_3==1
replace Q5010=4 if Q5010_4==1
replace Q5010=5 if Q5010_5==1
replace Q5010=6 if Q5010_6==1
replace Q5010=7 if Q5010_7==1
replace Q5010=8 if Q5010_8==1
rename Q5010 paymentinpa
codebook paymentinpa

* recode the value of Q5032 (outpatient care payment sources)
generate Q5032=1 if Q5032_1==1
replace Q5032=2 if Q5032_2==1
replace Q5032=3 if Q5032_3==1
replace Q5032=4 if Q5032_4==1
replace Q5032=5 if Q5032_5==1
replace Q5032=6 if Q5032_6==1
replace Q5032=7 if Q5032_7==1
replace Q5032=8 if Q5032_8==1
rename Q5032 paymentoutpa
codebook paymentoutpa

keep HHID ID country infortime inforcare formalcare inpatinet typeinpa outpatient typeoutpa inpasatis ///
outpasatis pension familysize health SWB nobenefit housespend gender age marital  education paymentinpa ///
paymentoutpa medical nobenefit rev_health rec_infortime employment 

* Factor Analysis 
factor infortime inforcare formalcare inpatinet typeinpa outpatient typeoutpa inpasatis outpasatis ///
pension medical nobenefit paymentinpa paymentoutpa, ipf factor(1)
rotate, varimax horst
predict factor1
rename factor1 careregimes
* China data
save megachb.dta,replace


/*- India -*/
/*merge*/
* merge the china's hosehold level data with the individual level data. 
use "https://docs.google.com/uc?id=1YWYC2DZbVEZVeT3QvOANTH0mnJ5d7RG8&export=download",clear
g HHID = substr(ID,1,8)
save inind, replace
use "https://docs.google.com/uc?id=1tvry9-xRoWA-MHqCRmd96lcdNaLdh6uB&export=download",clear
merge 1:m HHID using inind
save comind,replace

*rename variables
rename Q0602CA inforcare
rename Q0602CB infortime
rename Q5002 formalcare
rename Q1514A pension
rename Q1514B medical
rename Q1514E nobenefit
rename Q0829 housespend
rename Q5005 inpatinet
rename Q5008 typeinpa
rename Q5026 outpatient
rename Q5028 typeoutpa
rename Q5013 inpasatis
rename Q5034 outpasatis
rename Q1009 gender 
rename Q1503 employment 
rename Q1011 age
rename Q1012 marital
rename Q1016 education
rename Q2000 health
rename Q7010 SWB
rename Q0401 familysize
rename Q0001 country

* flip the health variable, make 5 the best outcome of health, 1 the worst outcome. rev_health is recode variable of health.
recode health (5=1 "very bad") (4=2 "bad")(3=3 "so so")(2=4 "good") (1=5 "very good")(8 9 .=.),gen(rev_health) 
recode infortime (0/10=1 "1-10hours") (11/20=2 "11-20hours") (21/91=3 "21hours and over"),generate(rec_infortime)

* recode the value of Q5010 (inpatient care payment sources)
generate Q5010=1 if Q5010_1==1
replace Q5010=2 if Q5010_2==1
replace Q5010=3 if Q5010_3==1
replace Q5010=4 if Q5010_4==1
replace Q5010=5 if Q5010_5==1
replace Q5010=6 if Q5010_6==1
replace Q5010=7 if Q5010_7==1
replace Q5010=8 if Q5010_8==1
rename Q5010 paymentinpa
codebook paymentinpa

* recode the value of Q5032 (outpatient care payment sources)
generate Q5032=1 if Q5032_1==1
replace Q5032=2 if Q5032_2==1
replace Q5032=3 if Q5032_3==1
replace Q5032=4 if Q5032_4==1
replace Q5032=5 if Q5032_5==1
replace Q5032=6 if Q5032_6==1
replace Q5032=7 if Q5032_7==1
replace Q5032=8 if Q5032_8==1
rename Q5032 paymentoutpa
codebook paymentoutpa

keep HHID ID country infortime inforcare formalcare inpatinet typeinpa outpatient typeoutpa inpasatis ///
outpasatis pension familysize health SWB nobenefit housespend gender age marital  education paymentinpa ///
paymentoutpa medical nobenefit rev_health rec_infortime employment 

* Factor Analysis 
factor infortime inforcare formalcare inpatinet typeinpa outpatient typeoutpa inpasatis outpasatis ///
pension medical nobenefit paymentinpa paymentoutpa, ipf factor(1)
rotate, varimax horst
predict factor1
rename factor1 careregimes

* India data
save megaindb.dta,replace


*append china data with india one.
append using megachb,force

*import excel spreadsheet1 
import excel "https://docs.google.com/uc?id=1Ddgr7BLA5-YtGHp0Lzpi-QvpJY2SeSuC&export=download", sheet("Data") firstrow clear
merge 1:m country using megaci, nogen
rename lifeexpectancyatbirth lifeex
save bigdata,replace
*import excel spreadsheet2
import excel "https://docs.google.com/uc?id=1T_EId_D5QppgjP5kv3X0CC31AMiFSRaA&export=download", sheet("Data") firstrow clear
rename CountryName country
rename femalelaborparticipation felabor
drop IndicatorCode
merge 1:m country using bigdata, nogen
save bigdata2,replace

*import excel spreadsheet3
import excel "https://docs.google.com/uc?id=1GnG2hYbxEVpDgVexkX7pXCO3UHjGqfII&export=download", sheet("Data") firstrow clear
rename GDPpercapita gdpcp
merge 1:m country using bigdata2, nogen
save bigdata3,replace

*bigdata.dta is the data that combine the outcome variables with independent variables in both nations.

*******select datasets*********
*use megachb, replace
*use megaindb,replace
*use megachb,replace

/********************/
/*descriptive statistics*/
/********************/

bysort country: summarize(infortime)
/* The average hours of informal care received by the elderly is 5.46 in China but 
7.45 in India.The Indian elderly tend to receive relatively longer informal care 
services than their Chinese counterparts. */

bysort country: tab (inforcare)
/* the share of the elderly receiving informal care is 11.87 percent in China but 
12.75 percent in India. In other words, there is a slightly higher percentage of
the elder population receiving informal care in India compared to China. This is 
surprising. */

bysort country: tab (pension)
bysort country: tab (medical)
bysort country: tab (nobenefit)
/* large proportion of older people in India do not obtain any benefit from 
their retirement (64.7%), whereas the number is only 9.98 percent in China. The 
share of pensions received by older persons is 36.7% in China, much higher
than the corresponding share in India. It demonstrates that financial support 
from the government is much stronger in China. The gap in public pension expenditures 
between these two nations highlights the enormous funding offered 
to the elderly in China. Whereas India lags behind in its direct financial 
support for its elderly.  */

bysort country: tab (education)
//show the break down of education level in each country. 

bysort country: tab (inpasatis)

tab country health
tab country inpasatis
tab country pension

sum infortime inforcare formalcare inpatinet typeinpa outpatient typeoutpa inpasatis outpasatis ///
pension medical nobenefit paymentinpa paymentoutpa


/*****************/
/* Visualizing data*/
/*****************/
*Start to visualize the data
histogram infortime, percent by(country)

histogram health, percent by(country)

histogram inforcare, percent by(country)

histogram employment, percent by(country)
* larger proportion of indian elderly population are working. 

histogram infortime, percent by(country)
graph bar health, blabel(bar) by(country, total)
hist infortime,freq
scatter  health SWB , by(country)
*scatter (health SWB, sort), by(country, total)
*twoway (health SWB, sort), by(country, total)


/********************/
/*Correlation*/
/********************/
pwcorr inforcare formalcare health age gender pension SWB, star(0.05)
pwcorr lifeex felabor gdpcp health SWB education careregimes, star(0.05)

/*****************/
/* Regression */
/*****************/
reg health careregimes gender marital familysize, robust 
/* health is not statistically significant because 
its p-value (0.161) is greater than the usual significance level of 0.05. Weird!
the weight of the variables? */

reg SWB careregimes gender marital familysize, robust 
/* SWB (subjective well-being) is statistically significant!!! Care regimes is 
positively affect SWB of the elderly in both nations. */

reg education careregimes gender marital familysize, robust
/* education attainment is statistically significant!!! Care systems have positively
influence on education attainment of the elderly in both nations. */

reg lifeex careregimes gender marital familysize, robust
/* life expectancy at birth is statistically significant!!! Care systems can positively
influence on life expectancy at birth in both nations. */

reg felabor careregimes gender marital familysize, robust

reg gdpcp careregimes gender marital familysize, robust
