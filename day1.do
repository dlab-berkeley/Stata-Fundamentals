clear all
cd C:\Users\garret\Documents\Teaching\DLabStata
use rugged_data.dta
set more off 

//There are a bunch of ways to comment your .do file.

*You can also just put an asterisk at the beginning of a line
capture log close //but that's not quite as cool as the two slashes
log using Stata_Intensive_Log.smcl, replace

/* But then say you wanted to write a really long
and super informative comment that you didn't want 
to have all on one line, like this one we're typing
right now. */

//Use multiple logical test on the same line
summ rugged if cont_africa //if cont_africa !=0
summ rugged if cont_africa==1 //we'll get the same thing because this is binary
*summ rugged if rugged_pc
summ rugged if cont_africa==1|cont_asia==1
summ rugged if cont_africa!=1 & cont_asia~=1

summ rugged if cont_africa==1 | cont_asia==1 & cont_europe!=1

//Let's create variables
//one way to do it
gen cont_aforas=1 if cont_africa==1|cont_asia==1
replace cont_aforas=0 if cont_africa!=1&cont_asia!=1
//another way to do the same thing
gen cont_aforas2=(cont_africa==1|cont_asia==1)

//a third way, often helpful with missing values
gen cont_aforas3=.
replace cont_aforas3=1 if cont_africa==1|cont_asia==1
replace cont_aforas3=0 if cont_africa!=1&cont_asia!=1

//Let's look at the rule of law
summ q_rule_law
count if q_rule_law>2 //this includes the missings
count if q_rule_law>2 & q_rule_law<. //this doesn't

gen awesomelaw=(q_rule_law>1.5) //this isn't the best

gen awesomelaw2=(q_rule_law>1.5 & q_rule_law<.) //this should work
gen awesomelaw3=(q_rule_law>1.5 & q_rule_law!=.) //this is the same
//Stata also uses .a through .z for different missing values
//which, if you think about it, means that awesomelaw2 is better than awesomelaw3
label var awesomelaw "rule of law higher than 1.5"
label var awesomelaw2 "rule of law >1.5 and not missing"
label var awesomelaw3 "just some weird third way of doing it"

move awesomelaw cont_africa
move awesomelaw2 cont_africa
move awesomelaw3 cont_africa

save "this is the new file.dta", replace 
export excel using "this is the excel version.xlsx", firstrow(variables) replace
outsheet using "this is the text version.txt", replace

*reg y x1 x2 x3 
reg rgdppc_2000 soil tropical cont_africa
reg rgdppc_2000 soil tropical cont_africa, robust

histogram rgdppc_2000

scatter soil tropical

twoway (scatter soil tropical)(lfit soil tropical)


exit
desc
tab cont_africa
list cont_africa
count
sort isocode
