function [ data ] = genParameters( numVar, numStep, rangeBit )
%GENPARAMETERS Summary of this function goes here
%   Detailed explanation goes here

maxValue = 2^rangeBit - 1;

data = randi([0 maxValue],numVar,numStep);
    

end

