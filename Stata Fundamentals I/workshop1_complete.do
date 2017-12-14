******************************* 
*	STATA INTENSIVE: WORKSHOP 1
*	FALL 2017, D-LAB
********************************


**************************************************

* Day 1 

* Outline:
* I. 	SETTING UP
* II. 	COMMENTING AND KEEPING SESSION LOGS
* III. 	EXAMINING DATA & DATA CLEANING
*			A. MISSING VALUES
*			B. DESCRIPTIVE STATISTICS
*					(i)  SUMMARIZE
*					(ii) TABULATE
* 					(iii) CROSS-TABULATE
* 			C. CREATING VARIABLES
* VI. 	IMPORTING & EXPORTING 

**************************************************



****************************** 
*         SETTING UP   		 *
******************************

/* 
		It's good practice to make sure all previous work has 
		been cleared at the start of your do-file
*/
 
 
 
* CLEAR ALL 
* clear all previously open data, variables, labels, matrices, memory, etc., 
* and close all open files, graph windows, etc

clear all 



* SET A PROJECT DIRECTORY

pwd // check the current working directory


* Method: Copy & Paste 

/**** 
		This is not the most efficient method for telling Stata to locate 
		and open your files, but it is the simplest, so we will work with 
		this for day 1 of the workshop                    
****/
	
	


/* Step 1: File > Change Working Directory > Navigate to the folder where you 
   have saved the data file nlsw88.dta */
   
/* Step 2: Copy-paste the last command that shows up on result screen.
   My result window shows this:*/   

cd "/Users/SSB/Box Sync/D-lab/stata/Workshop files/Workshop 1"
   
/***
		We paste this command above so that next time we can just run this 
		do-file from the top and it will run smoothly. We will not need to
		use the file menu or copy-paste again. We should be able to run 
		everything from the do-file.
***/


/* Step 3: Open the data file */

use nlsw88.dta , clear // open data file 

/* You can also write: */

use nlsw88 , clear
// don't have to specify .dta, that is the default extension


/***
		If you are using an older version of Stata, then please use:
		
use nlsw88_13, clear
***/





/* 
	Pause here, and now highlight everything above this point and click
	on the "do" button. It should run smoothly! You've started to create a 
	functional do-file!
*/







****************************** 
*         COMMENTING   		 *
****************************** 


// There are a bunch of ways to comment your .do file.

* You can also just put an asterisk at the beginning of a line
* You can use * to comment out lines of code that you want to suspend
// you can use double slash to make comments at the end of a command line or just as a line by itself (like this one)
// asterisk (*) cannot be placed at the end of a command line

des // describes the variables in the data
des *  describes the variables in the data  <-- this is wrong!
* des // this suspended the command altogether

/* But then say you wanted to write a really long
and super informative comment that you didn't want 
to have all on one line, like this one we're typing
right now. */


/* */

des


/* However, if you forget to close this slash-asterisk loop
then you will suspend all commands underneath! */



/* 




This helps you suspend multiple lines at the same time. 
They
don't			 have 
			to be 
	continuous					 lines 
	or 
	paragraphs.

	"The only people for me are the mad ones, 
	the ones who are mad to live, mad to talk, 
	mad to be saved, desirous of everything at 
	the same time, the ones who never yawn or 
	say a commonplace thing, but burn, burn, 
	burn like fabulous yellow roman candles exploding 
	like spiders across the stars."
	-- Jack Kerouac (On the Road, 1957)
	
	
	
	
*/



//////////////////////////
/*       CHALLENGE 1   	*/	
////////////////////////// 
/* 
(1) write "describes data" NEXT to the command "des" below

(2) Suspend all 3 lines of code below using one pair of /**/
*/ 

* Answer:

/*
des //describes data
sum 
count
*/



****************************** 
*            LOG    		 *
******************************

cap log close // Close any existing log files first.

*log close

* Start a log file.
// File -> Log -> Begin

log using stata_intro.log, replace

*log using stata_intro.log, append


/* 	The log is saved in your working directory,
	understand why we replace or append */



* Close a log file (Usually done at the end of the do file.)
log close



/*
		If you try using the previous log file by writing:

log using stata_intro.log  

		then stata will return error: "file...already exists" 
		To use a previously created log file, you need to use either
		"replace" or "append" after the comma
*/



* We may want to close any existing log files first.
capture log close // this is a good command to include at the beginning of your do-file
log using stata_intro.log, append







****************************** 
*          OPERATORS    	 *
******************************



