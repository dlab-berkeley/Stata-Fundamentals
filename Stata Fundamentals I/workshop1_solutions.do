********************************
*	STATA FUNDAMENTALS: PART 1
*	SPRING 2021, D-LAB
********************************


**************************************************

* Day 1 

* Outline:
* I. 	SETTING UP
* II. 	COMMENTING
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

* In this section, we'll learn how to import your data into Stata and how to run your code. In Stata, we often refer to the file that contains your code as a "do-file". 

* first, clear all previously open data, variables, labels, matrices, memory, etc., and close all open files, graph windows, etc

clear all 


* SET A WORKING DIRECTORY

* The working directory is the folder on your computer containing the files associated with a given Stata file - it's where Stata will look when you try to load data, and where it will export your data, unless you specify otherwise. Your working directory doesn't necessarily have to be the same folder where your do-file is saved. Stata will choose a default directory based on your application settings, and we can use a command to check which directory that is:

pwd // check the current working directory

* Often, the current working directory isn't actually the folder we want to use to store our work - below, we show how you can change the working directory to your desired folder.

* Method: Copy & Paste 

/**** 
This is not the most efficient method for telling Stata where to locate and open your files, but it is the simplest, so we will work with this for day 1 of the workshop                    
****/
	
/* Step 1: File > Change Working Directory > Navigate to the folder where you have saved the data file nlsw88.dta */
   
/* Step 2: Copy-paste the last command that shows up on result screen.
   My results window shows this:*/   

cd "\\Client\C$\Users\salma\Box\dlab_workshops-s21\stata-fundamentals\Stata Fundamentals I"


/***
We paste this command above so that next time we can just run this do-file from the top and it will run smoothly. We will not need to use the file menu or copy-paste again. We should be able to run everything from the do-file.
***/

// POLL 1 //

/* Step 3: Open the data file.*/

use nlsw88.dta , clear // open data file 

/***
Stata uses a special file type called .dta files to save data in a table format (similar to how Excel has their own .xlsx file types). At the end of today's workshop, we'll go over how to import other file types that are more common (e.g. .csv files).
***/

/* You can also write: */

use nlsw88 , clear // don't have to specify .dta, that is the default extension


/***
If you are using an older version of Stata, then please use: use nlsw88_13, clear
***/

/* 
Pause here, and now highlight everything above this point and click
on the "do" button. It should run smoothly! You've started to create a functional do-file!
*/


****************************** 
*         COMMENTING   		 *
****************************** 

// Comments are meant to make your code easier to understand. There are a bunch of ways to comment your .do file; comments will show up in green text while commands (the steps you want Stata to execute) will show up in black or blue text.

/* 
If you want to write a really long and super informative comment and you want to clearly show where the comment begins and ends, you can wrap it in a slash-asterisk (/* at the start, and */ at the end), like this one we're typing right now. 
*/
* You can put an asterisk at the beginning of a line to comment it out
* You can also use * to comment out lines of code that you want to suspend
// You can use double slash to make comments at the end of a command line or just as a line by itself (like this one)
// asterisk (*) cannot be placed at the end of a command line - it  can only be used on a line by itself. For example:

des // describes the variables in the data
des *  describes the variables in the data  <-- this is wrong!
* des // this suspended the command altogether

/* 
Try highlighting and running just the three lines above. The first line should run smoothly, giving us a description of the data. The second should give an error because it's not commented properly! 
*/

// POLL 2 //

/* Challenge question 1 */
/*
(1) write "describes data" NEXT to the command "des" below as a comment

(2) Suspend all 3 lines of code below using one pair of /**/
*/ 

/* Challenge question 1 solution */
/*
des // describe data
sum 
count
*/


**********************************************
*    EXAMINING A DATA SET: THE BASICS    	 *
**********************************************
* It is good practice to LOOK at your data before you start working with it
* That way, you get an idea of its shape and the variables in it quickly

* DESCRIBE

des // describes dataset and all variables

* BROWSE 
br // browse data in data editor

/* Challenge question 2 */
/*
What do the different colors mean in the data editor?
*/ 
/* Challenge question 2 solution */
/*
The colors designate different data types - in my data editor, strings are red.
*/

