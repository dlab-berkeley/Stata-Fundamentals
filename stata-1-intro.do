// Review of Stata interface
// Results window
// Command window

* Load a sample dataset.
* File -> Open
use "/home/ck37/data/rugged_data.dta"

// Variables window
// Review window
// Data browser

* How many observations are in this dataset?
count

* What variables are in this dataset?
describe

* Can we describe just a few variables?
describe rugged cont_africa cont_asia

* What do the values of the variables look like?
summarize

* Can we summarize just a few variables?
summarize rugged cont_africa cont_asia

* List all of the variables and values.
list
// (Show space and q for the "more" command)

* Disable the pause feature.
set more off

* Retry listing without the pause.
list

* List a subset of variables.
list rugged  cont_africa cont_asia

* tab
* tab1
* cross-tab

// Let's create a new do file.
// File -> New -> Do File
// [Copy and Paste previous commands into do-file.]
// Execute do file.

* Set a project directory.
cd C:\Users\garret\Documents\Teaching\DLabStata

* Check the current working diretory.
pwd

* Load our dataset.
use rugged_data.dta

* Disable the "more" feature.
set more off 

// There are a bunch of ways to comment your .do file.

* You can also just put an asterisk at the beginning of a line
// but that's not quite as cool as the two slashes.

/* But then say you wanted to write a really long
and super informative comment that you didn't want 
to have all on one line, like this one we're typing
right now. */

* Start a log file.
// File -> Log -> Begin
log using stata_intro.log

* Then close the log file at the end of the do file.
log close

* Let's try it one more time.
log using stata_intro.log

* We need to use the replace option if the log file already exists.
log using stata_intro.log, replace

* Also, we may want to close any existing log files first.
capture log close


* Let's start doing a little data analysis.

* Missing values

// Use multiple logical test on the same line
summ rugged if cont_africa //if cont_africa !=0
summ rugged if cont_africa==1 //we'll get the same thing because this is binary
*summ rugged if rugged_pc
summ rugged if cont_africa==1|cont_asia==1
summ rugged if cont_africa!=1 & cont_asia~=1

summ rugged if cont_africa==1 | cont_asia==1 & cont_europe!=1

// Let's create variables
// one way to do it
gen cont_aforas=1 if cont_africa==1|cont_asia==1
replace cont_aforas=0 if cont_africa!=1&cont_asia!=1
// another way to do the same thing
gen cont_aforas2=(cont_africa==1|cont_asia==1)

// a third way, often helpful with missing values
gen cont_aforas3=.
replace cont_aforas3=1 if cont_africa==1|cont_asia==1
replace cont_aforas3=0 if cont_africa!=1&cont_asia!=1

// Let's look at the rule of law
summ q_rule_law
count if q_rule_law>2 //this includes the missings
count if q_rule_law>2 & q_rule_law<. //this doesn't

gen awesomelaw=(q_rule_law>1.5) //this isn't the best

gen awesomelaw2=(q_rule_law>1.5 & q_rule_law<.) //this should work
gen awesomelaw3=(q_rule_law>1.5 & q_rule_law!=.) //this is the same
// Stata also uses .a through .z for different missing values
// which, if you think about it, means that awesomelaw2 is better than awesomelaw3
label var awesomelaw "rule of law higher than 1.5"
label var awesomelaw2 "rule of law >1.5 and not missing"
label var awesomelaw3 "just some weird third way of doing it"

* This should be "order"
move awesomelaw cont_africa
move awesomelaw2 cont_africa
move awesomelaw3 cont_africa

save "this is the new file.dta", replace

export delimited using "comma-separated version.csv", replace
export delimited using "tab-separated text version.tsv", replace delimiter(tab)

* import delimited

export excel using "this is the excel version.xlsx", firstrow(variables) replace

* import excel

*reg y x1 x2 x3 
reg rgdppc_2000 soil tropical cont_africa
reg rgdppc_2000 soil tropical cont_africa, robust
reg rgdppc_2000 soil tropical cont_africa, robust cluster(cont_asia)

histogram rgdppc_2000

scatter soil tropical

twoway (scatter soil tropical)(lfit soil tropical)

* Imputing values.
* Save the order (_n)
* Set seed
* Generate random number
* Sort by random number
* Create treatment/control.
* Check balance
* Gsort
