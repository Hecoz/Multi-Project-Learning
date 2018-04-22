%该功能与Evaluate中的功能一样，试验中我们使用的是Evaluate
function [F1,precision,recall,accuracy] = printClassMetrics (true_val, pred_val , verbose)
if( nargin == 2)
    verbose = 0;
end


  accuracy = mean(double(pred_val == true_val));
  acc_all0 = mean(double(-1 == true_val));
  if (verbose)
    fprintf("|--> accuracy == %f vs accuracy_all0 == %f \n",accuracy,acc_all0);
  end

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
 
  if (verbose) 
    fprintf("|-->  true_positives == %f  (actual positive =%f) \n",true_positives,actual_positives);
    fprintf("|-->  false_positives == %f \n",false_positives);
    fprintf("|-->  false_negatives == %f \n",false_negatives);
    fprintf("|-->  precision == %f \n",precision);
    fprintf("|-->  recall == %f \n",recall);
    fprintf("|-->  F1 == %f \n",F1);
  end
  
end
