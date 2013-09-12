function [ amazonEC2Client, EC2_info] = getAWSInstanceInfo ( amazonEC2Client )
%LISTAWSINSTA Summary of this function goes here
%   Detailed explanation goes here
disp('===========================================');
disp('Getting Info from AWS');
disp('===========================================');

try
    % Availability Zones
    availabilityZonesResult = amazonEC2Client.describeAvailabilityZones();
    availabilityZonesResult.getAvailabilityZones().size();
    
    % Describe Instances
    describeInstancesRequest = amazonEC2Client.describeInstances();
    reservations = describeInstancesRequest.getReservations();
    if isempty(reservations.isEmpty())
        disp('No Reservations Running');
    else
        count = 0;
        for i = 1:reservations.size
            instances  = reservations.get(i-1).getInstances();
          
%             for j = 1:instances.size
%                 instance(count) = instances.get(j-1);
%                 ami(count) = instances.get(j-1).getAmiLaunchIndex();
%                 imageId(count) = instances.get(j-1).getImageId();
%                 pubDnsName(count) = instances.get(j-1).getPublicDnsName();
%                 instanceId(count) = instances.get(j-1).getInstanceId();
%                 count = count+1;
%             end
            if strcmp(char(instances.get(0).getState),'{Code: 16,Name: running}')
                count = count+1;
                instance(count) = instances.get(0);
                ami(count) = instances.get(0).getAmiLaunchIndex();
                imageId(count) = instances.get(0).getImageId();
                pubDnsName(count) = instances.get(0).getPublicDnsName();
                instanceId(count) = instances.get(0).getInstanceId();
                
            else
                disp('terminated instances');
            end


        end
        
        disp(['You have ' num2str(count) ' Amazon EC2 Intance(s) Running'])
    end
    if(count > 0)
        EC2_info.instCount = count;
        EC2_info.imageId = char(imageId);
        EC2_info.instanceId = char(instanceId);
        EC2_info.pubDNSName = char(pubDnsName);
    else
        EC2_info.instCount = 0;
    end
catch ase
    disp(ase)
    rethrow(ase);
end
end