/*

Very quick rundown of operators in Stata

+	plus
-	minus
* 	multiply
/	divide 
^	exponent

= 	equal

&	and
|	or
>	greater than
>=	greater than or equal to
<=	less than or equal to
<	less than 
!	not (also ~)
!=	not equal to (also ~=)
==	logical test for equality (usually follows "if")

*/





**********************************************
*    EXAMINING A DATA SET: THE BASICS    	 *
**********************************************
** It is good practice to LOOK at your data before you start working with it
** That way, you get an idea of its shape and the variables in it quickly

* DESCRIBE

des // describes dataset and variables

/* the pause ("more") feature turned on again because the "set more off" 
 we wrote above is local to our do file if we're going to stop and start
 then it's better to type "set more off" directly into the command window */


* BROWSE 
br // browse data in data editor

**What do the different colors mean?
des married married_txt



* CODEBOOK

codebook union  // shows the contents of the variable union


* COUNT

count // counts the number of observations


* SUMMARIZE

/***
		Now let's start looking at some summary statistics using command: 
		"summarize" (or "sum" for short)
***/

sum // summarize the data, presents summary statistics
sum wage

sum wage, detail

* USING A CONDITIONAL OPERATOR
/***
		What is the average wage of observations who are non-married in this
		sample
***/

sum wage if married==1 


**How do we edit this command above if we want to look at married_txt?
sum wage if married_txt=="Married"


*Do you see any issues that might arrise from using a string variable?
codebook married_txt

*How is this variable different than married?
br married married_txt


////////////////////////////
/*        CHALLENGE 2 	  */	
////////////////////////////
/*
(1) Count the number of observations that are union members.
variable: union

(2) What is the mean wage for those who are not married?
variables: wage married
 
(hint: Use the operator "if")
*/


* Answers

*(1)

count if union==1

*(2)

sum wage if married==0




* MISSING VALUES *


/* Notice the observation numbers. Why do some variables have fewer observations? */


misstable summarize // tabulates missing values

codebook union 



// Let's look at how missing variables can affect results:

// Suppose we want to summarize wages for those individuals who are in unions (union=1)
// Here are 5 ways you may think to write the code (warning: not all are correct!)

/* A */ sum wage if union>0 
/* B */ sum wage if union!=0
/* C */ sum wage if union!=0 & union!=.
/* D */ sum wage if union!=0 & union<.
/* E */ sum wage if union==1



// Are these the same? Which is/are correct?






////////////////////////////
/*        CHALLENGE 3     */	
////////////////////////////
/*
(1) What is the average wage of those who have worked 10 or more years?
variables: wage tenure
*/


* Answer

summ wage if tenture>=10 & tenure<.


**************************************************************
*    BASIC DESCRIPTIVE STATISTICS: SUMMARIZE & TABULATE    	 *
**************************************************************

/* Let's use conditional operators to study different demographic 
groups in our data
 
(1) married
(2) college graduates
(3) married college graduates
(4) married college non-graduates
(5) unmarried college graduates
(6) unmarried college non-graduates 
*/


sum wage if married==1 // married
sum wage if collgrad==1 // college graduate
sum wage if married==1 & collgrad==1 // married graduate
sum wage if married==1 & collgrad==0 // married non-graduate
sum wage if married==0 & collgrad==1 // unmarried graduate
sum wage if married==0 & collgrad==0 // unmarried non-graduate


sum wage if married==1 | collgrad==1

/* One basic interpretation from the above descriptive statistics:
For the college graduates in the sample, those who are 
unmarried earn more (11.30) on average than those who are married (10.10).*/



////////////////////////////
/*        CHALLENGE 4	  */	
////////////////////////////

/* 

Let's ask a few more demography-based questions about this data:

(1) What is the average number of hours worked in the sample? 
variable: hours

(2) What is the average age and age range of this sample? 
Variable: age

(3) What is the average age for non-married observations?
variables: age, married

*/

* Answers

*(1)
summ hours
// Average number of hours: 37.21811 

*(2)
summ age
// Average age: 39.15316
// Age range: 34 to 46

*(3)
summ age if married==0
// Average age of non-married observations: 39.21891


* TABULATION & CROSS TABULATION *



// Very helpful for categorical variables
tab race
tab collgrad
tab union
tab union if hours>=60 & hours<.


* Twoway tables 
tab union collgrad, col 
tab union collgrad, row
tab union collgrad, col row

tab union collgrad, cell

////////////////////////////
/*        CHALLENGE 5 	  */	
////////////////////////////


/*

(1) How many observations in this dataset fall into each race group? 
Variables: race

(2) What percent of the sample is white?
Variable: race


*/

* Answers

*(1), (2)

tab race



