% This script dispatches EC2 instances using the aws-sdk api. 
%
% This script illustrates the usage of class mlepAwsProcess in the MLE+
% toolbox. 
%
% This script is free software.
%
% (C) 2013 by Willy Bernal(willyg@seas.upenn.edu)
%
% CHANGES:
%   2013-09-11  Created. 

%% Create an mlepAwsProcess instance and configure it
ep = mlepAwsProcess();
% Create EC2 Client
ep.createEC2Client();
% Init EC2 Client
ep.initEC2Client();
% Get Current instances Info
ep.getAWSInstanceInfo();
%Remove old file on AWS
ep.removeFolderOnAws();
% Push idf files to AWS
idfFolderPath = 'idfs';
ep.pushToAWS(idfFolderPath);
% Run simulation on AWS
ep.runSimulationOnAWS();
% Move simulation result to proper folders
ep.moveFileOnAWS();
% Fetch simulation result on AWS
ep.fetchDataOnAWS();
% Load Data
csvData = loadCSVs('OutputCSV');
plotCSV(csvData, 2);



% %The authenticity of host if run for the first time, need manual input
% for i = 1:numOfInst
%     lfile = '.';
%     rfile = '/home/ubuntu/mlep/Test1/Output/*.csv';
%     cmd = ['scp -r -i '  keyName ' ubuntu@' strtrim(EC2_info.pubDNSName(i,:)) ':' rfile ' ' lfile ];
%     [stastus, msg] = system(cmd, '-echo');
% end


% Create Instance if there is no instance on AWS
% describeInstancesRequest = amazonEC2Client.describeInstances();
% reservations = describeInstancesRequest.getReservations();
% 
% numOfInst = 2;
% for i = (reservations.size+1):numOfInst
%     
%     [amazonEC2Client, ec2Inst] = initAWSInstance(amazonEC2Client);
% end

% numOfInst = 2;
% Create Instances
% for i = (EC2_info.instCount+1):numOfInst
%     initAWSInstance(amazonEC2Client);
% end
