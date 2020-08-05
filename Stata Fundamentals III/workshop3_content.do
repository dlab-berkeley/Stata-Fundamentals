******************************* 
*	STATA INTENSIVE: WORKSHOP 3
*	SPRING 2020, D-LAB
********************************

**************************************************
* Day 3

* Outline:
* 0. 	WORKSHOP 2 WRAP-UP
* I. 	APPENDING & MERGING
* II.	RESHAPING	
* III.	MACROS
* IV.	LOOPS
* V. 	EXPORTING RESULTS

**************************************************

/* Step 1: File > Change Working Directory > Navigate to the folder where you 
   have saved the data file nlsw88.dta */
   
/* Step 2: Copy-paste the last command that shows up on result screen.
   My result window shows this:*/   

cd "/Users/isabellecohen/Dropbox/DLab/Stata Fundamentals III"
   
/***
		We paste this command above so that next time we can just run this 
		do-file from the top and it will run smoothly. We will not need to
		use the file menu or copy-paste again. We should be able to run 
		everything from the do-file.
***/

/* Making a Global:*/

//We could instead store this same file path in a global
global mycomp "/Users/isabellecohen/Dropbox/DLab/Stata Fundamentals III"

//Check if it worked
display "$mycomp"

//"Show me what the name "mycomp" represents" 
cd "$mycomp"

pwd
// POLL 1 //

**********************************************
* 0. 	WORKSHOP II WRAP-UP
**********************************************

clear all 
use nlsw88.dta, clear

*POST-ESTIMATION

//We can do more than just display coefficients following regression
//Examples from linear regression

help regress postestimation // here is the relevant help file

*TESTING FOR HETEROSKEDASTICITY
reg wage union age married 
estat hettest


*WALD TESTS
reg wage union age married 
test union = married

gen marriedXcollgrad=married*collgrad
reg wage age married collgrad union marriedXcollgrad
test collgrad+marriedXcollgrad=0
test married+marriedXcollgrad=0

//What are we testing? What do we conclude?

* PLOTTING REGRESSION RESULTS

// Sometimes, we may want to display results in figures rather than tables

//you will need to run the below to install this very useful user-written command
ssc install coefplot

reg wage union age married i.industry
coefplot
coefplot, horizontal
coefplot, drop(_cons) horizontal

//what about for a logistic regression?

logit union wage age married i.industry
coefplot


**********************************************
* I. 	APPENDING & MERGING
**********************************************

*APPEND DATASETS

*Data for round 1

clear all 
use nlsw88.dta, clear


count // how many observations in this dataset?
sum idcode // what is the range of id numbers in this dataset?
br // let's browse the data




* Data for round 2,

use nlsw88_wave2.dta, clear

count // how many observations in this dataset?
sum idcode // what is the range of id numbers in this dataset?
br // let's browse the data


// how many observations should we have if we combine them?

* Append the data

use nlsw88.dta, clear
append using nlsw88_wave2.dta

count // Do we have the correct number of observations?
sum idcode // Do we have all the expected ids?
br // let's browse the data


save nlsw88_wave1and2.dta, replace



* MERGE DATASETS

* Data for wave 1 
use nlsw88_wave1and2.dta

isid idcode // check if id makes  a unique identifier
duplicates report idcode 


*Lets look at the second part of the dataset
use nlsw88_childvars, clear

count 
des // let's see how many variables are in this dataset
isid idcode // check if id makes  a unique identifier
duplicates report idcode // another way of checking if idcode is unique

* Merge
use nlsw88_wave1and2.dta, clear

merge 1:1 idcode using nlsw88_childvars //one-to-one merge

*What does it mean to have different _merge values?
tab _merge
*What should we do with these observations?

count
des // how many variables should we have, including the new stata-created _merge variable?
br
rename _merge _merge_1 //rename _merge so you can merge again later w/o error

drop _merge_1 //or drop merge

save nlsw88_complete.dta, replace

// POLL 2 //

**********************************************
* II. 	RESHAPING
**********************************************

*Load data
use nlsw88_complete.dta, clear

//Some of this data is in "wide" format
list idcode childage1 childage2 childage3 childage4 in 1/10  //print the data to the screen

//First, we want to try and reshape it to "long" format
//Now, each row will be not a single individual, but an individual-child
reshape long childage, i(idcode) j(childidcode) 

list idcode childidcode childage in 1/10 //print again

/* Now take this data, and put it back into "wide" format

Right now, the data is organized at the individual-child level
That means that each observation represents a child
Instead, let's put the data at the individual level, so each row is one family

Note that we need to specify i() and j() after the comma
i() is the variable the data will be at the level of
j() will be how we're reshaping it*/

reshape wide childage, i(idcode) j(childidcode)

// POLL 3 //

**********************************************
* III. 	MACROS
**********************************************

//Imagine you want to do some analysis on our NLSW data
use nlsw88_complete.dta, clear

*LOCALS

local i=1
disp `i'
disp "The local called i has the value `i'"
//Now we increase i by 2.
local i=`i'+2
disp "The local called i now has the value `i'"

summ hours child_num
return list

//Calculate the ratio of hours worked to number of children
summ hours
*return list
local hours=r(mean) // store the average in a local

summ child_num
*return list
local child_num=r(mean) // store the average in a local

