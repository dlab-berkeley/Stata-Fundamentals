********************************
*	STATA FUNDAMENTALS: PART 2
*	SUMMER 2020, D-LAB
* 	EXERCISES 
********************************

/* 	This do file is to be run concurrently with workshop2_content.do.
	If you are running it independently, un-comment the following lines and run
	them to load in the data. */
	
*cd "Documents/DLab/stata-fundamentals-master/Stata Fundamentals II" // change to your own working directory
*use nlsw88.dta , clear



//////////////////////////
/*   PART 1 EXERCISES   */ 
//////////////////////////



* 1. Plot a histogram of weekly hours worked in which each bar represents 5 hours, starting at 0.
* Label the x-axis "Weekly Hours"
	// variable: hours
	
histogram hours, width(5) start(0) xtitle("Weekly Hours")

* OR
sum hours // max is  80
histogram hours, bin(16) start(0) xtitle("Weekly Hours")
	
	
* 2. Create a graph with one historgram of wage for each industry.
	// variables: wage, industry

histogram wage, by(industry)

* Bonus: Include a (single) title for the whole graph
	// hint: this is an option WITHIN an option

histogram wage, by(industry, title("Wage by Industry"))
	
	
* 3. Create a graph with a scatter plot of wage (y-axis) and total work experience (x-axis)
* for (1) white women and (2) black women on the same set of axes.
* Include a legend that labels the plot for each race
	// variables: wage, ttl_exp, race (1=white, 2=black)

* BONUS: change the marker colors from the default to 2 different fun colors
	// hint: help colorstyle

twoway (scatter wage ttl_exp if race==1, col(cranberry)) ///
	(scatter wage ttl_exp if race==2, col(teal)), ///
	legend(label(1 "White") label(2 "Black"))



//////////////////////////
/*   PART 2 EXERCISES   */ 
//////////////////////////



* 4. Correlate ALL of the continuous variables in the dataset.
* Correlate ONLY observations that are non-missing for ALL variables
	// hint: continuous variables are numeric variables for which a "unit increase" 
	// (or decrease) has inherent meaning.

corr age grade wage hours ttl_exp tenure
	
	
	
* 5. Is there a statistically significant difference in the mean wage of white and black women?
	// variables: wage race
	// hint: more than one valid approach
	// hint: one approach requires a conditional statement

	
/* Approach 1: */
ttest wage if race<3, by(race)

/* Approach 2: */
reg wage i.race // a bivariate regression is equivalent to testing the difference in group means

/* Answer: 
	Yes, white and black women earn significantly different wages on average.
	White women earn $1.24 more per hour than black women.
*/
	
	
* 6. Regress wage (dependent variable) on:
*	total experience, 
*	college graduation,
*	union status, and 
*	occupation.
* Omit respondents in occupations that are:
*	(1) unknown (i.e., "other" or missing) or (2) have fewer than 20 respondents.
	// variables: wage ttl_exp collgrad union occupation

* Bonus: Are the wages of clerical/unskilled workers significantly different from
* unskilled workers, all else constant?

/* STEP 1 */
tab occupation
tab occupation, nolab

* OR
codebook occupation
tab occupation
label list occlbl

/* STEP 2 */
reg wage ttl_exp collgrad union i.occupation if occupation<9

/* Bonus Solution 1 */
reg wage ttl_exp collgrad union i.occupation
test 4.occupation = 5.occupation

/* Bonus Solution 2 */
reg wage ttl_exp collgrad union ib4.occupation

*OR

reg wage ttl_exp collgrad union ib5.occupation
