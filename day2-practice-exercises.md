# Stata Day 2 Practice Exercises

Course materials at https://github.com/dlab-berkeley/stata-fundamentals

Please take a few minutes to give these exercises a try, writing down the command that gives you the answer. Feel free to work on this with a partner or two, and remember that you can use Stata’s help system. Try not to use any of the window-based menus.

1. What is Stata’s current working directory?
2. Start a log file.
3. Load this file into Stata : http://www.ats.ucla.edu/stat/stata/examples/ara/chile
4. How many observations are there?
5. What is the storage type for each variable in the dataset? (hint: use one command to list them all)
6. What year are the data from? (hint: the command from question #3 will list the command you run to get this)
7. What is the average age and income for the dataset?
8. Run the command to disable the pause feature when listing lots of data.
9. How many observations are age 18-29, and what is their average income?
10. Create an indicator/dummy variable for observations age 18-29, called “age_18_29”. Set it to 1 for observations in that age range and 0 otherwise.
11. Label that variable “Observations age 18-29”
12. Create a histogram of age.
13. Cross-tabulate gender and voting intention. Does voting intention differ significantly by gender? (there are multiple ways to test this)
