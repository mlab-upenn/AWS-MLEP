% This function performs recombination in GA
%
% This script is free software.
%
% (C) 2013 by Tao Lei (leitao@seas.upenn.edu)
%
% CHANGES:
%   2013-09-30  Created. 
function [ chromosomes_recombined ] = recombination( chromosomes_tobeRecom,chromoLen )
%RECOMBINATION Summary of this function goes here
%   INPUT   chromosomes_tobeRecom, decimal form of binary chromosomes.
%           e.g. if the chromosome is 1001, this input should be 9
%   OUTPUT  chromosomes_recombined size population by number of signalized nodes
chromosomes_recombined = zeros(size(chromosomes_tobeRecom));


crossPoints = randi([1,chromoLen],[size(chromosomes_tobeRecom,1)/2, size(chromosomes_tobeRecom,2)]);
crossPoints = round(crossPoints/chromoLen) * 5;
for i = 1:2:size(chromosomes_tobeRecom,1)
%     i
    for j = 1:size(chromosomes_tobeRecom,2)
%         j
        CP = crossPoints((i+1)/2,j);
        src1 = dec2bin(chromosomes_tobeRecom(i,j),chromoLen);
        src2 = dec2bin(chromosomes_tobeRecom(i+1,j),chromoLen);
        
%         CP
%         chromosomes_recombined(i,j) = bin2dec(strrep(src1, src1(1:CP), src2(1:CP)));
        chromosomes_recombined(i,j) = bin2dec(strcat(src1(1:CP),src2(CP+1:end)));

%         strcat(src1(1:CP),src2(CP+1:end))
%         strrep(src1, src1(1:CP), src2(1:CP))
%         mark = 1
%         chromosomes_recombined(i+1,j) = bin2dec(strrep(src2, src2(1:CP), src1(1:CP)));
        chromosomes_recombined(i+1,j) = bin2dec(strcat(src2(1:CP),src1(CP+1:end)));
%         strcat(src2(1:CP),src1(CP+1:end))
%         strrep(src2, src2(1:CP), src1(1:CP))
       
%         mark = 2
    end
    



end


end

