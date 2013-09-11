% Run AWS 
% Example how to run MLE+ AWS 
global MLEPAWSSETTINGS

% Create EC2 Client
amazonEC2Client = com.amazonaws.services.ec2.AmazonEC2Client();

% Init EC2 Client
amazonEC2Client = initClient(amazonEC2Client);
 
% Get Current instances Info
[amazonEC2Client, EC2_info] = getAWSInstanceInfo(amazonEC2Client);

% % Create Instance if there is no instance on AWS
% describeInstancesRequest = amazonEC2Client.describeInstances();
% reservations = describeInstancesRequest.getReservations();
% 
% numOfInst = 2;
% for i = (reservations.size+1):numOfInst
%     
%     [amazonEC2Client, ec2Inst] = initAWSInstance(amazonEC2Client);
% end

numOfInst = 2
% Create Instances
for i = (EC2_info.instCount+1):numOfInst
    initAWSInstance(amazonEC2Client);
end

%Get the new instance info
[amazonEC2Client, EC2_info] = getAWSInstanceInfo(amazonEC2Client);

% %The authenticity of host if run for the first time, need manual input
% for i = 1:numOfInst
%     lfile = '.';
%     rfile = '/home/ubuntu/mlep/Test1/Output/*.csv';
%     cmd = ['scp -r -i '  keyName ' ubuntu@' strtrim(EC2_info.pubDNSName(i,:)) ':' rfile ' ' lfile ];
%     [stastus, msg] = system(cmd, '-echo');
% end


%Remove old file on AWS
amazonEC2Client = removeFolderOnAWS(amazonEC2Client, EC2_info);

% Push idf files to AWS
amazonEC2Client = pushToAWS('idfs', amazonEC2Client, EC2_info, MLEPAWSSETTINGS.keyPath);

% Run simulation on AWS
amazonEC2Client = runSimulationOnAWS(amazonEC2Client, EC2_info);

% Move simulation result to proper folders
amazonEC2Client = moveFileOnAWS( amazonEC2Client, EC2_info );

% Fetch simulation result on AWS
amazonEC2Client  = fetchDataOnAWS( amazonEC2Client, EC2_info);

% Load Data
csvData = loadCSVs('OutputCSV');
plotCSV(csvData, 2)
