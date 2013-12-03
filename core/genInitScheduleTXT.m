function [ oneGen ] = genInitScheduleTXT( population, numVar, numStep, rangeBit,offset )
%WRITESCHEDULETXT Summary of this function goes here
%   Detailed explanation goes here
if exist('schedule', 'dir')
    rmdir('schedule', 's');
end
mkdir('schedule');
for i = 1:population
    data = genParameters(numVar,numStep,rangeBit);
    strChromos = encodeChromosomes(data,rangeBit);
    oneGen(i,:) = bin2dec(strChromos); 
    filename = strcat(num2str(i),'.txt');
    dlmwrite(strcat('schedule/',filename),[numVar, 24]);
    for j = 1:numVar
        dlmwrite(strcat('schedule/',filename), [offset * ones(1,7) roundn(data(j,:)./4,-1) + offset(j) offset * ones(1,7) ],'-append');
    end
end

end

