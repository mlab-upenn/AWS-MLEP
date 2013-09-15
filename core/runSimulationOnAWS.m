function [ amazonEC2Client ] = runSimulationOnAWS( amazonEC2Client, instanceInfo, keyName)
%RUNSIMULATIONONAWS Summary of this function goes here
%   Detailed explanation goes here

% Create Matlab Pool
if matlabpool('size') == 0
    matlabpool(instanceInfo.instCount);
end
cmd = cell(1,matlabpool('size'));

% Send runenergyplus command
parfor i =1:instanceInfo.instCount
    allFiles= dir(['idfs' num2str(i) filesep '*.idf']);
    files = {allFiles.name};
    fileNo = size(files,2);
    for j = 1:fileNo
        cmd = ['runenergyplus /home/ubuntu/mlep/simulation/' char(files(j))  ' USA_IL_Chicago-OHare.Intl.AP.725300_TMY3'];        
        sendCommand(amazonEC2Client, instanceInfo.pubDNSName(i,:), cmd, keyName);        
        msg = ['simulation ',num2str(j), ' on machine #',num2str(i), ' done' ];
        disp(msg);
   end

end
