function [ data  ] = ExtractAll( filedir )
%EXTRACTALL Summary of this function goes here
%   Detailed explanation goes here
allFiles = dir(filedir);
allFileNames = {allFiles(3:end).name};

fileNo = zeros(1,numel(allFileNames));
for i = 1:numel(allFileNames)
   fileNo(i) = str2double(allFileNames{i}(1:end-4)); 
end
[b idx] = sort(fileNo);
singledata = ExtractData(strcat(filedir,'\',allFileNames{1}),49,1,4)

allFileNames = allFileNames(idx);
data = zeros(numel(allFileNames),size(singledata,2));
for i = 1:numel(allFileNames)
    i
 
    data(i,:) =  ExtractData(strcat(filedir,'\',allFileNames{i}),49,1,4);

    

end
end

