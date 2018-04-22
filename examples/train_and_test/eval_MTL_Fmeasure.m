function f1ave = eval_MTL_Fmeasure (Y, X, W, C)
%calculate f-measure for classification 
    task_num = length(X);    
    f1_list = zeros(task_num,1);

    %calculate corrested classified numbers for every dataset
    for t = 1: task_num             
        f1_list(t) = fmeasure(Y{t},sign(X{t} * W(:, t) + C(t)));
    end 
    
    %calculate average fmeasure
    f1ave=mean(f1_list,'omitnan'); 
    
end

function F1 = fmeasure(true_val,pred_val)

  accuracy = mean(double(pred_val == true_val));
  acc_all0 = mean(double(-1 == true_val));

  actual_positives = sum(true_val == 1);
  actual_negatives = sum(true_val == -1);
  true_positives = sum((pred_val == 1) & (true_val == 1));
  false_positives = sum((pred_val == 1) & (true_val == -1));
  false_negatives = sum((pred_val == -1) & (true_val == 1));
  precision = 0; 
  
  if ( (true_positives + false_positives) > 0)
    precision = true_positives / (true_positives + false_positives);
  end

  recall = 0; 
  if ( (true_positives + false_negatives) > 0 )
    recall = true_positives / (true_positives + false_negatives);
  end

  F1 = 0;   
  if( (precision + recall) > 0) 
      F1 = 2 * precision * recall / (precision + recall);
  end
 
%   if (verbose) 
%     fprintf("|-->  true_positives == %f  (actual positive =%f) \n",true_positives,actual_positives);
%     fprintf("|-->  false_positives == %f \n",false_positives);
%     fprintf("|-->  false_negatives == %f \n",false_negatives);
%     fprintf("|-->  precision == %f \n",precision);
%     fprintf("|-->  recall == %f \n",recall);
%     fprintf("|-->  F1 == %f \n",F1);
%   end

end

