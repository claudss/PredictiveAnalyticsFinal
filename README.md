# Predictive Analytics Final Project
Final project for Predictive Analytics course at UCLA Extension, completed as part of Data Science certification.

## Table of Contents
* [Summary](#summary)
* [Data](#data)
* [Work](#exploratory-visualization)
* [Analysis](#analysis)
* [Conclusion](#conclusion)


## Summary
In this project, I analyzed a dataset of Portugal's real-time parliamentary election results, using Tableau to create visuals and R for statistical analysis. Data was collected in each of Portugal's districts/territories every 10 minutes or so, for a period of about 4 and a half hours (from 8 PM on 10/6/19 to 12:35 AM on 10/7/19). Values were separated by location and by political party, and included information such as total votes, number/percentage of blank votes and null votes, etc. For comparison purposes, the same values from the previous parliamentary election were also present in the dataset. Through machine learning models, I explored the potential of predicting voter turnout (i.e. total number of counted votes).

## Data
The dataset was acquired from the UC Irvine Machine Learning Repository, which offers free datasets to help out students and any other parties in need of such data- the link to its page on the roster can be found [here](https://archive.ics.uci.edu/ml/datasets/Real-time+Election+Results%3A+Portugal+2019). It also came with some R code used to help clean up the dataset, which has been included within these files. To process the raw data into some additional insights, the R script does as follows:

1. Takes the two main datasets: votes per party per district, and voting information for each district’s parishes (valid votes, past blank votes, past null votes, etc.) 
2. Estimates how many MPs (members of parliament) from each party have been elected based on votes over time using d’Hondt distribution, a specialized mathematical distribution used in electoral contexts
3. Merges newly acquired values with all existing data – this creates full ElectionData dataset file

Outside of this, no further data was transformed, other than my manual addition of a column of ISO 3166-2 geographic codes to the file. This served to clearly denote the locations of each district, and make it easier for tools such as Tableau to render the data visually.

## Exploratory Visualization
To start, I created a heat map showing the layout of Portugal’s districts, and the total amount of votes counted in each at the end of the real-time data collection period. This includes the islands of Azores (scattered left) and Madeira (lower middle):
![Heatmap](https://github.com/claudss/PredictiveAnalyticsFinal/blob/main/Images/Heatmap.png)

Due to lack of familiarity with Portugal's population spread, I also created some additional graphs via Tableau to examine which districts the most votes were coming from, and how many were being voted for per district:
![Graph1](https://github.com/claudss/PredictiveAnalyticsFinal/blob/main/Images/Graph1.png)

![Graph2](https://github.com/claudss/PredictiveAnalyticsFinal/blob/main/Images/Graph2.png)


## Analysis
The district of Lisboa stood out in my exploratory visualization- reasonable, since the capital of the Lisboa district is also Portugal’s national capital, Lisbon. Due to its clear importance and sway in the political landscape, I decided to use it as my test set to run machine learning models- all other districts could serve as the training set. Simple linear regression with all feasible predictors was the first model to be tested, with solid results:
![Linear Regression](https://github.com/claudss/PredictiveAnalyticsFinal/blob/main/Images/LinearRegression_Stats.png)

I also tested out a best possible subset check via graph to see if any predictors were not necessary. However, this did not result in much change, with the "best subset" having only one variable less than the existing one, so it was not pursued further:
![Best Subset](https://github.com/claudss/PredictiveAnalyticsFinal/blob/main/Images/BestSubset_Graph.png)

As an additional exercise, I also explored how feasible it was to predict how many MPs (members of parliament) would be elected to parliament from any particular political party. This is of interest because, rather than a strict two-party system, Portugal has a wide variety of political parties that have representation in parliament. I created some comparison plots to see how effective a model was at predicting this number (black line) compared to the d'Hondt distribution, a mathematical prediction method specifically engineered for election scenarios (orange line) and the actual progression of MPs elected over the voting period (blue line). Here is an example plot of linear regression vs. these other stats:
![Comparisons](https://github.com/claudss/PredictiveAnalyticsFinal/blob/main/Images/Compare_LinearRegressionSpecific.png)

## Conclusion
Due to this being a project for coursework, the scope was limited. A possible expansion onto it would likely require more research into the political landscape of the country, and examination of what biases could affect voting- e.g., would people vote for the longtime majority party (visible as having many MPs elected in the above chart) out of complacency/loyalty, or are there possibilities to choose other parties due to the promise of their policies/political stances?
