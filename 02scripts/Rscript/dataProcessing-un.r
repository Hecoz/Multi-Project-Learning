library("effsize")

projects = c("AEEEM.mat","MORPH.mat","Relink.mat","softlab.mat")
projectsdata <- NULL
steps <- 100
adds <- 99
for (i in seq(length(projects))) {
  
  project = projects[i]
  multitaskpath <- file.path("..", "..","03results",paste("MultiTask_",project,".csv",sep=""), fsep=.Platform$file.sep)
  MultiData <- read.csv(multitaskpath,header=F)
  unsupervisedpath <- file.path("..", "..","03results",paste("Unsupervised_",project,".csv",sep=""), fsep=.Platform$file.sep)
  unsupervisedData <- read.csv(unsupervisedpath,header=F)

  Fmeasure <- NULL
  AUCdata  <- NULL
  Fmeasure <- cbind(MultiData[,4],unsupervisedData[,4])
  AUCdata <- cbind(MultiData[,5],unsupervisedData[,5])
  
  datalen <- nrow(Fmeasure)
  modelnum <- 2

  result <- NULL
  for(k in seq(1,datalen,by = steps)){
    
    if(is.na(Fmeasure[k:(k+adds),2])){
      tmp1 <- NaN
      tmp2 <- NaN
    }else{
      tmp1 <- wilcox.test(Fmeasure[k:(k+adds),1],Fmeasure[k:(k+adds),2],exact=FALSE,conf.level = 0.95)[3]$p.value
      tmp2 <- cliff.delta(Fmeasure[k:(k+adds),1],Fmeasure[k:(k+adds),2],conf.level = 0.95)[1]$estimate
    }
    if(is.na(AUCdata[k:(k+adds),2])){
      tmp3 <- NaN
      tmp4 <- NaN
    }else{
      tmp3 <- wilcox.test(AUCdata[k:(k+adds),1],AUCdata[k:(k+adds),2],exact=FALSE,conf.level = 0.95)[3]$p.value
      tmp4 <- cliff.delta(AUCdata[k:(k+adds),1],AUCdata[k:(k+adds),2],conf.level = 0.95)[1]$estimate
    }
    tmp <- cbind(tmp1,tmp2,tmp3,tmp4)
    result <- rbind(result,tmp)
  }
  
  projectsdata <- rbind(projectsdata,result)
}
write.csv(projectsdata,"pvalue-delta-10folds-new.csv")






