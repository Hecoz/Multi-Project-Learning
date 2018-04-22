%%
%用Dirty在软件缺陷预测的数据集上进行验证


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

addpath('../MALSAR/functions/dirty/'); % load function
addpath('../MALSAR/c_files/prf_lbm/'); % load projection c libraries. 
addpath('../MALSAR/utils/'); % load utilities
addpath('../examples/train_and_test/'); 

SDP_DATA=load('AEEEM.mat');

%维度数
d = size(SDP_DATA.X{1},2);
%任务数
T = size(SDP_DATA.X,1);

X = SDP_DATA.X;
Y = SDP_DATA.Y;
W = randn(d, T);
W_mask = abs(randn(d, T))<1;
W(W_mask) = 0;

% preprocessing data
for t = 1: length(X)
    X{t} = zscore(X{t});                  % normalization
    %X{t} = [X{t} ones(size(X{t}, 1), 1)]; % add bias. 增加偏倚
end

%optimization options
opts.init = 2;  
opts.tFlag = 1; 
opts.tol = 10^-5;
%opts.maxIter = 100000; 
opts.maxIter = 10; 

% lambda range
lambda1_range = 2:-0.01:0.01;
lambda2_range = 2:-0.05:0.05;

%nested cross validation
out_cv_fold=10;
in_cv_fold=5;

%目标函数
obj_func_str = 'Logistic_Dirty';
%超参优化过程中的评估函数
%eval_func_str ='eval_MTL_accuracy';
%eval_func_str ='eval_MTL_Fmeasure';
eval_func_str ='eval_MTL_auc';

%output impormant parameters
fprintf("maxIter=%d\nlambda1_range=2:-0.01:0.01\nlambda2_range = 2:-0.05:0.05\neval_func_str=%s",opts.maxIter,eval_func_str);

%container for holding the results
r_inCvAcc=cell(1,out_cv_fold); %
r_S=cell(1,out_cv_fold);
%记录每一折中间的性能结果
r_allPerfromance=cell(1,out_cv_fold);




for i = 1: out_cv_fold
    Xtr = cell(T, 1);
    Ytr = cell(T, 1);
    Xte = cell(T, 1);
    Yte = cell(T, 1);
    
    %stratified cross validation
    for t = 1: T
        task_sample_size = length(Y{t});
        ct = find(Y{t}==-1);
        cs = find(Y{t}==1);
        %开始选取第i折的训练数据索引：包括正负两个实例
        ct_idx = i : out_cv_fold : length(ct);
        cs_idx = i : out_cv_fold : length(cs);
        
        te_idx = [ct(ct_idx); cs(cs_idx)];
        tr_idx = setdiff(1:task_sample_size, te_idx);
        
        Xtr{t} = X{t}(tr_idx, :);
        Ytr{t} = Y{t}(tr_idx, :);
        Xte{t} = X{t}(te_idx, :);
        Yte{t} = Y{t}(te_idx, :);
    end
    %找到最优超产的交叉检验过程
    %inner cv
    fprintf('inner CV started')
     [best_lambda1, best_lambda2, accuracy_mat] = CrossValidationDirty( Xtr, Ytr, ...
        obj_func_str, opts, lambda1_range,lambda2_range, in_cv_fold, ...
        eval_func_str);
    
    %用最优的超参来构建模型
    %train
    %warm start for one turn
    [W, C, P, Q, funcVal, lossVal] = Logistic_Dirty(Xtr, Ytr, best_lambda1, best_lambda2, opts);
    opts2=opts;
    opts2.init=1;
    opts2.C0=C;
    opts2.P0=P;
    opts2.Q0=Q;
    opts2.tol = 10^-10;
    [W2, C2, P2, Q2, funcVal2, lossVal2] = Logistic_Dirty(Xtr, Ytr, best_lambda1, best_lambda2, opts2);
    

     %test保存当前迭代的所有任务的所有结果
    current_iteration_performance = eval_MTL_allPerformance(Yte, Xte, W2, C2);
    
    %collect results,将当前结果保存到所有的轮次中
    r_allPerfromance{1,i}=current_iteration_performance;
    r_inCvAcc{i}=accuracy_mat;
    r_S{i}=nnz((sum(W2,2)==0))/size(W2,1);
  
end

 %fprintf('the average accuracy is \n')
 %disp(mean(cell2mat(r_acc)))
 

%预分配内存
acc = zeros(1,out_cv_fold);
pre = zeros(1,out_cv_fold);
recall =zeros(1,out_cv_fold);
f1 = zeros(1,out_cv_fold);
auc = zeros(1,out_cv_fold);

%先保存起来看看
%save 'allPerform' r_allPerfromance
 
 %输出统计结果
 for i=1: T
     %每一轮迭代结果   
    for j=1:out_cv_fold
        acc(j) = r_allPerfromance{1,j}(i).accuracy;
        pre(j) =r_allPerfromance{1,j}(i).precision;
        recall(j) = r_allPerfromance{1,j}(i).recall;
        f1(j) =  r_allPerfromance{1,j}(i).f_measure;
        auc(j) = r_allPerfromance{1,j}(i).auc;
    end
    
    fprintf('Summary on Task %d:\r Perform\tMean\tMax\r [Acc\t%f\t%f]\r [Pre\t%f\t%f]\r [Recall\t%f\t%f]\r [F1\t%f\t%f]\r [AUC\t%f\t%f]\r',i,...
    mean(acc,'omitnan'),max(acc),...
    mean(pre,'omitnan'),max(pre),...
    mean(recall,'omitnan'),max(recall),...
    mean(f1,'omitnan'),max(f1),...
    mean(auc,'omitnan'),max(auc));
 end

 
 %cv accuracy cross lambda
for i=1:out_cv_fold
    surf(lambda1_range', lambda2_range,r_inCvAcc{i}' );
    xlabel('Parameter for P');
    ylabel('parameter for Q');
    hold on; 
end
hold off;
title(fprintf('cross validation %s over different lambda ',eval_func_str));
set(gca,'FontSize',12);
print('-dpdf', '-r100', 'LogisticDirty');

 