* TABULATE, SUMMARIZE
* Summary statistics of one variable with respect to others 
/* e.g. What is the average wage for married/non-married 
 OR college graduates/non-graduates? */

help tabulate_summarize
tab collgrad, summarize(wage) means
tab married collgrad, summarize(wage) means



////////////////////////////
/*        CHALLENGE 6 	  */	
////////////////////////////
/*
(1) Find average wage by industry.
Variables: industry wage
*/

* Answer

tab industry, summarize(wage)




// do you notice anything strange about the wages here?
// mining wages are the highest??

// Let's explore the mining wage...
// Let's take a look at the observations that work in mining
// first we have to find the industry code that belongs to mining


* Finding numeric codes attached to value labels * 


br if industry==mining // no luck, industry is a numerical variable\
tab industry 
tab industry, nolabel
br if industry==2
/* OR */
// find name of value label 
codebook industry // you can also use: des industry
// then list the contents of that label
label list indlbl
br if industry==2



////////////////////////////////////
/*       CHALLENGE 7 (EXTRA)	  */	
////////////////////////////////////
/*


1. SUMMARY STATISTICS - SUM:

(1.A) 	What is the average hours worked by college graduates? 
		Variables: hours collgrad

(1.B) 	Who earns more on average - those with at least 12 years of education or
		college graduates? 
		Variables: wage grade collgrad

(1.C) 	Find the average wage for those workers that work more hours than 
		the average hours worked in the sample. 
		Variables: wage hours 
		[Hint: you may need to use copy paste for a part of this. There is a 
		more elegant way using locals which you'll learn in later workshops. ]

2. SUMMARY STATISTICS - TAB:

(2.A)	For the above question, which option(s) is/are correct? Try to answer this without
		running any of the lines of code below. Which code(s) do you think will give the right results?
		/* A */ sum wage if race>1
		/* B */ sum wage if race!=1
		/* C */ sum wage if race!=1 & race!=.
		/* D */ sum wage if race>=2
		/* E */ sum wage if race>=2 & race<=.
		/* F */ sum wage if race>1 & race<.
		/* G */ sum wage if race!=1 & race<=3
		/* H */ sum wage if race==2 | race==3
	

(2.B) 	Let's study race and living in a central city. 
		Variables: race c_city

(i) 	What percentage of whites live outside of central cities?
(ii) 	What percent of blacks lives in central cities?
(iii) 	What percent of the sample that lives outside of central cities is black? white?
(iv) 	What percent of the sample that lives in central cities is black? white?
(v) 	What percent of the total sample lives in central cities?

 
*/



* Answers


*(1.A)
summ hours if collgrad==1

*(1.B)
summ wage if collgrad==1
summ wage if grade>=12 & grade<.

*(1.C)
summ hours
summ wage if hours>=37.218


*(2.A)
/*In fact, they all work!*/

*(2.B)
*(i)
tab race c_city, row

*(ii)
tab race c_city, row

*(iii)
tab race c_city, col

*(iv)
tab race c_city, col

*(v)
tab race c_city, row
*or
tab c_city



*****************************************************
*         DATA CLEANING: CREATING VARIABLES    	    *
*****************************************************

* CREATE VARIABLES *

// We will show 3 different examples:
// Creating simple numeric variables (constants and simple mathematical transformations)
// Creating a numeric  variable from a string variable (manual labor and advanced)
// Creating a numeric indicator variable from another numeric variable 



/* 	Method 1: manual labor	 */


* Simple numeric variables

gen pilotsample=1

gen wage_day = wage*8 // wage per day (8 hour workday)

gen tenure_sqr = tenure^2



*Lets turn our string variable into a numeric variable

*Remember married and married_txt?
tab married married_txt
tab married_txt

gen married2=1 if married_txt=="M" | married_txt=="Married" | married_txt=="m" ///
	| married_txt=="maried" | married_txt=="married"
	
replace married2=0 if married_txt=="single" | married_txt=="S" | married_txt=="SINGLE" ///
	| married_txt=="Single" | married_txt=="s" | married_txt=="sIngle" ///
	| married_txt=="singLe" | married_txt=="single" | married_txt=="single " ///
	| married_txt=="single  " | married_txt==" single" | married_txt=="single   "

encode married_txt, gen(married3) // good when strings are clean



/*	 Method 2 (advanced!): regular expressions	 */


/*
Regular expressions are one way that you can work with strings in variables
There are two main commands: regexr and regexm.

regexr REPLACES a value within a string with a new variable

regexm, which we'll use today, combines strings and conditional operators.
regexm lets you search within a string for a given character; it returns 1, or 
TRUE, if the string has the character, and 0 otherwise.
*/

