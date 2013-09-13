function [ amazonEC2Client ] = fetchDataOnAWS( amazonEC2Client, instanceInfo, keyName)
%FETCHDATAONAWS Summary of this function goes here
%   Detailed explanation goes here
if matlabpool('size') == 0
    matlabpool(instanceInfo.instCount);
end

if exist('OutputCSV', 'dir')
    rmdir('OutputCSV', 's');
end
mkdir('OutputCSV');

lfile = 'OutputCSV/.';
rfile = '/home/ubuntu/mlep/simulation/out/*.csv';

parfor i = 1:instanceInfo.instCount
    cmd = ['scp -r -i '  keyName ' ubuntu@' strtrim(instanceInfo.pubDNSName(i,:)) ':' rfile ' ' lfile ];
    [stastus, msg] = system(cmd, '-echo');
    
end

end

