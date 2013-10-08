function [ strChromos ] = genChromosomes( data,numBits )
%GENCHROMOSOME Summary of this function goes here
%   Detailed explanation goes here

strChromos = cell(1,size(data,2));
for i = 1:size(data,2)
    for j = 1:size(data,1)
        strChromos{i} = strcat(strChromos{i}, dec2bin(data(j,i),numBits));
    end
end
strChromos = strChromos';

end

