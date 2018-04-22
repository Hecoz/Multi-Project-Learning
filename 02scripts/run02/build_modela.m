function allPerformance = build_modela(SDP_DATA,...
                                       out_cv_fold,...
                                       randomIndex) 
    d = size(SDP_DATA.X{1},2);   %维度数
    T = size(SDP_DATA.X,1);      %任务数

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
        X{t} = zscore(X{t});                   % normalization
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

        %%Logistic
        
        performance_LR = LRforAlldata(Xtr,...
                                      Ytr, ...
                                      Xte,...
                                      Yte);
        

        %%collect results,将当前结果保存到所有的轮次中
        allPerformance{1,i} = performance_LR;
    end
end