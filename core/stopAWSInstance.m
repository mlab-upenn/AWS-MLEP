function [ amazonEC2Client ] = stopAWSInstance( amazonEC2Client, instanceId )
%STOPAWSINSTANCE Summary of this function goes here
%   Detailed explanation goes here

disp('===========================================');
disp('Stop Instance!');
disp('===========================================');
% Prepare Inputs
% instanceId = java.lang.String('ami-8397e7ea');
% securityGroup = 'mlepSecurityGroup2';
% instanceType = java.lang.String('m1.medium');
% keyName = java.lang.String('EnergyPlusKey');

% Create Stop Instance Request
stopInstancesRequest = com.amazonaws.services.ec2.model.StopInstancesRequest();

% Set Instance ID
instanceId = char(instanceId);
stopInstancesRequest.withInstanceIds(instanceId);

% Stop Instance
stopInstanceResult = amazonEC2Client.stopInstances(stopInstancesRequest);

% Check Instance
disp(stopInstanceResult.toString());
end

