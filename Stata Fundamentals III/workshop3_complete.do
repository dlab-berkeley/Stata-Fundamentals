******************************* 
*	STATA INTENSIVE: WORKSHOP 3
*	FALL 2017, D-LAB
********************************

**************************************************
* Day 3

* Outline:
* I. 	APPENDING & MERGING
* II.	RESHAPING	
* III.	MACROS
* IV.	LOOPS
* V. 	EXPORTING RESULTS

**************************************************

*Setting do-file basics:
//We want to set a "global" like the one below, to store the file path to today's data
*global mycomp "/Users/isabellecohen/Dropbox/DLab/Stata Fundamentals III/"
// for my computer


//To set yours, manually open the data called "round1.dta" from your computer
//Do not use the stata menu; instead, find the file in your files, and double-click to open it
//Then run:
global mycomp : pwd

* "I want to give my file path the following name: mycomp" 

//Check if it worked
display "$mycomp"

* "Show me what the name "mycomp" represents" 

cd "$mycomp"

**********************************************
* I. 	APPENDING & MERGING
**********************************************

*APPEND DATASETS

* Data for rouund 1, conducted for families 1 and 2

clear all 
use child_round1.dta, clear

count // how many observations in this dataset?
sum famid // what is the range of family id numbers in this dataset?
br // let's browse the data



* Data for round 2, conducted for family 3

use child_round2, clear

count // how many observations in this dataset?
sum famid // what is the range of family id numbers in this dataset?
br // let's browse the data


// how many observations should we have if we combine them?

* Append

use child_round1, clear
append using child_round2

count // Do we have the correct number of observations?
tab famid // Do we have all the expected family ids?
br // let's browse the data


save child, replace



* MERGE DATASETS


* Data for part 1 of the dataset which contain an id and information on income and unemployment insurance

use income_part1, clear

count 
des // let's see how many variables are in this dataset
isid id // check if id makes  a unique identifier
duplicates report id// another way of checking if the combination of nr and year is unique
sort id // for merging, it's good practice to sort the data first
save income_part1, replace



* Data for part 1 of the dataset which contain an id and information on gender

use income_part2, clear

count 
des // let's see how many variables are in this dataset
isid id // check if id makes  a unique identifier
duplicates report id// another way of checking if the combination of nr and year is unique
sort id // for merging, it's good practice to sort the data first
save income_part2, replace



* Merge
use income_part1, clear

merge 1:1 nr year using income_part2 //one-to-one merge

tab _merge
count
des // how many variables should we have, including the new stata-created _merge variable?
br
rename _merge _merge_1 //rename _merge so you can merge again later w/o error


save income, replace



**********************************************
* II. 	RESHAPING
**********************************************

*Load data
use "$mycomp/income.dta", clear

//This data is in "wide" format
list //print the data to the screen

//First, we want to try and reshape it to "long" format
//Now, each row will be not a single individual, but an individual-year
reshape long inc ue, i(id) j(year) 

list //print again

reshape wide //once changed, it's easy to change back
reshape long //it's also easy to change back-back.


use "$mycomp/child.dta", clear

/*Take this data, and put it into "wide" format
Right now, the data is organized at the family-child level
That means that each observation represents a child
Instead, let's put the data at the family level, so each row is one family

Note that we need to specify i() and j() after the comma
i() is the variable the data will be at the level of
j() will be how we're reshaping it*/
//COMMAND:

reshape wide age gender, i(famid) j(childid)
list // to see if it worked

//Now go back
//COMMAND:

reshape long
list


**********************************************
* I. 	APPENDING & MERGING - EXTENSION
**********************************************
//We could also have started by reshaping income_part1, then done a many-to-one merge

use income_part1, clear

//Let's first reshape income_part1 to long format
//COMMMAND:
reshape long inc ue, i(id) j(year) 

//Now we merge in part 2 using what's called a many-to-one merge

