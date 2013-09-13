function [ csvData] = loadCSVs( filepath )
%LOADCSVS Summary of this function goes here
%   Detailed explanation goes here
allFiles = dir([filepath filesep '*.csv']);
files = {allFiles.name};


for i = 1:size(files,2)
    filename = strcat(filepath, '/', files(i));
    [vars, data{i} ts] = mlepLoadEPResults(filename{1});
end
csvData.vars = vars;
csvData.data = data;
csvData.ts = ts;
end

