% This script retrieves EC2 information from your AWS account. Copies the 
% idf files in the "idfs" folder to the instances, runs the simulations,
% and retrieves the results back to the local computer. Finally, it loads
% the results and plots the data. 
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
save('csvData.mat', 'csvData');
% Plot Data 
plotCSV(csvData, 2, 1:2 );



