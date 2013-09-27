%% SET MULTIPLE SCENARIOS
param = struct();

% satSP
param.satSP = {13 14 15 16 17};
% condSP
param.condSP = {0};
% chillerSP
param.chillerSP = {7.2 8.2 9.2 10.2 11.2};
% roomSP
param.roomSP = {22 23 24 25 26};
% pipeL
param.pipeL = {300};
% loopVolume
param.loopVolume = {4};

% generateTemplate
filename = '5ZoneAirCooledCondenser.idf';
newFile = 'test1.idf';
controls = genParametric(filename, param, newFile);
save('controls.mat', 'controls');
 
[status, msg] = system(['parametricpreprocessor ' newFile '&'],'-echo');


