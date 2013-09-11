% mlepAwsInit
% This initializes MLE+/AWS environment

global MLEPAWSSETTINGS

% Credentials Path
credPath = 'YOUR CREDENTIALS PATH';
credPath = 'TaoAwsCredentials.properties'
% Private Key Path
keyPath = 'YOUR PRIVATE KEY PATH';
keyPath = 'initial.pem'
noOfInstance = 2;
%% DO NOT MODIFY 

% AWS Home Path
fullname = mfilename('fullpath');
[direc, ~, ~ ]= fileparts(fullname);
MLEPAWSSETTINGS.homePath = direc;

% Credentials Path
MLEPAWSSETTINGS.credPath = credPath;

% Private Key Path
MLEPAWSSETTINGS.keyPath = keyPath;

% JAVA CLASSPATH
root = [MLEPAWSSETTINGS.homePath filesep 'lib'];
javaPath = dir([root filesep '*.jar']);
 
for i = 1:length(javaPath)
   javaaddpath([root filesep javaPath(i).name]); 
end

% % JAVA IMPORT
% import java.io.*;
% import java.util.*;
% 
% % Import Jsch
% import com.jcraft.jsch.ChannelSftp;
% import com.jcraft.jsch.JSch;
% import com.jcraft.jsch.Session;
% 
% % Import AWS
% import com.amazonaws.AmazonServiceException;
% import com.amazonaws.auth.AWSCredentials;
% import com.amazonaws.auth.PropertiesCredentials;
% import com.amazonaws.services.ec2.AmazonEC2;
% import com.amazonaws.services.ec2.AmazonEC2Client;
% import com.amazonaws.services.ec2.model.*;
% import com.amazonaws.services.s3.*;
% import com.amazonaws.services.simpledb.*;
% import com.amazonaws.*;
% import com.amazonaws.services.ec2.AmazonEC2Client;
% import org.apache.http.client.methods.HttpUriRequest;






