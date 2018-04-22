function performance_SVM = SVM(Xtr,...
                               Ytr, ...
                               Xte,...
                               Yte)
                           
    performance_SVM = [];
    project_num = length(Xtr);
    for i = 1:project_num
        X_train = cell2mat(Xtr(i));
        Y_train = cell2mat(Ytr(i));
        X_test  = cell2mat(Xte(i));
        Y_test  = cell2mat(Yte(i));
        
        model_NB = fitcsvm(X_train, Y_train,'Standardize',true,'KernelScale','auto');
        
        
        Y_result = predict(model_NB,X_test);
        
        EVAL = MyEvaluation(Y_test,Y_result);
        performance_SVM = [performance_SVM EVAL];  
    end
end