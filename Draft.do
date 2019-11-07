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
and ethnic disparity on the health outcome of the Chinese elderly.
*/

/* Research Question
1. Does the majority elderly have a better health status than their minority counterpart, as the literature suggest? 
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
the study measure SES included occupation, income, and education.  Using this model, the socioeconomic 
status of the ethnic group of elderly from urban/ rural areas are the independent variables. 
Dependent Variables: self-rated health status,functional capacity.
Control Variables:gender, marital status, family size.
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
 
/* the key variables for this study is age, residence location, ethinicty, marital status, 
health status.  */
* recode the rural variable
recode rural14 (3=0) (1 2=1) (-99=.)
la de rurallab 0 "Rural" 1 "Urban"
la val rural14 rurallab
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

* the second data set--the using dataset which are used to merge.
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
local depen age12 rural12 sex12 ethnic12 happiness12 marital12 born12 PROV income12 education12
display "`depen'"
save eld2.dta, replace

/*****************/
/* Merging data*/
/*****************/

/*merge1*/ 
sort ID
 merge 1:1 ID using eld1.dta, force
* the result shows that 53 data are successful merged.
save merge1.dta,replace


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
/*children primary finncial support accounting for 79% of people followed by retirement
accounting 13%. /*





