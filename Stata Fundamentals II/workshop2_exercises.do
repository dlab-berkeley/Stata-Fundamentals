********************************
*	STATA FUNDAMENTALS: PART 2
*	SUMMER 2020, D-LAB
* 	EXERCISES 
********************************

/* 	This do file is to be run concurrently with workshop1_follow.do.
	If you are running it independently, un-comment the following lines and run
	them to load in the data. */
	
*cd "Documents/DLab/stata-fundamentals-master/Stata Fundamentals II" // change to your own working directory
*use nlsw88.dta , clear



//////////////////////////
/*   PART 1 EXERCISES   */ 
//////////////////////////



* 1. Plot a histogram of weekly hours worked in which each bar represents 5 hours.
* Label the x-axis "Weekly Hours"
	// variable: hours
	

	
	
	
* 2. Create a graph with one historgram of wage for each industry.
	// variables: wage, industry
	
* Bonus: Include a (single) title for the whole graph
	// hint: this is an option WITHIN an option

	
	
	
	
* 3. Create a graph with a scatter plot of wage (y-axis) and total work experience (x-axis)
* for (1) white women and (2) black women on the same set of axes.
* Include a legend that labels the plot for each race
	// variables: wage, ttl_exp, race (1=white, 2=black)

* BONUS: change the marker colors from the default to 2 different fun colors
	// hint: help colorstyle





//////////////////////////
/*   PART 2 EXERCISES   */ 
//////////////////////////



* 4. Correlate ALL of the continuous variables in the dataset.
* Correlate ONLY observations that are non-missing for ALL variables
	// hint: continuous variables are numeric variables for which a "unit increase" 
	// (or decrease) has inherent meaning.

	
	
	
	
* 5. Is there a statistically significant difference in the mean wage of white and black women?
	// variables: wage race
	// hint: more than one solution
	// hint: one solution requires a conditional statement
	
	
	
	
	
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
