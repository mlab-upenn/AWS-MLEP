function [ varNo ] = plotCSV( csvData,varNo )
%PLOTCSV Summary of this function goes here
%   Detailed explanation goes here


data = cell2mat(csvData.data);
step = length(csvData.vars);
plot(data(:,varNo:step:end));
title(csvData.vars(varNo).name)
% hold off;
% for i = 1:size(files,2)
%     plot(data{i}(:,varNo),'Color', rand(1,3));
%   
%     hold on;
% end
% title(vars(varNo).name);

end

