******************************* 
*	Stata Intensive: Workshop 3
*	Fall 2016, D-LAB
*	Isabelle Cohen
*	Oct 26, 2016
********************************

**************************************************
* Day 3

* Practice Exercises
* 1. Importing Data
* 2. Reshaping
* 3. Labeling Variables
* 4. Merging
* 5. Data Cleaning with Loops
* 6. Labeling Values
* 7. Regression Analysis and Outputting Results 

*These practice exercises are based off the Stata Test given in 2014 to 
*job applicants at Evidence for Policy Design at Harvard Kennedy School.

**************************************************

global mycomp "/Users/isabellecohen/Desktop/DLab/Stata Fundamentals III" // for my computer

/*1. Importing Data
Import the file "RE - Test Data.xls" into Stata*/

import excel using "$mycomp/RE - Test Data.xls", firstrow clear

/*2. Reshaping
Reshape the test score data so that each student's data is only one row*/

reshape wide mathnorm, i(student_id) j(posttest)

/*3. Labeling Variables
Label the newly created variables for math scores*/

label var mathnorm0 "Pre-Test Math Scores"
label var mathnorm1 "Post-Test Math Scores"

/*4. Merging 
Merge this data with "RE - Student Info.dta"*/

merge 1:1 student_id using "$mycomp/RE - Student Info.dta", nogen

/*5. Data Cleaning with Loops
a. Create a variable showing the difference between the normalized post-test 
and normalized pre-test scores for each student and label as appropriate.*/

gen diff_mathnorm = mathnorm1 - mathnorm0
label var diff_mathnorm "Difference between Post and Pre Math Tests"

/*b. Create a dummy variable for each value of Third. 
Name each as third_(x), where x represents the third of the distribution 
into which the student falls, and label the variable accordingly. Use a loop.*/

forvalues j=1/3{
	gen third_`j' = (third ==`j')
	label var third_`j' "`j' Third of Distribution"
}

/*6. Labeling Values
Label the values of the treatment variable.
0 represents the Control Group, and 1 the Treatment Group*/

label def treatment 0 "Control" 1 "Treatment"
label val treatment treatment 

/*7. Regression Analysis and Outputting Results
Regress the difference between the normalized post-test and pre-test scores
on treatment for the entire sample, then separately for each third of the 
initial distribution. Control for the normalized pre-test scores and cluster 
the standard errors at the school grade level.

Please output the results from all regressions in Excel in the clearest form 
possible. Include the number of observations.

CHALLENGE: Use only 4 lines of code (not counting \\\ separations)
*/

foreach var of varlist third third_1 third_2 third_3 {
	reg diff_math treatment mathnorm0 if `var'!=0, cluster(school_grade_id)
	outreg2 using "$mycomp/Workshop 3 - Regression results.xls", excel label nocons ctitle(Change in Math Score) append
}
