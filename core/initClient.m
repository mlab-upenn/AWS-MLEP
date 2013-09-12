function [ amazonEC2Client ] = initClient( amazonEC2Client, credPath )
%INITCLIENT Summary of this function goes here
%   Detailed explanation goes here
disp('===========================================');
disp('Initialize EC2CLIENT!');
disp('===========================================');

% Create Path Name to Credentials
str1 = java.lang.String(credPath);

% Create File
file1 = java.io.File(str1);

% Load Property Credentials
propCred = com.amazonaws.auth.PropertiesCredentials(file1);

% Get Access Key
accKey = propCred.getAWSAccessKeyId()

% Get Secret Key
SecKey = propCred.getAWSSecretKey()

% AmazonClient
amazonEC2Client = com.amazonaws.services.ec2.AmazonEC2Client(propCred);

% Specify Region
amazonEC2Client.setEndpoint(java.lang.String('http://ec2.us-east-1.amazonaws.com'));

end

