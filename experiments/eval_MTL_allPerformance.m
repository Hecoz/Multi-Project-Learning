%% 使用MyEvaluation来计算所有的评价指标
%返回一个存放struct结构的数组

function all_performance = eval_MTL_allPerformance (Y, X, W, C)
    %calculate accuracy for classification 
    task_num = length(X);    

    %用task_num个cell来保存每个任务的结果,每个cell中存放的是struct结构
    %all_performance = cell(1,task_num);
    %初始化用于存放task_num个任务的性能结果，每一个结果都是一个struct结构
    all_performance = [];

    %calculate corrested classified numbers for every dataset
    for t = 1: task_num    
        %此处的评价函数要根据实例的类标进行设置,sigmoid结果是[0,1]，sign是>0为1，<0为-1
        %predicted = sigmoid(X{t} * W(:, t) + C(t)) >= 0.5;
        predicted = sign(X{t} * W(:, t) + C(t));
        EVAL = MyEvaluation(Y{t},predicted);
        all_performance = [all_performance EVAL];   
    end   
end
