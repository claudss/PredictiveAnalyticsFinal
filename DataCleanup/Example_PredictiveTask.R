setwd("D:/Desktop/CSX_ALL/PA/FinalProj/")
library(ggplot2)
library(randomForest)

res <- read.csv("ElectionData.csv")

train <- res[res$territoryName!="Lisboa" & dset$territoryName!="Território Nacional",]
test <- res[res$territoryName=="Lisboa",]

train <- train[,-c(15:21)] # data from previous election
test <- test[,-c(15:21)] # data from previous election

train$territoryName <- NULL; train$time <- NULL; train$Party <- NULL
test.name <- test$territoryName; test$territoryName <- NULL 
test.time <- test$time; test$time <- NULL
test.party <- test$Party; test$Party <- NULL 
train.ISOCode <- train$ISOCode; train$ISOCode <- NULL
test.ISOCode <- test$ISOCode; test$ISOCode <- NULL

library(randomForest);
model <- randomForest(FinalMandates ~ ., train);
p <- predict(model, test)

test["Prediction"] <- p
test["Party"] <- test.party

elapsed.test <- unique(test$TimeElapsed)

ggplot(test,aes(x=TimeElapsed,y=Prediction,group=Party)) + 
  geom_line(data=test,mapping = aes(x=TimeElapsed,y=Hondt,colour="red")) + 
  geom_line(data=test,mapping = aes(x=TimeElapsed,y=FinalMandates,colour="blue")) + 
  geom_line() + facet_wrap(Party ~ .)

library(caret)
print(model)




train <- res[res$territoryName!="Lisboa" & dset$territoryName!="Território Nacional",]
test <- res[res$territoryName=="Lisboa",]

train <- train[,-c(15:21)] # data from previous election
test <- test[,-c(15:21)] # data from previous election

train$territoryName <- NULL; train$time <- NULL; train$Party <- NULL
test.name <- test$territoryName; test$territoryName <- NULL 
test.time <- test$time; test$time <- NULL
test.party <- test$Party; test$Party <- NULL 
train.ISOCode <- train$ISOCode; train$ISOCode <- NULL
test.ISOCode <- test$ISOCode; test$ISOCode <- NULL


#library(glm);
model <- lm(FinalMandates ~ ., train, family="binomial");
p <- predict(model, test)

test["Prediction"] <- p
test["Party"] <- test.party

elapsed.test <- unique(test$TimeElapsed)

ggplot(test,aes(x=TimeElapsed,y=Prediction,group=Party)) + 
  geom_line(data=test,mapping = aes(x=TimeElapsed,y=Hondt,colour="red")) + 
  geom_line(data=test,mapping = aes(x=TimeElapsed,y=FinalMandates,colour="blue")) + 
  geom_line() + facet_wrap(Party ~ .)

library(caret)
print(model)




train <- res[res$territoryName!="Lisboa" & dset$territoryName!="Território Nacional",]
test <- res[res$territoryName=="Lisboa",]

train <- train[,-c(15:21)] # data from previous election
test <- test[,-c(15:21)] # data from previous election

train$territoryName <- NULL; train$time <- NULL; train$Party <- NULL
test.name <- test$territoryName; test$territoryName <- NULL 
test.time <- test$time; test$time <- NULL
test.party <- test$Party; test$Party <- NULL 
train.ISOCode <- train$ISOCode; train$ISOCode <- NULL
test.ISOCode <- test$ISOCode; test$ISOCode <- NULL

smallmodel <- lm(FinalMandates ~ totalMandates+availableMandates+totalVoters+Votes+Hondt, train, family="binomial");
psmall <- predict(smallmodel, test)

test["Prediction"] <- psmall
test["Party"] <- test.party

elapsed.test <- unique(test$TimeElapsed)

ggplot(test,aes(x=TimeElapsed,y=Prediction,group=Party)) + 
  geom_line(data=test,mapping = aes(x=TimeElapsed,y=Hondt,colour="red")) + 
  geom_line(data=test,mapping = aes(x=TimeElapsed,y=FinalMandates,colour="blue")) + 
  geom_line() + facet_wrap(Party ~ .)

library(caret)
print(model)
