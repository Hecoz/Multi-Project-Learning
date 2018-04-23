clear;
clc;
close;
warning off;
addpath('./MALSAR/functions/dirty/'); % load function
addpath('./MALSAR/c_files/prf_lbm/'); % load projection c libraries. 
addpath('./MALSAR/utils/');           % load utilities
addpath('./examples/train_and_test/'); 
addpath('./01data/SDPdata/');
addpath('./experiments/')
addpath('./02scripts/run02')
addpath('./02scripts/evaluation')
addpath('./02scripts/models/')

projects = {'AEEEM.mat','MORPH.mat','Relink.mat','softlab.mat'};
for p = 1:length(projects)
    project = projects{p};
    
    datasetName=project;
    %experiments options
    outTenFold         = 10;                    %independent execution numbers
    out_cv_fold        = 5;                     %nested cross validation numbers

    tenXtenFoldResults = cell(1,outTenFold);    %最外层带有随机因子的循环

    SDP_DATA=load(datasetName);
    %init taskNum.
    taskNum = size(SDP_DATA.X,1);
    datasetName = [datasetName,'_alldatafortrain'];

    for randomIndex= 1:outTenFold
        fprintf("<<<<<<<<<<<<<<<<<<<<Independent Execution Number %d>>>>>>>>>>>>>>>>>>>\n",randomIndex);

        inner_allPerformance = build_modela(SDP_DATA,...            %data
                                            out_cv_fold,...         %2 fold
                                            randomIndex);           %index of 10 folds
        tenXtenFoldResults{1,randomIndex} = inner_allPerformance(1,:);
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %save result
    resultFile = fopen(strcat("./03results/Logistic_",datasetName,".txt"),"w+");
    %output impormant parameters
    fprintf(resultFile,"Dataset Name:%s\n",datasetName);
    fprintf(resultFile,"Time: %s\n",datestr(now,0));
    fprintf(resultFile,"Independent Execution: %d;    Cross-Validation: %d\n",outTenFold,out_cv_fold);
    fprintf(resultFile,"\n");
    save_result(resultFile,tenXtenFoldResults,taskNum,outTenFold,out_cv_fold);
    fclose(resultFile);
    %save_result(resultFile,tenXtenFoldResults,taskNum,outTenFold,out_cv_fold);
    SaveResult(tenXtenFoldResults,['./03results/Logistic_',datasetName,'.csv'],outTenFold,out_cv_fold);
end
fprintf("<<<<<<<<<<<<<<<<<<<<Succefful Execution>>>>>>>>>>>>>>>>>>>\n");
