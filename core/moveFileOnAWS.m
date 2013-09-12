function [ amazonEC2Client ] = moveFileOnAWS( amazonEC2Client, instanceInfo )
%MOVEFILEONAWS Summary of this function goes here
%   Detailed explanation goes here
if matlabpool('size') == 0
    matlabpool(instanceInfo.instCount);
end
cmd_mkdir = 'mkdir /home/ubuntu/mlep/simulation/out';
cmd_mv = 'cp /home/ubuntu/mlep/simulation/Output/*.csv /home/ubuntu/mlep/simulation/out';
cmd_rm = 'rm /home/ubuntu/mlep/simulation/out/*Table.csv /home/ubuntu/mlep/simulation/out/*Meter.csv';
parfor i = 1:instanceInfo.instCount
    
    sendCommand(amazonEC2Client, instanceInfo.pubDNSName(i,:), cmd_mkdir);
    
    sendCommand(amazonEC2Client, instanceInfo.pubDNSName(i,:), cmd_mv);
    sendCommand(amazonEC2Client, instanceInfo.pubDNSName(i,:), cmd_rm);
    

    
end

end

