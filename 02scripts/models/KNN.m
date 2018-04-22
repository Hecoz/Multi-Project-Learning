function performance_KNN = KNN(Xtr,...
                               Ytr, ...
                               Xte,...
                               Yte)
    performance_KNN = []; 
    project_num = length(Xtr);
    for i = 1:project_num
        X_train = cell2mat(Xtr(i));
        Y_train = cell2mat(Ytr(i));
        X_test  = cell2mat(Xte(i));
        Y_test  = cell2mat(Yte(i));
        
        model_KNN = fitcknn(X_train,Y_train,'NumNeighbors',4,'Standardize',1); 

        Y_result  = predict(model_KNN,X_test);
        EVAL = MyEvaluation(Y_test,Y_result);
        performance_KNN = [performance_KNN EVAL];  
    end
end
