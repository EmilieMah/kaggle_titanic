
###### R  ###################


###################
"load data"
###################
# Nettoyage mémoire 
rm(list=ls())


# Libraries 
require(ggplot2)
require(MASS)
library(aod)
library(pROC)

##Paths 
path_in = "/Users/emiliemahuet/Desktop/études/M2/UPEC/cours/S2/Scoring/3/"
path_out ="/Users/emiliemahuet/Desktop/études/M2/UPEC/cours/S2/Scoring/3/" 


file="TITANIC1.csv"
titanic= read.csv2(paste(path_in,  file, sep=""), sep=";", dec= ",", header=TRUE)
logit <- glm(Survived ~ PClass + Sex + Age, family = binomial, data = titanic)
summary(logit)
#deviance : 1688.1 modèle de départ
#déviance finale : 1195.9


prob=predict(logit,type=c("response"))
titanic$prob=prob


library(pROC)
ROC <- roc(Survived ~ prob, data =titanic)
plot(ROC)   


## odds ratios 
exp(coef(logit))



# Boosting
library(boot)
boot.logit <- function(titanic, index){
  coef(glm(Survived ~., data = titanic, family = binomial, subset = index))
}
set.seed(10)
# Bootstrap standard errors and comparison to standard errors of model
boot(tf.train, boot.logit, 100);summary(logit)$coef[,2]


