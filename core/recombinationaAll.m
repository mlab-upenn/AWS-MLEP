function [ chromosomes_recombined ] = recombinationaAll( chromosomes_tobeRecom ,chromoLen,rangeBit)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here


chromosomes_recombined = zeros(size(chromosomes_tobeRecom));

numVar = chromoLen/rangeBit;
numStep = size(decodeChromos(dec2bin(chromosomes_tobeRecom(1,:),chromoLen),rangeBit),2);
data1 = zeros(numVar,numStep);
data2 = zeros(numVar,numStep);
crossPoints = randi([1 numStep], [numVar size(chromosomes_tobeRecom,1)/2]);
for i = 1:2:size(chromosomes_tobeRecom,1)
    src1 = decodeChromos(dec2bin(chromosomes_tobeRecom(i,:),chromoLen),rangeBit);
    src2 = decodeChromos(dec2bin(chromosomes_tobeRecom(i+1,:),chromoLen),rangeBit);
    for j = 1:(numVar)
        data1(j,1:crossPoints(j,(i+1)/2)) = src1(j,1:crossPoints(j,(i+1)/2));
        data1(j,(crossPoints(j,(i+1)/2)+1):end) = src2(j,(crossPoints(j,(i+1)/2)+1):end);
        data2(j,1:crossPoints(j,(i+1)/2)) = src2(j,1:crossPoints(j,(i+1)/2));
        data2(j,(crossPoints(j,(i+1)/2)+1):end) = src1(j,(crossPoints(j,(i+1)/2)+1):end);
    
        
    end
    chromosomes_recombined(i,:) = bin2dec(encodeChromosomes(data1,rangeBit));
    chromosomes_recombined(i+1,:) = bin2dec(encodeChromosomes(data2,rangeBit));
end
end

