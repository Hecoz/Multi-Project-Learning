clear;
clc;
close;
addpath('./03results/'); % load function

projects = {'AEEEM.mat','MORPH.mat','Relink.mat','softlab.mat'};

projectsdata = [];
steps = 100;
step = 99;
for p = 1:length(projects)
    project = projects{p};

    filename = project;
    MultiData    = csvread(['MultiTask_',filename,'.csv']);
    LogisticData = csvread(['Logistic_',filename,'.csv']);
    LogisticAll  = csvread(['Logistic_',filename,'_alldatafortrain.csv']);
    Fmeasure = [];
    AUCdata  = [];
    Fmeasure(:,1) = MultiData(:,4);
    Fmeasure(:,2) = LogisticData(:,4);
    Fmeasure(:,3) = LogisticAll(:,4);
    AUCdata(:,1)  = MultiData(:,5);
    AUCdata(:,2)  = LogisticData(:,5);
    AUCdata(:,3)  = LogisticAll(:,5);

    datalen  = length(Fmeasure);
    modelnum = 3;
    projectdata = [];
    for modelitem = 1:modelnum
        result = [];
        for i = 1:steps:datalen
            tmp(1) = mean(Fmeasure(i:(i+step),modelitem),'omitnan');
            tmp(2) = std(Fmeasure(i:(i+step),modelitem),0,'omitnan');
            tmp(3) = mean(AUCdata(i:(i+step),modelitem),'omitnan');
            tmp(4) = std(AUCdata(i:(i+step),modelitem),0,'omitnan');
            result = [result;tmp];
        end
        projectdata = [projectdata result];
    end
    projectsdata = [projectsdata;projectdata];
end
%save result
csvwrite('resultdata_new.csv',projectsdata);