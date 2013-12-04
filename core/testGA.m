clear;
gen = 90;
pop = 18;
numVar = 1;
numStep = 10;
rangeBit = 10;
offset = [0];
oneGen = genInitScheduleTXT(pop,numVar,numStep,rangeBit,offset);
chromoLen = rangeBit * numVar;
for i = 1:gen
   fitness = testFitness(oneGen,rangeBit);
   sel = selection(fitness,pop);
   recombinedChromosome = recombinationaAll(oneGen(sel,:),chromoLen,rangeBit);
   oneGen = mutation(recombinedChromosome,chromoLen);
   
%     oneGen*size(oneGen,2) / (2^rangeBit)
    
end