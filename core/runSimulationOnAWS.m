function [ amazonEC2Client ] = runSimulationOnAWS( amazonEC2Client, instanceInfo )
%RUNSIMULATIONONAWS Summary of this function goes here
%   Detailed explanation goes here
for i = 1:instanceInfo.instCount
    allFiles= dir(['idfs' num2str(i)]);
    files = {allFiles(3:end).name};
    for j = 1:size(files,2)
        fileNo(i,j) = str2double(files{j}(1:end-4));
    end
end

if matlabpool('size') == 0
    matlabpool(instanceInfo.instCount);
end
cmd = cell(1,matlabpool('size'));
parfor i =1:instanceInfo.instCount 
    for j = 1:size(fileNo,2)
        cmd{i} = ['runenergyplus /home/ubuntu/mlep/simulation/' num2str(fileNo(i,j))  ' USA_IL_Chicago-OHare.Intl.AP.725300_TMY3'];        
        sendCommand(amazonEC2Client, instanceInfo.pubDNSName(i,:), cmd{i});        
        msg = ['simulation ',num2str(j), ' on machine #',num2str(i), ' done' ];
        disp(msg);
   end

end
