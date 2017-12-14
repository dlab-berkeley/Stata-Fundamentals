******************************* 
*	Stata Intensive: Workshop 2
*	Fall 2017, D-LAB
*	Jackie Ferguson
*	12.13.20.17
********************************

**************************************************
* Day 2

* Outline:
* I. 	CORRELATION AND T-TESTS
* II. 	PLOTTING
* III. 	REGRESSION AND ITS OUTPUT
* IV. 	POST-ESTIMATION
* V. 	PLOTTING REGRESSION RESULTS

**************************************************



/* Step 1: File > Change Working Directory > Navigate to the folder where you 
   have saved the data file nlsw88.dta */
   
/* Step 2: Copy-paste the last command that shows up on result screen.
   My result window shows this:*/   

cd "C:\Users\Jackie\Dropbox\9. D-Lab\Workshop Modules\Stata Fundamentals II"
   
/***
		We paste this command above so that next time we can just run this 
		do-file from the top and it will run smoothly. We will not need to
		use the file menu or copy-paste again. We should be able to run 
		everything from the do-file.
***/


*I.  Open the data file */

use nlsw88.dta , clear // open data file 

/* You can also write: */

use nlsw88 , clear

*You can also use your nlsw88_clean.dta file from workshop I if you would like!

********************************************************************************
********************************************************************************
***From last Workshop!
********************************************************************************
********************************************************************************


* EXPORTING AND IMPORTING DATA *


* Export data for use with other programs
help export excel

*Export out of Stata in several different formats
*Can also use the drop down menu to populate this code
export delimited using "nlsw88.csv", replace datafmt
export excel using "nlsw88.xlsx", firstrow(variables) replace   


* Import data from excel sheet into stata as nlsw88_clean.xlsx

// Let's first clear the current data in memory
clear all

// import the data file you just exported to excel as nlsw88_clean.xlsx
import excel using "nlsw88.xlsx", first clear


// "first" specifies that the first row in the excel file is a variable name
*What would happen if we didn't select this option?
	*Our variable labels are imported as the first row of data!
	
**Do you notice anything different from our datafile to our xlsx file?
*Was any data lost?
*Does our data look any different?
des

*Compare it to the original data before we exported it to excel
clear all
use "nlsw88.dta", clear

***Yes, we lost our labels! 

*Set more off for this workshop-
*You can set it off permanently by adding ", perm" to the end
set more off




**************************************************
* I. 	CORRELATION AND T-TESTS
**********************************************

*CORRELATION AND T-TESTS

//How do we use the correlation command in Stata?
//First, let's access the help file for `correlate'
help correlate

//Let's try checking the correlation between age and wage
corr age wage 

//What if we want to look at age wage and tenure
//COMMAND:
corr age wage tenure

*T-TESTS

help ttest

/*This t-test is designed to compare means of same variable between two groups.  
In our example, we compare the mean wage between the group of union members 
and the group of non-union members. 
Ideally, these subjects are randomly selected from a larger population of subjects. 
The test assumes that variances for the two populations are the same. 

 If the p-value associated with the t-test is small (0.05 is often used as the threshold), 
 there is evidence that the mean is different from the hypothesized value. 
 If the p-value associated with the t-test is not small (p > 0.05), 
 then the null hypothesis is not rejected and you can conclude that the mean is
 not different from the hypothesized value. 
 
 See this website for more helpful tips on T-tests!
 https://stats.idre.ucla.edu/stata/output/t-test/
 
 */

//Now, let's test whether wages are different by union membership
ttest wage, by(union)
**What is this analysis telling us??
*We conclude that the difference of means in wages between union and non-union members is different from 0.

//What if we want to look at whether wages vary by if the person lives in the south?
//Hint: use the south variable
//COMMAND:
ttest wage, by(south)
*How would you interpret this?
*We conclude that the difference of means in wages between those who live in the
*south and those who do not live in the south is different from 0.




**************************************************
* II. 	PLOTTING
**********************************************
*HISTOGRAM

help histogram //let's take a look at the histogram command

histogram age
histogram age, freq

histogram wage
histogram wage, freq

histogram age, discrete 
histogram wage, discrete


//Let's create a histogram with five bins
//COMMAND:
histogram wage, bin(5)

//What about a histogram with bins of width 2?
//COMMAND:
histogram wage, width(2)


**All of our histogram options can stack together
histogram wage
histogram wage, freq

*Add a title 
//COMMAND:
histogram wage, freq title("Histogram by Wage in National Labor Survery in 1988" "Created 12.12.2017")

*Add a title and labels
//COMMAND:
histogram wage, freq ///
title("Histogram by Wage in National Labor Survery in 1988" ///
"Created 12.12.2017") ///
addlabels


