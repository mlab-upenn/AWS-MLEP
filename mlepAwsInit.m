% This script sets up the environment for MLE+AWS.
% It should be modified to include the path to your AWS credentials and the
% path to your private key. Eventually, the code will generate private
% keys to dispatch instances. 
% Run this script once before using any MLE+AWS functions.
%
% (C) 2013 by Willy Bernal (willyg@seas.upenn.edu)

% History: 
% Created: 2013-09-11 by Willy Bernal

% Credentials Path
%credPath = '/YOUR/CREDENTIALS/PATH';
credPath = 'C:\Users\mlab\Documents\GitRepository\AWS-MLEP\AwsCredentials.properties';

% Private Key Path
%keyPath = '/YOUR/PRIVATE/KEY/PATH';
keyPath = 'C:\Users\mlab\Documents\GitRepository\AWS-MLEP\EnergyPluskey.pem';

% Private Key Path
%secGroup = 'YOUR SECURITY GROUP NAME';
secGroup = 'mlepSecurityGroup2';

% Number of Instances
noOfInstance = 2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% DO NOT MODIFY %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% MLEP-AWS HOME 
fullname = mfilename('fullpath');
[direc, ~, ~ ]= fileparts(fullname);
cd(direc);

% JAVA CLASSPATH
addJavaPath([direc filesep 'lib']);

% JAVA IMPORT
importJava();

global MLEPAWSSETTINGS

% MLEPAWSSAETTINGS
MLEPAWSSETTINGS = struct(...
    'homePath', direc,...   % Home Path
    'credPath', credPath,...   % Path to your AWS credentials
    'keyPath', keyPath...   % Path to the key pair file
    );

addpath(MLEPAWSSETTINGS.homePath);
addpath([MLEPAWSSETTINGS.homePath filesep 'lib']);
addpath([MLEPAWSSETTINGS.homePath filesep 'core']);
savepath;


