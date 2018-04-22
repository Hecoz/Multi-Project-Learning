%自己实现的10 x 10 fold cross validation 

%%
%用Dirty在软件缺陷预测的数据集上进行验证

%%
% 10* 10-fold cross validation
%s=rng(2);x=rand(1,5);disp(x);
% randIndex=1;
% rng(randIndex);
% x=rand(1,3);
% [~,index]=sort(x);
% test=[0.3303    0.2046; 0.6193    0.2997;0.2668    0.6211];
% disp(test);
% testtt=test(index,:);
% disp(testtt);


%%
%nested cross validation for testing the logistic dirty model
%The stratified cv are integrated into method to handle
%"not_enough_data_sample" problems and privide more accurate estimator
%Han Cao
%24.02.2017
%%
clear;
clc;
close;

addpath('./MALSAR/functions/dirty/'); % load function
addpath('./MALSAR/c_files/prf_lbm/'); % load projection c libraries. 
addpath('./MALSAR/utils/'); % load utilities
addpath('./examples/train_and_test/'); 
addpath('./data/SDPdata/');
addpath('./experiments/')
addpath('./evaluation/')

datasetName='AEEEM.mat';
%optimization options
opts.init = 2;      % guess start point from a zero matrix. 
opts.tFlag = 1;     % terminate after relative objective value does not changes much.
opts.tol = 10^-5;   % tolerance. 
opts.maxIter = 2;   % maximum iteration number of optimization.最大迭代次数

% lambda range
%lambda1_range = 2:-0.01:0.01;
%lambda2_range = 2:-0.05:0.05;
lambda1_range_str=['2' ':' '-0.01' ':' '0.01'];
lambda2_range_str=['2' ':' '-0.05' ':' '0.05'];
lambda1_range = eval(lambda1_range_str);            %对于P的群稀疏正则化
lambda2_range = eval(lambda2_range_str);            %对于Q的群稀疏正则化

%目标函数
obj_func_str = 'Logistic_Dirty';

%超参优化过程中的评估函数
%eval_func_str ='eval_MTL_accuracy';
%eval_func_str ='eval_MTL_Fmeasure';
eval_func_str ='eval_MTL_auc';

%independent execution numbers
outTenFold = 10;

%nested cross validation numbers
out_cv_fold=2;

%optional_cv_fold=5;
optional_cv_fold=3;

%最外层带有随机因子的循环
tenXtenFoldResults =cell(1,outTenFold);


resultFile = fopen(strcat(datasetName,"_result.txt"),"w+");
%output impormant parameters
fprintf(resultFile,"Dataset Name:%s\n",datasetName);
fprintf(resultFile,"Time: %s\n",datestr(now,0));
fprintf(resultFile,"Independent Execution: %d;    Cross-Validation: %d\n",outTenFold,out_cv_fold);
fprintf(resultFile,"maxIter=%d\nlambda1_range=%s\nlambda2_range = %s\neval_func_str=%s\n",opts.maxIter,lambda1_range_str,lambda2_range_str,eval_func_str);
fprintf(resultFile,"\n");

SDP_DATA=load(datasetName);
%init taskNum，应该是5个项目？？？
taskNum = size(SDP_DATA.X,1);

 
for randomIndex= 1:outTenFold
    fprintf("<<<<<<<<<<<<<<<<<<<<Independent Execution Number %d>>>>>>>>>>>>>>>>>>>\n",randomIndex);
    
    inner_allPerformance = Dirty_Classify_Executor(SDP_DATA,...             %数据
                                                   opts,...                %参数选项
                                                   lambda1_range,...       %
                                                   lambda2_range,...       %
                                                   out_cv_fold,...         %2折
                                                   optional_cv_fold,...    %optional_cv_fold 3  don't understand
                                                   obj_func_str,...        %目标函数
                                                   eval_func_str,...       %超参优化过程中的评估函数
                                                   randomIndex);           %10次，
    tenXtenFoldResults{1,randomIndex} = inner_allPerformance;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%计算并保存结果到文件中
saveTenByTenFoldResults(resultFile,tenXtenFoldResults,taskNum,outTenFold,out_cv_fold);

fclose(resultFile);

fprintf("<<<<<<<<<<<<<<<<<<<<Succefful Execution>>>>>>>>>>>>>>>>>>>\n");
