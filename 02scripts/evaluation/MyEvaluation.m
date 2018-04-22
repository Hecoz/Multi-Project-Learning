%%Funtion to evaluation the preformance 
function [EVAL] = MyEvaluation(actural,predicted,Lp,Ln )
% This fucntion evaluates the performance of a classification model by 
% calculating the common performance measures: 
%Accuracy, Sensitivity, Specificity, Precision, Recall, F-Measure, G-mean,AUC
%
%Input: actural = Column matrix with actual class labels of the training
%                 examples
%       predicted = Column matrix with predicted class labels by the
%                    classification model
%        Lp:     label of POSITIVE pattern.  
%        Ln:     label of NEGATIVE pattern. 
% Output: EVAL = A struct for all the performance measures
    %使用Lp和Ln的缺省参数
    if nargin == 2
       Lp = 1;
       %如果类标是1 和 0 ，则Ln =0，如果类标是1和-1，则Ln = -1
       Ln = -1;
      % Ln = 0;    
    end


    idx = (actural()==1);

    p = length(actural(idx));
    n = length(actural(~idx));
    N = p+n;

    tp = sum(actural(idx)==predicted(idx));
    tn = sum(actural(~idx)==predicted(~idx));
    fp = n-tn;
    fn = p-tp;

    tp_rate = tp/p;
    tn_rate = tn/n;

    accuracy = (tp+tn)/N;
    sensitivity = tp_rate;
    specificity = tn_rate;
    precision = tp/(tp+fp);
    recall = sensitivity;
    f_measure = 2*((precision*recall)/(precision + recall));
    gmean = sqrt(tp_rate*tn_rate);

    %calcuate auc value
    auc = ROC(actural,predicted,Lp, Ln);

    %return all these peformance value
    %EVAl.accuracy = accuracy;

    EVAL.accuracy = accuracy;
    EVAL.sensitivity = sensitivity;
    EVAL.specificity = specificity;
    EVAL.precision = precision;
    EVAL.recall = recall;
    EVAL.f_measure = f_measure;
    EVAL.gmean = gmean;
    EVAL.auc = auc;
end


%%http://blog.csdn.net/Crystal_Cai/article/details/41694625
%可用，结果与matlab自带的函数结果一致

%或者使用MATLAB自带的 [~,~,~,auc]=perfcurve(labels,scores,posclass)
%labels:目标标签 scores:决策值 posclass：正类标签 如1

function [auc, curve] = ROC(actural,predicted,Lp, Ln)
% This function is to calculat the ordinats of points of ROC curve and the area
% under ROC curve(AUC).
%    This program was described in Fawcett's paper "ROC Graphs: notes and practical
% considerations for researchers".

% Input parameters:
%    predicted:  output of classifier. high socre denote the pattern is more likely 
%            to be POSITIVE pattern.
%    actural: classlabel of each pattern.
%    Lp:     label of POSITIVE pattern.  
%    Ln:     label of NEGATIVE pattern. 
% 
% Output:
%    curve: N*3 matrix. 
%            the 1st column is FP 
%            the 2nd column is TP
%            the 3rd column is score
%            note: the last row, etc.the last point is [1,1,0]. if output of this
%               function is applied to roc_av.m to calculate average curve of roc, 
%               it should be delete
%    auc:   scale number, area under ROC curve.

%   在求得AUC和curve后, 用plot(curve(:,1),curve(:,2))  
% 
    len = length(predicted);                % number of patterns
    if len ~= length(actural)
    error('The length of tow input vectors should be equal\n');
    end
    P = 0;    % number of Positive pattern
    N = 0;    % number of Negative pattern
    for i = 1:len
        if actural(i) == Lp
          P = P + 1;
        elseif actural(i) == Ln
          N = N + 1;
        else
          error('Wrong target value');
        end
    end

    % sort "L"  in decending order by scores
    predicted = predicted(:);
    actural = actural(:);
    L = [predicted actural];
    L = sortrows(L,1);
    index = len:-1:1;
    index = index';     %'
    L = L(index,:);

    fp = 0;   fp_pre = 0;   % number of False Positive pattern
    tp = 0;   tp_pre = 0;   % number of True Positive pattern.
    score_pre = -10000;
    curve = [];
    auc = 0;
    for i = 1:len
        if L(i,1) ~= score_pre
          curve = [curve; [fp/N, tp/P, L(i,1)]];
          auc = auc + trapezoid(fp, fp_pre, tp, tp_pre);

          score_pre = L(i,1);

          fp_pre = fp;
          tp_pre = tp;
        end

        if L(i,2) == Lp
          tp = tp + 1;
        else
          fp = fp + 1;
        end
    end
    curve = [curve; [1,1,0]];
    auc = auc / P / N;
    auc = auc + trapezoid(1, fp_pre/N, 1, tp_pre/P);
end 


% calculat the area of trapezoid
function area = trapezoid(x1,x2,y1,y2)
    a = abs(x1-x2);
    b = abs(y1+y2);
    area = a * b / 2;
end
