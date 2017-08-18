******************************* 
*	STATA SPECIAL TOPICS
*	DATA VISUALIZATION
*	FALL 2017, D-LAB
********************************

clear all

macro drop all

graph drop _all

set more off

cap log close

* Use file > change directory >> go to the folder you want to save files to 
* (it can be the folder where you saved this do-file)
cd "/Users/isabellecohen/Dropbox/DLab/Data Visualization"

pwd


********************************************************************************
*TABLE OF CONTENTS:
*1. Scatter Plots
	*1.1 Markers
	*1.2 Labelling points
	*1.3 Adding titles
	*1.4 Legends
	*1.5 Axis
*2. Line Plots
*3. Saving and Exporting Graphs 
	*3.1 Savings graphs
	*3.2 Exporting graphs
	*3.3 3.3 Exporting graphs to Latex
*4. Graphing Results
	*4.1 Using coefplot
	*4.2 Using parmest
	*4.3 More general approach
*5. Additional Materials
	*5.1 Aspect ratio
	*5.2 Jitter
	*5.3 Graph recordings
********************************************************************************


********************************************************************************
*                                                                              *
*                    		1. Scatter Plots                                   *
*                                                                              *
********************************************************************************


/**
The Program Effort Data

Here are the famous program effort data from Mauldin and Berelson. 

This extract consists of observations on an index of social setting, 
an index of family planning effort, and the percent decline in the 
crude birth rate (CBR) between 1965 and 1975, for 20 countries in Latin America

                 setting  effort   change
   Bolivia            46       0        1
   Brazil             74       0       10
   Chile              89      16       29
   Colombia           77      16       25
   CostaRica          84      21       29
   Cuba               89      15       40
   DominicanRep       68      14       21
   Ecuador            70       6        0
   ElSalvador         60      13       13
   Guatemala          55       9        4
   Haiti              35       3        0
   Honduras           51       7        7
   Jamaica            87      23       21
   Mexico             83       4        9
   Nicaragua          68       0        7
   Panama             84      19       22
   Paraguay           74       3        6
   Peru               73       0        2
   TrinidadTobago     84      15       29
   Venezuela          91       7       11

Reference: P.W. Mauldin and B. Berelson (1978) 
Conditions of fertility decline in developing countries, 1965-75 
Studies in Family Planning,9:89-147
JSTOR: http://www.jstor.org/stable/1965523



**/


* Input the data *

clear
input country setting	effort	change
1   46	0	1
2   74	0	10
3	89	16	29
4	77	16	25
5	84	21	29
6   89	15	40
7	68	14	21
8	70	6	0
9	60	13	13
10	55	9	4
11	35	3	0
12	51	7	7
13	87	23	21
14	83	4	9
15	68	0	7
16	84	19	22
17	74	3	6
18	73	0	2
19	84	15	29
20	91	7	11
end

summarize

* Adding labels to the dataset *

*** help label

label define country_lbl ///
	1 "Bolivia" 2 "Brazil" 3 "Chile" 4 "Colombia" 5 "CostaRica" 6 "Cuba" ///
	7 "DominicanRep" 8 "Ecuador" 9 "ElSalvador" 10 "Guatemala" 11 "Haiti" ///
	12 "Honduras" 13 "Jamaica" 14 "Mexico" 15 "Nicaragua" 16 "Panama" ///
	17 "Paraguay" 18 "Peru" 19 "TrinidadTobago" 20 "Venezuela"


label values country  country_lbl




********************************************************************************

* a very very simple graph *

graph twoway scatter change setting 

* label variables
label variable country "country"
label variable setting "index of social setting"
label variable effort "index of family planning effort" 
label variable change "percent decline in the crude birth rate"


* save this file *

save effort.dta, replace

*set scheme
set scheme s1mono

* re-run graph with labels and scheme
graph twoway scatter change setting 


********************************************************************************
*                                                                              *
*                     #delimit                                                 *
*                                                                              *
********************************************************************************

/** 


Many graphing commands end up being very long; one option is to use

   #delimit ; 

The #delimit command resets the character that marks the end of a command.


Commands in a do-file may be delimited with a carriage return or a semicolon.
When a do-file begins, the delimiter is a carriage return.  
The command " #delimit ; " changes the delimiter to a semicolon.
To restore the carriage return delimiter inside a file, use #delimit cr
**/


#delimit ;
graph twoway (scatter change setting) 
             (lfit change setting);
#delimit cr


graph twoway (scatter change setting) ///
             (lfit change setting)


********************************************************************************
*                                                                              *
*                    1.1 Markers                                               *
*                                                                              *
********************************************************************************

