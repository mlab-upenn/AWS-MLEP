function [ fitness ] = testFitness( oneGen,rangeBit )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


for i = 1:size(oneGen,2)
   fitness(:,i) = abs(oneGen(:,i) *(size(oneGen,2)/(2^rangeBit)) - i) ;
end
fitness = size(oneGen,2)./(sum(fitness,2) / size(oneGen,2));

end

