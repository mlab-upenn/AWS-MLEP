% This function perform mutation in GA process
%
% This script is free software.
%
% (C) 2013 by Tao Lei (leitao@seas.upenn.edu)
%
% CHANGES:
%   2013-09-30  Created. 
function [ newGeneration ] = mutation( recombined_chromosomes,chromoLen )
%MUTATION Summary of this function goes here
%   Detailed explanation goes here
chromoCount = size(recombined_chromosomes,1) * size(recombined_chromosomes,2);
mutationPos = randperm(chromoCount);
idxMutationChromo = mutationPos(1:round(chromoCount/100));
idxMutationBitInChromo = randi(chromoLen,1,round(chromoCount/100));

for i = 1:round(chromoCount/100)
    strChromo = dec2bin(recombined_chromosomes(idxMutationChromo(i)),chromoLen);
    strChromo(idxMutationBitInChromo(i)) = num2str(abs(str2double(strChromo(idxMutationBitInChromo(i))) - 1));
    recombined_chromosomes(idxMutationChromo(i)) = bin2dec(strChromo);
end

newGeneration = recombined_chromosomes;
end

