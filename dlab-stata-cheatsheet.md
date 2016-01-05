# D-Lab Stata Cheatsheet
Chris Kennedy - University of California, Berkeley – January 2016

**_In Progress_**

## 1. Introduction to Stata

[Review of Stata Window]

**use** "your_file.dta", clear – open a dataset.

**clear** – unload the current data from memory.

Ctrl-r – keyboard shortcut to quickly go back to a previous command.

**count** – report the total number of observations in the dataset.

**describe**  - list the variables, total observations, and variable types & labels.

**summarize** – show the mean, median, max, min of one or more variables.

**tab** my_var – show a breakdown of values for one variable.

**tab** my_var, **missing** – show a breakdown of values for one variable, and don't hide missing values.

**tab1** my_var1 my_var2 – shows separate breakdowns for multiple variables.

**tab** my_var1 my_var2 – show a breakdown of values across two variables.

**list** – display all observations in the dataset.

**pwd** – show the current working directory.

**cd** “other_directory/” – change the working directory to another directory.

**set more off** – disable the pause feature when showing multiple pages of output.

**log using** "my_log.log", replace – start a log file, and overwrite the file if it already exists.

**log close** – stop logging (put at the very end of your .do file).

**gen** new_var = 5 – create a new variable and set its value.

**replace** new_var = 4 – update the value of an existing variable.

**rename** old_varname new_varname - change the name of a variable.

**save** “my_data.dta”, replace – save the current data to a file, overwriting any existing file.

**histogram** myvar – plot a histogram of a variable.

**scatter** var1 var2 – scatterplot of two variables.

**help** – get information about a command

**export delimited** - create a csv text export of the current dataset.

**import delimited** - load a csv data file.

**export excel** - create an Excel export of the current dataset.

**import excel** - load an Excel data file.

**label** var - create a text description of a variable.

**clonevar** newvar = oldvar - create a copy of a variable, including any labels.

**label values** - create text for the different values of a variable, esp. for surveys.

**order** - change the order of a variable in the dataset.

**_n** - internal variable for an observation's order in the dataset (1, 2, 3, ..., n).

**sort** - re-order the dataset based on the value of one or more variables, in ascending order

**gsort** - re-order the dataset based on the value of one or more variables, in ascending or descending order

**drop** - remove observations that meet a certain criteria

**keep** - remove observations that don't meet a certain criteria

**display** "Some output" – output a message.

**compress** - reduce the filesize of the dataset if possible.

## 2. Stata Data Analysis

**findit** mdesc – search for a user-written command that could be installed

**ssc install** mdesc – install a user-written command from the Stata software archive.

**mdesc**

**set seed** - set the random number generator starting point

**set sortseed** - when sorting on a variable, ensure that ties are broken in the same random order.

gen rand = runiform() - create a random number for each observation in the dataset.

**reg** indep_var depvar1 depvar2 – fit an OLS regression.

**reg** indep_var depvar1 depvar2, **robust** – fit an OLS and use robust standard errors.

**reg** indep_var depvar1 depvar2, r **cluster**(village_id) – OLS with robust clustered SEs.

**predict** y_hat - predict y_hat after a regression

**logit** - fit a logistic regression

**logit, nolog** - fit a logistic regression and hide the optimization log

**corr** - correlation table

**ttest** - t-test

**twoway** (scatter) (lfit)

**append** - append one dataset to the currently loaded dataset.

**merge** - combine a dataset with the currently loaded dataset.

**by** - operate on subsets of a sorted dataset.

**bysort** - operate on subsets of a dataset and sort automatically

**egen** - generate a new variable with advanced functions

**preserve** - make a temporary backup of the current dataset.

**restore** - restore the temporary backup of the dataset.

**xi** - create indicator/dummy variables for a categorical variable.

**factor variables**

**interaction terms**

**duplicates report** - check for duplicate values in a dataset

**duplicates tag** - record the number of duplicates for each observation

**duplicates drop** - remove records that are duplicated

**outreg2**

**graph export**

f-test

survey weighting

## 3. Stata Programming

**quietly** <command> - hide any output from a command

**capture log close** – close an open log file if it exists, and if not ignore the error message.

**return list** - show the custom values that a previous command created

**ereturn list** - show the custom regression-related values that a previous command created

**local** myvar = 1 - create a programming variable (not in the dataset) and set it to 1.

**global** myvar = 1 - same thing, but allow other do files to also see the variable.

**foreach** var in var1 var2 var {
} - run certain commands seperately for each variable in a list

**forvalues** var in 1/10 {
} - run certain commands seperately for each value in a given range

**confirm numeric** - check if a variable is numeric or a string.

**reshape** - change a dataset from wide to long format or vice versa.

date processing

round()

floor()

ceil()

**graph combine**

**set obs 100**

**datasignature set**

**datasignature confirm**




## 4. Advanced Stata Programming

**matrix** - save the matrix result from a command

**matrix list** - display a saved matrix

**ds**, has(type numeric) - describe variables in a dataset that are a certain type

**local** var_list: **list** r(varlist) – exclude_list - remove variables from a list

**levelsof** - determine how many separate values a variable has

multiple log files

**display as error** - output a message with color-coding

**assert** - give an error if a certain condition is not met, for debugging purposes.

timers

**local : word count** - count how many words are in a string

custom ado file

**tempvar** - create temporary variables in a dataset with unique names, useful for ado commands

**tempname** - create temporary local macros with unique names, useful for ado commands

regular expressions


## Stata Resources

## Stata at Berkeley
