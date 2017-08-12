******************************* 
*	Stata Intensive: Workshop 2
*	Spring 2017, D-LAB
*	Isabelle Cohen
********************************

**************************************************
* Day 2

* Outline:
* I. 	CORRELATION AND T-TESTS
* II. 	PLOTTING
* III. 	REGRESSION AND ITS OUTPUT
* IV. 	POST-ESTIMATION

**************************************************

*Setting do-file basics:
//We want to set a "global" like the one below, to store the file path to today's data
*global mycomp "/Users/isabellecohen/Desktop/DLab/Stata Fundamentals II" // for my computer

//To set yours, manually open the data called "rugged_data.dta" from your computer
//Do not use the stata menu; instead, find the file in your files, and double-click to open it
//Then run:
global mycomp : pwd

//Check if it worked
display "$mycomp"

*Load data
use "$mycomp/rugged_data.dta", clear

**************************************************
* I. 	CORRELATION AND T-TESTS
**********************************************

*CORRELATION AND T-TESTS

//How do we use the correlation command in Stata?
//First, let's access the help file for `correlate'
help correlate

//Let's try checking the correlation between soil and tropical
corr soil tropical

//What if we want to look at soil, tropical, desert and dist_coast?
//COMMAND:


*T-TESTS

//Now, let's test whether the percentile of fertile soil is different in Africa

ttest soil, by(cont_africa)

//What if we want to look at whether the percentile of fertile soil differs by
//whether a country is or isn't in Europe?
//Hint: use the cont_europe variable
//COMMAND:



**************************************************
* II. 	PLOTTING
**********************************************
*HISTOGRAM

help histogram //let's take a look at the histogram command

histogram soil
histogram soil, discrete //don't actually do this

//Let's create a histogram with five bins
//COMMAND:


//What about a histogram with bins of width 2?
//COMMAND:



histogram soil, bin(10) title("This is a histogram of soil fertility") 
histogram soil, bin(10) title("This is a histogram of soil fertility") addlabels
histogram soil, bin(10) title("This is a histogram of soil fertility") addlabels ///
	xtitle("Override the existing x-axis title") 
histogram soil if soil!=0, bin(10) title("This is the histogram without zeroes") ///
	addlabels

histogram soil, by(cont_africa) 

//Those labels aren't very nice
//How can we label the values for cont_africa?
//COMMAND:




histogram soil, by(cont_africa) 

*SCATTERPLOT

help scatter //now scatterplots

scatter soil tropical
scatter soil tropical, title("Soil Fertility vs. Tropical Land") legend(on)
scatter soil desert tropical, title("Soil and Desert by Tropical Land") mcolor(black blue)

//Let's try using a scheme. Make the same scatterplot as above, with the economist scheme.
//COMMAND:


//There are other formatting changes we can also make
scatter soil desert tropical, title("Soil and Desert by Tropical Land") legend(on) ///
	mcolor(black blue) xlabel(0(20)100, format(%2.1f)) ylabel(,format(%2.1f))

*COMBINE GRAPHS
//We want to make a scatterplot, and add a linear prediction-based line of best fit 
twoway (scatter soil desert tropical, title("Soil and Desert by Tropical Land") ///
	legend(on) xlabel(0(20)100, format(%2.0f)) ylabel(,format(%2.0f))) ///
	(lfit soil tropical)

//alternatively, we can use || instead of () to define plots
twoway scatter soil desert tropical, title("Soil and Desert by Tropical Land") ///
	legend(on) xlabel(0(20)100, format(%2.0f)) ylabel(,format(%2.0f)) || ///
	lfit soil tropical
	
//Let's make the same graph, but now also add a linear prediction line for desert and tropical
//COMMAND:

	
//Now try adding a vertical line at x=40.
//Hint: Use the scatter help file.
//COMMAND: 





//Let's save the original graph
twoway (scatter soil desert tropical, title("Soil and Desert by Tropical Land") ///
	legend(on) xlabel(0(20)100, format(%2.0f)) ylabel(,format(%2.0f))) ///
	(lfit soil tropical)
graph save "$mycomp/soilanddesert.gph", replace // save in Stata format (can be re-opened in Stata)
graph export "$mycomp/soilanddesert.png", replace //save in .png format for use

**************************************************
* III. 	REGRESSION AND ITS OUTPUT
**********************************************

*LINEAR REGRESSION

help regress //Let's look at the doccumentation for the regress commend

reg rgdppc_2000 soil tropical cont_africa

//Let's try a robust standard error specification
reg rgdppc_2000 soil tropical cont_africa, robust
reg rgdppc_2000 soil tropical cont_africa, vce(robust)

