function [ oneGen ] = genScheduleTXT( population, numVar, numStep, rangeBit )
%WRITESCHEDULETXT Summary of this function goes here
%   Detailed explanation goes here
if exist('schedule', 'dir')
    rmdir('schedule', 's');
end
mkdir('schedule');
for i = 1:population
    data = genParameters(numVar,numStep,rangeBit);
    strChromos = genChromosomes(data,rangeBit);
    oneGen(i,:) = bin2dec(strChromos); 
    filename = strcat(num2str(i),'.txt');
    dlmwrite(strcat('schedule/',filename), data);
end

end

