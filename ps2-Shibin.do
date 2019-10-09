* Data Management Project- Probelm Set 2
*Shibin Yan, Fall 2019
*Revised: spring 2019 Oct.10
*----------------------------

//---------------------------data mgmt----------------------------------------------
//---------------------------data mgmt----------------------------------------------
//---------------------------data mgmt----------------------------------------------

/* Data Description 
The data are from Chinese Longitudinal Healthy Longevity Survey (CLHLS).It provides information 
on health status and quality of life of the elderly aged 65 and older in 22 provinces of China 
in the period 1998 to 2014. Moreover, the study was conducted to shed light on the determinants 
of healthy human longevity and oldest-old mortality. To this end, data were collected on a large percent of
the oldest population, including centenarian and nonagenarian; the CLHLS provides information on the health,
socioeconomic characteristics, family, lifestyle, and demographic profile of this aged population.  
*/

/* Research Goal
This research is on health disparity for Chinese elderly. This research would like to find out how geographic and ethinicity
of residents impact on health quality of old people in China.  
*/

*----------------------------

* the second data set.
use "https://docs.google.com/uc?id=1_exDjt1Rbc1B18wX0oMgyRZeWpm04uKH&export=download",clear
keep in 1/100
rename TRUEAGE age12
rename RESIDENC rural12
rename A1 sex12
rename A2 ethnic12
rename B27 happiness12
rename F41 marital12
rename A41 born12
keep ID age12 rural12 sex12 ethnic12 happiness12 marital12 born12
save eld2.dta, replace


//make the data use easier
use "https://docs.google.com/uc?id=1Sb_fGGdRiVSxFpcfHbp7RaV2QauGxi_q&export=download",clear
keep in 1/100
save eld1.dta,replace


// manipulate the data 
use eld1,clear
* some variable name get people confused. It would be better to rename these variables.
rename TRUEAGE age14
rename RESIDENC rural14
rename A1 sex14
rename A2 ethnic14
rename B27 happiness14
rename F41 marital14
rename A41 born14
keep ID age14 rural14 sex14 ethnic14 happiness14 marital14 born14
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
collapse (mean) age14, by(rural14)  
/*Create dataset containing the mean of elderly age in each location. So we can know
the life expectancy of the elderly in different geographic locations. No doubt, the data
tells us that the mean of age in city is biggest, compared to town and rural area*/
list  /*list the result*/


/*by: egen*/
bys rural14: egen medage=median(age14)
la var medage "median elderly age"
ta medage rural14

bys marital14: egen maxage14=max (age14)
la var maxage "maximums marital elderly age"
ta maxage14 marital14



/*merge*/
sort ID
merge 1:1 ID using eld2.dta



/*

bys rural12: egen maMeIn=mean(inc)
la var maMeIn "marital mean income"

bys marital: egen maMeEd=mean(edu)
la var maMeEd "marital mean educatoin"
//bys marital: l maMe* 
ta maMeIn marital
ta maMeEd marital




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



