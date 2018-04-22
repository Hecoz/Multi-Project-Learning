function allPerformance = Dirty_Classify_Executor (SDP_DATA,...
                                                   opts,...
                                                   lambda1_range,...
                                                   lambda2_range,...
                                                   out_cv_fold,...
                                                   optional_cv_fold,...
                                                   obj_func_str,...
                                                   eval_func_str,...
                                                   randomIndex)


    %维度数
    d = size(SDP_DATA.X{1},2);
    %任务数
    T = size(SDP_DATA.X,1);

    X = SDP_DATA.X;
    Y = SDP_DATA.Y;
    W = randn(d, T);
    W_mask = abs(randn(d, T))<1;
    W(W_mask) = 0;

    %首先根据随机因子进行随机化操作
    rng(randomIndex);
    for t=1:length(X)
         tmp=rand(1,size(X{t},1));
         [~,index]=sort(tmp);    
        X{t}=X{t}(index,:);
        Y{t}=Y{t}(index,:);
    end


    % preprocessing data
    for t = 1: length(X)
        X{t} = zscore(X{t});                  % normalization
        %X{t} = [X{t} ones(size(X{t}, 1), 1)]; % add bias. 增加偏倚
    end

    %记录每一折中间的性能结果
    allPerformance=cell(1,out_cv_fold);

    for i = 1: out_cv_fold
        Xtr = cell(T, 1);
        Ytr = cell(T, 1);
        Xte = cell(T, 1);
        Yte = cell(T, 1);

        %stratified cross validation
        for t = 1: T
            task_sample_size = length(Y{t});
            ct = find(Y{t}==-1);
            cs = find(Y{t}==1);
            %开始选取第i折的训练数据索引：包括正负两个实例
            ct_idx = i : out_cv_fold : length(ct);
            cs_idx = i : out_cv_fold : length(cs);

            te_idx = [ct(ct_idx); cs(cs_idx)];
            tr_idx = setdiff(1:task_sample_size, te_idx);

            Xtr{t} = X{t}(tr_idx, :);
            Ytr{t} = Y{t}(tr_idx, :);
            Xte{t} = X{t}(te_idx, :);
            Yte{t} = Y{t}(te_idx, :);
        end
        %找到最优超产的交叉检验过程
        %inner cv
        fprintf('\tinner CV started')
        [best_lambda1, best_lambda2, ~] = CrossValidationDirty( Xtr,...
                                                                Ytr, ...
                                                                obj_func_str,...
                                                                opts,...
                                                                lambda1_range,...
                                                                lambda2_range,...
                                                                optional_cv_fold, ...
                                                                eval_func_str);
        %用最优的超参来构建模型
        %train
        %warm start for one turn
        [~, C, P, Q, ~, ~] = Logistic_Dirty(Xtr, Ytr, best_lambda1, best_lambda2, opts);
        opts2=opts;
        opts2.init=1;
        opts2.C0=C;
        opts2.P0=P;
        opts2.Q0=Q;
        opts2.tol = 10^-10;
        [W2, C2, ~, ~, ~, ~] = Logistic_Dirty(Xtr, Ytr, best_lambda1, best_lambda2, opts2);

        %test保存当前迭代的所有任务的所有结果
        current_iteration_performance = eval_MTL_allPerformance(Yte, Xte, W2, C2);

        %collect results,将当前结果保存到所有的轮次中
        allPerformance{1,i}=current_iteration_performance;
    end

end