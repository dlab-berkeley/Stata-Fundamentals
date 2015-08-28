clear all
cd C:\Users\garret\Documents\Teaching\DLabStata
use rugged_data.dta
set more off 

/*
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

*histogram rgdppc_2000

*scatter soil tropical

*twoway (scatter soil tropical)(lfit soil tropical)

**************************************************
* Day 2
**************************************************
*CORRELATION
corr soil tropical
corr soil tropical desert dist_coast

*T-TESTS
ttest soil, by(cont_africa)
return list //get the list of stored results

*REGRESSION AND ITS OUPUT
reg rgdppc_2000 soil tropical cont_africa
return list //doesn't get you much
ereturn list //there, that's better
disp e(F) //print a value to the screen
disp 4+4 //check our math
disp _b[soil] //This is the soil coefficient
disp "The beta coefficient is "_b[soil] //Mixing words and stored values

disp "Soil's standard error is "_se[soil]
*disp "Soil's variance is "_V[soil] Nope, this doesn't work

//What are the system variables?
count
disp "There are "_N " observations" 

reg rgdppc_2000 soil tropical cont_africa, robust
reg rgdppc_2000 soil tropical cont_africa if awesomelaw2==1, robust 
//note if comes before the comma
//Stata drops multi-colinears for you.

reg rgdppc_2000 soil tropical cont_africa if cont_europe!=1, robust
reg rgdppc_2000 soil tropical cont_africa if cont_europe!=1&cont_north_america!=1, robust
*reg crime somelaw [aweight=countypop], robust //for weighted regressions
reg rgdppc_2000 soil tropical cont_africa [aweight=pop_1400] //wow, those are different coeffs

reg rgdppc_2000 soil desert tropical dist_coast q_rule_law cont_africa cont_asia cont_europe cont_oceania cont_north_america legor_gbr legor_fra legor_soc legor_deu colony_esp colony_gbr colony_fra colony_prt
//that works, but it's ugly.

reg rgdppc_2000 soil desert tropical dist_coast q_rule_law cont_africa cont_asia ///
cont_europe cont_oceania cont_north_america legor_gbr legor_fra legor_soc legor_deu ///
 colony_esp colony_gbr colony_fra colony_prt
// Three backticks gets you multiple lines in the same command

*A second way:
#delimit ;
summ cont_africa;
tab cont_africa;
tab cont_africa cont_asia;
reg rgdppc_2000 soil desert tropical dist_coast q_rule_law cont_africa cont_asia
cont_europe cont_oceania 
cont_north_america legor_gbr legor_fra legor_soc legor_deu
colony_esp colony_gbr colony_fra colony_prt

;
//That's not the prettiest either, but it's illustrating the point of ;'s
#delimit cr

//help regress //get the help file
//mansection R regress //get the even better manual file

**************************************************
* PLOTTING
**********************************************
*HISTOGRAM

*histogram soil
*histogram soil, discrete //don't actually do this
*histogram soil, bin(5)
*histogram soil, width(2)
*histogram soil, bin(10) title("This is a histogram of soil fertility") 
*histogram soil, bin(10) title("This is a histogram of soil fertility") addlabels
*histogram soil, bin(10) title("This is a histogram of soil fertility") ///
*addlabels xtitle("Fudge?")
*histogram soil if soil!=0, bin(10) title("This is the histogram without zeroes") ///
*addlabels

*SCATTERPLOT
*scatter soil tropical
*scatter soil tropical, title("Soil Fertility vs. Tropical Land") legend(on)
*scatter soil desert tropical, title("Soil and Desert by Tropical Land") legend(on) mcolor(black blue)
*scatter soil desert tropical, title("Soil and Desert by Tropical Land") legend(on) scheme(economist)
*scatter soil desert tropical, title("Soil and Desert by Tropical Land") legend(on) mcolor(black blue) xlabel(0(20)100, format(%2.0f)) ylabel(,format(%2.0f))

*COMBINE GRAPHS
/*twoway (scatter soil desert tropical, title("Soil and Desert by Tropical Land") ///
legend(on) xlabel(0(20)100, format(%2.0f)) ylabel(,format(%2.0f))) ///
(lfit soil tropical) (lfit desert tropical)*/

