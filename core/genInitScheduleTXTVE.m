function [oneGen] = genInitScheduleTXTVE(population, numVar, numStep, range)

if exist('schedule', 'dir')
    rmdir('schedule', 's');
end
mkdir('schedule');
for i = 1:population
    data = genParametersVE(numVar,numStep,range);
    strChromos = genChromosomes(data,rangeBit);
    oneGen(i,:) = bin2dec(strChromos); 
    filename = strcat(num2str(i),'.txt');
    dlmwrite(strcat('schedule/',filename),[numVar, numStep]);
    for j = 1:numVar
        dlmwrite(strcat('schedule/',filename), roundn(data(j,:)./4,-1) + offset(j),'-append');
    end
end

end

