function [ amazonEC2Client ] = removeFolderOnAWS( amazonEC2Client, instanceInfo )
%REMOVEFOLDERONAWS Summary of this function goes here
%   Detailed explanation goes here
% remove from aws
disp('Removing folders on AWS')
for i = 1:instanceInfo.instCount
   cmd = 'rm -r /home/ubuntu/mlep/simulation';
   sendCommand(amazonEC2Client, instanceInfo.pubDNSName(i,:), cmd);

end

end