/*twoway (scatter soil desert tropical, title("Soil and Desert by Tropical Land") ///
legend(on) xlabel(0(20)100, format(%2.0f)) ylabel(,format(%2.0f))) ///
(lfit soil tropical) (lfit desert tropical, xline(40))*/


******************************************
*MERGE DATA FILES
******************************************
*1 Merge Garret's two WASH B Files
*2 Merge your own two datasets
*3 Append your own two datasets

count //how many obs?

*FIRST, APPEND
datasignature set //Let's observe the state of the data right now
preserve //saves the state of the data temporarily
keep if _n <115
save firsthalfofdata.dta, replace
restore // go back to the preserved state

keep if _n>=115
save secondhalfofdata.dta, replace

//Let's put these data back together, starting with a blank set.
clear all
use firsthalfofdata.dta
count
append using secondhalfofdata.dta
count
datasignature confirm

******************************************
*SECOND APPEND WITH MISSING VARS
****************************************
datasignature set, reset //Let's observe the state of the data right now
preserve //saves the state of the data temporarily
keep if _n <115
save firsthalfofdata.dta, replace
restore // go back to the preserved state

keep if _n>=115
drop soil
save secondhalfofdataXS.dta, replace

//Let's put these data back together, starting with a blank set.
clear all
use firsthalfofdata.dta
count
append using secondhalfofdataXS.dta
count
*datasignature confirm

********************************************
*MERGE DATASETS
*******************************************
use WASHdlab.dta, clear //this is individual level data
merge m:1 villageid using VillagePop
count

*This is a little boring because it merged perfectly.
*Drop ~10 variables from the Village dataset, save with new file name.
*Do the same merge as above, but with new file, see what happens.

use VillagePop, clear
drop if _n<10
save VillagePopX10.dta, replace

use WASHdlab.dta, clear
merge m:1 villageid using VillagePopX10.dta
count
rename _merge merge_indi_villageX10 //rename _merge so you can merge again later w/o error


*********************************
* DAY 3
*********************************
webuse reshape1, clear //load a practice dataset off the web
list //print the data to the screen
reshape long inc ue, i(id) j(year) 
*reshape long inc, i(id) j(year) //this works, but gives you a weird mix
*moves data from wide to long format
reshape wide //once changed, it's easy to change back
reshape long //it's also easy to change back-back.

use military.dta, clear
reshape wide monthcounty stateunemp countyunemp ///
monthcountydeath outofstate outofcounty L1outofstate ///
L1monthcountydeath L1outofcounty active, i(fips) j(month)
/*make this wide format. change the variable mounthcountydeath
and active. i() needs the NEW identifier, and there will be
one variable for every j()--in our case, month*/
/*Note that you must put in _every_ variable that's not
constant across fips. PctBush04 and population ARE constant
so we don't need to reshape them.*/

//but that's actually a quite unwieldy format, so let's go back
reshape long
*/
******************************
*LOCALS AND GLOBALS, AKA MACROS
******************************
local i=1
disp `i'
disp "The local called i has the value `i'"
* OK, now i has increased by 2.
local i=`i'+2
disp "I is now `i'"

*Let's use WASHBdlab
use WASHdlab.dta
summ free_chl_yn tot_chl_yn
return list

*Let's calculate the ratio of average levels of chlorine
summ free_chl_yn
local free=r(mean)

summ tot_chl_yn
local tot=r(mean)

local ratio=`free'/`tot'
disp "The ratio of free to total chlorine is `ratio'"

*check it
disp .2118126/.2505092

*GLOBAL
*Considered bad form in programming, use sparingly.
*Easy list of long set of variable names
*Set the file path name for different computers

global garret="C:\Users\garret\Documents\Teaching\DLabStata"
cd $garret
*put this at the top of a shared do file

*************************************
*LOOPS
*************************************
reg free_chl_yn treatw
reg tot_chl_yn treatw
reg endvf treatw

//This will do the exact same thing
foreach var in free_chl_yn tot_chl_yn endvf{
reg `var' treatw
}

//var is just a placeholder, it could be anything
foreach fudge in el_momnodirt el_kidnodirt criticaltimessum elhaveplace elhavemat{
reg `fudge' treath
}

