function SaveResult(results,datasetName,outTenFold,out_cv_fold)
    

    project_data = [];
    for i = 1:outTenFold
        for j = 1:out_cv_fold
            project_data = [project_data;[results{1,i}{1,j}.accuracy;results{1,i}{1,j}.precision;results{1,i}{1,j}.recall;results{1,i}{1,j}.f_measure;results{1,i}{1,j}.auc]'];
        end
    end
    csvwrite(datasetName,project_data);
end