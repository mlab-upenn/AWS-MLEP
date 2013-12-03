function fitObj = calcFit1(popValues)

% Population size  
Npop = size(popValues,1);

% Fitness Values
fitObj = 6-power(popValues(:,1),2)-power(popValues(:,2),2)-power(popValues(:,3),2); 

