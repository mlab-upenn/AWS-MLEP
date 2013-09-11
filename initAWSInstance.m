function [amazonEC2Client, ec2Inst] = initAWSInstance( amazonEC2Client )
%INITAWSINSTANCE Summary of this function goes here
%   Detailed explanation goes here
disp('===========================================');
disp('Run Instance!');
disp('===========================================');

% Prepare Inputs
imageID = java.lang.String('ami-8397e7ea');
securityGroup = 'EPGroup';
instanceType = java.lang.String('t1.micro');
keyName = java.lang.String('initial');

% Create Request
runInstancesRequest = com.amazonaws.services.ec2.model.RunInstancesRequest();
runInstancesRequest.withImageId(imageID)...
    .withInstanceType(instanceType)...
    .withKeyName(keyName)...
    .withMinCount(java.lang.Integer(1))...
    .withMaxCount(java.lang.Integer(1)).withSecurityGroups(securityGroup);

% Launch Instance
runInstancesResult = amazonEC2Client.runInstances(runInstancesRequest);
reservation = runInstancesResult.getReservation();

% Gather Instance Info
instances = reservation.getInstances();
masterInstance = instances.get(0);
masterID = masterInstance.getInstanceId();
masterState = masterInstance.getState().getName();

while ~strcmp(char(masterInstance.getState.getName),'running')
    describeInstancesRequest = amazonEC2Client.describeInstances();
    reservations = describeInstancesRequest.getReservations();
    for i = 1:reservations.size
        instances  = reservations.get(i-1).getInstances();
        for j = 1:instances.size
            if strcmp(char(instances.get(j-1).getInstanceId()), char(masterID))
                masterInstance = instances.get(j-1);
                %disp('Found It')
                break;
            end
        end
    end
    
end
disp(['Intance with ID ' char(masterInstance.getInstanceId()) ' is ' char(masterInstance.getState.getName)]);

% Prepare Instance
ec2Inst = struct();
ec2Inst.instanceId = char(masterInstance.getInstanceId());
ec2Inst.publicDns = char(masterInstance.getPublicDnsName());

end

