# -*- coding: utf-8 -*-
# -*- coding: utf-8 -*-

# Extract version 3
#
# This script extracts all values within thegreenbook.com
# Version 3 makes changes to the holding of the data
# Whenever it is possible, it will be written into a file and rewritten
# over and over again

import mechanize
from bs4 import BeautifulSoup
import numpy as np
import os

# Redirect current working directory to desktop
# This is to allow saving and retrieving of files easier
os.getcwd()
os.chdir('C:\Users\Hairizuan\Desktop\Zontext')
os.listdir(os.getcwd())

# Start up mechanize
# Standard mechanize code
br = mechanize.Browser()
#br.set_all_readonly(False)
br.set_handle_robots(False)
br.set_handle_refresh(False)
br.addheaders = [('User-agent', 'Chrome')]

# Initialize the url to be looked through
url = 'http://www.thegreenbook.com/'

#####################################################
# First portion of scrapping
# Grabbing the data from the categories of the url
# Get the urls for the categories
# Use them to further obtain the next level in the web hierachy
#####################################################

response = br.open(url)
response_str = response.read()

# Grab all URLs from the main page being scrapped
listOfLinks = ['']
soup = BeautifulSoup(response_str)
for link in soup.find_all('a'):   
    listOfLinks.append(link.get('href'))

# Create a distinct list of web urls    
listOfLinks_nonrepeat = set(listOfLinks)

# To remove the none type from the list
listOfLinks_nonrepeat = [x for x in listOfLinks_nonrepeat if x is not None]

# To only add companies to the list
listOfCategories = ['']
# To go through the list and pull out all items with "companies" inside
for x in range(1, len(listOfLinks_nonrepeat)):
    if '/search/' in listOfLinks_nonrepeat[x]:
        listOfCategories.append(listOfLinks_nonrepeat[x])   
        
#####################################################
# Second portion of scrapping
# Using the list of categories to go one level further to get
# the list of companies in each category
#####################################################

# Debug statement
print('Part 2')

# For writing of records to a file; access an inner folder
os.chdir("./first_extract output")

# Reinitialize the url so that it can be pasted together
url = 'http://www.thegreenbook.com'

# Get the sub categories of the url
listOfSubCategories = ['']
for x in range(1, len(listOfCategories)):
    url_full = url + listOfCategories[x]
    response = br.open(url_full)
    response_str = response.read()
    # Require processing of the response_str
    # Reason: Having all the full html written out is too demanding
    soup = BeautifulSoup(response_str)
    for link in soup.find_all('a'):       
        listOfSubCategories.append([listOfCategories[x], link.get('href'), str(x)])
    # New code between V2 and V3 - continuously write to a file    
    temp_writer = np.asarray(listOfSubCategories)
    np.savetxt('listOfSubCategories.csv', temp_writer, delimiter=',', fmt='%s')
    # Debug line
    print(str(x) + " URL:   " + url_full)
        
# Create a distinct list of web urls    
listOfSubCategories = [list(x) for x in set(tuple(x) for x in listOfSubCategories)]

# To remove the none type from the list
listOfLinks_SubCategories_nonrepeat = ['']
for y in range(1, len(listOfSubCategories)):
    temp = [x for x in listOfSubCategories[y] if x is not None]
    if(len(temp)==3):    
        listOfLinks_SubCategories_nonrepeat.append(temp)

# To go through the list and pull out all items with "companies" inside
SubCategory1 = ['']
for x in range(1, len(listOfLinks_SubCategories_nonrepeat)):
    if '/products/' in listOfLinks_SubCategories_nonrepeat[x][1] and not 'thegreenbook' in listOfLinks_SubCategories_nonrepeat[x][1]:
        SubCategory1.append(listOfLinks_SubCategories_nonrepeat[x])
        print(x)


#####################################################
# Third part of the scrapping process
# Using the list of sub categories, go down one more level to get
# the list of links to all the company profiles
#####################################################

# Debug statement
print('Part 3')

# len(listOfLinks_SubCategories_nonrepeat)

listOfCompanies = ['']
for x in range(1, len(SubCategory1)):
    url_full = url + SubCategory1[x][1]
    response = br.open(url_full)
    response_str = response.read()
    # Require processing of the response_str
    # Reason: Having all the full html written out is too demanding
    soup = BeautifulSoup(response_str)
    for link in soup.find_all('a'):       
        listOfCompanies.append([SubCategory1[x][0], SubCategory1[x][1], link.get('href'), str(x)])
    # New code between V2 and V3 - continuously write to a file    
    temp_writer = np.asarray(listOfCompanies)
    np.savetxt('listOfCompanies.csv', temp_writer, delimiter=',', fmt='%s')
    # Debug line
    print(str(x) + " URL:   " + url_full)

# Create a distinct list of web urls    
listOfCompanies = [list(x) for x in set(tuple(x) for x in listOfCompanies)]

# To remove the none type from the list
listOfCompanies_nonrepeat = ['']
for y in range(1, len(listOfCompanies)):
    temp = [x for x in listOfCompanies[y] if x is not None]
    if(len(temp)==4):
        listOfCompanies_nonrepeat.append(temp)
        print(y)
    
# To go through the list and pull out all items with "companies" inside
Companies = ['']
for x in range(1, len(listOfCompanies_nonrepeat)):
    if '/companies/' in listOfCompanies_nonrepeat[x][2] and not 'enquiryForm' in listOfCompanies_nonrepeat[x][2]:
        Companies.append(listOfCompanies_nonrepeat[x]) 
        print(x)

#####################################################
# Fourth part of the scrapping process
# Writing it to csv file
#####################################################

# Write output to csv(Temporary solution)
Companies = Companies[1: len(Companies)]
a = np.asarray(Companies, dtype = 'string', order = 'FALSE')

np.savetxt('Company profile page.csv', a, delimiter=',', fmt='%s')