merge m:1 id using income_part2


**********************************************
* III. 	MACROS
**********************************************

*LOCALS

local i=1
disp `i'
disp "The local called i has the value `i'"
//Now we increase i by 2.
local i=`i'+2
disp "The local called i now has the value `i'"

//Let's use WASHdlab
use "$mycomp/WASHdlab.dta", clear

summ free_chl_yn tot_chl_yn
return list

//Calculate the ratio of average levels of free and total chlorine
summ free_chl_yn
return list
local free=r(mean) // store the average in a local


summ tot_chl_yn
return list
local tot=r(mean) // store the average in a local

local ratio=round(`free'/`tot',.001)
disp "The ratio of free to total chlorine is `ratio'"

//Let's check the math
disp .2118126/.2505092

//There are a number of built in commands Stata can use to make locals
local el_momnodirt_lab: var label el_momnodirt
display "The variable label for el_momnodirt is `el_momnodirt_lab'."

//Use the --help extended_fcn-- file to make a local containing the format of el_momnodirt 
//COMMAND:

local el_momnodirt_format: f el_momnodirt
display "the format of el_momnodirt is `el_momnodirt_format'"




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

reg free_chl_yn treatw
reg tot_chl_yn treatw
reg endvf treatw

//This will do the exact same thing
foreach var in free_chl_yn tot_chl_yn endvf {
	reg `var' treatw
}

//var is just a placeholder, it could be anything
//Try it yourself! Use another word in place of var.
//COMMAND:

foreach fudge in free_chl_yn tot_chl_yn endvf {
	reg `fudge' treatw
}

//Instead of using foreach fudge in, we can also use foreach fudge of
//This works only with variables
foreach fudge of varlist free_chl_yn tot_chl_yn endvf {
	reg `fudge' treath
}

/*You may notice that the output from inside a loop is not
quite as well documented as from outside a loop
It can be helpful to add display lines explaining where the code is*/
foreach fudge in free_chl_yn tot_chl_yn endvf {
	disp "********This regresses `fudge' on treath**********"
	reg `fudge' treath
}

//Regress each of the below outcome variables individually on treath, using a loop
//Control for whether the respondent has a tin roof, using the variable tinroof
//Outcomes: el_momnodirt el_kidnodirt criticaltimessum elhaveplace elhavemat
//COMMAND: 

foreach var in el_momnodirt el_kidnodirt criticaltimessum elhaveplace elhavemat {
	reg `var' treath tinroof
}


/*When running a long loop, you may want to turn off the --more-- command
This can be done with --set more off--
To do it permanently, you can run --set more off, permanently--*/

/*You can also use the command --set trace on-- to display 
EVERYTHING that goes on when you run a command
This should probably be a last resort, and can be turned off with --set trace off-- */

set trace on
foreach var in el_momnodirt el_kidnodirt criticaltimessum elhaveplace elhavemat {
	reg `var' treath tinroof
}

set trace off

*FORVALUES LOOPS

//What if you want to loop over numbers?
foreach X in 1 2 3 4 5 6 7 8 9 10 {
	disp "The number is `X'
}
//That works, but it's better to do forvalues
forvalues X=1(1)10 {
	disp "The number is `X'."
}

//Now set up a loop to display 1 to 9, display only odd numbers.
//COMMAND: 

forvalues x = 1(2)9 {
	disp "The number is `x'."
}

//You can even loop over numeric values in variable names
forvalues fudge=1/8 {
	reg free_chl_yn treat`fudge'
}

//loop over a list
local watervars endvf free_chl_yn tot_chl_yn

foreach var of local watervars {
	reg `var' treatw
}

//Define a list of the outcome variables below, then loop over them
//Outcomes: el_momnodirt el_kidnodirt criticaltimessum elhaveplace elhavemat
//COMMAND: 

local B el_momnodirt el_kidnodirt criticaltimessum elhaveplace elhavemat
foreach var of local B {
 reg `var' treath
 display "look! it's the variable `var'"
 }


* NESTED LOOPS

forvalues X=1/10 {
	forvalues Y=1/10 {
		disp "X is `X' and Y is `Y' and X*Y is "`X'*`Y'
	}
}

//Regress the water variables over all 8 treatment arms

local wvar free_chl_yn tot_chl_yn endvf 
local i=1 //add an index so we can see how many regs we're doing
foreach var of varlist `wvar'{
	forvalues X=1/8 {
		display "Regression `i':We're regressing `var' on treat`X'"
		local i=`i'+1
		reg `var' treat`X'
	}
}

