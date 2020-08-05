******************************* 
*	STATA INTENSIVE: WORKSHOP 3
*	SPRING 2020, D-LAB
********************************

/*This do file is based on the same materials as workshop 3, and is written 
	to be run concurrently. If you are running it independently, un-comment 
	the following lines and run them.*/
	
*cd "/Users/isabellecohen/Dropbox/DLab/Stata Fundamentals III" // change to your own working directory

/* EXERCISE 1: RESHAPING AND MERGING
	Rather than merging nlsw88_childvars into nlsw88_wave1and2 and then reshaping,
	we could instead have first reshaped nlsw88_childvars, and then done a
	many-to-one merge. Let's try that now!*/

/*Question 1.1: Open up nlsw88_childvars, and reshape it to long format*/

use nlsw88_childvars, clear
reshape long childage, i(idcode) j(childidcode)


/*Question 1.2: Merge nlsw88_wave1and2 (using) into nlsw88_childvars (master)
	using a many-to-one syntax*/

merge m:1 idcode using nlsw88_wave1and2

/*Question 1.3 (CHALLENGE): We want this data to be organized at the woman-child 
	level, meaning we should have a number of observations for each woman matching
	the number of children she has.
	1.3.1: How many observations are there initially?
	1.3.2: How could you check if there are women with extra observations? 
		(note: there are many ways to 'answer' this question)
	1.3.3: Can you find a way to drop observations for "fake" (created by the reshape)
		child observations?
	1.3.4: What is the correct number of observations in the end?*/

*1.3.1
count // 12,635 observations
unique idcode // this user-written command will tells us there should be 3167 women

*1.3.2
br idcode child_num // this simple code is one way (of many) of seeing many women have "extra" observations

*1.3.3
// We need to tackle this in two parts, separately for women with and without children
// with children:
drop if childage==. & child_num>0 & child_num<. // these are children that "don't exist" but are created by the reshape
// without children/didn't merge
drop if (child_num==0 | child_num==.) & childidcode>1 & _merge!=2 // this keeps one observation per woman without a child

*1.3.4
count // 6,568 obserations
unique idcode // still 3167

/*EXERCISE 2: LOCALS AND LOOPS
	Let's use nlsw88_complete to explore locals and loops further! Let's imagine we want to
	make a "dictionary" from this dataset, or print on the screen some information
	about each of the variables in the data.

	In this exercise, we'll focus on ttl_exp, tenure, south and smsa.*/

/*Question 2.1: Use the --help extended_fcn-- file to make a local containing 
	the variable label of ttl_exp, and display it.*/

local lbl : var label ttl_exp
display "The variable label of ttl_exp is `lbl'."

/*Question 2.2: Make a loop which goes over ttl_exp, tenure, south and smsa and
	lists the variable label for each one.*/

foreach var of varlist t* s* {
	local lbl : var label `var'	
	display "The variable label of `var' is `lbl'."
}

/*Question 2.3: Display the sentence - using locals and extended functions, not words
	- in the following format: "ttl_exp (float) contains the total work experence for each
	woman in the dataset." */
 
local lbl : var label ttl_exp
local type : type ttl_exp
display "ttl_exp (`type') contains `lbl' for each woman in the dataset."
 
/*Question 2.4: Make a loop which takes your sentence above, and fills it in for
	ttl_exp, tenure, south and smsa. Put a number at the beginning of each sentence
	which updates by one every time your loop runs*/

local x=1
foreach var of varlist t* s* {
	local lbl : var label `var'	
	local type : type ttl_exp
	display "`x'. `var' (`type') contains `lbl' for each woman in the dataset."
	local x = `x' + 1
}

/*Question 2.5 (CHALLENGE): Write a loop which produces the exact same results, 
	but this time use a forvalues loop to loop over the numbers 1 to 4 to do so.

	Hint: check the extended function help file and look at "word # of string".*/

local var_list ttl_exp tenure south smsa
forvalues x=1/4 {
	local var : word `x' of `var_list'
	local lbl : var label `var'	
	local type : type ttl_exp
	display "`x'. `var' (`type') contains `lbl' for each woman in the dataset."
}
