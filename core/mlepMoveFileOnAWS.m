function mlepMoveFileOnAWS(instanceInfo, keyName, rFolder)
%MLEPMOVEFILEONAWS This functions moves remote files from the cloud to the
%   out directory 
% (C) 2013 by Willy Bernal(willyg@seas.upenn.edu)

% Last update: 2013-09-11 by Willy Bernal
if matlabpool('size') == 0
    matlabpool(instanceInfo.instCount);
end

% Check Folder Name
[a, b, c] = fileparts(rFolder);
rFolder = [a filesep b];

% Setup Commands
cmd_mkdir = ['mkdir ' rFolder 'out'];
cmd_mv = ['cp ' rFolder 'Output/*.csv ' rFolder 'out'];
cmd_rm = ['rm ' rFolder 'out/*Table.csv ' rFolder 'out/*Meter.csv ' rFolder 'out/*sz.csv'];

parfor i = 1:instanceInfo.instCount
    sendCommand(instanceInfo.pubDNSName(i,:), cmd_mkdir, keyName, 'true');
    sendCommand(instanceInfo.pubDNSName(i,:), cmd_mv, keyName, 'true');
    sendCommand(instanceInfo.pubDNSName(i,:), cmd_rm, keyName, 'true');
end

end