gen married4=1 if regexm(married_txt,"m") | regexm(married_txt,"M")
replace married4=0 if regexm(married_txt,"s") | regexm(married_txt,"S")

*See how this differs from the string Married variable?
br  married_txt married2 married3 married4

tab married married2



* We can also create numeric variables from other numeric variables

// create a variable that indicates highschool graduate
// Be careful to think about 
// (1) missing values 
// (2) what should =1 and what should =0 for your variable

//let's first look at grade
codebook grade
// it has missing values, so beware


// method 1
gen hs1 = 1 if grade>=12 & grade!=. 
replace hs1 = 0 if grade<12


// method 2
gen hs2 = (grade>=12 & grade!=.) 
// this assigns 1 to the observations meeting the condition in the () and 0 to all else

//method 3
recode grade (0/11 = 0) (12/18 = 1), gen(hs3) 


//check all 3 versions
sum hs1 hs2 hs3 
sum hs*


// Why is hs2 different?
br grade hs* if hs2!=. & hs1==.


// Could we have generated hs2 a different way to fix it?
drop hs2

gen hs2 = (grade>=12) if grade!=. 

// drop the extraneous versions
drop  hs3


// Let's tabulate our new variable
tab hs1
// we can make this variable more informative...





*    LABEL VARIABLES AND ADD VALUE LABELS     *



// Let's rename hs1 as hs
rename hs1 hs

// Let's add a label to hs1
label variable hs "high school graduate"
label variable hs "High school graduate"

// Next, let's add a value label for each of the 2 values of hs
/* This requires TWO steps: 
	(1) create a separate value label assigning labels to 0 and 1
	(2) add that value label to the variable hs1
*/

// Let's define a value label called hs_vallabel
label define hs_vallabel 1 "High school graduate" 0 "Did not graduate high school" 

// Now, let's assign the value label hs_vallabel to the variable hs
label values hs hs_vallabel 

// Check that the label has been applied
tab hs 

// Remember that we can always check the contents of a value label with label list
label list hs_vallabel




* RE-ORDERING VARIABLES

* Re-ordering how variables appead in the dataset
order hs, before(collgrad)



* SAVING CHANGES TO FILE

* Save changes to a NEW file
save "nlsw88_clean" , replace
// why don't we want to save changes to the original file?



////////////////////////////
/*        CHALLENGE 8	  */	
////////////////////////////

/*


1. VARIABLE CREATION:

(1.A) 	Let's make and label a new variable about college attendance.
(i)		Create a variable called somecollege, i.e. more than 12 and less than 
		16 years of schooling) (call it somecollege, using any of the three methods 
		we used to create hs above.

(ii) 	Label somecollege "Attended some years of college" 

(iii) 	Create a new value label called somecollege_vallabel that assigns labels to 1 and 0

(iv) 	Add your new value label yesno to somecollege


	
(1.B) 	Let's make and label a new variable about marital status.
(i)		Use method 3 (recode) to creare a new variable "unmarried" that is the 
		opposite of the "married" variable. That is unmarried = 1 when married = 0 and vice versa.

(ii) 	Label your new unmarried variable "Not married"

(iii) 	Create a new value label called unmar_lbl that assigns 1 to single and 0 to married. 

(iv) 	Add value label unmar_lbl to unmarried

*/


* Answers

*(1.A)
*(i)
*One way to do this is

gen somecollege = 1 if grade>=12 & grade<16
replace somecollege = 0 if grade<12 | (grade>=16& grade<.)

*(ii)

label var somecollege "Attended some years of college" 

*(iii)

label define somecoll_label 1 "Attended some college" 0 "Attended none or all years of college"

*(iv)

label values somecollege somecoll_label




* (1.B)

*(i) 
 recode married (0 = 1) (1=0), gen(unmarried) 

*(ii)

label var unmarried "Not married"

*(iii)

label define unmar_lbl 1 "Single" 0 "Married"

*(iv)

label values unmarried unmar_lbl




*****************************************************
*     			EXPORTING AND IMPORTING   	    	*
*****************************************************


* Export data for use with other programs
help export excel
export delimited using "nlsw88_clean.csv", replace datafmt
export delimited using "nlsw88_clean.tsv", delimiter(tab) replace  datafmt
export excel using "nlsw88_clean.xlsx", firstrow(variables) replace   

* Import data from excel sheet into stata as nlsw88_clean.xlsx

// Let's first clear the current data in memory
clear all

// import the data file you just exported to excel as nlsw88_clean.xlsx
import excel using "nlsw88_clean.xlsx", first clear
// "first" specifies that the first row in the excel file is a 


