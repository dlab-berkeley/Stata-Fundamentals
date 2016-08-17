********************************
* DAY 3
*********************************

*FOR profile.do*

pwd

*then save profile.do in pwd*

*FOR FREE STATA**

*visit https://citrix.berkeley.edu

**FOR EXCERCISE**

use http://www.ats.ucla.edu/stat/stata/examples/ara/chile

********************************************
*MERGE DATASETS
*******************************************

use VillagePop, clear

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

********************************************
*RESHAPE DATASETS
*******************************************

use military.dta, clear

describe

tab month

br if fips==1001

drop L1outofstate L1monthcountydeath L1outofcounty monthcounty

reshape wide stateunemp countyunemp ///
monthcountydeath outofstate outofcounty active, i(fips) j(month)

gen recruit_change = (active200607 - active200110) / active200110

**GOOGLE "combine graphs stata ucla"**

twoway (scatter PctBush04 recruit_change)(lfit PctBush04 recruit_change),  name(recruit_all) 

twoway (scatter PctBush04 recruit_change)(lfit PctBush04 recruit_change) if recruit_change>0,   name(recruit_grow) 

twoway (scatter PctBush04 recruit_change)(lfit PctBush04 recruit_change) if recruit_change<0,   name(recruit_fall) 

graph combine recruit_all recruit_grow recruit_fall

graph save combined_recruit_bush.gph, replace

graph export combined_recruit_bush.pdf, replace

reshape long stateunemp countyunemp ///
monthcountydeath outofstate outofcounty active, i(fips) j(month)

********************************************
*EDIT STRINGS

*see http://econweb.tamu.edu/jnighohossian/tools/stata/strings.htm
*and 
********************************************

tostring fips month, generate(fipsstring monthstring)

gen monthcounty=monthstring + fipsstring

describe fipsstring

replace fipsstring="0"+fipsstring if length(fipsstring)==4

replace monthcounty=monthstring + fipsstring

gen statefips=substr(fipsstring, 1,2)
gen countycd=substr(fipsstring, 3,5)
gen state="   ALABAMA  ,&/  " if statefips=="01"
replace state=regexr(state, ",", "")
replace state=regexr(state, "&/", "")
replace state=ltrim(state)
replace state=rtrim(state)
replace state=lower(state)
replace state=upper(state)
replace state=proper(state)

********************************************
*COLLAPSE DATASETS
*******************************************

use rugged_data, clear

gen continent =1 if cont_africa==1
replace continent =2 if cont_asia ==1
replace continent =3 if cont_europe ==1
replace continent =4 if cont_oceania ==1
replace continent =5 if cont_north_america ==1
replace continent =6 if cont_south_america ==1
label define continent 1 "Africa" 2 "Asia" 3 "Europe" 4 "Oceania" 5 "North America" 6 "South America" 

gen cont_nm ="Africa" if continent==1
replace cont_nm ="Asia" if continent==2
replace cont_nm ="Europe" if continent==3
replace cont_nm ="Oceania" if continent==4
replace cont_nm ="North America" if continent==5
replace cont_nm ="South America" if continent==6

preserve

collapse (first) cont_nm (sum) land_area gemstones slave_exports pop_1400 ///
(mean) rgdppc_2000 rgdppc_1950_m q_rule_law [aweight=pop_1400], by(continent)

restore

******************************
*LOCALS AND GLOBALS, AKA MACROS
** see explanation here: http://www.stata.com/statalist/archive/2008-08/msg01258.html**

/*A macro in Stata is a named object that holds a single string value.
Macros thus have names and contents. 

The string can consist of numeric characters. Thus holding a string "42"
is a way to hold the corresponding number 42. Users of such macros tend
to think of them as containing numeric values.

-local- that defines a local macro and
to the fact that such macros are only visible locally, meaning within
the same program, do file, do-file editor contents or interactive
session

-global- that defines a global macro
and to the fact that such macros are visible everywhere, or globally,
meaning within any program, do file, or do-file editor contents and
within an interactive session.  
*/

******************************
local i=1
disp `i'
disp "The local called i has the value `i'"
* OK, now i has increased by 2.
local i=`i'+2
disp "I is now `i'"

*Let's use WASHBdlab
use rugged_data.dta, clear

*************************************
*LOOPS
*************************************

reg rgdppc_2000 rugged
reg rgdppc_2000 tropical soil
reg rgdppc_2000 soil

//This will do the exact same thing
foreach var in rugged tropical soil {
reg rgdppc_2000 `var'
}

//var is just a placeholder, it could be anything
foreach thingy in rugged tropical soil {
reg rgdppc_2000 `thingy'
}

//You may notice that the output from inside a loop is not
//quite as well documented as from outside a loop
//So I find it helpful to add display lines explaining where I am
foreach thingy in rgdppc_2000 {
disp "********This regresses `thingy' on rgdppc_2000**********"
reg `thingy' treath
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
forvalues thingy=1/6 {
 reg rgdppc_2000 rugged if continent==`thingy'
}
*************************
*If you want a local that is formatted for very nice display,
*see FROM http://www.stata.com/statalist/archive/2011-05/msg00269.html

//loop over a list
local continentvars cont_africa cont_asia cont_europe cont_oceania cont_north_america cont_south_america

foreach cont_ind of local continentvars {
 reg rgdppc_2000 rugged  if `cont_ind'==1
}

*Nested Loops
foreach var in rugged tropical soil {
 forvalues continentvals=1/6 {
  reg rgdppc_2000 `var' if continent==`continentvals'
 }
}

*

*******************************
*Let's do nice regression output, looped
********************************
findit outreg2

reg rgdppc_2000 rugged tropical soil
outreg2 using prettyoutput, word excel replace tdec(3) bdec(3) bracket ctitle(Basic) addnote(This table is totally awesome and should be published)

reg rgdppc_2000 rugged tropical soil
outreg2 using prettyoutput, word excel append tdec(3) bdec(3) bracket ctitle(With Controls)

reg rgdppc_2000 rugged tropical soil, robust
outreg2 using prettyoutput, word excel append tdec(3) bdec(3) bracket ctitle(Robust SE)

reg rgdppc_2000 rugged tropical soil, robust cluster(continent) 
outreg2 using prettyoutput, word excel append tdec(3) bdec(3) bracket ctitle(Clustered) 

*Now let's make it in TeX
reg rgdppc_2000 rugged tropical soil
outreg2 using prettyoutput, tex replace tdec(3) bdec(3) bracket ctitle(Basic) addnote(This table is totally awesome and should be published)

reg rgdppc_2000 rugged tropical soil
outreg2 using prettyoutput, tex append tdec(3) bdec(3) bracket ctitle(With Controls)

reg rgdppc_2000 rugged tropical soil, robust
outreg2 using prettyoutput, tex append tdec(3) bdec(3) bracket ctitle(Robust SE)

reg rgdppc_2000 rugged tropical soil, robust cluster(continent) 
outreg2 using prettyoutput, tex append tdec(3) bdec(3) bracket ctitle(Clustered) 

