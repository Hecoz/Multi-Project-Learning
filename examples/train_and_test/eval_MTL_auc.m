function aucave = eval_MTL_auc (Y, X, W, C)
%calculate f-measure for classification 
    task_num = length(X);    
    auc_list = zeros(task_num,1);

    %calculate corrested classified numbers for every dataset
    for t = 1: task_num             
        auc_list(t) = ROC(Y{t},sign(X{t} * W(:, t) + C(t)),1,-1);
    end 
    
    %calculate average fmeasure
    aucave=mean(auc_list,'omitnan'); 
    
end

