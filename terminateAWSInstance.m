function [ amazonEC2Client ] = terminateAWSInstance( amazonEC2Client, imageID)
%TERMINATEAWSINSTANCE Summary of this function goes here
%   Detailed explanation goes here
disp('===========================================');
disp('Terminate Instance!');
disp('===========================================');
% Prepare Inputs
%imageID = java.lang.String('ami-8397e7ea');

% Create Stop Instance Request
terminateInstancesRequest = com.amazonaws.services.ec2.model.TerminateInstancesRequest();

% Set Instance ID
imageID = char(imageID);
terminateInstancesRequest.withInstanceIds(imageID);

% Stop Instance
terminateInstanceResult = amazonEC2Client.terminateInstances(terminateInstancesRequest);

% Check Instance
disp(terminateInstanceResult.toString());

end

