clc
clear



allFiles = dir('idfs');
files = {allFiles(3:end).name};
noOfFiles = size(files,2);
for i = 1:noOfFiles
    mkdir(['idfPara/' files{i}(1:end-4)]);
    copyfile(['idfs/' files{i}],['idfPara/' files{i}(1:end-4)])
    fileNo(i) = str2double(files{i}(1:end-4));
end

% Global Variable
amazonEC2Client = com.amazonaws.services.ec2.AmazonEC2Client();
keyName = 'initial.pem';
% matlabpool(4);
% Init EC2 Client
amazonEC2Client = initClient(amazonEC2Client);

% Get Current instances Info
[amazonEC2Client, EC2_info] = getAWSInstanceInfo(amazonEC2Client);

cmd_mkdir = 'mkdir /home/ubuntu/mlep/paraTest';
sendCommand(amazonEC2Client, strtrim(EC2_info.pubDNSName(1,:)), cmd_mkdir);
lfile = 'idfPara/';
rfile = '/home/ubuntu/mlep/paraTest';
cmd = ['scp -r -i ' keyName ' ' lfile ' ubuntu@' strtrim(EC2_info.pubDNSName(1,:)) ':' rfile ' &'];
[stastus, msg] = system(cmd, '-echo');



if(matlabpool('size') > 0)
    matlabpool close
end
matlabpool(3);

parfor i = 1:matlabpool('size')
    cmd_run{i} = strcat('runenergyplus /home/ubuntu/mlep/paraTest/idfPara/', num2str(fileNo(i)),  '/', files(i), ' USA_IL_Chicago-OHare.Intl.AP.725300_TMY3');        
    sendCommand(amazonEC2Client, EC2_info.pubDNSName(1,:), cmd_run{i});       
end


