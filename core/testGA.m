clear;
gen = 300;
pop = 24;
numVar = 1;
numStep = 24;
rangeBit = 6;
offset = [0];
oneGen = genInitScheduleTXT(pop,numVar,numStep,rangeBit,offset);
chromoLen = rangeBit * numVar;
for i = 1:gen
   fitness = testFitness(oneGen,rangeBit);
   sel = selection(fitness,pop);
   recombinedChromosome = recombination(oneGen(sel,:),chromoLen);
   oneGen = mutation(recombinedChromosome,chromoLen);
   allfit(i) = mean(fitness);
   bestfit(i) = max(fitness);
%     oneGen*size(oneGen,2) / (2^rangeBit)
    
end