des married married_txt // we can describe selected variables by specifying which ones - here, we're just describing the married and married_txt fields

* CODEBOOK
* The codebook command in Stata provides additional details about each variable, beyond what is output by des
* We could use it to get a codebook of all the variables, which will result in a long output. For now, let's just look at the contents of the variable union:

codebook union  // shows the contents of the variable union


// POLL 3 //

* COUNT
count // counts the number of observations
* The command above counts the total number of observations in our dataset. But we can also count observations with a condition. For instance, if we want to know how many rows represent individuals who are over 40, we can use:
count if age > 40 // counts the number of observations where age is greater than 40

/* Challenge question 3 */
/*
Count the number of observations that are union members. (hint: you can use the command 
	codebook union
to first figure out what different values the variable union can have)
*/
count if union == 1



* SUMMARIZE * 

* shows number of observations, mean, min & max of all/some vars 
sum 


* MISSING VALUES *


/* Notice the observation numbers. Why do some variables have fewer observations? */

misstable summarize // tabulates missing values

codebook union 


**************************************************************
*    BASIC DESCRIPTIVE STATISTICS: SUMMARIZE & TABULATE    	 *
**************************************************************

* SUMMARIZE *

/*
Now let's start looking at some summary statistics using command: 
"summarize" (or "sum" for short)
*/

sum // summarize the data, presents summary statistics
sum wage
sum wage, detail

* we can combine conditional operators with the summarize command

* What is the average wage of observations who are married in this sample

sum wage if married==1 

* Let's use conditional operators to study different demographic groups in our data

sum wage if married==1 // married
sum wage if collgrad==1 // college graduate
sum wage if married==1 & collgrad==1 // married graduate
sum wage if married==1 & collgrad==0 // married non-graduate
sum wage if married==0 & collgrad==1 // unmarried graduate
sum wage if married==0 & collgrad==0 // unmarried non-graduate
sum wage if married==1 | collgrad==1 // married OR college graduate

/* One basic interpretation from the above descriptive statistics:
For the college graduates in the sample, those who are 
unmarried earn more (11.30) on average than those who are married (10.10).*/



** CHALLENGES **

/*
(4) What is the mean wage for those who are not married?
variables: wage married
(hint: Use the operator "if")
*/
sum wage if married == 0
* OR 
sum wage if married != 1



/*
(5) What is the average wage of those who have worked 10 or more years?
variables: wage tenure
*/
sum wage if tenure >= 10 & tenure != . 



/* 
(6) What is the average number of hours worked in the sample? 
variable: hours
*/
sum hours



/*
(7) What is the average age and age range of this sample? 
Variable: age
*/
sum age



/*
(8) What is the average age for non-married observations?
variables: age, married
*/
sum age if married == 0 


// Let's look at how missing variables can affect results:

// Suppose we want to summarize wages for those individuals who are in unions (union=1)
// Here are 5 ways you may think to write the code (warning: not all are correct!)

/* A */ sum wage if union>0 
/* B */ sum wage if union!=0
/* C */ sum wage if union!=0 & union!=.
/* D */ sum wage if union!=0 & union<.
/* E */ sum wage if union==1

// POLL 4 //



* TABULATION & CROSS TABULATION *



// Very helpful for categorical variables
tab race
tab collgrad
tab union
tab union if hours>=60 & hours<.


* Twoway tables 
tab union collgrad
tab union collgrad, col 
tab union collgrad, row
tab union collgrad, col row

tab union collgrad, cell


// POLL 5 //


** CHALLENGE **
/*
(9) How many observations in this dataset fall into each race group? 
Variables: race
*/
tab race



/*
(10) What percent of the sample is white?
Variable: race
*/
tab race


* TABULATE, SUMMARIZE
* Summary statistics of one variable with respect to others 
/* e.g. What is the average wage for married/non-married 
 OR college graduates/non-graduates? */

help tabulate_summarize
tab collgrad, summarize(wage) means
tab married collgrad, summarize(wage) means


** CHALLENGE **
/*
(11) Find average wage by industry.
Variables: industry wage
*/
tab industry, sum(wage) means



// do you notice anything strange about the wages here?
// mining wages are the highest??

