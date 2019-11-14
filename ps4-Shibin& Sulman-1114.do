* Data Management Project- Probelm Set 4
*Shibin Yan & Sulman Saleem, Fall 2019
*Revised: Fall 2019 Nov.7
*----------------------------

//---------------------------data mgmt----------------------------------------------
//---------------------------data mgmt----------------------------------------------
//---------------------------data mgmt----------------------------------------------

/*****************/
/* Introduction */
/*****************/

/* Data Description 
Data came from the Chinese Longitudinal Healthy Longevity Survey (CLHLS), released by 
the National Archive of Computerized Data on Aging in 2017. The CLHLS surveys 
include seven waves of data which are released in 1998, 2000, 2002, 2005, 2008, 2010 
and 2014 respectively. The CLHLS provides information on health status and quality of 
life of the elderly aged 65 and older in China,included socioeconomic characteristics, 
family, lifestyle, and demographic profile of this aged population. A national representative 
sample of people aged 65 or older was drawn. The dataset covers 23 out of 31 provinces in China, 
including five minority autonomous regions. These minority autonomous regions that have
a much higher proportion of minority group concentration are Guangxi, Inner Mongolia,
Ningxia, Xinjiang, and Tibet. In this study, the data from the 2014 wave of the CLHLS
surveys will be utilized because it is easy to observe the effect of the health disparity
on the older population in one dataset. The study sample consists of 7,192 older adults
aged 65 and over; 7% (n=495) of them are ethnic minorities. In addition, it comprises
3,214 urban elderly which accounting for 44.6% of the sample and 3,980 rural elderly.
The response rate was 97.7 percent.   
*/

/* Research Goal
This research is about health disparity for Chinese elderly. This research aims to 
find out how geographic and ethnicity of residents affect collectively on health quality of old 
people in China. In other words, this study will assess the impact of geographic 
and ethnicity disparity on the health outcome of the Chinese elderly.
*/

/* Research Question
1. Does the majority elderly have a better health status than their minority counterpart, as the literature showed? 
2. Does the elderly living in urban area live longer than their counterpart in rural area?
*/

/* Hypothesis 
Hypothesis 1: The Han (majority) elderly living in an urban area have a better health status than those in a rural area. 
Hypothesis 2: The Han (majority) elderly living in an urban area have a better health status than the minorities in an urban area. 
Hypothesis 3: The Han (majority) elderly living in a rural area have a better health status than the minorities in an urban area.
Hypothesis 4: The minorities elderly living in an urban area have a better health status than those in a rural area.
*/

/* Variables 
Independent Variables: age,education,income and employment status. 
* Justification of use these variables: Health disparity is not simply related to differences 
in health. The fundamental-cause theory insists that socioeconomic status 
is a fundamental cause of health disparity. Disparities in health have persisted in developed countries 
and groups who experience some of the greatest disparities in health tend to experience the greatest 
socioeconomic disparities. Shavers argues that SES is a significant contributor to the disparate 
health observed among ethnic groups in different regions (rural/ urban). Based on Shavers’s model, 
the study measure SES included occupation, income, and education. Using this model, the socioeconomic 
status of the ethnic group of elderly from urban/ rural areas are the independent variables. 

Dependent Variables: self-rated health status,functional capacity (ADLs& IADLs) .

Control Variables: gender, marital status, family size.
*/
* explain these variables in ps5.

//////////////////////Project Start////////////////////////

clear
set more off
version 15
//////////////////////////////////////////////////////////


//////////////////////Package Install////////////////////////

