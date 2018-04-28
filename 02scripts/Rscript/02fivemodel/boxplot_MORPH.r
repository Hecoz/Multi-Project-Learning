library(ggplot2)
library("effsize")
library(reshape2)

project <- "MORPH.mat"
filepath <- file.path("..","..", "..","03results", fsep=.Platform$file.sep)
multitaskpath <- file.path(filepath,paste("MultiTask_",project,".csv",sep=""), fsep=.Platform$file.sep)
MultiData <- read.csv(multitaskpath,header=F)
colnames(MultiData) <- c("Accuracy","Precision","Recall","F1","AUC")
MultiData[,1:3] <- NULL
randomforestpath <- file.path(filepath,paste("RandomForest_",project,".csv",sep=""), fsep=.Platform$file.sep)
RMData <- read.csv(randomforestpath,header = F)
colnames(RMData) <- c("Accuracy","Precision","Recall","F1","AUC")
RMData[,1:3] <- NULL
knnpath <- file.path(filepath,paste("KNN_",project,".csv",sep=""), fsep=.Platform$file.sep)
KNNData <- read.csv(knnpath,header = F)
colnames(KNNData) <- c("Accuracy","Precision","Recall","F1","AUC")
KNNData[,1:3] <- NULL
svmpath <- file.path(filepath,paste("SVM_",project,".csv",sep=""), fsep=.Platform$file.sep)
SVMData <- read.csv(svmpath,header = F)
colnames(SVMData) <- c("Accuracy","Precision","Recall","F1","AUC")
SVMData[,1:3] <- NULL
dicisiontreepath <- file.path(filepath,paste("DecisionTree_",project,".csv",sep=""), fsep=.Platform$file.sep)
DTData <- read.csv(dicisiontreepath,header = F)
colnames(DTData) <- c("Accuracy","Precision","Recall","F1","AUC")
DTData[,1:3] <- NULL

pronum <- 100
dataLen <- nrow(MultiData)
projectNum <- dataLen/pronum
evaluateNum <- 2
projectName <- NULL
proName <- c("ant-1.3","arc","camel-1.0","poi-1.5","redaktor","skarbonka","tomcat","velocity","xalan-2.4","xerces-1.2")
for( i in seq(evaluateNum)){
  for(j in seq(projectNum)){
    projectName <- cbind(projectName,t(rep(proName[j],pronum)))
  }
}
projectName <- t(projectName)

MultiData    <- melt(MultiData)
RMData       <- melt(RMData)
KNNData      <- melt(KNNData)
SVMData      <- melt(SVMData)
DTData       <- melt(DTData)

MultiData    <- cbind(MultiData,projectName,rep("JOMORO",evaluateNum*dataLen))
RMData       <- cbind(RMData,projectName,rep("RM",evaluateNum*dataLen))
KNNData      <- cbind(KNNData,projectName,rep("KNN",evaluateNum*dataLen))
SVMData      <- cbind(SVMData,projectName,rep("SVM",evaluateNum*dataLen))
DTData       <- cbind(DTData,projectName,rep("DT",evaluateNum*dataLen))

colnames(MultiData) <- c("evaluate","value","projectname","method")
colnames(RMData) <- c("evaluate","value","projectname","method")
colnames(KNNData) <- c("evaluate","value","projectname","method")
colnames(SVMData) <- c("evaluate","value","projectname","method")
colnames(DTData) <- c("evaluate","value","projectname","method")

allData <- rbind(MultiData,RMData,KNNData,SVMData,DTData)

fun_mean <- function(x){
  return(data.frame(y=mean(x),label=round(mean(x,na.rm=T),3)))
}

p<- ggplot(allData,aes(x = factor(method),y = value),na.rm = TRUE) + geom_boxplot(na.rm = TRUE) + 
  stat_summary(fun.y = mean, geom = "errorbar", aes(ymax = ..y.., ymin = ..y..),width = .75,color = "blue",linetype = "dashed") + 
  xlab("Methods") + 
  ylab("Performance") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
p + facet_grid(evaluate ~ projectname) #以vs和am为分类变量