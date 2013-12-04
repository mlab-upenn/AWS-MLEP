function [ amazonEC2Client ] = runSimulationOnAWS( amazonEC2Client, instanceInfo, keyName, filedir)
%RUNSIMULATIONONAWS Summary of this function goes here
%   Detailed explanation goes here

% Create Matlab Pool
if matlabpool('size') == 0
    matlabpool(instanceInfo.instCount);
end
% cmd = cell(1,matlabpool('size'));

% Send runenergyplus command

parfor i =1:instanceInfo.instCount
    allFiles= dir([filedir num2str(i) filesep '*.txt']);
    files = {allFiles.name};
    fileNo = size(files,2);
    for j = 1:fileNo


        filename = char(files(j));
        cmd = ['mv /home/ubuntu/mlep/simulation/*.idf /home/ubuntu/mlep/simulation/' filename(1:end-4) '.idf'];
        sendCommand(amazonEC2Client, instanceInfo.pubDNSName(i,:), cmd, keyName);        
        cmd = ['ssh -o StrictHostKeyChecking=no -i ' keyName ' ubuntu@' instanceInfo.pubDNSName(i,:) ' ' '''cd /home/ubuntu/mlep/simulation;export BCVTB_HOME=/home/ubuntu/mlep/bcvtb;java -jar mlepJava1.jar ' filename(1:end-4)  '.idf ' char(files(j))''];
        cmd = strcat(cmd,'''');
% cmd = 'ssh -o StrictHostKeyChecking=no -i /Users/willyg/Documents/Git/AWS-MLEP/EnergyPlusKey.pem ubuntu@ec2-54-211-239-83.compute-1.amazonaws.com ''cd /home/ubuntu/project;export BCVTB_HOME=/home/ubuntu/mlep/bcvtb;java -jar mlepJava1.jar /home/ubuntu/project SmallOffice-000001 1.txt''';
% cmd   
        system(cmd);
        pause(4);

%        cmd = ['cd /home/ubuntu/mlep/simulation/; java -jar mlepJava1.jar ' char(files(j)) '.idf ' char(files(j))]; 
%         cmd = ['java -jar /home/ubuntu/mlep/simulation/mlepJava1.jar / /home/ubuntu/mlep/simulation/' char(files(j)) '.idf /home/ubuntu/mlep/simulation/' char(files(j))]; 
       
        
%         sendCommand(amazonEC2Client, instanceInfo.pubDNSName(i,:), cmd, keyName); 

       msg = ['simulation ',num2str(j), ' on machine #',num2str(i), ' done' ];
       disp(msg);
   end

end

