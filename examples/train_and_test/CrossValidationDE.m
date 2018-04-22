function [ best_lambda1, best_lambda2, populations] = CrossValidationDE(X,...
                                                                        Y,...
                                                                        model_train,...
                                                                        obj_func_opts,...                          
                                                                        cv_fold,...
                                                                        cost_function)
    model_train  = str2func(model_train);
    cost_function = str2func(cost_function);
                                                               
    % Initialization parameters
    nvar          = obj_func_opts.nvar;           %number of Decision Variables
    nvar_min      = obj_func_opts.nvar_min;       %Lower bound of Decision Variables
    nvar_max      = obj_func_opts.nvar_max;       %Lower bound of Decision Variables
    num_pop       = obj_func_opts.num_pop;        %number of population
    Max_Iteration = obj_func_opts.iter;           %Max Iteration
    beta_min      = obj_func_opts.beta_min;       %Lower bound of Scaling Factor
    beta_max      = obj_func_opts.beta_max;       %Upper bound of Scaling Factor
    Cross_Pro     = obj_func_opts.Cross_Pro;      %Crossover Probability
                                                                                                                                                    
    task_num = length(X);       % compute sample size for each task
    outer_best_sol.cost = -inf; % best solution

    % begin cross validation
    fprintf('[')
    for cv_idx = 1: cv_fold
        fprintf('.')

        % buid cross validation data splittings for each task.
        cv_Xtr = cell(task_num, 1);
        cv_Ytr = cell(task_num, 1);
        cv_Xte = cell(task_num, 1);
        cv_Yte = cell(task_num, 1);

        %generate train and test dataset
        for t = 1: task_num
            task_sample_size = length(Y{t});

            ct = find(Y{t}== -1);
            cs = find(Y{t}== 1);
            ct_idx = cv_idx : cv_fold : length(ct);
            cs_idx = cv_idx : cv_fold : length(cs);
            te_idx = [ct(ct_idx); cs(cs_idx)];
            tr_idx = setdiff(1:task_sample_size, te_idx);%2 for train , 1 for test

            cv_Xtr{t} = X{t}(tr_idx, :);
            cv_Ytr{t} = Y{t}(tr_idx, :);
            cv_Xte{t} = X{t}(te_idx, :);
            cv_Yte{t} = Y{t}(te_idx, :);
        end
        
        %Initialization the first population
        init_pop.solution         = [];
        init_pop.cost             = [];
        innder_best_sol.cost      = -inf;
        populations               = repmat(init_pop,num_pop,1);     
        
        for i = 1:num_pop
            opts=obj_func_opts;
            opts.init=2;
            if(isfield(opts, 'P0'))
                opts = rmfield(opts, 'P0');
            end
            if(isfield(opts, 'Q0'))
                opts = rmfield(opts, 'Q0');
            end
            if(isfield(opts, 'C0'))
                opts = rmfield(opts, 'C0');
            end
            populations(i).solution = unifrnd(nvar_min,nvar_max,1,nvar);
            [W, C, P, Q]            = model_train(cv_Xtr, cv_Ytr, populations(i).solution(1), populations(i).solution(2), opts);
            opts.init=1;
            opts.P0=P;
            opts.Q0=Q;
            opts.C0=C;
            populations(i).cost     = cost_function(cv_Yte, cv_Xte, W, C);
            %Update the best solution
            if populations(i).cost > innder_best_sol.cost
                innder_best_sol = populations(i);
            end
        end
        
        %Evolution Step
        index = 1;
        BestSolutions_cost = zeros(Max_Iteration,1);
        while (index <= Max_Iteration)
            for i = 1:num_pop
                x=populations(i).solution;
                choice=randperm(num_pop);        %generate item number random
                choice(choice==i)=[];     
                %Mutation
                F = unifrnd(beta_min,beta_max,num_pop,1);
                y = populations(choice(1)).solution + F.*(populations(choice(2)).solution - populations(3).solution);
                y = max(y,nvar_min);
                y = min(y,nvar_max);
                %Crossover
                z           = zeros(size(x));
                cross_index = randi(numel(x)); 
                for j = 1:numel(x)
                    if j == cross_index || rand <= Cross_Pro
                        z(j) = y(j);
                    else
                        z(j) = x(j);
                    end
                end
                %Select
                new_sol.solution = z;
                opts=obj_func_opts;
                opts.init=2;
                if(isfield(opts, 'P0'))
                    opts = rmfield(opts, 'P0');
                end
                if(isfield(opts, 'Q0'))
                    opts = rmfield(opts, 'Q0');
                end
                if(isfield(opts, 'C0'))
                    opts = rmfield(opts, 'C0');
                end
                [W, C, P, Q]     = model_train(cv_Xtr, cv_Ytr, new_sol.solution(1), new_sol.solution(2), opts);
                opts.init        = 1;
                opts.P0          = P;
                opts.Q0          = Q;
                opts.C0          = C;
                new_sol.cost     = cost_function(cv_Yte, cv_Xte, W, C);
                if new_sol.cost > populations(i).cost
                    populations(i) = new_sol;

                    if(populations(i).cost > innder_best_sol.cost)
                        innder_best_sol = populations(i);
                    end
                end
            end
            %Update index
            BestSolutions_cost(index) = innder_best_sol.cost;
            %disp(['Iteration ' num2str(index) ': Best Cost = ' num2str(BestSolutions_cost(index))]);
            index = index + 1;
        end
        %Show Results
%         semilogy(BestSolutions_cost,'LineWidth', 2);
%         xlabel('Iteration');
%         ylabel('Best Cost');
%         grid on;
        %update outer best solution
        if innder_best_sol.cost > outer_best_sol.cost
            outer_best_sol = innder_best_sol;
        end
    end

    fprintf(']\n')

    best_lambda1 = outer_best_sol.solution(1);
    best_lambda2 = outer_best_sol.solution(2);
end

