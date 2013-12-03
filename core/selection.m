% This function performs selection in GA process
%
% This script is free software.
%
% (C) 2013 by Tao Lei (leitao@seas.upenn.edu)
%
% CHANGES:
%   2013-09-30  Created. 
function [ idxIndividualSelected ] = selection( fitness, population )
%SELECTION Summary of this function goes here
%   Detailed explanation goes here
%   INPUT   fitness     fitness of each individual in current generation
%           population  the number of individuals(chromosomes) in one generation
%   OUTPUT  idxIndividualSelected   index of the selected individuals 
scale = 10;
fitness = round(fitness * scale);
[sortedFitness idx] = sort(fitness);
fitness(idx(1:round(population / scale))) = 0;

pool = zeros(1,sum(fitness));
poolFillPos = 1;
for i = 1:length(fitness)
    pool(poolFillPos:poolFillPos +  fitness(i) - 1) = i;
    poolFillPos = poolFillPos + fitness(i);    
end
selectPool = pool(randperm(length(pool)));

idxIndividualSelected = selectPool(1:length(fitness));


end

