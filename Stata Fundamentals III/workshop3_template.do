******************************* 
*	Stata Intensive: Workshop 3
*	Spring 2017, D-LAB
*	Isabelle Cohen
********************************

**************************************************
* Day 3

* Outline:
* I. 	MERGING
* II.	RESHAPING	
* III.	MACROS
* IV.	LOOPS
* V. 	EXPORTING RESULTS

**************************************************

*Setting do-file basics:
//We want to set a "global" like the one below, to store the file path to today's data
*global mycomp "/Users/isabellecohen/Desktop/DLab/Stata Fundamentals III" // for my computer

//To set yours, manually open the data called "WASHdlab.dta" from your computer
//Do not use the stata menu; instead, find the file in your files, and double-click to open it
//Then run:
global mycomp : pwd

//Check if it worked
display "$mycomp"

**********************************************
* I. 	MERGING
**********************************************
*Load data
use "$mycomp/WASHdlab.dta", clear

count //how many obs?

*APPEND DATASETS
datasignature set //Let's observe the state of the data right now
//Note: the below needs to be run as a block, through restore
preserve //saves the state of the data temporarily
keep if _n <115
save "$mycomp/firsthalfofdata.dta", replace
restore // go back to the preserved state

keep if _n>=115
save "$mycomp/secondhalfofdata.dta", replace

//Let's put these data back together, starting with a blank set.
clear all
use "$mycomp/firsthalfofdata.dta"
count
append using "$mycomp/secondhalfofdata.dta"
count
datasignature confirm

*MERGE DATASETS
use "$mycomp/WASHdlab.dta", clear
set seed 12345678
bys villageid: gen subid=_n // this data lacks a subid id indicator, so we create one
isid villageid subid

//Note: the below needs to be run as a block, through merge
preserve
keep villageid subid Endd2a_primary_source_type
tempfile primarysource
save `primarysource'
restore

drop Endd2a_primary_source_type

merge 1:1 villageid subid using `primarysource' //one-to-one merge
rename _merge _merge_primarysource //rename _merge so you can merge again later w/o error

//Let's try a more interesting example, combining different levels of data
merge m:1 villageid using "$mycomp/VillagePop.dta" //many-to-one merge
count

//This is a little boring because it merged perfectly.
//Drop ~10 variables from the Village dataset, save with new file name.
//Do the same merge as above, but with new file, see what happens.

use "$mycomp/VillagePop.dta", clear
drop if _n<10
save "$mycomp/VillagePopX10.dta", replace

//Now open the WASHdlab data, and merge in the VillagePopX10.dta file
//COMMAND:
use "$mycomp/WASHdlab.dta", clear
merge m:1 villageid using "$mycomp/VillagePopX10.dta"
rename _merge _merge_villagepopx10

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

//Now go back
//COMMAND:
reshape long 


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

//Let's use WASHBdlab
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

local ratio=`free'/`tot'
local ratio2=round(`free'/`tot',.001)
disp "The ratio of free to total chlorine is `ratio'; rounded, `ratio2'"

//Let's check the math
disp .2118126/.2505092

//There are a number of built in commands Stata can use to make locals
local el_momnodirt_lab: var label el_momnodirt
display "The variable label for el_momnodirt is `el_momnodirt_lab'."

//Use the --help extended_fcn-- file to make a local containing the format of el_momnodirt 
//COMMAND:
local el_momnodirt_format: format el_momnodirt
display "The format for el_momnodirt is `el_momnodirt_format'."

local el_momnodirt_type: type el_momnodirt
display "The type for el_momnodirt is `el_momnodirt_type'."

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
foreach fudge of varlist el_momnodirt el_kidnodirt criticaltimessum elhaveplace elhavemat {
	reg `fudge' treath tinroof
}

/*When running a long loop, you may want to turn off the --more-- command
This can be done with --set more off--
To do it permanently, you can run --set more off, permanently--*/

/*You can also use the command --set trace on-- to display 
EVERYTHING that goes on when you run a command
This should probably be a last resort, and can be turned off with --set trace off-- */

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
forvalues X=1(2)9 {
	disp "The number is `X'."
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

local outcomes el_momnodirt el_kidnodirt criticaltimessum elhaveplace elhavemat
foreach var of local outcomes {
	reg `var' treatw
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
		display "Regression `i': We're regressing `var' on treat`X'"
		
		reg `var' treat`X'
		
		local i=`i'+1
	}
}

//Now run two versions of each regression, one with controls and one without
//Include the following variables as controls 
//Controls: tinroof respage1 respage2 respage3 kiswahili english total_households total_kids
//How might you keep track of what's going on within the loop?
//COMMAND: 

local wvar free_chl_yn tot_chl_yn endvf 
local controls tinroof respage1 respage2 respage3 kiswahili english total_households total_kids
local i=1 
foreach var of varlist `wvar'{
	forvalues X=1/8 {
		display "Regression `i': We're regressing `var' on treat`X'"
		
		reg `var' treat`X'
		
		reg `var' treat`X' `controls'
		
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
//ssc install outreg2

global controlvars tinroof respage1 respage2 respage3 kiswahili english total_households total_kids

//First, output to a .txt file
reg free_chl_yn treatw
outreg2 using "$mycomp/Output/regression_results", replace tdec(3) bdec(3) bracket ctitle(Basic) addnote(This table is totally awesome and should be published)

reg free_chl_yn treatw $controlvars
outreg2 using "$mycomp/Output/regression_results", append tdec(3) bdec(3) bracket ctitle(With Controls)

reg free_chl_yn treatw $controlvars, robust
outreg2 using "$mycomp/Output/regression_results", append tdec(3) bdec(3) bracket ctitle(Robust SE)

//Append another regression of free_chl_yn on treatw with controls, using the robust specification and clustering on the villageid
//COMMAND:
reg free_chl_yn treatw $controlvars, vce(cluster villageid)
outreg2 using "$mycomp/Output/regression_results", append tdec(3) bdec(3) bracket ctitle(Clustered SE)

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

