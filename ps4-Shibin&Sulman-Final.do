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
3,212 urban elderly which accounting for 44.6% of the sample and 3,980 rural elderly.
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


//////////////////////Project Start////////////////////////

clear
set more off
version 15

//////////////////////////////////////////////////////////


/********************/
/* Manipulating data*/
/********************/

//make the data use easier
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
*E6 to E12 is the variables used to measure elderly's instrumental activities of daily living (IADLs).

* generate one depdendent variabel-functional capacity of the elderly
egen ADL= rowmean (bathing14 dressing14)
egen ADL1= rowmean (ADL toileting14)
egen ADL2= rowmean (ADL1 transfer14)
egen ADL3= rowmean (ADL2 continen14)
sort ADL
*list ADL
egen IADL= rowmean (feeding14 visiting14 shopping14 cooking14 washing14 walking14 carrying14)
sort IADL
*list IADL
egen function14= rowmean (ADL3 IADL)

* recode the rural variable
recode rural14 (3=0) (1 2=1) (-99=.),gen(Rural14) 
la de rurallab 0 "Rural" 1 "Urban"
la val Rural14 rurallab
label list rurallab
* recode the ethnicity variable
recode ethnic14  (1=0) (2 3 4 5 6 7 8=1),gen(major14) 
la de ethniclab 0 "majority" 1 "minority"
la val major14 ethniclab
label list ethniclab
recode marital14 (2 3 4 5=0) (1=1), gen(spouse14)
la de maritallab 0 "single" 1 "spouse"   
la val spouse14 maritallab
save eld1.dta, replace
//may want to save this! you do all this work and then it gets lost: when you do graphs and visuzalizations later, 
//its much better to start with clean labelled data than just run everything from scratch again 

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
rename E12 carrying12
*E6 to E12 is the variables used to measure elderly's instrumental activities of daily living (IADLs).
save eld2.dta, replace

/*****************/
/* Merging data*/
/*****************/

/*merge1*/ 
sort ID
merge 1:1 ID using eld1.dta, force
/*
the reason for the non-merge is because thousands of new observations add into the 
master datasets. 
*/
save merge1.dta,replace
*reshape long rural age, i(ID) j(year)
/* by reshaping the rural variable, we can see the change on the place of the elderly. It is
significant to observe the change of living places of the elderly. We would like to test the hypothesis
that elderly living in the city area will have a better life expectancy or health resources than their
counterpart in the rural area. These are several observations of data we found can support the hypothesis. 
The reshape can help us easier to compare the data, especially a large dataset. */


/********************/
/*descriptive statistics*/
/********************/

/*by: egen*/
use eld1.dta, clear
bys rural14: egen medage=median(age14)
* creat the median age variable, so we can know the median age in different areas.
la var medage "median elderly age"
ta medage rural14

bys marital14: egen maxage14=max (age14)
la var maxage "maximums marital elderly age"
/* creat the maximum marital elderly age. By doing this, we can know the largest age of
elder people in different marital status groups. The result shows that 62 widowed elderly's
age is 108, which count as the maximum age in their group. */
ta maxage14 marital14

bys ethnic14: egen meanage14=mean(age14)
/* we would liek to know the mean of elderly age from different ethnicity groups. So we creat
the meanage14 variable. The result shows that 97 Han majority people live as long as 89 years.
 */
la var meanage "mean elderly age"
tab meanage14 ethnic14

tab rural12
//Shows the break down of the interviewee's geograpic location\\
tab age12
//Gives break down of how many people are there by age. 

tab ethnic12
//Break of ethnicity and it appears that han is where 94% of interviewee are from
sum A52
// summarizing # of people living with you and on average about 3

tab A532
/* tabulating whether the participant have their own bedroom and it appears that
nearly 94% of them actually do. */
tab A533
/*  This tells me the type of dwelling participant lives in and it appears that
detached house is the predominatly the main type  accounting for 2/3. */
tab A530
/*a530 examinzes if the house/apartment of the elder" purchased/self-built/
inherited/rented? And the answer appears to be that most of the houses are
self-built. */

tab A535
/* House damage? It appears that most (72%) people didn't have house damaged.*/

tab A537
/* Which fuels are you using for cooking? It appears that most people are using
firewood-straw. It probaly has an impact on their health.*/

tab A540
/* the primary reason that you live in an institution (elderly center) it 
appears that data is missing for 85% of the people but no child is the
reason that most people are living in elderly care. */

