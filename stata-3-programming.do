********************************
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
