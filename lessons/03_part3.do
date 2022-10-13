******************************* 
*	STATA FUNDAMENTALS: WORKSHOP 3
*	 AY 2021- 2022, D-LAB
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

cd "/Users/reneestarowicz/Desktop/Stata Fundamentals/Stata Fundamentals III"
   
/***
		We paste this command above so that next time we can just run this 
		do-file from the top and it will run smoothly. We will not need to
		use the file menu or copy-paste again. We should be able to run 
		everything from the do-file.
***/

pwd

// POLL 1 //

**********************************************
* 0. 	WORKSHOP II WRAP-UP
**********************************************


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


// how many observations should we have if we combine them? What would we expect to see for the Max. and Min. idcodes?


* Append the datastat

use nlsw88.dta, clear
append using nlsw88_wave2.dta
help append

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
help merge
merge 1:1 idcode using nlsw88_childvars //one-to-one merge

*Note: _merge present at the bottom of the variables list 
*What does it mean to have different _merge values?
tab _merge

/*
_merge = 1: A case that was present in the master dataset only.
_merge = 2: A case that was present in the using dataset only.
_merge = 3: A case that was present in both datasets.
*/


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
help reshape 
list idcode childidcode childage in 1/10 //print again

/* Now take this data, and put it back into "wide" format

Right now, the data is organized at the individual-child level
That means that each observation represents a child
Instead, let's put the data at the individual (idcode- mother) level, so each row is one family

Note that we need to specify i() and j() after the comma
i() is the variable the data will be at the level of
j() will be how we're reshaping it*/
help reshape 
reshape wide childage, i(idcode) j(childidcode)

// POLL 3 //


/* CHALLENGE: RESHAPING AND MERGING **
	Rather than merging nlsw88_childvars into nlsw88_wave1and2 and then reshaping,
	we could instead have first reshaped nlsw88_childvars, and then done a
	many-to-one merge. Let's try that now!*/

/*1.1: Open up nlsw88_childvars, and reshape it to long format*/



/*1.2: Merge nlsw88_wave1and2 (using) into nlsw88_childvars (master)
	using a many-to-one syntax*/


/*1.3: We want this data to be organized at the woman-child level,
	meaning we should have a number of observations for each woman matching
	the number of children she has. For example, if a women has 3 children, there
	should be 3 observations for her. 
	
	1.3.1: How many observations are there initially? How many women are there in our data?
	(hint: use the user-written command --unique-- by typing "ssc install unique"
	and then looking at the help file)
	

	1.3.2: How could you check if there are women with extra observations? 
		(note: there are many ways to 'answer' this question)
		
	1.3.3: Can you find a way to drop observations for "fake" (created by the reshape)
		child observations?
		
	1.3.4: What is the correct number of observations in the end?*/


**********************************************
* III. 	MACROS
**********************************************

//Imagine you want to do some analysis on our NLSW data
use nlsw88_complete.dta, clear

*LOCALS
help local 

local i=1
disp `i'
disp "The local called i has the value `i'"
//Now we increase i by 2.
local i=`i'+2
disp "The local called i now has the value `i'"

summ hours child_num
return list // stores results in r()

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

/* Making a Global:*/

//We could store the file path to the working directory in a global
pwd

* copy your own working directory and replace mine below*

global mycomp "/Users/reneestarowicz/Desktop/Stata Fundamentals/Stata Fundamentals III"

//Check if it worked
display "$mycomp"

// reset working directory using the global 
cd "$mycomp"

// check it worked
pwd

// this global will be useful latter when we save files to a different folder


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


help foreach 

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
help forvalues
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


/** CHALLENGE 2: LOCALS AND LOOPS **
	Let's use nlsw88_complete to explore locals and loops further! Let's imagine we want to
	make a "dictionary" from this dataset, or print on the screen some information
	about each of the variables in the data.
	
	In this exercise, we'll focus on ttl_exp, tenure, south and smsa.*/

/*2.1: Use the --help extended_fcn-- file to make a local containing the variable 
label of ttl_exp, and display it. The command can be found under the subheading
"Macro functions for extracting data attributes" in the help file extended_fcn*/
* (hint: the variable label is the explanation for what the variable is)



/*2.2: Make a loop which goes over ttl_exp, tenure, south and smsa and
lists the variable label for each one.*/




/*2.3: Display the sentence - using locals and extended functions, not words
	- in the following format: "ttl_exp (float) contains the total work experence for each
	woman in the dataset." */
 
 
 
/*2.4: Make a loop which takes your sentence above, and fills it in for
	ttl_exp, tenure, south and smsa. Put a number at the beginning of each sentence
	which updates by one every time your loop runs*/



/*2.5 (CHALLENGE): Write a loop which produces the exact same results, 
	but this time use a forvalues loop to loop over the numbers 1 to 4 to do so.

	Hint: check the extended function help file and look at "word # of string".*/


	
	

**********************************************
* V. 	EXPORTING RESULTS
**********************************************

//Create a folder to store output
//the mkdir folder creates the folder specified in " " (if the file path makes sense)
//cap, or capture, is a Stata command which tells Stata to keep going even if it can't implement that command

// we are making use of your global $mycomp so that we don't have to write out the whole filepath 

cap mkdir "$mycomp/Output"

*OUTREG2
//To install outreg2:
ssc install outreg2

help outreg2

global controlvars south married union

// POLL 7 //

// Export results to EXCEL (default is text file)

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


// Here, I also use two loops, first over three variables
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

putexcel // writes Stata expressions, matrices, tables, images, and returned results to an Excel