// Let's explore the mining wage...
// Let's take a look at the observations that work in mining
// first we have to find the industry code that belongs to mining


* Finding numeric codes attached to value labels * 


br if industry==Mining // no luck, industry is a numerical variable
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

// We will show 3 different examples:
// (1) Creating simple numeric variables (constants and simple mathematical transformations)
// (2) Creating a numeric  variable from a string variable (manual labor and advanced)
// (3) Creating a numeric indicator variable from another numeric variable 


* (1) Simple numeric variables

gen year88=1

gen wage_day = wage*8 // wage per day (8 hour workday)

gen tenure_sqr = tenure^2



* (2) Turning our string variable into a numeric variable

* Why do we want to convert a string to a numeric variable? Example:

sum wage if married_txt=="Married"
sum wage if married == 1

*Do you see any issues that might arrise from using a string variable?
tab married_txt married 


/* 	Method 1: manual labor	 */


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

gen married_txt2 = married_txt
replace married_txt2=trim(married_txt2) // removes leading and trailing spaces
replace married_txt2=proper(married_txt2)
replace married_txt2=lower(married_txt2)
replace married_txt2=upper(married_txt2)


/*	 Method 2 (advanced!): regular expressions	 */


/*
Regular expressions are one way that you can work with strings in variables
Regular expressions are methods that allows for searching, matching and replacing within strings.
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



* (3) Create numeric variables from other numeric variables

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

count if hs1!=hs2

// drop the extraneous versions
drop hs2 hs3


// POLL 6 //



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

// Let's define a value label called YN
label define hs_vallabel 1 "High school graduate" 0 "Did not graduate high school" 

// Now, let's assign the value label YN to the variable hs
label values hs hs_vallabel 

// Check that the label has been applied
tab hs 

// Remember that we can always check the contents of a value label with label list
label list hs_vallabel


// POLL 7 //

** CHALLENGE **
/*
Let's make and label a new variable about college attendance.
(12a)	Create a variable called somecollege, i.e. more than 12 and less than 
	16 years of schooling) (call it somecollege, using any of the three methods 
	we used to create hs).
*/
// method 1
gen somecollege1 = 1 if grade > 12 & grade < 16
replace somecollege1 = 0 if grade <= 12 | grade >= 16
replace somecollege1 = . if grade == . 

// method 2
gen somecollege2 = (grade > 12 & grade <16) if grade != . 

// method 3
recode grade (0/12 = 0) (13/15 = 1) (16/18 = 0), gen(somecollege3)


sum somecollege*
rename somecollege1 somecollege



/*
(12b) Label somecollege "Attended some years of college" 
*/
label variable somecollege "Attended some years of college"




/*
(12c) Create a new value label called somecollege_vallabel that assigns labels to 1 and 0
*/
label define somecollege_vallabel 0 "did not attend college or completed college" 1 "attended some college"



/*
(12d) Add your new value label to somecollege and check it has added
*/
label val somecollege somecollege_vallabel
tab somecollege


* RE-ORDERING VARIABLES

* Re-ordering how variables appead in the dataset
order hs, before(collgrad)



* SAVING CHANGES TO FILE

* Save changes to a NEW file
save "nlsw88_clean" , replace
// why don't we want to save changes to the original file?


*****************************************************
*     			EXPORTING AND IMPORTING   	    	*
*****************************************************


* Export data for use with other programs
help export excel
export delimited using "nlsw88_clean.csv", replace datafmt
export delim "nlsw88_clean.csv", replace dataf
export delim "nlsw88_clean.csv", replace nolabel

export delimited using "nlsw88_clean.tsv", delimiter(tab) replace  datafmt

export excel using "nlsw88_clean.xlsx", firstrow(variables) replace  
export excel using "nlsw88_clean.xlsx", replace   

* Import data from excel sheet into stata as nlsw88_clean.xlsx

// Let's first clear the current data in memory
clear all

// import the data file you just exported to excel as nlsw88_clean.xlsx
import excel using "nlsw88_clean.xlsx", first clear
import excel "/Users/isabellecohen/Dropbox/DLab/Stata Fundamentals I/nlsw88_clean.xlsx", sheet("Sheet1") firstrow clear

// "first" specifies that the first row in the excel file is a 

des