local ratio=round(`hours'/`child_num',.001)
disp "The ratio of hours worked to number of children is `ratio'"

//Let's check the math
disp 37.23/2.08

//There are a number of built in commands Stata can use to make locals
local industry_lab: value label industry
display "The value label for industry is `industry_lab'."

// POLL 4 //

*GLOBALS

//Considered bad form in programming, use sparingly.
//Easy list of long set of variable names
//Set the file path name for different computers

//We set up a global at the beginning of this do file, which can be very useful
display "$mycomp"



**********************************************
* IV. 	LOOPS
**********************************************

*FOREACH LOOPS

reg wage grade
reg ttl_exp grade
reg hours grade


//This will do the exact same thing
foreach var in wage ttl_exp hours {
	reg `var' grade
}



//Instead of using foreach var in, we can also use foreach var of
//This works only with variables
foreach fudge of varlist wage ttl_exp hours {
	reg `fudge' grade
}


//Using of varlist lets us do interesting things like search our variable list
foreach fudge of varlist t* {
	reg `fudge' grade
}

/*You may notice that the output from inside a loop is not
quite as well documented as from outside a loop
It can be helpful to add display lines explaining where the code is*/
 
// POLL 5 //
 
foreach fudge in wage ttl_exp hours {
	disp "********This regresses `fudge' on grade **********"
	reg `fudge' grade
}

/*When running a long loop, you may want to turn off the --more-- command
This can be done with --set more off--
To do it permanently, you can run --set more off, permanently--*/

/*You can also use the command --set trace on-- to display 
EVERYTHING that goes on when you run a command
This should probably be a last resort, and can be turned off with --set trace off-- */

set trace on
foreach var in wage ttl_exp hours {
	reg `var' grade
}
set trace off

*FORVALUES LOOPS

//What if you want to loop over numbers?
foreach X in 1 2 3 4 5 6 7 8 9 10 {
	disp "The number is `X'"
}

//That works, but it's better to do forvalues
forvalues X=1(1)10 {
	disp "The number is `X'."
}

//You can even loop over numeric values in variable names
forvalues x=1/4 {
	summ childage`x'
}

//loop over a list
local outcomes wage ttl_exp hours
foreach var of local outcomes {
	reg `var' grade
}

//we're definitely not limited to regression when it comes to loops
local outcome_list wage tenure
foreach outcome of local outcome_list {
	describe `outcome'
	reg `outcome' grade
	count if `outcome'==.
	local nr = r(N)
	display "`outcome' is missing for `nr' observations."
}


* NESTED LOOPS

forvalues X=1/10 {
	forvalues Y=1/10 {
		disp "X is `X' and Y is `Y' and X*Y is "`X'*`Y'
	}
}

//Control for the age of a different child in each regression

local outcomes wage ttl_exp hours
local i=1 //add an index so we can see how many regs we're doing
foreach var of varlist `outcomes' {
	forvalues x=1/4 {
		display "Regression `i':We're regressing `var' on grade, controlling for child age `x'"
		local i=`i'+1
		reg `var' grade childage`x'
	}
}

// POLL 6 //



**********************************************
* V. 	EXPORTING RESULTS
**********************************************

//Create a folder to store output
//the mkdir folder creates the folder specified in " " (if the file path makes sense)
//cap, or capture, is a Stata command which tells Stata to keep going even if it can't implement that command
cap mkdir "$mycomp/Output"

*OUTREG2
//To install outreg2:
ssc install outreg2

global controlvars south married union

//First, output to a .txt file
reg wage grade
outreg2 using "$mycomp/Output/regression_results", replace tdec(3) ///
	bdec(3) bracket ctitle(Basic) ///
	addnote(This table is totally awesome and should be published)

reg wage grade $controlvars
outreg2 using "$mycomp/Output/regression_results", append tdec(3) ///
	bdec(3) bracket ctitle(With Controls)

reg wage grade $controlvars, robust
outreg2 using "$mycomp/Output/regression_results", append tdec(3) ///
	bdec(3) bracket ctitle(Robust SE)

reg wage grade $controlvars, robust cluster(industry)
outreg2 using "$mycomp/Output/regression_results", append tdec(3) ///
	bdec(3) bracket ctitle(Cluster SE)


// POLL 7 //

// Export results to EXCEL

reg wage grade
outreg2 using "$mycomp/Output/regression_results.xls", replace tdec(3) ///
	bdec(3) bracket ctitle(Basic) ///
	addnote(This table is totally awesome and should be published)

reg wage grade $controlvars
outreg2 using "$mycomp/Output/regression_results.xls", append tdec(3) ///
	bdec(3) bracket ctitle(With Controls)

reg wage grade $controlvars, robust
outreg2 using "$mycomp/Output/regression_results.xls", append tdec(3) ///
	bdec(3) bracket ctitle(Robust SE)

reg wage grade $controlvars, robust cluster(industry)
outreg2 using "$mycomp/Output/regression_results.xls", append tdec(3) ///
	bdec(3) bracket ctitle(Cluster SE)


//The below does the same thing for a .tex file
//Here, I also use two loops, first over three variables
// Within each variable, we then loop over three specifications (and titles!)

local spec_list `" "$controlvars" "$controlvars, robust" "$controlvars, robust cluster(industry)" "'
local spec_title `" "With Controls" "Robust SE" "Clustered" "'	

local outcomes wage ttl_exp hours

foreach var of varlist `outcomes' {
	reg `var' grade
	outreg2 using "$mycomp/Output/regression_results_`var'.xls", replace tdec(3) bdec(3) bracket ctitle(Basic) ///
		addnote(This table is totally awesome and should be published)
	
	local j =1
	foreach spec in `spec_list' {
		local title : word `j' of `spec_title'
		reg `var' grade `spec'
		outreg2 using "$mycomp/Output/regression_results_`var'.xls", append tdec(3) bdec(3) bracket ctitle("`title'")
		local j = `j' + 1
	}
}
