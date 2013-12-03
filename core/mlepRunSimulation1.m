function mlepRunSimulation1(instanceInfo, keyName, lFolder, rFolder)
%MLEPRUNSIMULATIONON1 Runs Simulation of E+ 
%   This functions launches all the E+ simulations in the specified folder
%   (rFolder)
%   Inputs: 
%       instanceInfo - cell with all the instances information
%       keyName - Path to the key file 
%       rFolder - Folder in the EC2 instances where the E+ files reside.
% 
% This script is free software.
%
% (C) 2013 by Willy Bernal(willyg@seas.upenn.edu)

% start matlabpool for parallel execution
if matlabpool('size') == 0
    matlabpool(instanceInfo.instCount);
end

[a, b, c] = fileparts(rFolder);
rFolder = [a filesep b];

% for each EC2 instance
parfor i = 1:instanceInfo.instCount
    allFiles= dir([lFolder num2str(i) filesep '*.idf']);
    files = {allFiles.name};
    fileNo = size(files,2);
    for j = 1:fileNo
        cmd = ['runenergyplus ' rFolder char(files(j))  ' USA_IL_Chicago-OHare.Intl.AP.725300_TMY3'];
        sendCommand(instanceInfo.pubDNSName(i,:), cmd, keyName, 'true');
        msg = ['Simulation ',num2str(j), ' on machine #',num2str(i), ' done' ];
        disp(msg);
    end 

end