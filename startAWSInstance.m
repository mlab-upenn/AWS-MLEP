function [ amazonEC2Client] = startAWSInstance( amazonEC2Client,instanceId )
%STARTAWSINSTANCE Summary of this function goes here
%   Detailed explanation goes here
disp('===========================================');
disp('Start Instance!');
disp('===========================================');
% Prepare Inputs
% instanceId = java.lang.String('ami-8397e7ea');

% Create Start Instance Request
startInstancesRequest = com.amazonaws.services.ec2.model.StartInstancesRequest();

% Set Instance ID
instanceId = char(instanceId);
startInstancesRequest.withInstanceIds(instanceId);

% Start Instance
startInstanceResult = amazonEC2Client.startInstances(startInstancesRequest);

% Check Instance
disp(startInstanceResult.toString());

end

