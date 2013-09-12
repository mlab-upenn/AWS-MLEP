function [ amazonEC2Client ] = pushToAWS( filepath, amazonEC2Client,instanceInfo, keyName )
%PUSHTOAWS Summary of this function goes here
%   Detailed explanation goes here

allFiles = dir(filepath);
files = {allFiles(3:end).name};
for i = 1:instanceInfo.instCount
    mkdir(['idfs' num2str(i)]);
end

noOfFiles = size(files,2);
for i = 1:noOfFiles
   copyfile(['idfs/' files{i}],['idfs' num2str(mod(str2double(files{i}(1:end-4)),instanceInfo.instCount)+1)])
    
end
% keyName = 'initial.pem';
if matlabpool('size') == 0
    matlabpool(instanceInfo.instCount)
end
cmd_mkdir = 'mkdir /home/ubuntu/mlep/simulation';

parfor i = 1:instanceInfo.instCount
    disp('making simulation folder on AWS');
    sendCommand(amazonEC2Client, strtrim(instanceInfo.pubDNSName(i,:)), cmd_mkdir);
    lfile = ['idfs' num2str(i) '/*'];
    rfile = '/home/ubuntu/mlep/simulation';
    disp('Pushing idf files to AWS')
    cmd = ['scp -i ' keyName ' ' lfile ' ubuntu@' strtrim(instanceInfo.pubDNSName(i,:)) ':' rfile ' &'];
    [stastus, msg] = system(cmd, '-echo');

    
end
end
% % remove from aws
% instanceInfo = EC2_info;
% for i = 1:instanceInfo.instCount
%    cmd = 'rm -r /home/ubuntu/mlep/simulation';
%    sendCommand(amazonEC2Client, instanceInfo.pubDNSName(i,:), cmd);
% end
% 
% lfile = '.';
% rfile = '/home/ubuntu/mlep/Test1/Output/*.csv'
% cmd = ['scp -r -i '  keyName ' ubuntu@' strtrim(instanceInfo.pubDNSName(2,:)) ':' rfile ' ' lfile ];
% [stastus, msg] = system(cmd, '-echo');