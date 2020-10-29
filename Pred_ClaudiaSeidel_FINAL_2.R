setwd("D:/Desktop/CSX_ALL/PA/FinalProj") # set up libraries, data, etc.
dset <- read.csv("ElectionData.csv")
library(tidyverse)
library(caret)
library(randomForest)
library(leaps)

# get train and test subsets: can we predict voter turnout in a district (Lisbon) based only on other districts?
# we have to exclude "territorio nacional" here because that is the lump sum of all votes across the country
listrain <- dset[dset$territoryName!="Lisboa" & dset$territoryName!="Território Nacional",]
listest <- dset[dset$territoryName=="Lisboa",]

traintwo <- listrain
testtwo <- listest
trainthree <- listrain
testthree <- listest
trainfour <- listrain
testfour<- listest

# try initial linear model: using specific numerical set of parameters
lm_model_full <- lm(totalVoters~
                      totalMandates+
                      availableMandates+
                      numParishes+
                      numParishesApproved+
                      blankVotes+
                      nullVotes+
                      pre.blankVotes+
                      pre.blankVotesPercentage+
                      pre.nullVotes+
                      pre.nullVotesPercentage+
                      pre.votersPercentage+
                      pre.subscribedVoters+
                      pre.totalVoters,data=listrain)
#lm_model_full <- lm(totalVoters~., data=train)
summary(lm_model_full)

p <- predict(lm_model_full, listest)

#predicted values
#training set predictions from the model fit to the training set
listrain$predict_full <- predict(lm_model_full, data=listrain) 
#test set predictions from the model fit to the training set
listest$predict_full <- predict(lm_model_full, 
                                newdata = listest)



# some extras- we can see from this barplot that there is some high intercorrelation between variables (high VIF values)
# however, these variables all have to do with votes in some way, which means it makes sense why they would have correlation
#library(car)
#vif_object<-as.data.frame(vif(lm_model_full))
#vif_object
#barplot(vif(lm_model_full))

# begin the best subset selection process
regfit.full=regsubsets(totalVoters~
                         totalMandates+
                         availableMandates+
                         numParishes+
                         numParishesApproved+
                         blankVotes+
                         nullVotes+
                         pre.blankVotes+
                         pre.blankVotesPercentage+
                         pre.nullVotes+
                         pre.nullVotesPercentage+
                         pre.votersPercentage+
                         pre.subscribedVoters+
                         pre.totalVoters,data=listrain, nvmax=13, method="forward")

reg.summary=summary(regfit.full)
reg.summary
names(reg.summary) # name options?
reg.summary$rsq # r-squared values all look high- good!

# begin k-fold (10-fold) cross-validation
k=10
set.seed(1)
folds=sample(1:k,nrow(listrain),replace=TRUE)
cv.errors=matrix(NA,k,13, dimnames=list(NULL, paste(1:13)))
#k = 10, nrow = number of observations, 13 variables total under consideration
# function from ISLR textbook - predict with regsubsets
predict.regsubsets=function(object,newdata,id,...){
  form=as.formula(object$call[[2]])
  mat=model.matrix(form,newdata)
  coefi=coef(object,id=id)
  xvars=names(coefi)
  mat[,xvars]%*%coefi
}
#iterate across all variables (using folds) and calculate the cross-validation error
for(j in 1:k){
  best.fit=regsubsets(totalVoters~
                        totalMandates+
                        availableMandates+
                        numParishes+
                        numParishesApproved+
                        blankVotes+
                        nullVotes+
                        pre.blankVotes+
                        pre.blankVotesPercentage+
                        pre.nullVotes+
                        pre.nullVotesPercentage+
                        pre.votersPercentage+
                        pre.subscribedVoters+
                        pre.totalVoters,data=listrain[folds!=j,],nvmax=13,
                      method="forward")
  for(i in 1:13){
    pred=predict(best.fit,listrain[folds==j,],id=i)
    cv.errors[j,i]=mean( (listrain$totalVoters[folds==j]-pred)^2)
  }
}
mean.cv.errors=apply(cv.errors,2,mean)
mean.cv.errors
par(mfrow=c(1,1))
plot(mean.cv.errors,type='b', xlab="Number of Variables") # show graph- things flatten out fully at 16!

# find out what variable's got to go
reg.best=regsubsets(totalVoters~
                      totalMandates+
                      availableMandates+
                      numParishes+
                      numParishesApproved+
                      blankVotes+
                      blankVotesPercentage+
                      nullVotes+
                      nullVotesPercentage+
                      votersPercentage+
                      subscribedVoters+
                      pre.blankVotes+
                      pre.blankVotesPercentage+
                      pre.nullVotes+
                      pre.nullVotesPercentage+
                      pre.votersPercentage+
                      pre.subscribedVoters+
                      pre.totalVoters, data=listrain, nvmax=13,
                    method="forward")
names(coef(reg.best,13)) # this is where we see our curve flatten out earliest!

