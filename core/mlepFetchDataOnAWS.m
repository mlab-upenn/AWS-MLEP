function mlepFetchDataOnAWS(instanceInfo, keyName, rFolder)
%MLEPFETCHDATAONAWS This function fetches all the .csv files from the cloud
% instances
% (C) 2013 by Willy Bernal(willyg@seas.upenn.edu)

% Last update: 2013-09-11 by Willy Bernal
if matlabpool('size') == 0
    matlabpool(instanceInfo.instCount);
end

if exist('OutputCSV', 'dir')
    rmdir('OutputCSV', 's');
end
mkdir('OutputCSV');

% Check Folder Name
[a, b, c] = fileparts(rFolder);
rFolder = [a filesep b];

lfile = 'OutputCSV/.';
rfile = [rFolder 'out/*.csv'];

parfor i = 1:instanceInfo.instCount
    cmd = ['scp -r -i '  keyName ' ubuntu@' strtrim(instanceInfo.pubDNSName(i,:)) ':' rfile ' ' lfile ];
    [stastus, msg] = system(cmd, '-echo');
    
end

end

