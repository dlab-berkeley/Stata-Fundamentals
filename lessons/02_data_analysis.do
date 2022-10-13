********************************
*	STATA FUNDAMENTALS: PART 2
*	AY 2021-2022, D-LAB
********************************


**************************************************
* Day 2

* Outline:
* I. 	PLOTTING
* II. 	CORRELATION AND T-TESTS
* III. 	REGRESSION AND ITS OUTPUT
* IV. 	POST-ESTIMATION
* V. 	PLOTTING REGRESSION RESULTS

**************************************************



/* Step 1: File > Change Working Directory > Navigate to the folder where you 
   have saved the data file nlsw88.dta */
   
/* Step 2: Copy-paste the last command that shows up on result screen.
   My result window shows this:*/   

cd "/Users/reneestarowicz/Downloads/stata-fundamentals-master 3 _2021 Updates/Stata Fundamentals II"

   
/***
		We paste this command above so that next time we can just run this 
		do-file from the top and it will run smoothly. We will not need to
		use the file menu or copy-paste again. We should be able to run 
		everything from the do-file.
***/

// POLL 1 //

**********************************************
* 0. 	WORKSHOP I WRAP-UP
**********************************************


**************************************************
* I. 	PLOTTING
**************************************************

//Let's use the unchanged data again

use nlsw88.dta , clear 

/* Note: We are going to focus on the commands and defining 
specific elements using syntax available in the 'help'
file but you can generate plots and define characteristics 
using the drop down menus as well */



*** HISTOGRAM ***

help histogram //let's take a look at the histogram command

// POLL 2 //

histogram age
histogram age, freq

histogram wage
histogram wage, freq

histogram age, discrete 
histogram wage, discrete


//Let's create a histogram with five bins
histogram age, bin(5)


//What about a histogram with bins of width 2?
//COMMAND:
histogram age, width(2)

// Add the following title: "Histogram by Wage in National Labor Survery in 1988"
histogram wage, title("Histogram by Wage in National Labor Survery in 1988")

// We can also change axis titles
histogram wage, title("Histogram by Wage in National Labor Survery in 1988") ///
	xtitle("Hourly Wage in 1988 Dollars")


**All of our histogram options can stack together
histogram wage, freq width(2) ///
	title("Histogram by Wage in National Labor Survery in 1988") ///
	xtitle("Hourly Wage in 1988 Dollars")


** CHALLENGE **
* 1. Plot a histogram of weekly hours worked in which each bar represents 5 hours.
* Label the x-axis "Weekly Hours"
	// variable: hours


*** Additional options for a Histogram


*We can restrict our sample with a conditional statement
histogram wage if married==1
	
*We can also create a histogram by a categorical variable
histogram wage, by(married) 


* name graphs to save in Stata session memory
histogram wage, by(married) name(hist_wageXmarried)


// POLL 3 //

** CHALLENGE **
* 2. Create a graph with one historgram of wage for each industry.
	// variables: wage, industry
	
* Bonus: Include a (single) title for the whole graph
	// hint: this is an option WITHIN an option

	
	


*** SCATTERPLOT ***


help scatter //now scatterplots

scatter wage age
 
scatter wage tenure 

scatter wage age, title("Hourly  vs. Age") legend(on)
scatter wage age, title("Hourly  vs. Age") mcolor(blue)

//Let's try using a scheme. 
help scheme

//Make the same scatterplot as above, with a monocolor scheme.
scatter wage age, title("Hourly  vs. Age") scheme(s1mono)

scatter wage age, title("Hourly  vs. Age") scheme(s1mono) mcolor(blue)




//There are other formatting changes we can also make
scatter wage age, title("Hourly  vs. Age") legend(on) ///
	mcolor(blue) xlabel(34(1)46, format(%2.0f)) ylabel(,format(%2.1f))


	
*** COMBINE GRAPHS
help twoway

//We want to make a scatterplot, and add a linear prediction-based line of best fit 	
twoway (scatter wage age, mcolor(blue)) ///
	(lfit wage age), title("Hourly  vs. Age") xlabel(34(1)46, format(%2.0f)) ///
	ylabel(,format(%2.1f)) legend(on)

//Alternatively, we can use || instead of () to define plots
scatter wage age,  mcolor(blue) || ///
	lfit wage age || , title("Hourly  vs. Age") xlabel(34(1)46, format(%2.0f)) ///
	ylabel(,format(%2.1f)) legend(on)


//Let's save (open) graph
twoway (scatter wage age,  mcolor(blue)) ///
	(lfit wage age) , title("Hourly  vs. Age") scheme(s1color) ///
	xlabel(34(1)46, format(%2.0f)) ylabel(,format(%2.1f)) ///
	legend(on label(1 "Hourly Wage") label(2 "Regression Line"))

