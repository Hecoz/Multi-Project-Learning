function performance_DT = DecisionTree(Xtr,...
                                        Ytr, ...
                                        Xte,...
                                        Yte)
                           
    performance_DT = [];
    project_num = length(Xtr);
    for i = 1:project_num
        X_train = cell2mat(Xtr(i));
        Y_train = cell2mat(Ytr(i));
        X_test  = cell2mat(Xte(i));
        Y_test  = cell2mat(Yte(i));
        
        model_DT = fitctree(X_train, Y_train);
        Y_result = predict(model_DT,X_test);
        
        EVAL = MyEvaluation(Y_test,Y_result);
        performance_DT = [performance_DT EVAL];  
    end
end