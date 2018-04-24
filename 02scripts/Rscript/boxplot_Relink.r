library(ggplot2)
library("effsize")
library(reshape2)

project <- "Relink.mat"
multitaskpath <- file.path("..", "..","03results",paste("MultiTask_",project,".csv",sep=""), fsep=.Platform$file.sep)
MultiData <- read.csv(multitaskpath,header=F)
colnames(MultiData) <- c("Accuracy","Precision","Recall","F1","AUC")
logisticpath <- file.path("..", "..","03results",paste("Logistic_",project,".csv",sep=""), fsep=.Platform$file.sep)
LogisticData <- read.csv(logisticpath,header=F)
colnames(LogisticData) <- c("Accuracy","Precision","Recall","F1","AUC")
logisticallpath <- file.path("..", "..","03results",paste("Logistic_",project,"_alldatafortrain.csv",sep=""), fsep=.Platform$file.sep)
LogisticAll <- read.csv(logisticallpath,header=F)
colnames(LogisticAll) <- c("Accuracy","Precision","Recall","F1","AUC")
randomforestpath <- file.path("..", "..","03results",paste("RandomForest_",project,".csv",sep=""), fsep=.Platform$file.sep)
RMData <- read.csv(randomforestpath,header = F)
colnames(RMData) <- c("Accuracy","Precision","Recall","F1","AUC")
knnpath <- file.path("..", "..","03results",paste("KNN_",project,".csv",sep=""), fsep=.Platform$file.sep)
KNNData <- read.csv(knnpath,header = F)
colnames(KNNData) <- c("Accuracy","Precision","Recall","F1","AUC")
svmpath <- file.path("..", "..","03results",paste("SVM_",project,".csv",sep=""), fsep=.Platform$file.sep)
SVMData <- read.csv(svmpath,header = F)
colnames(SVMData) <- c("Accuracy","Precision","Recall","F1","AUC")
dicisiontreepath <- file.path("..", "..","03results",paste("DecisionTree_",project,".csv",sep=""), fsep=.Platform$file.sep)
DTData <- read.csv(dicisiontreepath,header = F)
colnames(DTData) <- c("Accuracy","Precision","Recall","F1","AUC")

dataLen <- nrow(MultiData)
projectNum <- dataLen/20
evaluateNum <- 5
projectName <- NULL
proName <- c("Apache","Safe","Zxing")
for( i in seq(evaluateNum)){
  for(j in seq(projectNum)){
    projectName <- cbind(projectName,t(rep(proName[j],20)))
  }
}
projectName <- t(projectName)

MultiData    <- melt(MultiData)
LogisticData <- melt(LogisticData)
LogisticAll  <- melt(LogisticAll)
RMData       <- melt(RMData)
KNNData      <- melt(KNNData)
SVMData      <- melt(SVMData)
DTData       <- melt(DTData)

MultiData    <- cbind(MultiData,projectName,rep("XXX",evaluateNum*dataLen))
LogisticData <- cbind(LogisticData,projectName,rep("SPL",evaluateNum*dataLen))
LogisticAll  <- cbind(LogisticAll,projectName,rep("SCL",evaluateNum*dataLen))
RMData       <- cbind(RMData,projectName,rep("RM",evaluateNum*dataLen))
KNNData      <- cbind(KNNData,projectName,rep("KNN",evaluateNum*dataLen))
SVMData      <- cbind(SVMData,projectName,rep("SVM",evaluateNum*dataLen))
DTData       <- cbind(DTData,projectName,rep("DT",evaluateNum*dataLen))

colnames(MultiData) <- c("evaluate","value","projectname","method")
colnames(LogisticData) <- c("evaluate","value","projectname","method")
colnames(LogisticAll) <- c("evaluate","value","projectname","method")
colnames(RMData) <- c("evaluate","value","projectname","method")
colnames(KNNData) <- c("evaluate","value","projectname","method")
colnames(SVMData) <- c("evaluate","value","projectname","method")
colnames(DTData) <- c("evaluate","value","projectname","method")

allData <- rbind(MultiData,LogisticData,LogisticAll,RMData,KNNData,SVMData,DTData)

fun_mean <- function(x){
  return(data.frame(y=mean(x),label=round(mean(x,na.rm=T),3)))
}

p<- ggplot(allData,aes(factor(method),value),na.rm = TRUE) + geom_boxplot(na.rm = TRUE) + stat_summary(fun.y=mean, geom="point", shape=20, size=1, color="red", fill="red") + stat_summary(fun.data = fun_mean, geom="text",color="red",size=2, vjust=-0.7)
p + facet_grid(projectname ~ evaluate) #以vs和am为分类变量
#previous_theme <- theme_set(theme_bw())
