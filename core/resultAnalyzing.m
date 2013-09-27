% This function analyze the simulation output
% This function is still in developing
%
% This script is free software.
%
% (C) 2013 by Tao Lei (leitao@seas.upenn.edu)
%
% CHANGES:
%   2013-09-21  Created. 
function [ result ] = resultAnalyzing( csvData, varNo, startTime, endTime )
%RESULTANALYZING Summary of this function goes here
%   Detailed explanation goes here
%   startTime   new schedule begin time, expected input 1-24
%   endTime     new schedule end time, expected input 1-24, must be greater
%               than startTime

% TS - Time Step in Seconds
% P1 - Response Time
% P2 - NOT ASSIGNED
% P3 - Kickback
% P4 - Steady-State Reduction
% P5 - Transient Reduction
% P6 - Average Power Consumption
% P7 - Total Reduction

for i = 1:size(csvData.data,2)
   sTime = floor(size(csvData.data{i},1) * startTime / 24);
   eTime = floor(size(csvData.data{i},1) * endTime / 24);
   initPower = csvData.data{i}(sTime, varNo);
   endPower = csvData.data{i}(eTime,varNo);
   [minPower,minPWTime] = min(csvData.data{i}(sTime:eTime,varNo));
   [maxPower, maxPWTime] = max(csvData.data{i}(sTime:end,varNo));
   result{i}.P1 = minPWTime + sTime - 1 ;
   result{i}.P2 = 0;
   result{i}.P3 = maxPower - endPower;
   result{i}.P4 = initPower - endPower;
   result{i}.P5 = initPower - minPower;
   
   TS = 86400 / (size(csvData.data{i},1));
   result{i}.P6 = sum(csvData.data{i}(sTime:eTime,varNo))/length(sTime:eTime) ; % * TS
   result{i}.P7 = initPower - result{i}.P6; % * (eTime - sTime + 1) * TS
 

end

end

