function [data] = genParametersVE(numVar,numStep,range)

for i = 1:numVar
   
    data(i,:) = randi(range(i,:),1 ,numStep);
end