help graph_twoway
help scatter /* click on: marker_options */


* this will remind you of the main marker symbols that are available *

graph query symbol

palette symbolpalette




* solid circle
#delimit ;
graph twoway (scatter change setting, msymbol(circle)); 
#delimit cr

* another way to write it
#delimit ;
graph twoway (scatter change setting, msymbol(O)); 
#delimit cr


* solid triangle
#delimit ;
graph twoway (scatter change setting, msymbol(triangle))
#delimit cr


* another way to write it
#delimit ;
graph twoway (scatter change setting, msymbol(T));
#delimit cr


/* Give it a try 
EXERCISE: */ 

* hollow triangle



* hollow circle





* a scatter plot with weighted markers *
help weight
#delimit ;
graph twoway (scatter change setting [w=effort], msymbol(circle_hollow));
#delimit cr


* adding color *
help colorstyle
#delimit ;
graph twoway (scatter change setting, msymbol(O) mcolor(emerald));
#delimit cr


/* what if you want to change the size of the markers?
EXERCISE: */
*hint: help marker_options




* add a second variable *
* use parantheses to insert another "graph" 

* Stata will also format the two variables differently by default 
* but it may not look the way you want
#delimit ;
graph twoway (scatter change setting)
			 (scatter effort setting);
#delimit cr

/*Try formatting the two plots differently yourself
EXERCISE: */



********************************************************************************
*                                                                              *
*                    1.2 Labelling Points                                      *
*                                                                              *
********************************************************************************
		   


* using the variable country as a label for the points 

help scatter 
// see marker_label_options 

graph twoway (scatter change setting, mlabel(country))




// suppose I want the country numbers to be added to the country label (optional!)
numlabel country_lbl, add
graph twoway (scatter change setting, mlabel(country))

* this graph is too cluttered *

* the position of the marker labels can be rotated using mlabposition *
// see  marker_label_options

// place marker labels beneath markers
help clockposstyle
graph twoway (scatter change setting, mlabel(country) mlabp(6)) 

/* Now position the labels at nine o'clock on the watch face 
EXERCISE: */
	

	
/**

There are are better ways of labelling and positioning points.

We can generate a variable "pos" which has specific values for where we want the
labels on the points to be positioned (the hours on a watch face).


**/


gen pos=3
label variable  pos "position for graph"

	
* here are the labels at position 3 using the variable "pos" *

graph twoway (scatter change setting, mlabel(country) mlabv(pos) ) 
* notice the use of mlabv rather than mlabelposition

* the graph is still a wee bit cluttered however *

* TrinidadTobago *
replace pos = 8 if country==19

* CostaRica *
replace pos = 12 if country==5

* Panama *
replace pos = 2 if country==16

*Nicaragua* 	
replace pos = 2 if country==15 	
	
* positioning labels on the watch face according to the variable "pos" *
	
graph twoway (scatter change setting, mlabel(country) mlabv(pos) ) 



/**

I'm not convinced the numbers alongside the country labels are that useful.

May get confused for some sort of ranking.

Let us remove them from the graph.

**/

//  List names of value labels
label dir


numlabel country_lbl, remove


graph twoway (scatter change setting, mlabel(country) mlabv(pos)) 



********************************************************************************
*                                                                              *
*                    	 1.3 Adding Titles                                     *
*                                                                              *
********************************************************************************			 

// Back to simple graph
graph twoway (scatter change setting)



/**

The stuff after the comma "," 

This is where much of the real work in getting your graph to look publication
ready will take place

A very common mistake is forget the "," .

Try to put it on a seperate line!


**/

help twoway_options
help title_options


#delimit ;
graph twoway (scatter change setting, mcolor(emerald))
			 , 
			 title("Fertility Decline by Social Setting" " ")
             ytitle("Fertility Decline")  
			 xtitle("Index of Social Setting") ;
#delimit cr		



/**

This is a handy reminder of some elements of the graph.

**/


#delimit ;
graph twoway (scatter change setting)
              , 
		     title("Title Here" " ")
             ytitle("y title here")  
			 xtitle("x title here") 		 
			 subtitle("sub title here") 
			 note("note here") 
			 caption("caption goes here") ;
#delimit cr

*Note that the " " in the title gives you a space between the title and the graph
/*What if you wanted to create a title where the words were on two lines?
EXERCISE: */



			 	 
********************************************************************************
*                                                                              *
*                           	1.4 Legends                                    *
*                                                                              *
********************************************************************************			 

	
* turning legends on and off *	


#delimit ;
graph twoway (scatter change setting)
             (lfit change setting) ;
#delimit cr
// The legend seems clunky


// Let's add back our titles

