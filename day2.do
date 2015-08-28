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


exit
desc
tab cont_africa
list cont_africa
count
sort isocode
