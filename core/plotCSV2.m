function [ output_args ] = plotCSV2( csvData, varNoList , period )
%PLOTCSV2 Summary of this function goes here
%   Detailed explanation goes here

if nargin < 3
    period = 1:size(csvData.ts,1);
end
data = cell2mat(csvData.data);
data = sum(data(period,:));
step = length(csvData.vars);
for i = varNoList
    figure()
    plot(data(:,i:step:end), 'color', rand(1,3));
    title(csvData.vars(i).object);
    ylabel([csvData.vars(i).name, ' ',csvData.vars(i).unit])
    hold on;
end

end