# new model, with pre.blankVotes (which was missing above) removed- can we see much difference?
lm_model_subset = lm(totalVoters~
                       totalMandates+
                       availableMandates+
                       numParishes+
                       numParishesApproved+
                       blankVotes+
                       blankVotesPercentage+
                       nullVotes+
                       nullVotesPercentage+
                       votersPercentage+
                       subscribedVoters+
                       pre.blankVotesPercentage+
                       pre.nullVotes+
                       pre.nullVotesPercentage+
                       pre.votersPercentage+
                       pre.subscribedVoters+
                       pre.totalVoters, data=listrain)
summary(lm_model_subset) # pretty much identical...


# ----- EXTRA: PREDICTING NUMBER OF MPS -----
# RANDOM FOREST
traintwo <- traintwo[,-c(15:21)] # data from previous election
testtwo <- testtwo[,-c(15:21)] # data from previous election

traintwo$territoryName <- NULL; traintwo$time <- NULL; traintwo$Party <- NULL
testtwo.name <- testtwo$territoryName; testtwo$territoryName <- NULL 
testtwo.time <- testtwo$time; testtwo$time <- NULL
testtwo.party <- testtwo$Party; testtwo$Party <- NULL 
traintwo.ISOCode <- traintwo$ISOCode; traintwo$ISOCode <- NULL
testtwo.ISOCode <- testtwo$ISOCode; testtwo$ISOCode <- NULL

rfmodel <- randomForest(FinalMandates ~ ., traintwo);
p <- predict(rfmodel, testtwo)

testtwo["Prediction"] <- p
testtwo["Party"] <- testtwo.party

elapsed.testtwo <- unique(testtwo$TimeElapsed)

ggplot(testtwo,aes(x=TimeElapsed,y=Prediction,group=Party)) + 
  geom_line(data=testtwo,mapping = aes(x=TimeElapsed,y=Hondt,colour="red")) + 
  geom_line(data=testtwo,mapping = aes(x=TimeElapsed,y=FinalMandates,colour="blue")) + 
  geom_line() + facet_wrap(Party ~ .)

print(rfmodel)

# LINEAR MODELING
library(glm)
trainthree <- trainthree[,-c(15:21)] # data from previous election
testthree <- testthree[,-c(15:21)] # data from previous election

trainthree$territoryName <- NULL; trainthree$time <- NULL; trainthree$Party <- NULL
testthree.name <- testthree$territoryName; testthree$territoryName <- NULL 
testthree.time <- testthree$time; testthree$time <- NULL
testthree.party <- testthree$Party; testthree$Party <- NULL 
trainthree.ISOCode <- trainthree$ISOCode; trainthree$ISOCode <- NULL
testthree.ISOCode <- testthree$ISOCode; testthree$ISOCode <- NULL

lmmodel1 <- lm(FinalMandates ~ ., trainthree, family="binomial");
p <- predict(lmmodel1, testthree)

testthree["Prediction"] <- p
testthree["Party"] <- testthree.party

elapsed.testthree <- unique(testthree$TimeElapsed)

ggplot(testthree,aes(x=TimeElapsed,y=Prediction,group=Party)) + 
  geom_line(data=testthree,mapping = aes(x=TimeElapsed,y=Hondt,colour="red")) + 
  geom_line(data=testthree,mapping = aes(x=TimeElapsed,y=FinalMandates,colour="blue")) + 
  geom_line() + facet_wrap(Party ~ .)

print(lmmodel1)

# LINEAR MODEL - TRIMMED SLIGHTLY
trainfour <- trainfour[,-c(15:21)] # data from previous election
testfour <- testfour[,-c(15:21)] # data from previous election

trainfour$territoryName <- NULL; trainfour$time <- NULL; trainfour$Party <- NULL
testfour.name <- testfour$territoryName; testfour$territoryName <- NULL 
testfour.time <- testfour$time; testfour$time <- NULL
testfour.party <- testfour$Party; testfour$Party <- NULL 
trainfour.ISOCode <- trainfour$ISOCode; trainfour$ISOCode <- NULL
testfour.ISOCode <- testfour$ISOCode; testfour$ISOCode <- NULL

smallmodel <- lm(FinalMandates ~ totalMandates+availableMandates+totalVoters+Votes+Hondt, trainfour, family="binomial");
psmall <- predict(smallmodel, testfour)

testfour["Prediction"] <- psmall
testfour["Party"] <- testfour.party

elapsed.testfour <- unique(testfour$TimeElapsed)

ggplot(testfour,aes(x=TimeElapsed,y=Prediction,group=Party)) + 
  geom_line(data=testfour,mapping = aes(x=TimeElapsed,y=Hondt,colour="red")) + 
  geom_line(data=testfour,mapping = aes(x=TimeElapsed,y=FinalMandates,colour="blue")) + 
  geom_line() + facet_wrap(Party ~ .)

library(caret)
print(smallmodel)