sum A541 
/* It appeats that 8543 is average monthly cost of living in elderly home. This 
is probaly in Chinese curreny. */

tab A542
/*Who pays living cost? Children and spouses but data missing for 84% people */

tab B11 
/* self-reported quality of life it appears that nearly 41% feel that their health 
is good. */

tab B21 
/* intrestingly nearly 59% of the people think bright side of things. */

tab B22
/* Nearly 52% of people keep their belongings "often clean."*/

tab B23 
/* nearly 38% of the people  seldom feel fearful or anxious. */

tab B24 
/* nearly 33% of the elderly seldom feel lonely. */

tab B25  
/* nearly 50% of the elder in combinded percetage make their own decision */

tab ethnic12 D5
/* Gives break down of ethnic group and the kind of water that they are 
drinking? */

tab ethnic12 B11
/* breakdown of self-resported health by ethnic group */

tab ethnic12 RDEMILK
/* It appears that in genreal that most people are without milk. */

tab ethnic12 D4VIT1
/* Certainly higher percetage of Han provinces versus others. */

tab PROV D5
/* It appears that most povinces drink boiled water. */

tab rural12 B11
/* Perhaps the most important tab of all. It gives breakdown of self-reported
health in city, town and rural areas. It appears that more people in terms
of percetage reported to have been very good in terms of health versus town and
rural areas. */
tab rural12 PROV
/* Larger number of people from this sample appear to be from rural areas.*/

tab happiness12
/* Intrestingly there appears to be large population 32% who that they would be 
happier if they were younger. */

tab rural12 happiness12
/*Happiness by region rural, town, and city. */ 

graph bar (sum) happiness12, over(rural12) by(happiness12)
/* Graph by region and whether they happier if were younger.*/

tab rural12 F652B
/* It does appear that cast majority of people in genreal don't have physical
examination once a years in genreal. */

sum F9
*About 4 siblings with std deviation of 7

tab F111A
/* Whom you ususally speak? Turns out spouse and son are the highest while 
neighbor is 3rd. But there are 479 people who speak with no one. */

tab B11 F111A
/* Surprisingly there are small amount of people who are talking with no one
but still reported quality of life to be very good. */
tab F112A
/*1st person to whom you talk first when you need to share your thoughts? 1) Son
then spouse...somewhat surprising*/

tab rural12 F142
/*It appears higher percetage of 30%rural people have access to home visit 
services */
graph pie [pweight = rural12], over(rural12) sort(rural12)
*Breakdown of population in pie chart. 

tab G14C1 rural12
*breakdown of diseases by region

tab rural12 H3
*interviewer rated the participants health...inclusive table

tab B28_14 rural12
/*categories of residenze in city, town and rural  and feelings in terms of sad, 
depressed and blue */

histogram D31_14, title(Number of Time able to Eat Fruit)
* Ability to eat fruit

tab D31_14
*more detailed with fruits

tab D4MEAT2_14 rural12
* meant breakdown by region
graph pie [pweight = rural12], over(E9) title(Do you cook at home?)
*Vast majority of people cook at home

sum age14
*average age 85

tab  sex14
*about 500 more females in the dataset than male

tab D4A B11
/*Green tea the most specified tea and those who drink reported better quality of
life. */

tab marital14
*58% of people widowed and 39% currently married and not surprising  less 1 never married
tab D14G4A
*right handed people accounted for 53% and left handed less than 1%

tab D11FINANC
*children primary finncial support accounting for 79% of people followed by retirement accounting 13%. 

/*****************/
/* Regression */
/*****************/

pwcorr health14 age14 education14 income14 employment14, star(.05)
corr health14 age14 education14 income14 employment14

local control smoking14 marital14 familysize14 sex14
display "`control'"
reg health14 happiness14
reg health14 income14 
reg health14 income14 education14 employment14
reg health14 income14 education14 employment14 age14
reg health14 income14 education14 employment14 age14 "`control'"

