% This function creates a EC2 security group with specific name and
% description
%
% This script is free software.
%
% (C) 2013 by Tao Lei (leitao@seas.upenn.edu)
%
% CHANGES:
%   2013-09-15  Created. 

function [ amazonEC2Client, SGName ] = createSecurityGroup( SGName, SGDescription,amazonEC2Client )
%CREATESECURITYGROUP Summary of this function goes here
%   Detailed explanation goes here
%   SGName          the name of the security group you wish to create
%   SGDescription   the description of the security group you wish to create
%   amazonEC2Client amazon EC2 instance client object




% Create an Empty EC2 security group on AWS
csgr = com.amazonaws.services.ec2.model.CreateSecurityGroupRequest(SGName, SGDescription);
amazonEC2Client.createSecurityGroup(csgr);

% Create a security group ingress rule authorizer
authorizeSGIPIngress = com.amazonaws.services.ec2.model.AuthorizeSecurityGroupIngressRequest;

% Get the list of the current security groups
describeSG = amazonEC2Client.describeSecurityGroups;
SGList = describeSG.getSecurityGroups;

% find the security group just created
for i = 1:size(SGList)
   newSG = SGList.get(i-1);  
   if strcmp(newSG.getGroupName, SGName)
       break;
   end
end

% create new rules (allowing all ingress tcp)
ipRuleList = newSG.getIpPermissions;
ipRule = com.amazonaws.services.ec2.model.IpPermission;
ipRule.setIpProtocol('tcp');
ipRule.setFromPort(java.lang.Integer(0));
ipRule.setToPort(java.lang.Integer(65535));
ipRange = ipRule.getIpRanges;
ipRange.add(java.lang.String('0.0.0.0/0'));
ipRule.setIpRanges(ipRange);
ipRuleList.add(ipRule);

% authorize the new rule
authorizeSGIPIngress.setIpPermissions(ipRuleList);
authorizeSGIPIngress.setGroupId(newSG.getGroupId);
amazonEC2Client.authorizeSecurityGroupIngress(authorizeSGIPIngress);

end

