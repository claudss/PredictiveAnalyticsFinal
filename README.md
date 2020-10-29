# Predictive Analytics Final Project
Final project for Predictive Analytics course at UCLA Extension, completed as part of Data Science certification.

## Table of Contents


## Summary
In this project, I analyzed a dataset of Portugal's real-time parliamentary election results. Data was collected in each of Portugal's districts/territories every 10 minutes or so, for a period of about 4 and a half hours (from 8 PM on 10/6/19 to 12:35 AM on 10/7/19). Values were separated by location and by political party, and included information such as total votes, number/percentage of blank votes and null votes, etc. For comparison purposes, the same values from the previous parliamentary election were also present in the dataset.

## Data
The dataset was acquired from the UC Irvine Machine Learning Repository, which offers free datasets to help out students and any other parties in need of such data- the link to its page on the roster can be found [here](https://archive.ics.uci.edu/ml/datasets/Real-time+Election+Results%3A+Portugal+2019). It also came with some R code used to help clean up the dataset, which has been included within these files. To process the raw data into some additional insights, the R script does as follows:

1. Takes the two main datasets: votes per party per district, and voting information for each district’s parishes (valid votes, past blank votes, past null votes, etc.) 
2. Estimates how many MPs (members of parliament) from each party have been elected based on votes over time using d’Hondt distribution, a specialized mathematical distribution used in electoral contexts
3. Merges newly acquired values with all existing data – this creates full ElectionData dataset file

Outside of this, no further data was transformed, other than my manual addition of a column of ISO 3166-2 geographic codes to the file. This served to clearly denote the locations of each district, and make it easier for tools such as Tableau to render the data visually.

## Exploratory Visualization


## Analysis

## Conclusions