*Create a difference X-axis Title
//COMMAND:
histogram wage, freq ///
title("Histogram by Wage in National Labor Survery in 1988" ///
"Created 12.12.2017") ///
addlabels xtitle("Hourly Wage" "In Dollars")

help scheme

**Add scheme

histogram wage, freq ///
title("Histogram by Wage in National Labor Survery in 1988" ///
"Created 12.12.2017") ///
 xtitle("Hourly Wage" "In Dollars") scheme(economist)

 
 histogram wage, freq ///
title("Histogram by Wage in National Labor Survery in 1988" ///
"Created 12.12.2017") ///
 xtitle("Hourly Wage" "In Dollars") scheme(sj)
 
 histogram wage, freq ///
title("Histogram by Wage in National Labor Survery in 1988" ///
"Created 12.12.2017") ///
 xtitle("Hourly Wage" "In Dollars") scheme(s2mono)
 
 
*************
**Additional options for a Histogram
*************

*We can restrict our population by a conditional statement
histogram wage if married==1, freq width(.25) ///
title("Wage Histogram only amongst those who are married") ///
 xtitle("Hourly Wage" "In Dollars") scheme(s2mono)
	
	
*We can also create a histogram by a categorical variable
histogram wage, by(married) ///
 title("Wage Histogram by Marital Status") ///
 freq width(.25) ///
 xtitle("Hourly Wage" "In Dollars") scheme(s2mono)
 *This code above gives us a repetitive title! ick. 
 
*heres how we fix it, move the title after married.
histogram wage, by(married, title("Wage Histogram by Marital Status")) ///
 freq width(.25) ///
 xtitle("Hourly Wage" "In Dollars") scheme(s2mono)

//How would we change this command if we wanted to look at the histograms by industry?
//COMMAND:
histogram wage, by(industry, title("Wage Histogram by Industry")) ///
 freq width(.25) ///
 xtitle("Hourly Wage" "In Dollars") scheme(s2mono)

*************
*SCATTERPLOT
*************

help scatter //now scatterplots

scatter wage age
corr wage age

scatter wage tenure 
scatter wage age, title("Hourly  vs. Age") legend(on)
scatter wage age, title("Hourly  vs. Age") mcolor(mint)

//Let's try using a scheme. 
help scheme

//Make the same scatterplot as above, with a monocolor scheme.
//COMMAND:
scatter wage age, title("Hourly  vs. Age") ///
 mcolor(mint) scheme(s1mono)


//There are other formatting changes we can also make
scatter wage age, title("Hourly  vs. Age") legend(on) ///
	mcolor(blue) xlabel(34(1)46, format(%2.0f)) ///
	ylabel(,format(%2.1f))

*COMBINE GRAPHS
//We want to make a scatterplot, and add a linear prediction-based line of best fit 	
twoway (scatter wage age, title("Hourly  vs. Age") legend(on) ///
	mcolor(blue) xlabel(34(1)46, format(%2.0f)) ylabel(,format(%2.1f))) ///
	(lfit wage age)	

//Alternatively, we can use || instead of () to define plots
scatter wage age, title("Hourly  vs. Age") legend(on) ///
	mcolor(blue) xlabel(34(1)46, format(%2.0f)) //
	ylabel(,format(%2.1f)) || ///
	(lfit wage age)


//Let's save the graph
scatter wage age, title("Hourly  vs. Age") legend(on) scheme(s1color) ///
	mcolor(blue) xlabel(34(1)46, format(%2.0f)) ylabel(,format(%2.1f)) || ///
	(lfit wage age) 
	
	
graph save "wageage.gph", replace // save in Stata format (can be re-opened in Stata)
graph export "wageage.png", replace //save in .png format for use

*Remember- you can code all these graphs on one line without the /// 
*I have them broken up into multiple lines for easy display in class 
*Do what is best for you!

*************
**Additional options for a Scatter Plot
*************
scatter wage grade, jitter(1)

*Scatter plot by wage and age- separate graph for each
scatter wage grade, by(race)

*Same as previous but includes a graph for total cohort
scatter wage grade, by(race, total)

***This is the same syntax as the histogram above!



******************
*More Advanced Plotting Options
******************

**What if we want to put two graphs on the same plot?

**Two histograms in one
twoway (histogram wage if union==1) ///
		(histogram wage if union==0)
		*Hard to differentiate the bars
		
*Lets add some color differences and add a legend
twoway (histogram wage if union==1, color(blue)) ///
	(histogram wage if union==0, legend(order (1 "Union" 2 "Non-Union")))
	
*Lets change the opacity of the bars 
twoway (histogram wage if union==1,  color(blue) lcolor(black)) ///
	(histogram wage if union==0,  fcolor(none) lcolor(black) /// 
	legend(order (1 "Union" 2 "Non-Union")))
	
