function performance_LR = LRforAlldata(Xtr,...
                                       Ytr, ...
                                       Xte,...
                                       Yte)
    X = [];
    Y = [];
    performance_LR = [];
    project_num = length(Xte);
    for i = 1:project_num
        X_train = cell2mat(Xtr(i));
        Y_train = cell2mat(Ytr(i));
        Y_train(Y_train== -1) = 0;
        X = [X;X_train];
        Y = [Y;Y_train];
    end
    
    model_LR = glmfit(X,Y,'binomial','Link','logit');
    
    for i = 1:project_num
        X_test  = cell2mat(Xte(i));
        Y_test  = cell2mat(Yte(i));
        Y_test (Y_test == -1) = 0;
        
        Y_result = glmval(model_LR,X_test,'logit');
        prevalue = Y_result;
        Y_result(Y_result <  0.5) = 0;
        Y_result(Y_result >= 0.5) = 1;
        
        alldata = [prevalue Y_result Y_test];
        alldata = sortrows(alldata,-1);
        EVAL = MyEvaluation(alldata(:,3),alldata(:,2),1,0);
        performance_LR = [performance_LR EVAL];  
    end
end