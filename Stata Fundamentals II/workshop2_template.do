********************************
*	STATA INTENSIVE: WORKSHOP 2
*	SPRING 2019, D-LAB
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

cd "/Users/isabellecohen/Dropbox/DLab/Stata Fundamentals II"
   
/***
		We paste this command above so that next time we can just run this 
		do-file from the top and it will run smoothly. We will not need to
		use the file menu or copy-paste again. We should be able to run 
		everything from the do-file.
***/


*Open the data file

use nlsw88.dta, clear // open data file 




**************************************************
* I. 	CORRELATION AND T-TESTS
**********************************************

//Let's use the unchanged data again

use nlsw88.dta , clear 

*CORRELATION AND T-TESTS

//How do we use the correlation command in Stata?
//First, let's access the help file for `correlate'
help correlate

//Let's try checking the correlation between age and wage
corr age wage 

//What if we want to look at age wage and tenure
//COMMAND:




*T-TESTS

//Now, let's test whether wages are different by union membership

ttest wage, by(union)

//What if we want to look at whether wages vary by if the person lives in the south?

//Hint: use the south variable
//COMMAND:




*How would you interpret this?


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



//What about a histogram with bins of width 2?
//COMMAND:




**All of our histogram options can stack together

*Add the following title: "Histogram by Wage in National Labor Survery in 1988"
//COMMAND:





*Change the title for the x-axis
//COMMAND:




*************
**Additional options for a Histogram
*************

*We can restrict our sample with a conditional statement
histogram wage if married==1, width(.25) 
	
	
*We can also create a histogram by a categorical variable
histogram wage, by(married) 


//How would we change this command if we wanted to look at the histograms by industry?
//COMMAND:




*************
*SCATTERPLOT
*************

help scatter //now scatterplots

scatter wage age
 
scatter wage tenure 
scatter wage age, title("Hourly  vs. Age") legend(on)
scatter wage age, title("Hourly  vs. Age") mcolor(blue)

//Let's try using a scheme. 
help scheme

//Make the same scatterplot as above, with a monocolor scheme.
//COMMAND:




//There are other formatting changes we can also make
scatter wage age, title("Hourly  vs. Age") legend(on) ///
	mcolor(blue) xlabel(34(1)46, format(%2.0f)) ylabel(,format(%2.1f))

*COMBINE GRAPHS
//We want to make a scatterplot, and add a linear prediction-based line of best fit 	
twoway (scatter wage age, title("Hourly  vs. Age") legend(on) ///
	mcolor(blue) xlabel(34(1)46, format(%2.0f)) ylabel(,format(%2.1f))) ///
	(lfit wage age)

//Alternatively, we can use || instead of () to define plots
scatter wage age, title("Hourly  vs. Age") legend(on) ///
	mcolor(blue) xlabel(34(1)46, format(%2.0f)) ylabel(,format(%2.1f)) || ///
	lfit wage age

scatter wage age || lfit wage age

//Let's save the graph
scatter wage age, title("Hourly  vs. Age") scheme(s1color) ///
	mcolor(blue) xlabel(34(1)46, format(%2.0f)) ylabel(,format(%2.1f)) || ///
	lfit wage age , legend(on label(1 "Hourly Wage") label(2 "Regression Line"))
	
graph save "wageage.gph", replace // save in Stata format (can be re-opened in Stata)
graph export "wageage.png", replace //save in .png format for use

*Remember- you can code all these graphs on one line without the /// 
*I have them broken up into multiple lines for easy display in class 
*Do what is best for you!


*************
**Additional options for a Scatter Plot
*************


*Scatter plot by wage and age- separate graph for each
scatter wage age, by(race)

*Same as previous but includes a graph for total cohort
scatter wage age, by(race, total)

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
twoway (histogram wage if union==1, percent color(blue) lcolor(black)) ///
	(histogram wage if union==0, fcolor(none) lcolor(black) /// 
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

*LINEAR REGRESSION

help regress //Let's look at the doccumentation for the regress commend

*Lets regress wage and age
reg wage age

*How about wage, age, union, and married?
//COMMAND:





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



*The i. here lets us split up the categorical industry variable into dummies by value

//What if we only want to run this regression for certain industries?
//COMMAND:







*Note number of observations in these regressions
*Do all of them match?


*Why not?

*INTERACTIONS

// Let's add an interaction term for being married and graduating from college

*Basic regression
reg wage age union married collgrad

gen marriedXcollgrad= married*collgrad


reg wage age married collgrad union marriedXcollgrad

// Another way to do this:
*This produces a version with dummies for each "category"
reg wage age union married#collgrad

*This produces the same as the original specification
reg wage age union married##collgrad

// How do these two specifications differ?

*ROBUST STANDARD ERRORS

// Let's add robust standard errors to our regression; use the help file to do so
//COMMAND:






*LOGIT REGRESSIONS
//Logits are used for binary dependent variables
//For a logit regression, we interpret the coefficients as the log odds

*Lets predict union status
logit union wage age married

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

reg wage age married collgrad union marriedXcollgrad
test collgrad+marriedXcollgrad=0
test married+marriedXcollgrad=0

//What are we testing? What do we conclude?



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


**How would you alter this coefplot for a logistic regression?
*Use the outcome union
//COMMAND:




*Does the scale need to be changed at all?


//What if you want to use 99 percent confidence intervals instead of 95?
//Use the help file for coefplot to figure out how to plot the above figure that way
//COMMAND: 




