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
% Create Instance if there is no instance on AWS
numOfInst = 6;
ep.initAWSInstance(numOfInst);

% %The authenticity of host if run for the first time, need manual input
% for i = 1:numOfInst
%     lfile = '.';
%     rfile = '/home/ubuntu/mlep/Test1/Output/*.csv';
%     cmd = ['scp -r -i '  keyName ' ubuntu@' strtrim(EC2_info.pubDNSName(i,:)) ':' rfile ' ' lfile ];
%     [stastus, msg] = system(cmd, '-echo');
% end
