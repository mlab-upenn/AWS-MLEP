
clear;
clc;
import java.io.*;
import java.util.*;

% Import Jsch
import com.jcraft.jsch.ChannelSftp;
import com.jcraft.jsch.JSch;
import com.jcraft.jsch.Session;

% Import AWS
import com.amazonaws.AmazonServiceException;
import com.amazonaws.auth.AWSCredentials;
import com.amazonaws.auth.PropertiesCredentials;
import com.amazonaws.services.ec2.AmazonEC2;
import com.amazonaws.services.ec2.AmazonEC2Client;
import com.amazonaws.services.ec2.model.*;
import com.amazonaws.services.s3.*;
import com.amazonaws.services.simpledb.*;
import com.amazonaws.*;
import com.amazonaws.services.ec2.AmazonEC2Client;
import org.apache.http.client.methods.HttpUriRequest;


% Set credentials and #of instances here
keyName = 'initial.pem';
credPath = 'TaoAwsCredentials.properties';
numOfInst = 2;

% Global Variable
amazonEC2Client = com.amazonaws.services.ec2.AmazonEC2Client();

% matlabpool(4);
% Init EC2 Client
amazonEC2Client = initClient(amazonEC2Client, credPath);

% Get Current instances Info
[amazonEC2Client, EC2_info] = getAWSInstanceInfo(amazonEC2Client);



% Create Instances
for i = (EC2_info.instCount+1):numOfInst
    [amazonEC2Client,ec2Inst] = initAWSInstance(amazonEC2Client);

end

%Get the new instance info
[amazonEC2Client, EC2_info] = getAWSInstanceInfo(amazonEC2Client);

%The authenticity of host if run for the first time, need manual input
for i = 1:numOfInst
    lfile = '.';
    rfile = '/home/ubuntu/mlep/Test1/Output/*.csv';
    cmd = ['scp -r -i '  keyName ' ubuntu@' strtrim(EC2_info.pubDNSName(i,:)) ':' rfile ' ' lfile ];
    [stastus, msg] = system(cmd, '-echo');
end


%Remove old file on AWS
amazonEC2Client = removeFolderOnAWS(amazonEC2Client, EC2_info);

% Push idf files to AWS
amazonEC2Client = pushToAWS('idfs', amazonEC2Client, EC2_info, keyName);

% Run simulation on AWS
amazonEC2Client = runSimulationOnAWS(amazonEC2Client, EC2_info);

% Move simulation result to proper folders
amazonEC2Client = moveFileOnAWS( amazonEC2Client, EC2_info );

% Fetch simulation result on AWS
amazonEC2Client  = fetchDataOnAWS( amazonEC2Client, EC2_info);
if matlabpool('size') > 0
    matlabpool close;
end
