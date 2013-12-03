function [ strChromos, chromoLen ] = encodeChromosomes( data,rangeBit )
%GENCHROMOSOME Summary of this function goes here
%   Detailed explanation goes here

strChromos = cell(1,size(data,2));
for i = 1:size(data,2)
    for j = 1:size(data,1)
        strChromos{i} = strcat(strChromos{i}, dec2bin(data(j,i),rangeBit));
    end
end
strChromos = strChromos';
chromoLen = size(data,1) * rangeBit;

end