net install outreg2, from(http://fmwww.bc.edu/RePEc/bocode/o) 
*net install regplot, from(http://www.stata-journal.com/software/sj4-4/) 

//////////////////////////////////////////////////////////

/********************/
/* data cleaning*/
/********************/

use "https://docs.google.com/uc?id=1Sb_fGGdRiVSxFpcfHbp7RaV2QauGxi_q&export=download",clear
* some variable names get people confused. It would be better to rename these variables.
rename TRUEAGE age14
rename RESIDENC rural14
rename A1 sex14
rename A2 ethnic14
rename B27 happiness14
rename F41 marital14
rename A41 born14
rename B12 health14
rename F35 income14
rename F23 employment14
rename F1 education14
rename A52 familysize14
rename D71 smoking14
rename E1 bathing14
rename E2 dressing14
rename E3 toileting14
rename E4 transfer14
rename E5 continen14
*E1 to E5 is the variables which use to measure elderly's activities of daily living (ADLs).
rename E6 feeding14
rename E7 visiting14
rename E8 shopping14
rename E9 cooking14
rename E10 washing14
rename E11 walking14
rename E12 carrying14
*E6 to E14 is the variables used to measure elderly's instrumental activities of daily living (IADLs).

local idvar ID YEARIN MONTHIN DAYIN TYPE PROV
display "`idvar'"
keep  age14 rural14 sex14 `idvar' ethnic14 happiness14 marital14 born14 health14 income14  employment14 education14 ///
familysize14 smoking14 bathing14 dressing14 toileting14 transfer14 continen14 feeding14 visiting14 shopping14 ///
cooking14 washing14 walking14 carrying14 A542A


* Factor Analysis 
factor feeding14 visiting14 shopping14 cooking14 washing14 walking14 carrying14 bathing14 dressing14 ///
toileting14 transfer14 continen14,ipf factor(2)
rotate, varimax horst
predict factor1 factor2 
egen function14 = rowmean(factor1 factor2)
* function14 is the dependent variable which measure the function disability of the elderly. 

* recode the rural variable
recode rural14 (3=0) (1 2=1) (-99=.),gen(Urban14) 
la de urbanlab 0 "Rural" 1 "Urban"
la val Urban14 urbanlab
label list urbanlab
* recode the ethnicity variable
recode ethnic14  (1=0) (2 3 4 5 6 7 8=1),gen(major14) 
la de ethniclab 0 "majority" 1 "minority"
la val major14 ethniclab
label list ethniclab
recode marital14 (2 3 4 5=0) (1=1), gen(spouse14)
la de maritallab 0 "single" 1 "spouse"   
la val spouse14 maritallab

recode health14 (5=1) (4=2)(3=3)(2=4) (1=5)(8 9 .=.),gen(Health14) 
la de healthlab 1 "very bad" 2 "bad" 3 "so so" 4 "good" 5 "very good"
la val Health14 healthlab
label list healthlab
tab Health14,m 
save eld1.dta, replace


* the second dataset--the using dataset which are used to merge.
use "https://docs.google.com/uc?id=1_exDjt1Rbc1B18wX0oMgyRZeWpm04uKH&export=download",clear
rename TRUEAGE age12
rename RESIDENC rural12
rename A1 sex12
rename A2 ethnic12
rename B27 happiness12
rename F41 marital12
rename A41 born12
rename F35 income12
rename B12 health12
rename F1 education12
rename F23 employment12
local depen age12 rural12 sex12 ethnic12 happiness12 marital12 born12 PROV income12 education12
display "`depen'"
rename A52 familysize12
rename D71 smoking12
rename E1 bathing12
rename E2 dressing12
rename E3 toileting12
rename E4 transfer12
rename E5 continen12
*E1 to E5 is the variables which use to measure elderly's activities of daily living (ADLs).

rename E6 feeding12
rename E7 visiting12
rename E8 shopping12
rename E9 cooking12
rename E10 washing12
rename E11 walking12
rename E14 carrying12
*E6 to E12 is the variables used to measure elderly's instrumental activities of daily living (IADLs).

local idvar ID YEARIN MONTHIN DAYIN TYPE PROV
display "`idvar'"
keep `idvar' age12 rural12 sex12 ethnic12 happiness12 marital12 born12 health12 income12 /// 
employment12 education12 familysize12 smoking12 bathing12 dressing12 toileting12 transfer12 continen12 feeding12 visiting12 shopping12 cooking12 washing12 walking12 carrying12 A542A
save eld2.dta, replace

/*****************/
/* Merging data*/
/*****************/

/*merge1*/ 
use eld2, replace
sort ID
destring A542A, replace
merge 1:1 ID using eld1.dta
save merge1.dta,replace
sort _merge
list TYPE if _merge==1
list TYPE if _merge==2
/*
the reasons for the non-merge is that there are thousands of new observations added to 
the using datasets, and that many observations appeared in the master dataset are not 
longer appear in the using dataset. Maybe it is becasue the elderly died or the researchers
cannot find these elderly for interview again.  
*/

*reshape long rural age born happiness, i(ID) j(year)
/* 
by reshaping the rural variable, we can see the change on the place of the elderly. It is
significant to observe the change of living places of the elderly. We would like to test the hypothesis
that elderly living in the city area will have a better life expectancy or health resources than their
counterpart in the rural area. These are several observations of data we found can support the hypothesis. 
The reshape can help us easier to compare the data, especially a large dataset. 
*/

*append using merge1

/*merge2*/
use merge1,clear
decode PROV, g(PROV1)
replace PROV1 = proper(PROV1)
save merge2, replace
import excel "https://docs.google.com/uc?id=14owWYRQ4O8GYwoN8VWVsyUyY1ke9KlwF&export=download", sheet("Sheet1") firstrow clear
keep in 1/31
rename PROV PROV1
merge 1:m PROV1 using merge2, nogen 
save merge3, replace 
sort _merge
list PROV1 if _merge==1
list PROV1 if _merge==2
list PROV1 if _merge==1 | _merge==2
/*
the reason for the non-merge is because there is different way to spell the name of
 province name between the master dataset and using dataset, such as Shannxi and 
 Shaanxi.
*/
* Data from China Statistical Yearbook 2018 http://www.stats.gov.cn/tjsj/ndsj/2018/indexeh.htm.

 /*merge3*/
use "https://docs.google.com/uc?id=1WMOXBRM8910rlTr3VV3uFCXPtuT5LRmC&export=download",clear
keep if COUNTRY==1 | COUNTRY==10 | COUNTRY==22  
keep COUNTRY RESIDENCE PROVINCE_CHNS AGE INCOME PPP GOODHEALTH BMI
ren PROVINCE_CHNS PROV
decode PROV, gen(PROV1)
replace PROV1 = proper(PROV1)
collapse (mean) AGE , by(PROV1)
save merge4,replace
*Data from Research on Early Life and Aging Trends and Effects: A Cross-National Study 1996-2008 https://www.icpsr.umich.edu/icpsrweb/DSDR/studies/34241.

merge 1:m PROV1 using merge3, nogen
sort PROV1
list PROV1 if _merge==1
list PROV1 if _merge==2
save merge5, replace
*list PROV1 if _merge==1 | _merge==2
/* A lot of non-merge happen in the using dataset because there are a lot of missing value of PROV1 variable in 
the using dataset. */




/********************/
/*descriptive statistics*/
/********************/
use merge5, clear
bys marital14: egen maxage14=max (age14)
la var maxage "maximums marital elderly age"
/* creat the maximum marital elderly age. By doing this, we can know the largest age of
elder people in different marital status groups. The result shows that 62 widowed elderly's
age is 108, which count as the maximum age in their group. */
ta maxage14 marital14

bys ethnic14: egen meanage=mean(age14)
/* we would liek to know the mean of elderly age from different ethnicity groups. So we creat
the meanage14 variable. The result shows that 97 Han majority people live as long as 89 years.
 */
la var meanage "mean elderly age"
tab meanage14 ethnic14

tab rural14
//Shows the break down of the interviewee's geograpic location\\
tab age14
//Gives break down of how many people are there by age. 

tab ethnic14
//Break of ethnicity and it appears that han is where 94% of interviewee are from

tab rural14 PROV
/* Larger number of people from this sample appear to be from rural areas.*/

graph bar (sum) happiness14, over(rural14) by(happiness14)
/* Graph by region and whether they happier if were younger.*/

graph pie [pweight = rural14], over(rural14) sort(rural14)
*Breakdown of population in pie chart. 

sum age14
*average age 85

tab  sex14
*about 500 more females in the dataset than male

tab marital14
*58% of people widowed and 39% currently married and not surprising  less 1 never married

tabstat Health14 income14 education14 employment14 , by(rural14) 
tabstat Health14 income14 education14 employment14 , by(rural14)  nototal long col(stat)

///Using outreg2 to export summary statistics of all variables in dataset.
outreg2 using des.doc, replace sum(log) keep(Health14 function14 rural14 ethnic14  income14 education14 employment14 age14 ///
smoking14 marital14 familysize14 sex14)


/*****************/
/* Regression */
/*****************/
/// use pwcorr & corr command to check the correlation between the variables that we are using.
pwcorr Health14 function14 sex14 age14 education14 income14 employment14, star(.05)
corr Health14 age14 education14 income14 employment14

/// What's the main determinants of elderly's health?
local control smoking14 marital14 familysize14 sex14
local varin income14 education14 employment14 age14
display "`control'"
display "`varin'"


foreach s in "rural14 "  "rural14 ethnic14" "rural14 ethnic14  income14 education14 employment14"{
outreg2 using reg1.xls,  bdec(2) st(coef) excel append lab
reg Health14 `s'
}

reg Health14 rural14 
reg Health14 rural14 ethnic14
reg Health14 rural14 ethnic14  income14 
reg Health14 rural14 ethnic14  income14 education14 employment14
reg Health14 rural14 ethnic14  `varin'
reg Health14 rural14 ethnic14  `varin' 
reg Health14 rural14 ethnic14  `varin' `control' , robust
predict health_predict
label variable health_predict "health predicted"
scatter Health14 health_predict
///use predictor values to see how well the model is!
outreg2 using reg9.doc, onecol bdec(2) st(coef) excel append ct(A3) lab
/* 
We expect to find, as stated in the hypothese easlier, that income, education and employment predict greater
health. Income, education & employment are proxy of the health disparity. A4 model in the regression talbel 
tells us that the relatonship between health disparity and health status is statistical significant. There is positive
relationship between these variables. In other words, the more income, education level and job opportunity older get, 
the more likely they can get a better health. It support the statement from literature that socioeconomic status (income, edution, employment)
are the determint factor of health. A5 model add ethnicity and geography. We can see that both ethnicity and gepgraphy have
substantial ans statiscally significant effect on health. A9 adds other predictors of health as controls and ethnicity effect on health
decrease. In addition, as hold other control variable constant, the effect of famioy size may seem surprising-it is negative! In other words, the more people that elderly live with,
the worse their health, which is opposite with the literature. 
*/

/// check what's the main determinants of elderly's functioning capactiy?
local control smoking14 marital14 familysize14 sex14
local varin income14 education14 employment14 age14
reg function14 happiness14
reg function14 happiness14 income14 
reg function14 happiness14 income14 education14 employment14
reg function14 happiness14 `varin'
reg function14 happiness14 `varin' `control' , robust
outreg2 using reg2.xls, onecol bdec(2) st(coef) excel append ct(A7) lab
/* 
functioning capacity is another proxy of health status of the elderly. We expect to see that health disparity greately affect
functioning capacity of the elderly. In A5 column, geographic location and income have more effect on functioning capacity of the
elderly, as we expected. In A9 column, when we added all predictor variable together, we can find that geographic location, 
smoking and marital status have a statistical significant effect on functioning capactiy. One thing out of our expectation is that the
relationship marital status and functioning capactiy is statistical significant and postive! That means that elderly who are not living 
with spouse tend to have a better health! 
*/

/// compare the health status of elderly from different areas to see how geographic location difference affect health.
xi: regress Health14 i.rural14 ethnic14 income14 education14 employment14 smoking14 marital14 familysize14 sex14,robust
rename _Irural14_2 town
rename _Irural14_3 rural
label variable town "town"
label variable rural "rural"
outreg2 using reg11.xls
/* 
We expect to see that elderly living in city have better health than their counterparts in rural area. The literature show to us that 
older people from urban areas get better health than elderly in rural because they can access more health care resources than their 
rural counterparts.Quite opposite, in the regression table, it shows that we can find that elderly have 0.123 more unit increase on 
health compared to elderly in city, holding other variables constant. The elderly in rural area have better health than the elderly 
in the city. It is so surprise outcome! Maybe it is related to happiness and pollution and environment. We will look deep in the data.
And we don't find correlation between the health of elderly in town and the health of elderly in rural. 
*/
///problem: why the lable of variables did not show in the outreg table?

///here we would like to check why the elderly in rural area have better health than the elderly in the city. Maybe happiness contribute to that outcome.
xi: regress Health14 i.rural14 ethnic14 income14 education14 employment14 happiness14 smoking14 marital14 familysize14 sex14,robust
graph bar (mean) happiness14, over(rural14)
eststo model2
esttab, r2 ar2 se scalar(rmse)
predict Health14_predict
scatter Health14 Health14_predict
/* 
From the regression table, we can see that happiness/ Subjective well-being (SWB) have a significant effect on health of elderly. And then, we can find that elderly in rural
report a better health than their counterparts in town and city! According to Dr.Adam's SWB theory, nature envrionment make people happier. So elderly in rural areas get
more chance to exposure to nature enviornment than their counterparts in city. So they tends to become happier. 
*/

/// look deep on the strong relationship between health and income.
gen logincome = log(income14) 
regress Health14 rural14 ethnic14 logincome education14 employment14 smoking14 marital14 familysize14 sex14,robust

xi: regress Health14 i.Urban14 ethnic14 income14 education14 employment14 smoking14 marital14 familysize14 sex14, robust
outreg2 using reg12.xls

xi: regress Health14 i.ethnic14 Urban14 income14 education14 employment14 smoking14 marital14 familysize14 sex14, robust
outreg2 using reg13.xls
/* 
As we stated in hypothesis, we expect to see that the Han (majority) elderly living have a better health status than the minorities.
Regression table shows us that Zhuang minority group have worst health, compared to the majority. This is not surprise. However, it also 
reveals that mongolia and other ethnic group have a better health than majority. This is out of our expectation. The data tells us that 
some ethnic group do better than majority on health but some don't. We need to know the reason of that. 
*/

reg Health14 i.Urban14##c.familysize14 income14 education14 employment14 smoking14 marital14 , robust beta
outreg2 using reg13.xls

xi: regress function14 income14 education14 employment14 smoking14 marital14 familysize14 sex14 i.ethnic14, robust
ovtest
reg function14 i.Urban14##c.income14, robust beta

reg function14 i.rural14##c.income14 education14 employment14 smoking14 marital14 familysize14 sex14 i.ethnic14, robust beta

* use the log for income variable to see the effect!

reg Health14 i. ethnic14
gen ethage = age14 * ethnic14
regress Health14 age14 ethnic14 ethage
regplot, by(ethnic14)
regplot, sep(ethnic14)

gen ethage1 = age14 * major14
regress Health14 age14 major14 ethage1
regplot, by(major14)
regplot, sep(major14)

gen ethe = education14 * major14
regress Health14 education14 major14 ethe
regplot, by(major14)
regplot, sep(major14)

// Robust Check
reg Health14 income14 , robust
scatter Health14 income14 ,ml(ethnic14)

/*****************/
/* Visualizing data*/
/*****************/

*Start to visualize the data 
tab ethnic14
sum age14
hist age14, frequency normal
*validated age with frequncy 
gr export graph1.png, replace  //pdf, png, etc

hist income14,normal
gr export graph2.pdf, replace  //pdf, png, etc

histogram Health14, discrete freq addlabels xlabel(0 1(1)9,valuelabel)
*Here we see the breakdown of self-reported health their respective breakdown
gr export graph3.png, replace  //pdf, png, etc

histogram ethnic14, discrete freq addlabels xlabel(0 1,valuelabel)
*ethnic grup breakdown
gr export graph4.png, replace  //pdf, png, etc

histogram rural14, discrete freq addlabels 
*breakdown of city, town and rural 
gr export graph4.png, replace  //pdf, png, etc

histogram income14, discrete freq addlabels 
gr export graph5.png, replace  //pdf, png, etc

histogram education14, discrete freq addlabels 
gr export graph7.png, replace  //pdf, png, etc

histogram employment14, discrete freq addlabels
*paid enagement post job
gr export graph8.png, replace  //pdf, png, etc 

histogram age14, frequency by(rural14)
gr export graph9.png, replace  //pdf, png, etc

hist Health14, frequency by(rural14)
gr export graph10.png, replace  //pdf, png, etc

hist Health14, frequency by(sex14)
gr export graph11.png, replace  //pdf, png, etc

hist function14, frequency by(sex14)
gr export graph14.png, replace  //pdf, png, etc

*Group Statistic 
tab rural14, sum (age14)
tab ethnic14, sum (age14)
tab rural14, sum (Health14)
tab Health14, sum (rural14)
histogram Health14 , normal

twoway histogram Health14 , discrete freq by(rural14)
gr export graph13.png, replace  //pdf, png, etc

twoway histogram Health14 , discrete freq by(ethnic14)
gr export graph14.png, replace  //pdf, png, etc

twoway histogram age14 , discrete freq by(rural14)
gr export graph14.png, replace  //pdf, png, etc

twoway histogram age14 , discrete freq by(ethnic14)
gr export graph14.png, replace  //pdf, png, etc

twoway histogram function14 , discrete freq by(ethnic14)
gr export graph14.png, replace  //pdf, png, etc

twoway histogram function14 , discrete freq by(rural14)
gr export graph14.png, replace  //pdf, png, etc

tw(scatter Health14 age14)(lfit Health14 age14)
twoway (scatter Health14 age14) if age14>65
twoway (scatter Health14 age14) if age14>65, ylabel(, labsize(small))
twoway (scatter Health14 age14) if age14>65, ylabel(, labsize(small)) title(the relationship between health and age)
twoway (scatter Health14 age14) if age14>65, ylabel(, labsize(small)) title(the relationship between health and age) legend(on)
twoway (scatter Health14 age14) if age14>65, ylabel(, labsize(small)) by(, title(the relationship between health and age)) ///
by(, legend(on)) by(rural14, total)
gr export graph25.png, replace  //pdf, png, etc

twoway (scatter Health14 income14) (lfit Health14 income14)

histogram age14, discrete freq by( ethnic14 , total)

reg age14 ethnic14 rural14
scatter age14 ethnic14 || lfit age14 ethnic14
gr export graph15.png, replace  //pdf, png, etc

scatter Health14 education14 || lfit Health14 education14
*negative realtionship b/w health and years of schooling
gr export graph16.png, replace  //pdf, png, etc

tabstat Health14 , by( ethnic14 ) stat(mean sd min max) nototal long format
tabstat age14 , by( rural14 ) stat(mean sd min max) nototal long format

graph hbar Health14, over(PROV) bargap(50)
*Mean of self-reported health by provinces
gr export graph17.png, replace  //pdf, png, etc

symplot age14 
gr export graph18.png, replace  //pdf, png, etc

symplot income14
gr export graph19.png, replace  //pdf, png, etc

symplot marital14
gr export graph20.png, replace  //pdf, png, etc

graph matrix Health14 age14, by(ethnic14, total)
/* Self-reported health and validated age by provinces*/
gr export graph141.png, replace  //pdf, png, etc

graph matrix Health14 income14, by(rural14, total)
gr export graph142.png, replace  //pdf, png, etc

qnorm age14, grid
gr export graph23.png, replace  //pdf, png, etc

tab ethnic14 , sum (age14)
graph matrix Health14 income14 education14 employment14 sex14 marital14, half maxis(ylabel(none) xlabel(none))
gr export graph24.png, replace  //pdf, png, etc
graph matrix function14 income14 education14 employment14, half maxis(ylabel(none) xlabel(none))
gr export graph25.png, replace  //pdf, png, etc


/// Loops

codebook marital14
codebook rural14
levelsof marital14, loc(marital14)
di "`marital'"
levelsof rural14, loc(m1)
levelsof marital14, loc(r1)
foreach m of local m1 {
       foreach r of local r1 {
              tab income14 if marital14 == `m' & rural14 == `r'
       }
}


foreach var of varlist income12 {
  rename `var' `var'20 
}

levelsof marital14, loc(r2)
foreach m of local r2 {
di `m'
}

foreach var of varlist E1-E5 {
  rename `var' `var'12 
}



//-----------------Violation------------------------------------------------
use merge5, clear
reg Health14 Urban14 
predict Healthhat
graph twoway (scatter Health14 Urban14 ) (line Health14 Urban14, sort)
graph twoway (scatter Health14 Urban14) (lfit Health14 Urban14)
reg Health14 Urban14 ethnic14 income14 education14 employment14 smoking14 marital14 familysize14 sex14
rvfplot, yline(0)
gr export g1.eps, replace

estat hettest
estat imtest
estat szroeter, rhs
//looks like if we regress on urban there is less heteroskedascity.



/*****************/
/*Outreg*/
/*****************/

*export model1


use merge5, clear

reg Health14 rural14 
/* *and then export to excel, note eform option that will exponentiate betas; ct will give it column title A1 */
outreg2 using reg5.xls, onecol bdec(2) st(coef) excel replace ct(A1) lab
/* *then i run some otjer specification */
reg Health14 rural14 ethnic14 
/* *and then export to excel, note eform option that will exponentiate betas; ct will give it column title A1 */
outreg2 using reg5.xls, onecol bdec(2) st(coef) excel replace ct(A2) lab
/* *then i run some otjer specification */
reg Health14 rural14 ethnic14 income14 
/* *and then export to excel, note eform option that will exponentiate betas; ct will give it column title A1 */
outreg2 using reg5.xls, onecol bdec(2) st(coef) excel replace ct(A3) lab
/* *then i run some otjer specification */
reg Health14 rural14 ethnic14 income14 education14 
/* *and outreg2 again but i append instead of replace */
outreg2 using reg5.xls, onecol bdec(2) st(coef) excel append ct(A4) lab  
reg Health14 rural14 ethnic14 income14 education14 employment14 
/* *and outreg2 again but i append instead of replace */
outreg2 using reg5.xls, onecol bdec(2) st(coef) excel append ct(A5) lab 
reg Health14 rural14 ethnic14 income14 education14 employment14 smoking14
/* *and outreg2 again but i append instead of replace */
outreg2 using reg5.xls, onecol bdec(2) st(coef) excel append ct(A6) lab  
reg Health14 rural14 ethnic14 income14 education14 employment14 smoking14 marital14
/* *and outreg2 again but i append instead of replace */
outreg2 using reg5.xls, onecol bdec(2) st(coef) excel append ct(A7) lab
reg Health14 rural14 ethnic14 income14 education14 employment14 smoking14 marital14 familysize14
/* *and outreg2 again but i append instead of replace */
outreg2 using reg5.xls, onecol bdec(2) st(coef) excel append ct(A8) lab
reg Health14 rural14 ethnic14 income14 education14 employment14 smoking14 marital14 familysize14 sex14
/* *and outreg2 again but i append instead of replace */
outreg2 using reg5.xls, onecol bdec(2) st(coef) excel append ct(A9) lab

*export model2
use merge5, clear
reg function14 rural14 
/* *and then export to excel, note eform option that will exponentiate betas; ct will give it column title A1 */
outreg2 using reg6.xls, onecol bdec(2) st(coef) excel replace ct(A1) lab
/* *then i run some otjer specification */
reg function14 rural14 ethnic14 
/* *and then export to excel, note eform option that will exponentiate betas; ct will give it column title A1 */
outreg2 using reg6.xls, onecol bdec(2) st(coef) excel replace ct(A2) lab
reg function14 rural14 ethnic14 income14 
/* *and then export to excel, note eform option that will exponentiate betas; ct will give it column title A1 */
outreg2 using reg6.xls, onecol bdec(2) st(coef) excel replace ct(A3) lab
reg function14 rural14 ethnic14 income14 education14 
/* *and outreg2 again but i append instead of replace */
outreg2 using reg6.xls, onecol bdec(2) st(coef) excel append ct(A4) lab  
reg function14 rural14 ethnic14 income14 education14 employment14 
/* *and outreg2 again but i append instead of replace */
outreg2 using reg6.xls, onecol bdec(2) st(coef) excel append ct(A5) lab 
reg function14 rural14 ethnic14 income14 education14 employment14 smoking14
/* *and outreg2 again but i append instead of replace */
outreg2 using reg6.xls, onecol bdec(2) st(coef) excel append ct(A6) lab  
reg function14 rural14 ethnic14 income14 education14 employment14 smoking14 marital14
/* *and outreg2 again but i append instead of replace */
outreg2 using reg6.xls, onecol bdec(2) st(coef) excel append ct(A7) lab
reg function14 rural14 ethnic14 income14 education14 employment14 smoking14 marital14 familysize14
/* *and outreg2 again but i append instead of replace */
outreg2 using reg6.xls, onecol bdec(2) st(coef) excel append ct(A8) lab
reg function14 rural14 ethnic14 income14 education14 employment14 smoking14 marital14 familysize14 sex14
/* *and outreg2 again but i append instead of replace */
outreg2 using reg6.xls, onecol bdec(2) st(coef) excel append ct(A9) lab


/**************/
/* references */
/**************/
*1. Chinese Longitudinal Healthy Longevity Survey (https://www.icpsr.umich.edu/icpsrweb/NACDA/studies/36692)
*2. Tung, Ho-Jui, and Elizabeth J. Mutran. "Ehnicity and Health Disparities Among the Elderly in Taiwan." Research on Aging27, no. 3 (2005): 327-354.