//Now run two versions of each regression, one with controls and one without
//Include the following variables as controls 
//Controls: tinroof respage1 respage2 respage3 kiswahili english total_households total_kids
//How might you keep track of what's going on within the loop?
//COMMAND: 

local wvar free_chl_yn tot_chl_yn endvf 
global controlvars tinroof respage1 respage2 respage3 kiswahili english total_households total_kids
local i=1 
foreach var of varlist `wvar'{
	forvalues X=1/8 {
		display "Regression `i': We're regressing `var' on treat`X'"
		reg `var' treat`X'
		display "Regression `i': We're regressing `var' on treat`X' with controls"
		reg `var' treat`X' $controlvars
		local i=`i'+1
	}
}




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

global controlvars tinroof respage1 respage2 respage3 kiswahili english total_households total_kids

//First, output to a .txt file
reg free_chl_yn treatw
outreg2 using "$mycomp/Output/regression_results", replace tdec(3) bdec(3) bracket ctitle(Basic) addnote(This table is totally awesome and should be published)

reg free_chl_yn treatw $controlvars
outreg2 using "$mycomp/Output/regression_results", append tdec(3) bdec(3) bracket ctitle(With Controls)

reg free_chl_yn treatw $controlvars, robust
outreg2 using "$mycomp/Output/regression_results", append tdec(3) bdec(3) bracket ctitle(Robust SE)


// Export results to EXCEL

reg free_chl_yn treatw
outreg2 using "$mycomp/Output/regression_results.xls", replace tdec(3) bdec(3) bracket ctitle(Basic) addnote(This table is totally awesome and should be published)

reg free_chl_yn treatw $controlvars
outreg2 using "$mycomp/Output/regression_results.xls", append tdec(3) bdec(3) bracket ctitle(With Controls)

reg free_chl_yn treatw $controlvars, robust
outreg2 using "$mycomp/Output/regression_results.xls", append tdec(3) bdec(3) bracket ctitle(Robust SE)


//Append another regression of free_chl_yn on treatw with controls, using the robust specification and clustering on the villageid
//COMMAND:
 
reg free_chl_yn treatw $controlvars, robust cluster(villageid) 
outreg2 using "$mycomp/Output/regression_results.xls", append tdec(3) bdec(3) bracket ctitle(Clustered) 


//The below does the same thing for a .tex file
//Here, I also use two loops, first over three variables
// Within each variable, we then loop over three specifications (and titles!)

local spec_list `" "$controlvars" "$controlvars, robust" "$controlvars, robust cluster(villageid)" "'
local spec_title `" "With Controls" "Robust SE" "Clustered" "'	

local wvar free_chl_yn tot_chl_yn endvf 

foreach var of varlist `wvar' {
	reg `var' treatw
	outreg2 using "$mycomp/Output/regression_results_`var'.tex", replace tex tdec(3) bdec(3) bracket ctitle(Basic) addnote(This table is totally awesome and should be published)
	
	local j =1
	foreach spec in `spec_list' {
		local title : word `j' of `spec_title'
		reg `var' treatw `spec'
		outreg2 using "$mycomp/Output/regression_results_`var'.tex", append tex tdec(3) bdec(3) bracket ctitle("`title'")
		local j = `j' + 1
	}
}

