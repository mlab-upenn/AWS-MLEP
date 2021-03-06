function [ amazonEC2Client ] = moveFileOnAWS( amazonEC2Client, instanceInfo, keyName)
%MOVEFILEONAWS Summary of this function goes here
%   Detailed explanation goes here
if matlabpool('size') == 0
    matlabpool(instanceInfo.instCount);
end
cmd_mkdir = 'mkdir /home/ubuntu/mlep/simulation/out';
cmd_mv = 'cp /home/ubuntu/mlep/simulation/Output/*.csv /home/ubuntu/mlep/simulation/out';
cmd_rm = 'rm /home/ubuntu/mlep/simulation/out/*Table.csv /home/ubuntu/mlep/simulation/out/*Meter.csv /home/ubuntu/mlep/simulation/out/*sz.csv';
parfor i = 1:instanceInfo.instCount
    sendCommand(amazonEC2Client, instanceInfo.pubDNSName(i,:), cmd_mkdir, keyName);
    sendCommand(amazonEC2Client, instanceInfo.pubDNSName(i,:), cmd_mv, keyName);
    sendCommand(amazonEC2Client, instanceInfo.pubDNSName(i,:), cmd_rm, keyName);
end

end

