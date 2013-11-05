function [ singleChromo ] = genSingleChromo( data )
%GENSINGLECHROMO Summary of this function goes here
%   Detailed explanation goes here
singleChromo = [];
for i = 1:size(data,1)
    singleChromo = strcat(singleChromo,dec2bin(data(i)));
    
end
end

