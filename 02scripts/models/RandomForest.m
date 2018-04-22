function performance_RM = RandomForest(Xtr,...
                                        Ytr, ...
                                        Xte,...
                                        Yte)
    performance_RM = []; 
    project_num = length(Xtr);
    for i = 1:project_num
        X_train = cell2mat(Xtr(i));
        Y_train = cell2mat(Ytr(i));
        X_test  = cell2mat(Xte(i));
        Y_test  = cell2mat(Yte(i));
        
        tree_RM = TreeBagger(100,X_train,Y_train,'Method','classification'); 

        Y_result  = predict(tree_RM,X_test);
        EVAL = MyEvaluation(Y_test,Y_result);
        performance_RM = [performance_RM EVAL];  
    end
end
