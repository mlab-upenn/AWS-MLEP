function [indMap] = pushToAWS( filepath, amazonEC2Client,instanceInfo, keyName )
%PUSHTOAWS Summary of this function goes here
%   Detailed explanation goes here

allFiles = dir([filepath filesep '*.idf']);
files = {allFiles.name};
for i = 1:instanceInfo.instCount
    dirName = ['idfs' num2str(i)];
    if exist(dirName,'dir')
        rmdir(dirName, 's');
    end
    mkdir(dirName);
end

% Create Vector of Files with their corresponding Instances
indMap = repmat([1:instanceInfo.instCount], 1, 100);
indMap = indMap(1:size(files,2));
indMap = sort(indMap);

% Copy Files to their Instances
noOfFiles = size(files,2);
for i = 1:noOfFiles
   copyfile(['idfs' filesep files{i}],['idfs' num2str(indMap(i)) filesep files{i}]);% ,instanceInfo.instCount)+1)
    
end

% keyName = 'initial.pem';
if matlabpool('size') == 0
    matlabpool(instanceInfo.instCount)
end
cmd_mkdir = 'mkdir /home/ubuntu/mlep/simulation';

parfor i = 1:instanceInfo.instCount
    disp('making simulation folder on AWS');
    sendCommand(amazonEC2Client, strtrim(instanceInfo.pubDNSName(i,:)), cmd_mkdir, keyName);
    lfile = ['idfs' num2str(i) '/*'];
    rfile = '/home/ubuntu/mlep/simulation';
    disp('Pushing idf files to AWS')
    cmd = ['scp -o StrictHostKeyChecking=no -i ' keyName ' ' lfile ' ubuntu@' strtrim(instanceInfo.pubDNSName(i,:)) ':' rfile ' &'];
    [stastus, msg] = system(cmd, '-echo');

    
end
end