//You may notice that the output from inside a loop is not
//quite as well documented as from outside a loop
//So I find it helpful to add display lines explaining where I am
foreach fudge in el_momnodirt el_kidnodirt criticaltimessum elhaveplace elhavemat{
disp "********This regresses `fudge' on treath**********"
reg `fudge' treath
}

*forvalues loops over numbers
foreach X in 1 2 3 4 5 6 7  8 9 10 {
disp "The number is `X'
}
//That works, but it's better to do forvalues
forvalues X=1(2)10 {
disp "The number is `X'
}

//loop over numeric values in variable names
forvalues fudge=1/8 {
 reg free_chl_yn treat`fudge'
}
*************************
*If you want a local that is formatted for very nice display,
*see FROM http://www.stata.com/statalist/archive/2011-05/msg00269.html

//loop over a list
local watervars endvf free_chl_yn tot_chl_yn

foreach var of local watervars{
 reg `var' treatw
}

//try it with hygiene variables
label var el_momnodirt "Do mom's hands have no dirt? Y/N"
label var el_kidnodirt "Do kid's hands have no dirt? Y/N"
label var criticaltimessum "Number of critical hw times named w/o prompting"
label var elhaveplace "Do they have dedicated place for hw? Y/N"
label var elhavemat "Do they have materials-soap/water-for hw? Y/N"

local hvar el_momnodirt el_kidnodirt criticaltimessum elhaveplace elhavemat
foreach var of local hvar{
 reg `var' treath
}

*Nested Loops
forvalues X=1/10 {
 forvalues Y=1/10 {
  disp "X is `X' and Y is `Y' and X*Y is "`X'*`Y'
 }
}

*Regress both lists (hygiene and water) over all 8 treatment arms
*Can Stata loop over multiple lists? Unclear.
*Can Stata combine lists into master list? Also unclear.

local masterlist el_momnodirt el_kidnodirt criticaltimessum elhaveplace elhavemat endvf free_chl_yn tot_chl_yn
local i=1 //add an index so we can see how many regs we're doing

/*
foreach fudge of local masterlist{
 forvalues X=1/8 {
  display "Regression `i':We're regressing `var' on treat`X'"
  local i=`i'+1
  reg `fudge' treat`X'
 }
}
*/

*I bet we can do the two loops with globals, though
global RHS_controls="tinroof respage1 respage2 respage3 kiswahili english total_households total_kids"
reg free_chl_yn treatw $RHS_controls

*Can we loop over multiple globals? Apparently not.
/*
global wvars="endvf free_chl_yn tot_chl_yn"
global hvars="el_momnodirt el_kidnodirt criticaltimessum elhaveplace elhavemat"
foreach fudge of $wvars $hvars{
 forvalues X=1/8 {
  display "Regression `i':We're regressing `var' on treat`X'"
  local i=`i'+1
  reg `fudge' treat`X'
 }
}
*/

*******************************
*Let's do nice regression output, looped
********************************
*findit outreg2
reg free_chl_yn treatw
outreg2 using prettyoutput, replace tdec(3) bdec(3) bracket ctitle(Basic) addnote(This table is totally awesome and should be published)

reg free_chl_yn treatw $RHS_controls
outreg2 using prettyoutput, append tdec(3) bdec(3) bracket ctitle(With Controls)

reg free_chl_yn treatw $RHS_controls, robust
outreg2 using prettyoutput, append tdec(3) bdec(3) bracket ctitle(Robust SE)

reg free_chl_yn treatw $RHS_controls, robust cluster(villageid) 
outreg2 using prettyoutput, append tdec(3) bdec(3) bracket ctitle(Clustered) 

*Now let's make it in TeX
reg free_chl_yn treatw
outreg2 using prettyoutput, replace tex tdec(3) bdec(3) bracket ctitle(Basic) addnote(This table is totally awesome and should be published)

reg free_chl_yn treatw $RHS_controls
outreg2 using prettyoutput, append tex tdec(3) bdec(3) bracket ctitle(With Controls)

reg free_chl_yn treatw $RHS_controls, robust
outreg2 using prettyoutput, append tex tdec(3) bdec(3) bracket ctitle(Robust SE)

reg free_chl_yn treatw $RHS_controls, robust cluster(villageid) 
outreg2 using prettyoutput, append tex tdec(3) bdec(3) bracket ctitle(Clustered) 


//local `var'lab: var label `var'  //How to make a local of a variable label
//macro list //list all the macros
//macro drop all //drop all the macros

exit
desc
tab cont_africa
list cont_africa
count
sort isocode
