# SampleCode

Sample code in Python and R languages.

# Python

The Python script aims to extract total number of companies that registered with Greenbook.com
This is done via the use of the Mechanize and Beautiful Soup libraries

-> The Python Script is still in progress (more features and updates)
Some of the drawbacks of this script is due very long run times. It is extracting 3 layers of links from the Greenbook site.
Initially no of links: 30+
Second layer of links: 10000+
Third layer of links : 100,000+ links to tranverse

Hence, future of updates of this script will include
-> Parallel instantiation of python to scrape the site with multiple scrappers
-> Using of database to store the data (Currently it is writing it to a file)

# R

There are two R scripts here:
1. RSelenium.R -> Using of an R script to automatically login to Google Analytics via the Firefox browser. This was an experiment to see whether screenshots of GA can be taken. Baseline reporting
2. Data Manipulation.R -> Common boilerplate R functionalities that I faced while working. Require further clean up in order for it to be usable but I mainly use it by copy and paste the useful functions to my new R scripts before carrying on