reg health14 happiness14 `control'  // Problem?
reg happiness14 ethnic14 rural14 
reg happiness14 ethnic14 rural14 income14 education14 employment14 age14

xi: regress health14 income14 education14 employment14 smoking14 marital14 familysize14 sex14 i.ethnic14, robust
eststo model2
esttab, r2 ar2 se scalar(rmse)
predict health14_predict
scatter health14 health14_predict
xi: regress health14 income14 education14 employment14 smoking14 marital14 familysize14 sex14 i.ethnic14, robust
ovtest

reg health14 i. ethnic14
gen ethage = age14 * ethnic14
regress health14 age14 ethnic14 ethage
regplot, by(ethnic14)
regplot, sep(ethnic14)

gen ethage1 = age14 * major14
regress health14 age14 major14 ethage1
regplot, by(major14)
regplot, sep(major14)

gen ethe = education14 * major14
regress health14 education14 major14 ethe
regplot, by(major14)
regplot, sep(major14)

// Robust Check
reg health14 income14 , robust
scatter health14 income14 ,ml(ethnic14)

/*****************/
/* Visualizing data*/
/*****************/

tab ethnic14
* Start to visualize the data 
*Basic descriptive statistic 
sum age14
hist age14, frequency normal
histogram health14, discrete freq addlabels xlabel(0 1(1)9,valuelabel)
histogram ethnic14, discrete freq addlabels xlabel(0 1,valuelabel)
histogram rural14, discrete freq addlabels xlabel(0 1, valuelabel)
histogram income14, discrete freq addlabels xlabel(0 1, valuelabel)
histogram happiness14, discrete freq addlabels 
histogram education14, discrete freq addlabels 
histogram employment14, discrete freq addlabels 

*Group Statistic 
tab rural14, sum (age14)
tab ethnic14, sum (age14)
histogram age14, frequency by(rural14)
hist health14, frequency by(rural14)
tab rural14, sum (health14)
tab health14, sum (rural14)
histogram health14 , normal
hist age14,normal
twoway histogram health14 , discrete freq by(rural14)
twoway histogram health14 , discrete freq by(ethnic14)
twoway histogram age14 , discrete freq by(rural14)
twoway histogram age14 , discrete freq by(ethnic14)
tw(scatter health14 age14)(lfit health14 age14)
histogram age14, discrete freq by( ethnic14 , total)

reg age14 ethnic14 rural14
scatter age14 ethnic14 || lfit age14 ethnic14
scatter health14 education14 || lfit health14 education14
tabstat health14 , by( ethnic14 ) stat(mean sd min max) nototal long format
tabstat age14 , by( rural14 ) stat(mean sd min max) nototal long format
graph bar health14, over(PROV) bargap(50)
symplot age14 
symplot income14
graph matrix health14 age14, by(ethnic14, total)
qnorm age14, grid
tab A2 , sum (TRUEAGE)
graph matrix health14 income14 education14 employment14, half maxis(ylabel(none) xlabel(none))


/*****************/
/*Outreg*/
/*****************/

net install outreg2, from(http://fmwww.bc.edu/RePEc/bocode/o) 

use merge1, clear

 *run some regression
reg health14 income14 
/* *and then export to excel, note eform option that will exponentiate betas; ct will give it column title A1 */
outreg2 using reg1.xls, onecol bdec(2) st(coef) excel replace ct(A1) lab
/* *then i run some otjer specification */
reg health14 income14 education14 
/* *and outreg2 again but i append instead of replace */
outreg2 using reg1.xls, onecol bdec(2) st(coef) excel append ct(A2) lab  
reg health14 income14 education14 employment14 
/* *and outreg2 again but i append instead of replace */
outreg2 using reg1.xls, onecol bdec(2) st(coef) excel append ct(A3) lab 
reg health14 income14 education14 employment14 smoking14
/* *and outreg2 again but i append instead of replace */
outreg2 using reg1.xls, onecol bdec(2) st(coef) excel append ct(A4) lab  
reg health14 income14 education14 employment14 smoking14 marital14
/* *and outreg2 again but i append instead of replace */
outreg2 using reg1.xls, onecol bdec(2) st(coef) excel append ct(A5) lab
reg health14 income14 education14 employment14 smoking14 marital14 familysize14
/* *and outreg2 again but i append instead of replace */
outreg2 using reg1.xls, onecol bdec(2) st(coef) excel append ct(A6) lab
reg health14 income14 education14 employment14 smoking14 marital14 familysize14 sex14
/* *and outreg2 again but i append instead of replace */
outreg2 using reg1.xls, onecol bdec(2) st(coef) excel append ct(A7) lab

/**************/
/* references */
/**************/
1. Chinese Longitudinal Healthy Longevity Survey 
(https://www.icpsr.umich.edu/icpsrweb/NACDA/studies/36692)

