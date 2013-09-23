% This function is for plotting multiple simulation results
% This script is free software.
%
% (C) 2013 by Tao Lei (leitao@seas.upenn.edu)
%
% CHANGES:
%   2013-09-15  Created. 
function [ varNo ] = plotCSV( csvData,varNo,simuNo )
%PLOTCSV Summary of this function goes here
%   csvData     variable containing all simulation run output
%   varNo       specify which variable to plot
%   simuNo      specify which simulation run(s) to plot

data = cell2mat(csvData.data);
step = length(csvData.vars);
figure();
allSimu = varNo:step:size(data,2);
plot(data(:,allSimu(simuNo)));
title(csvData.vars(varNo).object);
ylabel(csvData.vars(varNo).name);
xlabel('Time (min)');
legend(strtrim(cellstr(num2str(simuNo'))));

% hold off;
% for i = 1:size(files,2)
%     plot(data{i}(:,varNo),'Color', rand(1,3));
%   
%     hold on;
% end
% title(vars(varNo).name);

end

