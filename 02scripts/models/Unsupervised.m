function performance_US = Unsupervised(Xtr,...
                                       Ytr, ...
                                       Xte,...
                                       Yte,...
                                       p)
    performance_US = [];
    project_num = length(Xtr);
    threshold_rate = 0.1;
    switch p
        case{1}
            rankitem = 26;
        case{2}
            rankitem = 11;
        case{3}
            rankitem = 11;
        case{4}
            rankitem = 1;
        otherwise
            disp("IMPOSSIBLE");
    end
    for i = 1:project_num
        X_train = cell2mat(Xtr(i));
        Y_train = cell2mat(Ytr(i));
        
        X_test  = cell2mat(Xte(i));
        Y_test  = cell2mat(Yte(i));
        
        [~,index] = sort(-X_test(:,rankitem));
        X_test = X_test(index,:);
        Y_test = Y_test(index,:);
        
        [nrows,ncols] = size(Y_test);
        Y_result = -ones(nrows,ncols);
        threshold = floor(nrows*threshold_rate);
        Y_result(1:threshold,:) = 1;
        
        EVAL = MyEvaluation(Y_test,Y_result);
        performance_US = [performance_US EVAL];  
    end
end