*Change the y axis to percentage
twoway (histogram wage if union==1, percent color(blue) lcolor(black)) ///
	(histogram wage if union==0, percent fcolor(none) lcolor(black) /// 
	legend(order (1 "Union" 2 "Non-Union")))

*Add a title
twoway (histogram wage if union==1, percent color(blue) lcolor(black)) ///
	(histogram wage if union==0, title("Wage by Union Status") percent fcolor(none) lcolor(black) /// 
	legend(order (1 "Union" 2 "Non-Union")))
	
	

**************************************************
* III. 	REGRESSION AND ITS OUTPUT
**********************************************

/* See this helpful website for interpreting regressions! 
https://stats.idre.ucla.edu/stata/output/regression-analysis-2/
*/

*LINEAR REGRESSION

help regress //Let's look at the doccumentation for the regress commend

*Lets regress wage and age
reg wage age

*check for missings!
misstable summarize

*How about wage, age, union, and married?
//COMMAND:
regress wage age union married


*Why can't we use married_txt?
reg wage age union married_txt
	*Because it is a string variable- analysis programs cannot handle strings in regressions

*So far all of our variables have been continous or binary
*What happens when we do a categorical variable?

*What does this output mean?
reg wage age union married industry // Not right

*This treats each industry number as its own category instead of assuming a linear
*relationship between each of them
**How do we fix this?
//COMMAND:
reg wage age union married i.industry 

*If we want to change baseline category
reg wage age union married ib6.industry 

//What if we only want to run this regression for certain industries?
//COMMAND:
reg wage age union married if industry==6

*Note number of observations in these regressions
*Do all of them match?
	*No!
*Why not?
	*Because some of the variables have missing data
	*And the regression is running a complete case analysis-
	*Which means it is dropping a person if they are missing ANY information 




******************
*Interaction Terms
******************


// Let's add an interaction term for being married and education

*Basic regression
reg wage age union married collgrad

gen marriedXcollgrad= married*collgrad


//Run the same basic specification as before, with the robust indicator
//Include the interaction term and other relevant variables
reg wage age married collgrad union marriedXcollgrad

reg wage age union married#collgrad




*LOGIT REGRESSIONS
//Logits are used for binary dependent variables
//For a logit regression, we interpret the coefficients as the log odds

/* See this helpful website for interpretting the results of a logsitic regression
https://stats.idre.ucla.edu/stata/output/logistic-regression-analysis/
*/

*Lets predict union status
logit union wage age married

//The coefficient on wage tells us that, holding age and married at a fixed value,
//a one-unit increase in wage leads to a certain increase in the log odds of being a union worker


//The coefficient on wage tells us that, holding age and married at a fixed value,
//a one-unit increase in wage leads to a certain increase in the log odds of being a union worker

*What the heck are log odds?
disp exp(.076859 )

//or use the or option
logit union wage age married, or

*Or use the logistic command
logistic union wage age married


//specifically, we see approximately a 7% increase in the odds of being a union worker


*What is the difference
help logistic
help logit



******************************************
* IV. 	POST-ESTIMATION
******************************************
//We can do more than just display coefficients following regression
//Examples from linear regression

help regress postestimation // here is the relevant help file

*TESTING FOR HETEROSKEDASTICITY
reg wage union age married 
estat hettest


*WALD TESTS
reg wage union age married 
test union = married

//What are we testing? What do we conclude?
*The Wald test for a logistic regression is used to determine whether a certain
*predictor variable X is significant or not. 
*It rejects the null hypothesis of the corresponding coefficient being zero

*In this wald test above, we reject the null hypothesis that the difference between 
*married and union is the same. Being married vs being in the union have different 
*effects on your wage. 

******************************************
* V.	PLOTTING REGRESSION RESULTS
******************************************

// Sometimes, we may want to display results in figures rather than tables

//you will need to run the below to install this very useful user-written command
ssc install coefplot

reg wage union age married i.industry
coefplot, horizontal
coefplot, drop(_cons) horizontal

reg wage union age married i.industry
coefplot, drop(_cons) vertical  



**How would you alter this coefplot for a logistic regression?
//COMMAND:
logit union wage age married i.industry
coefplot, drop(_cons)   

*Does the Scale need to be changed at all?

*That looks too crowded. Lets change the angle of the labels
coefplot, drop(_cons) vertical xlabel(,angle(45))


//What if you want to use 99 percent confidence intervals instead of 95?
//Use the help file for coefplot to figure out how to plot the above figure that way
//COMMAND: 
coefplot, drop(_cons) vertical xlabel(,angle(45)) levels(99)




