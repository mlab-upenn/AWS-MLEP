function [ amazonEC2Client ] = fetchDataOnAWS( amazonEC2Client, instanceInfo )
%FETCHDATAONAWS Summary of this function goes here
%   Detailed explanation goes here
if matlabpool('size') == 0
    matlabpool(instanceInfo.instCount);
end

if ~isdir('OutputCSV')
   mkdir('OutputCSV'); 
end
lfile = 'OutputCSV/.';
rfile = '/home/ubuntu/mlep/simulation/out/*.csv';

parfor i = 1:instanceInfo.instCount
    cmd = ['scp -r -i '  'initial.pem' ' ubuntu@' strtrim(instanceInfo.pubDNSName(i,:)) ':' rfile ' ' lfile ]; 
    [stastus, msg] = system(cmd, '-echo');
    
end

end