graph save "wageage.gph", replace // save open graph in Stata format (can be re-opened in Stata)
graph export "wageage.png", replace //save open graph in .png format for use

// we can also save named graphs without having to (totally) re-run the code
graph save hist_wageXmarried "hist_wageXmarried.gph", replace

graph display hist_wageXmarried
graph export "hist_wageXmarried.png", name(hist_wageXmarried) replace


*Remember- you can code all these graphs on one line without the /// 
*I have them broken up into multiple lines for easy display in class 
*Do what is best for you!



** Additional options for a Scatter Plot



*Scatter plot by wage and age- separate graph for each
scatter wage age, by(race)

*Same as previous but includes a graph for total cohort
scatter wage age, by(race, total)

***This is the same syntax as the histogram above!




*** More Advanced Plotting Options ***

*What if we want to put two histograms on the same plot?

**Two histograms in one
twoway (histogram wage if union==1) ///
		(histogram wage if union==0)
		*Hard to differentiate the bars
		
*Lets add some color differences and add a legend
twoway (histogram wage if union==1, color(blue)) ///
	(histogram wage if union==0) , legend(order (1 "Union" 2 "Non-Union"))
	
*Lets change the opacity of the bars 
twoway (histogram wage if union==1, fcolor(blue%50) lcolor(black)) ///
	(histogram wage if union==0, fcolor(red%50) lcolor(black)), /// 
	legend(order (1 "Union" 2 "Non-Union"))
	
*Change the y axis to percentage
twoway (histogram wage if union==1, percent fcolor(blue%50) lcolor(black)) ///
	(histogram wage if union==0, percent fcolor(red%50) lcolor(black)), /// 
	legend(order (1 "Union" 2 "Non-Union"))

*Line up bars and add a title
twoway (histogram wage if union==1, percent fcolor(blue%50) lcolor(black) start(1) width(2)) ///
	(histogram wage if union==0, percent fcolor(red%50) lcolor(black) start(1) width(2)), /// 
	legend(order (1 "Union" 2 "Non-Union")) title("Wage by Union Status")
	

** CHALLENGE **
* 3. Create a graph with a scatter plot of wage (y-axis) and total work experience (x-axis)
* for (1) white women and (2) black women on the same set of axes.
* Include a legend that labels the plot for each race
	// variables: wage, ttl_exp, race (1=white, 2=black)

* BONUS: change the marker colors from the default to 2 different fun colors
	// hint: help colorstyle	
	
	
	
	
	
	
// POLL 4 //


**********************************************
* II. 	CORRELATION AND T-TESTS
**********************************************



*CORRELATION AND T-TESTS


/* Correlations measure the strength and direction of the linear relationship between the two variables. 
The correlation coefficient can range from -1 to +1, with -1 indicating a perfect negative correlation, +1 indicating a perfect positive correlation, and 0 indicating no correlation at all. */


//How do we use the correlation command in Stata?
//First, let's access the help file for `correlate'
help correlate

//Let's try checking the correlation between age and wage
corr age wage 

// What if we want to look at age wage and tenure?
// Notice anything different?
//COMMAND:

corr age wage tenure
pwcorr age wage tenure

// POLL 5 //
corr age grade wage hours ttl_exp


** CHALLENGE **
* 4. Correlate ALL of the continuous variables in the dataset that are non-missing for ALL variables
	// hint: continuous variables are numeric variables for which a "unit increase" 
	// (or decrease) has inherent meaning.
	
	

	

*T-TESTS

/* Example breakdown of the output for Stata T-tests:
 https://stats.idre.ucla.edu/stata/output/t-test/ 
 */
 
/*1.State the null hypothesis (H0) and alternative hypothesis (Ha). Decide on significance level (alpha)

2. Plan your test (z or t) and check the assumptions required for that test.
(for t-test: scale of measurement, random sampling, normality of data distribution, adequacy of sample size, and equality of variance in standard deviation.)

3. Do your calculations.  Find the value of the test statistic (z or t). This usually measures how far the data are from H0. Find the associated P-Value.

4. Conclude compare your p-value with alpha and interpret the conclusion in context. 
P-value: the probability of getting the results you got (or more extreme results) given that the null hypothesis is true.
If p-value is equal to or smaller than alpha (e.g., .05), H0 has to be rejected and you conclude that Ha is true. "There is evidence to conclude that.."
If p-value is greater than alpha, H0 cannot be rejected at alpha and you conclude H0 is true. "There is not sufficient evidence.." */





//Now, let's test whether wages are different by union membership

ttest wage, by(union)

//What if we want to look at whether wages vary by if the person lives in the south?

ttest wage, by(south)


*How would you interpret this?