#delimit ;
graph twoway (scatter change setting)
             (lfit change setting) 
              , 
		     title("Fertility Decline by Social Setting" " ")
             ytitle("Fertility Decline")  
			 xtitle("Index of Social Setting") 		 
			 legend(on)
			 ;
#delimit cr

* turn legend off *
 
#delimit ;
graph twoway (scatter change setting)
             (lfit change setting) 
              , 
		     title("Fertility Decline by Social Setting" " ")
             ytitle("Fertility Decline")  
			 xtitle("Index of Social Setting") 		 
			 legend(off)
			 ;
#delimit cr





**** Let's run through various legend features

help legend_options

* changing the shape of the legend (rows and columns) *

* row(#) specifies number of rows

#delimit ;
graph twoway (scatter change setting)
             (lfit change setting) 
              , 
		     title("Fertility Decline by Social Setting" " ")
             ytitle("Fertility Decline")  
			 xtitle("Index of Social Setting") 		 
			 legend(row(1))
			 ;
#delimit cr

* cols(#) specifies number of keys per line

#delimit ;
graph twoway (scatter change setting)
             (lfit change setting) 
              , 
		     title("Fertility Decline by Social Setting" " ")
             ytitle("Fertility Decline")  
			 xtitle("Index of Social Setting") 		 
			 legend(cols(1))
			 ;
#delimit cr



* adding a subtitle to the legend *
			 
#delimit ;
graph twoway (scatter change setting)
             (lfit change setting) 
              , 
		     title("Fertility Decline by Social Setting" " ")
             ytitle("Fertility Decline")  
			 xtitle("Index of Social Setting") 		 
			 legend(cols(1) subtitle("This is my legend"))
			 ;
#delimit cr


/*What about altering the position of the legend?
Hint: help legend_options
EXERCISE: */




* changing the order within the legend and re-titling the symbol*		 

#delimit ;
graph twoway (scatter change setting)
             (lfit change setting) 
              , 
		     title("Fertility Decline by Social Setting" " ")
             ytitle("Fertility Decline")  
			 xtitle("Index of Social Setting") 		 
			 legend(subtitle("This is my legend")
			        order(2 "Line" 1 "Dot"))
			 ;
#delimit cr

* change the order without re-titling 
#delimit ;
graph twoway (scatter change setting)
             (lfit change setting) 
              , 
		     title("Fertility Decline by Social Setting" " ")
             ytitle("Fertility Decline")  
			 xtitle("Index of Social Setting") 		 
			 legend(subtitle("This is my legend")
			        order(2 1))
			 ;
#delimit cr

* change the title without re-ordering 
#delimit ;
graph twoway (scatter change setting)
             (lfit change setting) 
              , 
		     title("Fertility Decline by Social Setting" " ")
             ytitle("Fertility Decline")  
			 xtitle("Index of Social Setting") 		 
			 legend(subtitle("This is my legend")
			        label(1 "Dot") label(2 "Line"))
			 ;
#delimit cr

* using ring(0) to move the legend inside the plotting area *
* ring(#) specifies distance from plot region
			 
#delimit ;
graph twoway (scatter change setting)
             (lfit change setting) 
              , 
		     title("Fertility Decline by Social Setting" " ")
             ytitle("Fertility Decline")  
			 xtitle("Index of Social Setting") 		 
			 legend(ring(0)subtitle("This is my legend")
			        order(1 "Dot" 2 "Line"))
			 ;
#delimit cr

* using ring(0) to move the legend inside the plotting area and position *

/**

Using ring(0) to move the legend inside the plotting area and put it at the
five o'clock position

**/
#delimit ;
graph twoway (scatter change setting)
             (lfit change setting) 
              , 
		     title("Fertility Decline by Social Setting" " ")
             ytitle("Fertility Decline")  
			 xtitle("Index of Social Setting") 		 
			 legend(ring(0) pos(10)subtitle("This is my legend")
			        order(1 "Dot" 2 "Line"))
			 ;
#delimit cr
			
			
/*

Interpretation of ring()
            ---------------------------------------------------
            plot region        0     | ring(0) = plot region
            {t|b|l|r}1title()  1     |
            {t|b|l|r}2title()  2     | ring(k), k>0, is outside
            legend()           3     | the plot region
            note()             4     |
            caption()          5     | the larger the ring()
            subtitle()         6     | value, the farther
            title()            7     | away
            ---------------------------------------------------

                Interpretation of clock position()
                    ring(k), k>0, and ring(0)
            +---------------------------------------+
            |        11         12        1         |
            |                                       |
            |       +-----------------------+       |
            |10     |10 or 11   12   1 or 2 |     2 |
            |       |                       |       |
            |       |                       |       |
            | 9     | 9          0        3 |     3 |
            |       |                       |       |
            |       |                       |       |
            | 8     | 7 or 8     6   4 or 5 |     4 |
            |       +-----------------------+       |
            |                                       |
            |         7         6         5         |
            +---------------------------------------+


  

*/
	
	
********************************************************************************
*                                                                              *
*                           	1.5 Axis                                       *
*                                                                              *
********************************************************************************


			 
help axis_options

* turning the scales off *

help axis_scale_options

#delimit ;
graph twoway (scatter change setting)
             (lfit change setting) 
              , 
			 xscale(off)
			 yscale(off)
		     title("Fertility Decline by Social Setting" " ")
             ytitle("Fertility Decline")  
			 xtitle("Index of Social Setting") 		 
			 legend(off)
			 ;	
#delimit cr


/** 

Removing the axis line.

This is a little less obvious and can be fiddly at first.

**/

#delimit ;
graph twoway (scatter change setting)
             (lfit change setting) 
             , 
			 xscale(noline)
			 yscale(noline)
			 title("Fertility Decline by Social Setting" " ")
             ytitle("Fertility Decline")  
			 xtitle("Index of Social Setting") 		 
			 legend(off)
			 ;
#delimit cr	
		 
* notice that the axis lines look like they are still on the graph *


* it is worth learning something about the plot region *
help region_options
help areastyle

#delimit ;
graph twoway (scatter change setting, plotregion(style(none)));
#delimit cr
// this took away the outline/border and left the axes only

// now remove axis lines

#delimit ;
graph twoway (scatter change setting, plotregion(style(none)))
              ,  
			 xscale(noline)
			 yscale(noline);
#delimit cr

/**


The axes and the border around the plot region were right on top of each other. 

Specifying plotregion(style(none)) will do away with the border and reveal 
only the axes to us.


**/


* changing scales *

help axis_scale_options

// Set x-axis scale to 40 to 110
// Set y-axis scale to -10 to 50
#delimit ;
graph twoway (scatter change setting)
             (lfit change setting) 
              , 
			xscale(range(40 110))
			yscale(range(-10 50))
		     title("Fertility Decline by Social Setting" " ")
             ytitle("Fertility Decline")  
			 xtitle("Index of Social Setting") 		 
			 legend(off)
			 ;			 
#delimit cr



* ticks and axis labels*


// back to standard graph
#delimit ;
graph twoway (scatter change setting)
             (lfit change setting) 
			 ,
		     title("Fertility Decline by Social Setting" " ")
             ytitle("Fertility Decline")  
			 xtitle("Index of Social Setting") 		 
			 legend(off)
			 ;	
#delimit cr
* notice that neither axis starts at 0 for this data



* by default about five or six values are labeled and ticked on each axis *

// suppose I want approx 10 values shown on each axis

help axis_label_options

#delimit ;
graph twoway (scatter change setting)
             (lfit change setting) 
			 ,
		     ylabel(#10) 
			 xlabel(#10)
			 title("Fertility Decline by Social Setting" " ")
             ytitle("Fertility Decline")  
			 xtitle("Index of Social Setting") 		 
			 legend(off)
			 ;	
#delimit cr			 
* notice that the number of ticks changed too


			 
* specifying the values to be labeled and ticked *

#delimit ;
graph twoway (scatter change setting)
             (lfit change setting) 
			 ,
			 ylabel(10 20 30 40 50 60 70 80 90)
			 xlabel(10 20 30 40 50 60 70 80 90)
		     title("Fertility Decline by Social Setting" " ")
             ytitle("Fertility Decline")  
			 xtitle("Index of Social Setting") 		 
			 legend(off)
			 ;	
#delimit cr	 
* notice that the scale changed too 




/*We can also use the label options to specify the rule label 0 to 50 in steps of 
5 on the y axis and 0 to 100 in steps of 5 on the x axis (without writing out each
number in steps of 5)
EXERCISE: */


			
* adding ticks every 10 units *

* (this is different from adding 10 labels)

#delimit ;
graph twoway (scatter change setting)
             (lfit change setting) 
              , 
			 ytick(#10)
			 xtick(#10)
		     title("Fertility Decline by Social Setting" " ")
             ytitle("Fertility Decline")  
			 xtitle("Index of Social Setting") 		 
			 legend(off)
			 ;	
#delimit cr	



*What about adding minor ticks?
/*Add five minor ticks to the y and x axis.
help axis_label_options
EXERCISE: */




* minor labels *


/**

10 minor labels between major ticks on the x axis and

5 minor label between the major ticks on the y axis 

**/


#delimit ;
graph twoway (scatter change setting)
             (lfit change setting) 
              , 
			 ymlabel(##5)
			 xmlabel(##10)
		     title("Fertility Decline by Social Setting" " ")
             ytitle("Fertility Decline")  
			 xtitle("Index of Social Setting") 		 
			 legend(off);
#delimit cr	

		 
		 
		 
* grids  *

help axis_label_options

#delimit ;
graph twoway (scatter change setting)
             (lfit change setting) 
			 ,
			 ylabel(, grid)
			 xlabel(, grid)
		     title("Fertility Decline by Social Setting" " ")
             ytitle("Fertility Decline")  
			 xtitle("Index of Social Setting") 		 
			 legend(off)
			 ;	
#delimit cr	

			 
* grids colors  *

#delimit ;
graph twoway (scatter change setting)
             (lfit change setting) 
			 ,
			 ylabel(, grid glcolor(pink))
			 xlabel(, grid)
		     title("Fertility Decline by Social Setting" " ")
             ytitle("Fertility Decline")  
			 xtitle("Index of Social Setting") 		 
			 legend(off)
			 ;	
#delimit cr	
	
	
/*Specify a line pattern for the grid
help axis_label_options
EXERCISE: */



********************************************************************************


********************************************************************************
*                                                                              *
*                   		2. Line Plots                                 	   *
*                                                                              *    
********************************************************************************

* US life expectancy data *


sysuse uslifeexp, clear

* a simple line plot *

help line

graph twoway line le_wmale le_bmale year

/**

If you are puzzled by the dip prior to 1920 
just search "US life expectancy 1918" 

**/



* altering line color 

help connect_options
help colorstyle

#delimit
graph twoway (line le_wmale le_bmale year , lcolor(green red) )
              , 
			  title("U.S. Life Expectancy") subtitle("Males") 
	          legend( order(1 "White men" 2 "Black men")) ;
#delimit cr


* altering the line pattern *

help linepatternstyle

#delimit
graph twoway (line le_wmale le_bmale year , lpatter(dash dash_dot ))
              , 
			  title("U.S. Life Expectancy") subtitle("Males") 
	          legend( order(1 "White men" 2 "Black men")) ;
#delimit cr
		   

/* Now let's altering the line width; set them to thin and thick
help linewidthstyle
EXERCISE: */






********************************************************************************
*                                                                              *
*              		 3. Saving and Exporting Graphs                            *
*                                                                              *
********************************************************************************	   




********************************************************************************
*                                                                              *
*                    		3.1 Saving Graphs                                  *
*                                                                              *
********************************************************************************	   


* use the saved effort.dta file  *

use "effort.dta", clear


* naming a graph *

#delimit ;
graph twoway (scatter change setting)
              ,
			  name(g1, replace);
#delimit cr	


* now close your graph window *

* displaying a previously named graph *

graph display g1


* saving a graph to disk *

#delimit ;
graph twoway (scatter change setting)
              ,
			  name(g1, replace);
#delimit cr	

graph save g1, replace


* recalling a saved graph *

graph use g1


* draw another graph *

#delimit ;
graph twoway (scatter change setting[w=effort], msymbol(circle_hollow))
              ,
			  name(g2, replace);
#delimit cr	
		  
graph save g2, replace		


* combining graphs *

graph combine g1 g2


* list names of graphs in memory *

graph dir


* the graph that is currently in memory is called "Graph" *

* describe graph stored as "Graph" *

graph describe Graph


* discards a graph stored in memory *

graph drop Graph
graph dir

* discards all graphs in memory *

graph drop _all
graph dir


* discards files from disk (can be any file, not just graphs) *

erase g1.gph 
erase g2.gph 
graph dir

* cannot erase multiple files at one time



********************************************************************************
*                                                                              *
*                    		3.2 Exporting Graphs                               *
*                                                                              *
********************************************************************************

/** 

Let us change dataset for the next section.

**/


sysuse census, clear
gen drate = divorce / pop18p 
label var drate "Divorce rate"
drop if state=="Nevada"

/**

exporting a graph to your document


here are some potential formats

.ps	    PostScript	
.eps	Encapsulated Postscript	
.tif	Tagged Image Format	
.png	Portable Network Graphic	
.wmf	Windows Metafile
.emf	Windows Enhanced Metafile	
.pdf	Portable Document Format	

empf -- works well with word
eps -- frequently used for Latex
png -- useful for displaying on websites


**/



#delimit ;
graph twoway (scatter drate medage, msymbol(circle))
              ,
			  name(g3, replace);
#delimit cr	


* these formats work well with Word *



/* 	windows enhanced metafile  ( BUT I cannot create this using a mac) */
* graph export "g3.emf", replace 





* portable network graphic *

graph export "g3.png", replace



* portable document format *
graph export "g3.ps", replace

*It is not necessary to name the graph in order to export

#delimit ;
graph twoway (scatter drate medage, msymbol(circle));
#delimit cr	

* this is a pdf format *

graph export "g4.pdf", replace



/**

here is a useful web page on file types etc

https://www.ssc.wisc.edu/sscc/pubs/4-23.htm

**/




********************************************************************************
*                                                                              *
*                    3.3 Exporting graphs to Latex                             *
*                                                                              *
********************************************************************************


/**

I am not a Latex user but here is the perceived wisdom.

The package graph2tex is required

graph2tex does two things

1. It takes the most recently created graph and exports it as a .eps file.

2. It displays LaTeX code you could insert for displaying the figure in your 
   LaTeX document.


**/


* you may have to install graph2tex first *


findit graph2tex

	#delimit ;
twoway (scatter divorce marriage) 
        , 
		title("Number of Divorces & Marriages")
		subtitle("(US States)")
		ytitle("Number of Divorces" " ")  
		xtitle(" " "Number of Marriages") 		 
		note("note:State data excluding Nevada")
		legend(off)
		scheme(s1mono);
#delimit cr

graph2tex, epsfile(myplot)	

/**

Stata has saved the file and also given you the Latex code to work with it in 
your document 

\begin{figure}[h]
\begin{centering}
  \includegraphics[height=3in]{myplot}
\end{centering}
\end{figure}


(Note your tex file needs to know the location of myplot)

Here is a useful wee page

http://www.ats.ucla.edu/stat/stata/latex/graph_stata_latex.htm


**/





********************************************************************************
*                                                                              *
*              		 		4. Graphing Results                                *
*                                                                              *
********************************************************************************	   


********************************************************************************
*                                                                              *
*                   		4.1 Using coefplot                                 *
*                                                                              *    
********************************************************************************		 

/**

In this section we cover graphing results.

The focus is graphing results from statistical models.

Rather than graphing "data" we are now graphing "resultssets" 
(i.e. sets of results).

Roger Newson uses the term "resultssets" but he also states that he would 
like to thank Nicholas J. Cox, of Durham University, UK, for coining the term 
resultsset to describe a Stata dataset of results.

**/


/**

Here is a very recent development in extracting and plotting coefficients from
the great Ben Jann.

ftp://repec.sowi.unibe.ch/files/wp1/jann-2013-coefplot.pdf

**/


* you might have to find and install the package first *

findit coefplot

ssc install coefplot


webuse womenwk, clear

tab educ, gen(ed)
label variable age "Age in years"
rename ed1 no_ed
rename ed2 low_education
rename ed3 medium_education
rename ed4 high_education
label variable no_ed "No education"
label variable low_education "Low education"
label variable medium_education "Medium education"
label variable high_education"High education"


regress wage low_education medium_education high_education age

* plotting the coefficients *

coefplot

coefplot, vertical baselevels drop(_cons age) yline(0)

coefplot, vertical baselevels drop(_cons age) yline(0) levels(99 95)

* a more publication ready graph *

#delimit ;
coefplot, vertical baselevels drop(_cons age) yline(0)
          ytitle("Regression Coefficient" " ") 
		  xtitle(" " "Education Level")
		  title("Regression Model of Women's Hourly Wage",
		   size(medium) justification(right) )
		   subtitle("Educational Levels", size(medsmall) justification(right))
		   scheme(s1mono)
          ;
#delimit cr
	
	
* estimate two models *

regress wage low_education medium_education high_education age
estimates store model1

regress wage low_education medium_education high_education age married
estimates store model2



		  
#delimit ;
coefplot model1, vertical baselevels drop(_cons age married) xline(0)
          ytitle(" ""Regression Coefficient") 
		  xtitle(" " "Education Level")
		  xlabel(1 "Low" 
	          2 "Medium" 3 "High"  )
		  title("Regression Model" "of Women's Hourly Wage", /* notice 2 lines*/
		   size(medium) justification(center) )
		   subtitle("Educational Levels", size(medsmall) justification(center))
		   scheme(s1mono)
		   name(gmodel1, replace)
          ;
#delimit cr

#delimit ;
coefplot model2, vertical baselevels drop(_cons age married) yline(0)
          ytitle(" ""Regression Coefficient") 
		  xtitle(" " "Education Level")
		  xlabel(1 "Low" 
	          2 "Medium" 3 "High"  )
		  title("Regression Model" "of Women's Hourly Wage",
		   size(medium) justification(center) )
           subtitle("Educational Levels", size(medsmall) justification(center))
		   scheme(s1mono)
		   name(gmodel2, replace)
          ;
#delimit cr


* plotting the coefficients from both models *

#delimit ;
coefplot (model1, label(model 1)) (model2, label(model 2))
          ,  vertical baselevels 
          drop(_cons age married) yline(0) lcolor(red)
          ytitle(" ""Regression Coefficient") 
		  xtitle(" " "Education Level")
		  xlabel(1 "Low" 
	          2 "Medium" 3 "High"  )
		  title("Regression Model of Women's Hourly Wage",
		   size(medium) justification(center) )
		   subtitle("Educational Levels", size(medsmall) justification(center))
          scheme(s1mono)
		  ;
#delimit cr



/**

Further information and examples are available here

http://www.stata.com/meeting/germany14/abstracts/materials/de14_jann.pdf .


**/


********************************************************************************
*                                                                              *
*                    	4.2 Using parmest                                      *
*                                                                              *
********************************************************************************



/**

Another approach is to use Roger Newson's parmest program.
 
Parmest takes, as input, the most recently calculated set of estimation results, 
created by the most recently executed estimation command.
  
It creates, as output, a new dataset, with one observation per 
estimated parameter, and variables containing parameter names, estimates, 
standard errors, z-test or t-test statistics, p-values, confidence limits, 
and other estimation results if requested by the user.

**/




* you may have to install this package first *

ssc install parmest

ssc d parmest

/**

The hsb2 dataset is taken from a national survey of high school seniors 
two hundred observation were randomly sampled from the 
High School and Beyond survey.

**/


use "https://stats.idre.ucla.edu/stat/stata/notes/hsb2", clear

numlabel _all, add

summarize

tab race 

tabulate race, gen(ethnic)
rename  ethnic1 hispanic
rename ethnic2 asian
rename ethnic3 africam
rename ethnic4 white

reg read female  hispanic asian africam

* save the regression results *

#delimit ;
parmest,format(estimate min95 max95 %8.2f p) list(,) 
               saving(parmest1,replace) ;
#delimit cr		

* use the new file with the regression results *

use parmest1.dta, clear

browse

* take a look at the data *

summarize

browse

gen id=_n

* it can be handy to give each row an id number *

* a simple graph of the estimates for ethnicity in the model *

#delimit ;
twoway (scatter estimate id if id>1 & id<5, msymbol(circle_hollow))
       (rspike min95 max95 id if id>1 & id<5);
#delimit cr

* a more publication-ready graph of the estimates for ethnicity in the model *

#delimit ;
twoway (scatter estimate id if id>1 & id<5, msymbol(circle_hollow))
       (rspike min95 max95 id if id>1 & id<5)
	   ,
	   ytitle("") 
	   xtitle("")
	   xscale(range(2, 4.5))
	   xlabel(2 "Hispanic" 
	          3 "Asian" 4 "African-American" , valuelabel alternate )
       title("Standardised Reading Score, Ethnicity Effects")
       subtitle("Regression coefficients and confidence intervals")
       note("Source: High School and Beyond, n=200."
             "Model 1: Regression model 'Reading Score' ethnicity and gender.")
       legend( order(1 2)label(1 "Parameter estimate") label(2 "95% C.I.") ); 
#delimit cr


********************************************************************************
*                                                                              *
*                    4.3 More general approach                                 *
*                                                                              *
********************************************************************************

/**

Here is another approach to extracting and plotting coefficients.

This is more general and can be adapted for other purposes.

**/

use "https://stats.idre.ucla.edu/stat/stata/notes/hsb2", clear

numlabel _all, add

summarize

tab race, missing

tabulate race, gen(ethnic)
rename  ethnic1 hispanic
rename ethnic2 asian
rename ethnic3 africam
rename ethnic4 white

reg read female  hispanic asian africam

* take a look at the matrix of estimation results *

matrix list e(b)

* make your own matrix *

matrix b = (e(b))

mat list b

* convert matrix info to variables *

svmat b

keep b1 b2 b3 b4 b5

summarize

gen id=_n

* take a look at the data *
summarize id

browse

* all you want are the values in row 1

keep if id==1

browse

* drop the estimate for female and the constant *

drop b1 b5

* calculate a value for whites repsondents *

gen b0=0

* calculate some values for the X axis *

gen id0=1
gen id2=1.5
gen id3=2
gen id4=2.5

#delimit ;
twoway 
	(scatter b0 id0, msymbol(square_hollow) mlcolor(gs0)  msize(medium)) 
	(scatter b2 id2, msymbol(circle_hollow) mlcolor(gs0)  msize(medium)) 			  
	(scatter b3 id3, msymbol(triangle_hollow) mlcolor(gs0)  msize(medium)) 
	(scatter b4 id4, msymbol(diamond_hollow) mlcolor(gs0)  msize(medium))  , 
	ytitle("") xtitle("Ethnicity")  
	yscale(range() titlegap(1) ) xscale(range(1, 3)) 
	xlabel(1 2 3 4 5 6 7 8 9, valuelabel alternate ) 
	xlabel(1 "White" 1.5 "Hispanic" 2 "Asian" 2.5 "African-American", 
	valuelabel alternate ) 
	title("Standardised Reading Score and Ethnicity", 
	size(large) justification(center) )
	subtitle("Regression coefficients", 
	size(medsmall) justification(center) ) 
	note("Source: High School and Beyond, n=200." 
	"Model 1: Regression model 'Reading Score' gender and ethnicity.", 
	justification(left) )
	legend(off) ;
#delimit cr






********************************************************************************
*                  	                                                           *
*                 	 	5. Additional Materials                                 *
*                                                                              *    
********************************************************************************

********************************************************************************
*                                                                              *
*                    		5.1 Aspect ratio                                   *
*                                                                              *    
********************************************************************************		 


sysuse uslifeexp, clear

* an aspect ratio greater than 1 creates a tall skinny graph *

#delimit ;	 
graph twoway (line le_wmale le_bmale year , lwidth(thin thick))
              , 
			  title("U.S. Life Expectancy") subtitle("Males") 
	           legend( order(1 "White men" 2 "Black men")) 
		        aspectratio(1.3);
#delimit cr
		 
		 
* an aspect ratio less than 1 creates a shorter graph *

#delimit ;
graph twoway (line le_wmale le_bmale year , lwidth(thin thick) ) ///
             , 
		     title("U.S. Life Expectancy") subtitle("Males") ///
	         legend( order(1 "white" 2 "black")) ///
		     aspectratio(.3);
#delimit cr




********************************************************************************
*                                                                              *
*                    			5.2 Jitter                                     *
*                                                                              *
********************************************************************************



/** 

Scatter will add spherical random noise to your data before plotting 
if you specify jitter(#), where # represents the size of the noise as 
a percentage of the graphical area.  

This can be useful for creating graphs of categorical data when, 
if the data are not jittered, many of the points would be on top of each other, 
making it impossible to tell whether the plotted point represented 
one or 1,000 observations.

For instance, in a variation on auto.dta used below, mpg is recorded in units 
of 5 mpg, and weight is recorded in units of 500 pounds.  

A standard scatter has considerable overprinting

**/

sysuse autornd, clear
tab mpg

scatter mpg weight , name(nonjitter, replace)

/**

There are 74 points in the graph, even though it appears because of 
overprinting as if there are only 19.

Jittering solves this problem.

**/

scatter mpg weight, jitter(2) name(jitter, replace)

graph combine nonjitter jitter 

********************************************************************************
*                                                                              *
*                    		5.3 Graph Recordings                               *
*                                                                              *
********************************************************************************

/*Another option is to manually make changes in the Stata graph editor
One can "record" these changes by pressing the circle at the bottom right
of the screen, and replay the recordings on the same graph or another graph.

Replaying the changes can be done by:
- opening the graph in the graph edit window and manually playing the recording
after navigating to it, using the play button on the bottom right
- play the recording within your do file, using the 
graph play
command
- (LAST RESORT) opening the .grec recorded file and copying the commands from 
within it, prefacing them with
gr_edit
in your do file

For more information, see:
help graph_editor##recorder
*/

********************************************************************************


/**

© Vernon Gayle, University of Edinburgh.

Professor Vernon Gayle (vernon.gayle@ed.ac.uk) 

This file has been adapted from a do-file produced by Vernon Gayle.

Any material in this file must not be reproduced, 
published or used for teaching without permission from Professor Gayle.

The original idea for teaching graphing in this way came from my colleague
Professor Stephen Jenkins (s.jenkins@lse.ac.uk) who is a Stata genius.

Johannes Langer a graduate student at the University of Edinburgh provided very
useful comments and helped expunge some typos and errors.

Over the last decade much of the Stata materials that Professor Gayle 
has developed have been in close collaboration with Professor Paul Lambert, 
Stirling University. However, Professor Gayle is responsible for any errors 
in this  file.


Citing this .do file

Gayle, V. (2016). Producing Publication Ready Graphs in Stata, 
                  University of Edinburgh.

© Vernon Gayle, University of Edinburgh.

Professor Vernon Gayle (vernon.gayle@ed.ac.uk) 


********************************************************************************

