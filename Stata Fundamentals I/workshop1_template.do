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
* VII. 	GRAPHS & REGRESSION QUICK OVERVIEW (Optional, if we get there)

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
   My resuly window shows this:*/   


   
/***
		We paste this command above so that next time we can just run this 
		do-file from the top and it will run smoothly. We will not need to
		use the file menu or copy-paste again. We should be able to run 
		everything from the do-file.
***/


/* Step 3: Open the data file */

use nlsw88.dta , clear // open data file lifeexp.dta

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

/*But then say you wanted to write a really long
and super informative comment that you didn't want 
to have all on one line, like this one we're typing
right now. */

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
/*        CHALLENGE   	*/	
////////////////////////// 
/* 
(1) write "presents summary statistics" NEXT to the command "sum"

(2) Suspend all 3 lines of code using one pair of /**/
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
log using stata_intro.log, replace







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

&	and
|	or
>	greater than
>=	greater than or equal to
<=
=	equal
!	not (also ~)
!=	not equal to (also ~=)
==	logical test for equality (usually follows "if")

*/





**********************************************
*    EXAMINING A DATA SET: THE BASICS    	 *
**********************************************


* DESCRIBE

des // describes dataset and variables

/* the pause ("more") feature turned on again because the "set more off" 
 we wrote above is local to our do file if we're going to stop and start
 then it's better to type "set more off" directly into the command window */


browse

* BROWSE 
br // browse data in data editor


* LIST

list // lists the data
list in 1/10 // list the 1st thry 10th observation

sort age // sort the dataset by age
list age married in -5/l  /* list the age and marital status of
last 5 observations, i.e. the highest 5 ages in the data */







//////////////////////////
/*        CHALLENGE 	*/	
//////////////////////////
/*
(1) List the highest 3 wages in the sample?
Variable: wage


(2) Is the highest wage observation married?
Variable: wage married
*/






* LIST VS. BROWSE

/*Using the "browse" command, we can look at our data in a spreadsheet format.
Let's compare what listing data looks like when we do it on the main results
page and when we do it using browse:*/

list wage married in -100/l   // lists output in results window
browse wage married in -100/l // shows the same thing browser window 



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


* USING A CONDITIONAL OPERATOR
/***
		What is the average wage of observations who are non-married in this
		sample
***/

sum wage if married==1 






//////////////////////////
/*        CHALLENGE 	*/	
//////////////////////////
/*
(1) Count the number of observations that are union members.
variable: union

(2) What is the mean wage for those who are not married?
variables: wage married
 
(hint: Use the operator "if")
*/



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






//////////////////////////
/*        CHALLENGE 	*/	
//////////////////////////
/*
(1) What is the average wage of those who have worked 10 or more years?
variables: wage tenure
*/




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


/* One basic interpretation from the above descriptive statistics:
For the college graduates in the sample, those who are 
unmarried earn more (11.30) on average than those who are married (10.10).*/



//////////////////////////
/*        CHALLENGE 	*/	
//////////////////////////

/* 

Let's ask a few more demography-based questions about this data:

(1) What is the average number of hours worked in the sample? 
variable: hours

(2) What is the average age and age range of this sample? 
Variable: age

(3) What is the average hours worked by college graduates? 
Variables: hours collgrad

(4) Who earns more on average - those with at least 12 years of education or
college graduates? 
Variables: wage grade collgrad

(5) Find the average wage for those workers that work more hours than 
the average hours worked in the sample. 
Variables: wage hours 
[Hint: you may need to use copy paste for a part of this. There is a 
more elegant way using locals which you'll learn in later workshops. ]


*/





* TABULATION & CROSS TABULATION *



// Very helpful for categorical variables
tab race
tab collgrad
tab married
tab married if hours>=60 & hours<.


* What are tab tab1 and tab2?
tab race
tab union
tab collgrad

tab1 race union collgrad 
tab race union collgrad // returns error. why?
tab union collgrad 
tab2 race union collgrad

tab race union
tab race collgrad
tab union collgrad


* Twoway tables 
tab union collgrad, col 
tab union collgrad, row
tab union collgrad, col row



//////////////////////////
/*        CHALLENGE 	*/	
//////////////////////////


/*

(1) How many observations in this dataset fall into each race group?
(a) What percent of the sample is white?




(2)	Find the average wage for non-white observations. Give this a try before looking below:
	
	
	
	
	
(3) For the above question, which option(s) is/are correct? Try to answer this without
running any of the lines of code below. Which code(s) do you think will give the right results?
	/* A */ sum wage if race>1
	/* B */ sum wage if race!=1
	/* C */ sum wage if race!=1 & race!=.
	/* D */ sum wage if race>=2
	/* E */ sum wage if race>=2 & race<=.
	/* F */ sum wage if race>1 & race<.
	/* G */ sum wage if race!=1 & race<=3
	/* H */ sum wage if race==2 | race==3
	
	

(4) Let's study race and living in a central city. 
Variables: race c_city

(a) What percentage of whites live outside of central cities?
(b) What percent of blacks lives in central cities?
(c) What percent of the sample that lives outside of central cities is black? white?
(d) What percent of the sample that lives in central cities is black? white?
(e) What percent of the total sample lives in central cities?


*/





