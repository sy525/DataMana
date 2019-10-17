
* Data Management Project- Probelm Set 3
*Shibin Yan, Fall 2019
*Revised: spring 2019 Oct.17
*----------------------------

//---------------------------data mgmt----------------------------------------------
//---------------------------data mgmt----------------------------------------------
//---------------------------data mgmt----------------------------------------------

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
find out how geographic and ethnicity of residents impact on health quality of old 
people in China. In other words, this study will assess the impact of geographic 
and ethnicity disparity on the health outcome of the Chinese elderly.
*/

*----------------------------

* the second data set--the using dataset which are used to merge.
use "https://docs.google.com/uc?id=1_exDjt1Rbc1B18wX0oMgyRZeWpm04uKH&export=download",clear
rename TRUEAGE age12
rename RESIDENC rural12
rename A1 sex12
rename A2 ethnic12
rename B27 happiness12
rename F41 marital12
rename A41 born12
rename F35 income
rename  A53A4_14 education
keep ID age12 rural12 sex12 ethnic12 happiness12 marital12 born12 PROV income education
save eld2.dta, replace


//make the data use easier
use "https://docs.google.com/uc?id=1Sb_fGGdRiVSxFpcfHbp7RaV2QauGxi_q&export=download",clear
* some variable name get people confused. It would be better to rename these variables.
rename TRUEAGE age14
rename RESIDENC rural14
rename A1 sex14
rename A2 ethnic14
rename B27 happiness14
rename F41 marital14
rename A41 born14
keep ID age14 rural14 sex14 ethnic14 happiness14 marital14 born14 V_BTHYR V_BTHMON TYPE PROV
save eld1.dta,replace
/* the key variables for this study is age, resident location, ethinicty, marital status, 
places that people was born, happiness. So I can keep these key variables in the dataset
if I want to make the process of data analysis simpler. */


/*repalce*/
tab happiness14,nola
tab happiness14,mi
drop if happiness14==.
codebook happiness14
generate happy=.            /*gen empty var*/
replace happy=1 if happiness14>0 & happiness14 <4
replace happy=0 if happiness14>4  
/* I would like to know whehter the elderly in the sample happy or not. So I use 
the replace code to make the happy variable to be a dummy variable. 
*/
tab happy                            

/*recode*/
* recode the rural categorical variables.
recode rural14 (1=0) (2=1) (3=.)
label define rural 0 Urban 1 Rural
label list rural
codebook rural14
* recode the marital14 categorical variables.
recode marital14 (3 4 5=0) (1=1), gen(spouse14)
* recode the marital variables. Make the elderly living with spouse code as 1 and the one living alone 0. 
tab spouse14


/*collapse*/
use eld1.dta, clear
collapse (mean) age14, by(rural14)  
/*Create dataset containing the mean of elderly age in each location. So we can know
the life expectancy of the elderly in different geographic locations. No doubt, the data
tells us that the mean of age in city is biggest, compared to town and rural area. As some 
literatures showed, elderly living in city and town area has a longer life expetancy than their
counterpart in rural area. The data support the argument.*/
list  /*list the result*/


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



/*merge1*/
sort ID
merge 1:1 ID using eld2.dta
* the result shows that 53 data are successful merged.
save merge1.dta,replace
/*reshpe1*/
reshape long rural age, i(ID) j(year)
/* by reshaping the rural variable, we can see the change on the place of the elderly. It is
significant to observe the change of living places of the elderly. We would like to test the hypothesis
that elderly living in the city area will have a better life expectancy or health resources than their
counterpart in the rural area. These are several observations of data we found can support the hypothesis. The reshape
can help us easier to compare the data, especially a large dataset. */


/*merge2*/
use eld2.dta,clear
drop  age12 rural12 sex12 ethnic12 happiness12 marital12 born12 
merge 1:1 ID using eld1.dta, nogen
save merge2.dta,replace

/*merge3*/
use "https://docs.google.com/uc?id=1r0brtgXRy0r39L6p1TOUimh8ULZGJIb2&export=download",clear
recode PBIRTH (5=0) (1 2 3 4=1) (-99=.)
label define rural 0 Urban 1 Rural
label list rural
merge 1:1 ID using merge2.dta, nogen
save merge3.dta,replace


/*merge4*/
use "https://docs.google.com/uc?id=1T87WO8AvWbsfkekR3H0NIeQRhmzHN3aG&export=download",clear
rename S104 marital
save data1,replace
use merge1.dta, clear
*reshape long marital, i(ID) j(year)
merge 1:1 ID using merge1.dta, nogen
save merge4.dta,replace

/*merge5*/
use "https://docs.google.com/uc?id=1Sb_fGGdRiVSxFpcfHbp7RaV2QauGxi_q&export=download",clear
decode PROV, gen(PROV1)
replace PROV1 = proper(PROV1)
save merge5,replace
import excel "https://docs.google.com/uc?id=1X9vOTsmzC43fwj-IoRzHVFy6FWkKx-WA&export=download", sheet("Sheet1") firstrow clear
keep in 1/31
save prov1,replace
use merge5
merge m:1 PROV1 using prov1, nogen 



 




/*
/*regression*/
sum age14
/*
age is a key variable in this study. For age, there are 7,192 observations in the dataset. The mean of age is 85.32 and
the standard deviation is 10.77. We can know the age variables from these numbers!
*/

hist age14
* use graph to know the key variable--age visually. Age is right skewed.

tab rural14, sum (age14)
/* 
In this table, it is obvious that more elderly people tend to live in rural area and
town area. There are 3980 elderly living in the rural area. 
*/

* find the correlation between ethnicity and age. 
reg age14 ethnic14 sex14
/*
I try to find the correlation among ethnicity, gender and elderly's age, in order to
know how ethnicity and gender impact on elderly's age. On the ethnicity variable, 
the 95% confidence interval is [-0.3217541,0.0638592]. One unite increase in ethnicity level 
leads to a increase of -.013 point in age, controlling for gender of elderly. It is not significant.
Also, one unite increase in the gender of the elderly leads to a increase of 4.50 point in 
age, controlling for the ethnicity of the elderly. It is statistically significant!
*/


