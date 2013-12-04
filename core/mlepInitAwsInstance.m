function [amazonEC2Client, ec2Inst] = mlepInitAWSInstance(amazonEC2Client, numInst, keyPath, securityGroup, instType)
%INITAWSINSTANCE Summary of this function goes here 
%   Detailed explanation goes here
disp('===========================================');
disp('Run Instances!');
disp('===========================================');

% Prepare Inputs
imageID = java.lang.String('ami-33aef35a');
%securityGroup = 'EPGroup';
instanceType = java.lang.String(instType);
[~,keyName,~] = fileparts(keyPath);
%keyName = java.lang.String('initial');
 
% Create Request
runInstancesRequest = com.amazonaws.services.ec2.model.RunInstancesRequest();
runInstancesRequest.withImageId(imageID)...
    .withInstanceType(instanceType)... 
    .withKeyName(keyName)...
    .withMinCount(java.lang.Integer(numInst))...
    .withMaxCount(java.lang.Integer(numInst)).withSecurityGroups(securityGroup);

% Launch Instance
runInstancesResult = amazonEC2Client.runInstances(runInstancesRequest);
reservationsLaunched = runInstancesResult.getReservation();
reservationLaunchedID = reservationsLaunched.getReservationId();
instancesLaunched = reservationsLaunched.getInstances();

while (1)
    describeInstancesResult = amazonEC2Client.describeInstances();
    reservations = describeInstancesResult;
    
    i = 0;
    reservation = reservations.get(i);
    while(~strcmp(char(reservation.getReservationId), char(reservationLaunchedID)))
        i = i + 1;
        reservation = reservations.get(i);
    end
    
    instances = reservation.getInstances();
    for j = 1:instances.size
        if instan
    end
end

% Check if it is running
        instances = reservation.getInstances();
        for j = 1:instances.size
            while(1);
        end
       
    end
    describeInstancesResult = amazonEC2Client.describeInstances();
    reservations = describeInstancesResult;
end
% reservation = reservations.get(i-1);
% instances = reservation.getInstances();
% for j = 1:instances.size
%     instance = instances.get(j);
%     while(~strcmp(char(instance.getState.getName),'running'))
%         
%     end
% end
        
% while ~strcmp(char(masterInstance.getState.getName),'running')
%     describeInstancesRequest = amazonEC2Client.describeInstances();
%     reservations = describeInstancesRequest.getReservations();
%     for i = 1:reservations.size
%         instances  = reservations.get(i-1).getInstances();
%         for j = 1:instances.size
%             if strcmp(char(instances.get(j-1).getInstanceId()), char(masterID))
%                 masterInstance = instances.get(j-1);
%                 %disp('Found It')
%                 break;
%             end
%         end
%     end
% end
% disp(['Intance with ID ' char(masterInstance.getInstanceId()) ' is ' char(masterInstance.getState.getName)]);

% Prepare Instance
% ec2Inst = struct();
% ec2Inst.instanceId = char(masterInstance.getInstanceId());
% ec2Inst.publicDns = char(masterInstance.getPublicDnsName());