//What if we only want to run this regression for countries whose legal origin is common law?
//use the variable legor_gbr, which equals 1 if the legal origin is common law.
//note that the 'if' should come before the comma
//COMMAND:


//what about restricting our samples to countries not in Europe or North America?
//use the cont_europe and cont_north_america variables
//COMMAND:




//let's try weighting by population
reg rgdppc_2000 soil tropical cont_africa [aweight=pop_1400] //wow, those are different coeffs

//now, we want to include more controls
reg rgdppc_2000 soil desert tropical dist_coast q_rule_law cont_africa cont_asia cont_europe cont_oceania cont_north_america legor_gbr legor_fra legor_soc legor_deu colony_esp colony_gbr colony_fra colony_prt
//that works, but it's ugly.

reg rgdppc_2000 soil desert tropical dist_coast q_rule_law cont_africa cont_asia ///
	cont_europe cont_oceania cont_north_america legor_gbr legor_fra legor_soc legor_deu ///
	colony_esp colony_gbr colony_fra colony_prt
// Three backticks gets you multiple lines in the same command
// what happens if you copy paste this code to the command window?


// Let's add an interaction term for rule of law and Portuguese origins
gen q_rule_lawXcolony_prt = q_rule_law*colony_prt

//Run the same basic specification as before, with the robust indicator
//Include the interaction term and other relevant variables
reg rgdppc_2000 soil tropical cont_africa q_rule_law  q_rule_lawXcolony_prt colony_prt, robust

*LOGIT REGRESSIONS
//Logits are used for binary dependent variables
//For a logit regression, we interpret the coefficients as the log odds

//Transform the GDP variable into a binary variable; just an example
gen high_rgdppc_2000 = (rgdppc_2000>9094.893) if rgdppc_2000<.  //DO NOT DO THIS

logit high_rgdppc_2000 soil tropical cont_africa

//The coefficient on tropical tells us that, holding soil and cont_africa at a fixed value,
//a one-unit increase in tropical leads to a certain decrease in the odds of having a high GDP

disp exp(.0146563)

//or use the or option
logit high_rgdppc_2000 soil tropical cont_africa, or

//specifically, we see approximately a 1% decrease in the odds of having a high GDP

*PROBIT REGRESSIONS
//Probits are also used for binary dependent variables
//For a probit regression, we can interpret signs, but not the precise value of the coefficient

probit high_rgdppc_2000 soil tropical cont_africa

******************************************
* IV. 	POST-ESTIMATION
******************************************
//We can do more than just display coefficients following regression
//Examples from linear regression

help regress postestimation // here is the relevant help file

*PREDICTED VALUES
reg rgdppc_2000 soil tropical cont_africa, robust
predict fitted, xb

//What are we doing when we estimate predicted values?
gen fitted_v2 = _b[soil]*soil + _b[tropical]*tropical + _b[cont_africa]*cont_africa + _b[_cons]

//Are fitted and fitted_v2 the same? How can we check?
//COMMAND:



//Let's graph these
scatter rgdppc_2000 fitted tropical, by(cont_africa) // our x and y axes don't look great
scatter rgdppc_2000 fitted tropical, by(cont_africa) xlabel(0(20)100, format(%2.0f)) ylabel(,format(%2.0f))
scatter rgdppc_2000 fitted tropical, by(cont_africa) xlabel(0(20)100, format(%2.0f)) ylabel(,format(%2.0f)) ///
	sort  c(. l) // we can also connect 
scatter rgdppc_2000 fitted tropical, by(cont_africa) xlabel(0(20)100, format(%2.0f)) ylabel(,format(%2.0f)) ///
	sort  c(. l) m(. i) // or even drop the dots

*RESIDUALS
reg rgdppc_2000 soil tropical cont_africa, robust
predict r, resid

//What are we doing when we estimate residuals?
gen r_v2 = rgdppc_2000-(_b[soil]*soil + _b[tropical]*tropical + _b[cont_africa]*cont_africa + _b[_cons])

//Are r and r_v2 the same? Check
//COMMAND:


scatter rgdppc_2000 r tropical, by(cont_africa) xlabel(0(20)100, format(%2.0f)) ylabel(,format(%2.0f))
//Draw the scatter plot with a line connecting the residuals, with no dots identifying the points
//COMMAND:



//Let's graph both together
//COMMAND:
scatter rgdppc_2000 fitted r tropical, by(cont_africa) xlabel(0(20)100, format(%2.0f)) ylabel(,format(%2.0f))



//What is happening here? What happens when we add together r and fitted?
gen total=r+fitted
*br total rgdppc_2000

*WALD TESTS
reg rgdppc_2000 soil tropical colony_esp colony_gbr, robust
test colony_esp = colony_gbr

//What are we testing? What do we conclude?

