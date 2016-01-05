# D-Lab Stata Cheatsheet
Chris Kennedy - University of California, Berkeley – January 2016

**_In Progress_**

## 1. Introduction to Stata

[Review of Stata Window]

use “your_file.dta”, clear – open a dataset.

clear – unload the current data from memory.

Ctrl-r – keyboard shortcut to quickly go back to a previous command.

count – report the total number of observations in the dataset.

describe  - list the variables, total observations, and variable types & labels.

summarize – show the mean, median, max, min of one or more variables.

tab my_var – show a breakdown of values for one or two variables.

tab1 my_var1 my_var2 – shows separate breakdowns for multiple variables.

list – display all observations in the dataset.

pwd – show the current working directory.

cd “other_directory/” – change the working directory to another directory.

set more off – disable the pause feature when showing multiple pages of output.

log using “my_log.log”, replace – start a log file, and overwrite the file if it already exists.

log close – stop logging (put at the very end of your .do file).

gen new_var = 5 – create a new variable and set is value.

replace new_var = 4 – update the value of an existing variable.

rename

save “my_data.dta”, replace – save the current data to a file, overwriting any existing file.

histogram myvar – plot a histogram of a variable.

scatter var1 var2 – scatterplot of two variables.

help – get information about a command

export delimited

import delimited

export excel

import excel

label var

clonevar

label values

order

_n

sort

set seed

set sortseed

gen rand = runiform()

drop

keep

compress

display “Some output” – output a message.


## 2. Stata Data Analysis

findit mdesc – search for a user-written command that could be installed

ssc install mdesc – install a user-written command from the Stata software archive.

mdesc

corr

ttest

reg indep_var depvar1 depvar2 – fit an OLS regression.

reg indep_var depvar1 depvar2, robust – fit an OLS and use robust standard errors.

reg indep_var depvar1 depvar2, r cluster(village_id) – OLS with robust clustered SEs.

twoway (scatter) (lfit)

predict

logit

logit, nolog

append

merge

by

bysort

egen

gsort

preserve

restore

xi

factor variables

interaction terms

outreg2

graph export

f-test

date processing

round()

floor()

ceil()

## 3. Stata Programming

quietly

capture log close – close an open log file if it exists, and if not ignore the error message.

return list

ereturn list

local myvar = 1

global myvar = 1

egen

foreach var in var1 var2 var {
}

forvalues var in 1/10 {
}

confirm numeric

reshape

graph combine

datasignature set

datasignature confirm

duplicates report

duplicates tag

duplicates drop


## 4. Advanced Stata Programming

matrix

matrix list

ds, has(type numeric)

local var_list: list r(varlist) – exclude_list

levelsof

multiple log files

display as error

assert

timers

local : word count

custom ado file

tempvar

tempname

regular expressions

survey weighting

## Stata Resources

## Stata at Berkeley