* TABULATE, SUMMARIZE
* Summary statistics of one variable with respect to others 
/* e.g. What is the average wage for married/non-married 
 OR college graduates/non-graduates? */

help tabulate_summarize
tab collgrad, summarize(wage) means
tab married collgrad, summarize(wage) means



//////////////////////////
/*        CHALLENGE 	*/	
//////////////////////////
/*
(1) Use help file to tabulate the standard deviation of wages by marital status.
variables: married wage



(2) Find average wage by industry.
variables: industry wage
*/




// do you notice anything strange about the wages here?
// mining wages are the highest??

// Let's explore the mining wage...
// Let's take a loot at the observations that work in mining
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






*****************************************************
*         DATA CLEANING: CREATING VARIABLES    	    *
*****************************************************



* CREATE VARIABLES * 



// create a variable that indicates highschool graduate
// Be careful to think about (1) missing values 
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


// method 3
gen hs3 = .
replace hs3 = 1 if grade>=12 & grade!=. 
replace hs3 = 0 if grade<12
// this method is more careful when missing values are involved (the variable "grade" has 2 missing values)


//method 4
recode grade (0/11 = 0) (12/18 = 1), gen(hs4) 



//check all 4 versions
sum hs1 hs2 hs3 hs4
sum hs*



// Why is hs2 different?
br grade hs* if hs2!=. & hs1==.



// drop the wrong version (hs2) and the extraneous versions
drop hs2 hs3 hs4


// Let's tabulate our new variable
tab hs1
// we can make this variable more informative...





*    LABEL VARIABLES AND ADD VALUE LABELS     *



// Let's rename hs1 as hs
rename hs1 hs

// Let's add a label to hs1
label variable hs "high school graduate" 

// Next, let's add a value label for each of the 2 values of hs
/* This requires TWO steps: 
	(1) create a separate value label assigning labels to 0 and 1
	(2) add that value label to the variable hs1
*/


// Let's define a value label called YN
label define YN 1 "YES" 0 "NO" 

// Now, let's assign the value label YN to the variable hs
label values hs YN 

// Check that the label has been applied
tab hs 





* Exercise: Create a variable for some college 
* (more than 12 and less than 16 years of schooling)

 
gen somecollege = (grade>12 & grade<16)
replace somecollege = . if grade==.
la var somecollege "attended some (not all) years of college" //Notice the shorthands for the commands
la val somecollege YN // applying the same label "YN" that was created above for another variable
tab somecollege






//////////////////////////
/*        CHALLENGE 	*/	
//////////////////////////

/* 

(1a) Create another version of the some college variable (call it somecollege3)
	using a method similar to method 3 used for creating hs above.

(1b) Label somecollege3 as  "attended some years of college" 

(1c) Use help file for label (help label) to drop the value label YN

(1d) Create a new value label called yesno that assigns 1 to yes and 0 to no

(1e) Add value label yesno to somecollege3


	
(2a) Use method 4 (recode) to creare a new variable "unmarried" that is the 
opposite of the "married" variable. That is unmarried = 1 when married = 0 and vice versa.

(2b) label unmarried "not married"

(2c) Create a new value label called unmar_lbl that assigns 
1 to single and 0 to married. 

(2d) Add value label unmar_lbl to unmarried
 
*/





* RE-ORDERING VARIABLES

* Re-ordering how variables appead in the dataset
order hs somecollege , before(collgrad)



* SAVING CHANGES TO FILE

* Save changes to a NEW file
save "nlsw88_clean" , replace
// why don't we want to save changes to the original file?





* EXPORTING AND IMPORTING DATA *


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

des

clear all
use "$mycomp/nlsw88.dta", clear
set more off













*** SNEAK PEEK INTO NEXT TIME ****

****************************** 
*       	GRAPHS    	 	 *
******************************



* Histogram and Density Graphs
hist wage

twoway (kdensity wage if collgrad==1) (kdensity wage if collgrad==0), ///
legend(label(1 "College Grad") label(2 "Non Grad"))

// did you notice the use of "///"? how is it different from "//"?

* Scatter Plots and Linear Graphs
twoway (scatter wage grade) (lfit wage grade )

twoway (lfit wage grade if race==1 )(lfit wage grade  if race==2), ///
legend(label(1 "White") label(2 "Black"))


twoway (lfit wage grade if married==1 )(lfit wage grade  if married==0), ///
legend(label(1 "married") label(2 "single"))







****************************** 
*       REGRESSION (MINI)    *
******************************
* reg y x1 x2 

* These are not meaningful regressions. For demonstration only!
reg wage age race 
reg wage age i.race
reg wage age i.race grade collgrad married union ttl_exp tenure i.industry c_city smsa south 



//////////////////////////
/*        CHALLENGE 	*/	
//////////////////////////

/*

(1)  Create a variable for annual income (which is the number of hours worked each week
	multiplied by wages multiplied by the number of weeks in a year). Call this variable annual_inc.
	
	
(2) Plot density graphs of annual income for college graduates and non graduates (separately) 
	on the same plot. Label the lines appropriately. What is your takeaway?

	
(3) Plot a scatter plot and a linear graph of how annual income changes with level of education.


(4) Plot annual income against education for both whites and blacks on the same plot. 
	Label lines appropriately.
	

*/



