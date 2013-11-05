function [ data ] = genParameters( numVar, numStep, rangeBit )
%GENPARAMETERS Summary of this function goes here
%   Detailed explanation goes here

maxValue = 2^rangeBit - 1;

data = randi(maxValue,numVar,numStep);
    

end

