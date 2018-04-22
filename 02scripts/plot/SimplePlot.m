clear;
clc;
close;
addpath('./03results/'); % load function

MultiData    = csvread('MultiTask_softlab.mat.csv');
LogisticData = csvread('Logistic_softlab.mat.csv');
LogisticAll  = csvread('Logistic_softlab.mat_alldatafortrain.csv');

figure
boxplot([MultiData(:,1),LogisticData(:,1),LogisticAll(:,1)]);
title('Accuracy-Overall')

figure
boxplot([MultiData(:,2),LogisticData(:,2),LogisticAll(:,2)]);
title('Precision-Overall')

figure
boxplot([MultiData(:,3),LogisticData(:,3),LogisticAll(:,3)]);
title('Recall-Overall')

figure
boxplot([MultiData(:,4),LogisticData(:,4),LogisticAll(:,4)]);
title('F1-Overall')

figure
boxplot([MultiData(:,5),LogisticData(:,5),LogisticAll(:,5)]);
title('AUC-Overall')