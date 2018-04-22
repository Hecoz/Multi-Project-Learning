load fisheriris  
X = meas;    % Use all data for fitting  
Y = species; % Response data 

%Mdl = fitcknn(X,Y);
%Mdl.NumNeighbors = 4;
Mdl = fitcknn(X,Y,'NumNeighbors',4,'Standardize',1); 

flwr = [5.0 3.0 5.0 1.45];
flwrClass = predict(Mdl,flwr)