** CHALLENGE **
* 5. Is there a statistically significant difference in the mean wage of white and black women?
	// variables: wage race
	// hint: the ttest approach requires a conditional statement
	
	
	

	

**************************************************
* III. 	REGRESSION AND ITS OUTPUT
**********************************************

*LINEAR REGRESSION

/* Example of Stata Regression output breakdown:
https://stats.idre.ucla.edu/stata/output/regression-analysis/
*/


/* Major box of the Regression output: Parameter Estimates
Look closely at "j," "k," "l," and "m"

*Note*
Dependent Variable and Predictor Variable(s)

Coef: 
Slope, These estimates tell the amount of increase in dependent variable 
that would be predicted by a 1 unit increase in the predictor. 
_Cons: Y-Intercept, when all other variables are equal to 0

P-value: Coefficients having p-values less than alpha are statistically significant. 
*/

help regress //Let's look at the doccumentation for the regress commend

*Lets regress wage and age
reg wage age

*How about wage on age, union, and married?
reg wage age union married



// POLL 6 //



*Why can't we use married_txt?
reg wage age union married_txt

*So far all of our variables have been continous or binary
*What happens when we do a categorical variable?

*What does this output mean?
reg wage age union married industry // Not right

*We want to treat each industry number as its own category instead of assuming a linear
*relationship between them
**How do we fix this?
//COMMAND:

reg wage age union married i.industry

*The i. here lets us split up the categorical industry variable into dummies by value




//What if we only want to run this regression for certain industries?
//COMMAND:


reg wage age union married if industry==5
reg wage age union married if industry==12



*Note number of observations in these regressions
*Do all of them match?
*Why not?

* OMMITTED CATEGORY 
* when we run a regression with a categorical variable, there is always an ommitted category 
* the coefficients are interpretted relative to the ommitted category
 reg wage age union married i.industry
 
 * you can change the ommitted category - say you wanted it to be relative to farmers
 codebook occupation
 label list occlbl	// farmers = 9 
 reg wage ttl_exp collgrad union ib9.occupation
 
 
* a bivariate (two variable) regression is equivalent to testing the difference in group means
reg wage i.race

* we can compare this to the ttest above
* do any of the coefficients look the same?
ttest wage if race <3, by(race)


** CHALLENGE **
* 6. Regress wage (dependent variable) on:
*	total experience, 
*	college graduation,
*	union status, and 
*	occupation.
* Omit respondents in occupations that are:
*	(1) unknown (i.e., "other" or missing) or (2) have fewer than 20 respondents.
	// variables: wage ttl_exp collgrad union occupation






*INTERACTIONS

// Let's add an interaction term for being married and graduating from college

*Basic regression
reg wage age union married collgrad

gen marriedXcollgrad= married*collgrad


reg wage age union married collgrad marriedXcollgrad

// Another way to do this:

*	Including Interactions	*
*https://www.stata.com/why-use-stata/easy-to-grow-with/linear.pdf

*To include only the interaction terms, put # between the terms
* To include both main effects and interaction terms in a model, put ## between the variables


*This produces a version with dummies for each "category"
reg wage age union married#collgrad

*This produces the same as the original specification
reg wage age union married##collgrad

// How do these two specifications differ?



******************************************
* IV. 	POST-ESTIMATION
******************************************
//We can do more than just display coefficients following regression
//Examples from linear regression
//Postestimation commands are commands that can be run after a model is fit
help regress postestimation // here is the relevant help file

*TESTING FOR HETEROSKEDASTICITY
/* That is, the variance of the error term is constant (Homoskedasticity). If the error terms do not have constant variance, they are said to be heteroskedastic.
*/

reg wage union age married 
estat hettest



*WALD TESTS
/*
https://www.stata.com/manuals13/rtest.pdf

The first step in performing a Wald test is to run the full model (i.e., the model containing all predictor variables).The second line of syntax below instructs Stata to run a Wald test in order to test the equality of two coefficients.

*/
reg wage union age married 
test union = married 

/* We find that we can reject the hypothesis at the .05 and/or at the .01 levels */



** CHALLENGE **
* 7. Are the wages of clerical/unskilled workers significantly different from
* unskilled workers? 
*(hint: two methods - one using Wald test, another using ommitted categories)




******************************************
* V.	PLOTTING REGRESSION RESULTS
******************************************

// Sometimes, we may want to display results in figures rather than tables

//you will need to run the below to install this very useful user-written command
ssc install coefplot

reg wage union age married i.industry
coefplot
coefplot, horizontal
coefplot, drop(_cons) horizontal


//What if you want to use 99 percent confidence intervals instead of 95?
//Use the help file for coefplot to figure out how to plot the above figure that way
//COMMAND: 


reg wage union age married i.industry
coefplot, levels(99 95)

