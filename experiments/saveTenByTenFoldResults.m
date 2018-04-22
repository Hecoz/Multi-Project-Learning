%%保存10 x 10 fold cross validation results
function saveTenByTenFoldResults (resultFile,tenXtenFoldResults,taskNum,outTenFold,out_cv_fold)

    acc_all=zeros(outTenFold,out_cv_fold,taskNum);
    pre_all =zeros(outTenFold,out_cv_fold,taskNum);
    recall_all=zeros(outTenFold,out_cv_fold,taskNum);
    f1_all=zeros(outTenFold,out_cv_fold,taskNum);
    auc_all=zeros(outTenFold,out_cv_fold,taskNum);
    %格式化数据输出，小数点后保留四位

    for t=1:taskNum
        for i=1: outTenFold
            for j=1:out_cv_fold
                acc_all(i,j,t) = tenXtenFoldResults{1,i}{1,j}(t).accuracy;
                pre_all(i,j,t) =tenXtenFoldResults{1,i}{1,j}(t).precision;
                recall_all(i,j,t) = tenXtenFoldResults{1,i}{1,j}(t).recall;
                f1_all(i,j,t) =  tenXtenFoldResults{1,i}{1,j}(t).f_measure;
                auc_all(i,j,t) = tenXtenFoldResults{1,i}{1,j}(t).auc;
            end           
        end
    end

    %acc_all= vpa(acc_all,4);
    %每一个10折的最大值和平均值
    %输出统计结果
    for i=1: taskNum
        %每一轮迭代结果   
        fprintf(resultFile,'<<<<<<<<<<<<<<<<<<<<Summary On Task %d:>>>>>>>>>>>>>>>>>>>>\r',i);
        fprintf(resultFile,'Acc: %d-folds Means: %s\n',out_cv_fold,mat2str(mean(acc_all(:,:,i),2,'omitnan')));
        fprintf(resultFile,'Acc: %d-folds Max: %s\n',out_cv_fold,mat2str(max(acc_all(:,:,i),[],2)));

        fprintf(resultFile,'Pre: %d-folds Means: %s\n',out_cv_fold,mat2str(mean(pre_all(:,:,i),2,'omitnan')));
        fprintf(resultFile,'Pre: %d-folds Max: %s\n',out_cv_fold,mat2str(max(pre_all(:,:,i),[],2)));

        fprintf(resultFile,'recall: %d-folds Means: %s\n',out_cv_fold,mat2str(mean(recall_all(:,:,i),2,'omitnan')));
        fprintf(resultFile,'recall: %d-folds Max: %s\n',out_cv_fold,mat2str(max(recall_all(:,:,i),[],2)));

        fprintf(resultFile,'f1: %d-folds Means: %s\n',out_cv_fold,mat2str(mean(f1_all(:,:,i),2,'omitnan')));
        fprintf(resultFile,'f1: %d-folds Max: %s\n',out_cv_fold,mat2str(max(f1_all(:,:,i),[],2)));

        fprintf(resultFile,'auc: %d-folds Means: %s\n',out_cv_fold,mat2str(mean(auc_all(:,:,i),2,'omitnan')));
        fprintf(resultFile,'auc: %d-folds Max: %s\n',out_cv_fold,mat2str(max(auc_all(:,:,i),[],2)));

        %输出最后的总体情况

        fprintf(resultFile,'******************************************************************\n\n');
        fprintf(resultFile,'Task %d: Acc-Overall: Means:%f \t Max: %f\n',...
                                  i,mean(mean(acc_all(:,:,i),2,'omitnan')),max(max(acc_all(:,:,i),[],2)));
        fprintf(resultFile,'Task %d: Pre-Overall: Means:%f \t Max: %f\n',...
                                  i,mean(mean(pre_all(:,:,i),2,'omitnan')),max(max(pre_all(:,:,i),[],2)));
        fprintf(resultFile,'Task %d: Recall-Overall: Means:%f \t Max: %f\n',...
                                  i,mean(mean(recall_all(:,:,i),2,'omitnan')),max(max(recall_all(:,:,i),[],2)));
        fprintf(resultFile,'Task %d: F1-Overall: Means:%f \t Max: %f\n',...
                                  i,mean(mean(f1_all(:,:,i),2,'omitnan')),max(max(f1_all(:,:,i),[],2)));
        fprintf(resultFile,'Task %d: AUC-Overall: Means:%f\tMax: %f\n',...
                                  i,mean(mean(auc_all(:,:,i),2,'omitnan')),max(max(auc_all(:,:,i),[],2)));
        fprintf(resultFile,'******************************************************************\n\n');
    end

    fprintf(resultFile,'***************************All Original Data Start***************************\n');
    
    for i=1:taskNum
        fprintf(resultFile,'Task %d Details:\n',i);
        fprintf(resultFile,'Acc:\n%s\n\n',mat2str(acc_all(:,:,i))); 
        fprintf(resultFile,'Pre:\n%s\n\n',mat2str(pre_all(:,:,i)));
        fprintf(resultFile,'Recall:\n%s\n\n',mat2str(recall_all(:,:,i)));
        fprintf(resultFile,'f1:\n%s\n\n',mat2str(f1_all(:,:,i)));
        fprintf(resultFile,'Auc:\n%s\n\n',mat2str(auc_all(:,:,i)));
    end
 
    fprintf(resultFile,'\n');
    fprintf(resultFile,'***************************All Original Data End***************************\n');
end