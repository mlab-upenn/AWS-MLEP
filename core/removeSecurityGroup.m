function removeSecurityGroup( SGName,amazonEC2Client )
%REMOVESECURITYGROUP Summary of this function goes here
%   This function removes the EC2 security group with the specified name (SGName)
%   Input       SGName              the security group to be removed
%               amazonEC2Client     the EC2 client info
%
%   Created by Tao Lei Dec 5th 2013

SGList = amazonEC2Client.describeSecurityGroups.getSecurityGroups;
for i = 1:size(SGList)
    if strcmp(SGList.get(i-1).getGroupName,SGName)
        delReq = com.amazonaws.services.ec2.model.DeleteSecurityGroupRequest(SGName);
        amazonEC2Client.deleteSecurityGroup(delReq);   
        
    end
end


end

