function performance_LR = LogisticRegression(Xtr,...
                                             Ytr, ...
                                             Xte,...
                                             Yte)
    performance_LR = [];
    project_num = length(Xtr);
    for i = 1:project_num
        X_train = cell2mat(Xtr(i));
        Y_train = cell2mat(Ytr(i));
        X_test  = cell2mat(Xte(i));
        Y_test  = cell2mat(Yte(i));
        Y_train(Y_train== -1) = 0;
        Y_test (Y_test == -1) = 0;
        
        model_LR = glmfit(X_train,Y_train,'binomial','Link','logit');
        Y_result = glmval(model_LR,X_test,'logit');
        Y_result(Y_result <  0.5) = 0;
        Y_result(Y_result >= 0.5) = 1;
        EVAL = MyEvaluation(Y_test,Y_result,1,0);
        performance_LR = [performance_LR EVAL];  
    end
end