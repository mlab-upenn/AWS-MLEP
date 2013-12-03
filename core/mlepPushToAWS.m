function [indMap] = pushToAWS(instanceInfo, keyName, lFolder, rFolder )
%PUSHTOAWS Summary of this function goes here
%   Detailed explanation goes here

% Get Files
allFiles = dir([lFolder filesep '*']);
files = {allFiles.name};
files = files(3:end);

% Create Vector of Files with their corresponding Instances
indMap = repmat([1:instanceInfo.instCount], 1, 100);
indMap = indMap(1:size(files,2));
indMap = sort(indMap);

% Check Matlab Pool
if matlabpool('size') == 0
    matlabpool(instanceInfo.instCount)
end

[a, b, c] = fileparts(rFolder);
rFolder = [a filesep b];
cmd_mkdir = ['mkdir ' rFolder]; 
% [a, b, c] = fileparts(lFolder);
% lFolder = [b filesep '*']

parfor i = 1:instanceInfo.instCount
    disp('Removing Local Folders');
    cmd = ['rm -r ' lFolder num2str(i)]; 
    [status, msg] = system(cmd, '-echo');
end
 
% Copy respective files to Local Folders
parfor i = 1:instanceInfo.instCount
    disp('Making Local Folders');
    cmd = ['mkdir ' lFolder num2str(i)]; 
    [status, msg] = system(cmd, '-echo');
    disp('Copying files');
    instFile = files(indMap==i);
    for j = instFile
        cmd = ['cp ' lFolder filesep char(j) ' ' lFolder num2str(i)]; 
        [status, msg] = system(cmd);
    end
end

% Copy respective files to instances
parfor i = 1:instanceInfo.instCount
    disp('Making simulation folder on AWS');
    sendCommand(strtrim(instanceInfo.pubDNSName(i,:)), cmd_mkdir, keyName, 'true');
    disp('Pushing idf files to AWS')
    cmd = ['scp -o StrictHostKeyChecking=no -i ' keyName ' ' lFolder num2str(i) filesep '* ubuntu@' strtrim(instanceInfo.pubDNSName(i,:)) ':' rFolder ' &'];
    [stastus, msg] = system(cmd, '-echo');
end

end
