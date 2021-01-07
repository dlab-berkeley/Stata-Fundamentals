********************************
*	STATA FUNDAMENTALS: WORKSHOP 2
*	SPRING 2021, D-LAB
* 	SOLUTIONS DO FILE
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

cd "C:\Users\heroa\Google Drive\DLab\stata-fundamentals\Stata Fundamentals II"
   
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

histogram hours, width(5) start(0) xtitle("Weekly Hours")

* OR
sum hours // max is  80
histogram hours, bin(16) start(0) xtitle("Weekly Hours")	
	

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
	
histogram wage, by(industry)

* Bonus: Include a (single) title for the whole graph
	// hint: this is an option WITHIN an option

histogram wage, by(industry, title("Wage by Industry"))	
	

	
	


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
	
twoway (scatter wage ttl_exp if race==1, col(cranberry)) ///
	(scatter wage ttl_exp if race==2, col(teal)), ///
	legend(label(1 "White") label(2 "Black"))

	
	
	
	
// POLL 4 //


**********************************************
* II. 	CORRELATION AND T-TESTS
**********************************************



*CORRELATION AND T-TESTS

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
	
corr age grade wage hours ttl_exp tenure	

	

*T-TESTS

//Now, let's test whether wages are different by union membership

ttest wage, by(union)

//What if we want to look at whether wages vary by if the person lives in the south?

ttest wage, by(south)


*How would you interpret this?


** CHALLENGE **
* 5. Is there a statistically significant difference in the mean wage of white and black women?
	// variables: wage race
	// hint: the ttest approach requires a conditional statement
ttest wage if race<3, by(race)
	
/* Answer: 
	Yes, white and black women earn significantly different wages on average.
	White women earn $1.24 more per hour than black women.
*/	

	

**************************************************
* III. 	REGRESSION AND ITS OUTPUT
**********************************************

*LINEAR REGRESSION

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

/* STEP 1 */
tab occupation
tab occupation, nolab

* OR
codebook occupation
tab occupation
label list occlbl

/* STEP 2 */
reg wage ttl_exp collgrad union i.occupation if occupation<9




*INTERACTIONS

// Let's add an interaction term for being married and graduating from college

*Basic regression
reg wage age union married collgrad

gen marriedXcollgrad= married*collgrad


reg wage age union married collgrad marriedXcollgrad

// Another way to do this:
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

help regress postestimation // here is the relevant help file

*TESTING FOR HETEROSKEDASTICITY
reg wage union age married 
estat hettest



*WALD TESTS
reg wage union age married 
test union = married




** CHALLENGE **
* 7. Are the wages of clerical/unskilled workers significantly different from
* unskilled workers? 
*(hint: two methods - one using Wald test, another using ommitted categories)

label list occlbl

/* Solution 1 */
reg wage i.occupation
test 4.occupation = 5.occupation

/* Solution 2 */

reg wage ib4.occupation

*OR

reg wage ib5.occupation


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

