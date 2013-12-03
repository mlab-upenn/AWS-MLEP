function genTXTSchedule(newSchedule_chromosomes, chromoLen, rangeBit, offset)
if exist('schedule', 'dir')
    rmdir('schedule', 's');
end
mkdir('schedule');

for i = 1:size(newSchedule_chromosomes,1)
    
    data = decodeChromos(dec2bin(newSchedule_chromosomes(i,:),chromoLen), rangeBit);
    numVar = size(data,1);
    numStep = size(data,2);
    filename = strcat(num2str(i),'.txt');
    dlmwrite(strcat('schedule/',filename),[numVar, 24]);
    for j = 1:numVar
        dlmwrite(strcat('schedule/',filename), [offset * ones(1,7) roundn(data(j,:)./4,-1) + offset(j) offset * ones(1,7) ],'-append');
    end
end




end