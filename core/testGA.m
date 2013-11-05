pop = 10;
numVar = 2;
numStep = 24;
for i = 1:pop
    data = genParameters(numVar,numStep,5);
    strChromos = genChromosomes(data,5);
    oneGen(i,:) = bin2dec(strChromos);
    
end