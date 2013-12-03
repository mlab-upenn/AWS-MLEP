%% SET MULTIPLE SCENARIOS
param = struct();

% satSP
vec = linspace(convtemp(55,'F','C'), convtemp(60,'F','C'), 5);
param.satSP = {round(vec*100)/100};
% condSP
param.condSP = {0};
% chillerSP
vec = linspace(convtemp(45,'F','C'),convtemp(50,'F','C'),5);
param.chillerSP = {round(vec*100)/100};
% roomSP
vec = linspace(convtemp(72,'F','C'),convtemp(78,'F','C'),5);
param.roomSP = {round(vec*100)/100};
% pipeL
param.pipeL = {300};
% loopVolume
param.loopVolume = {6};

% generateTemplate
filename = '5ZoneAirCooledCondenser.idf';
newFile = 'test1.idf';
controls = genParametric(filename, param, newFile);
save('controls.mat', 'controls');
 
[status, msg] = system(['parametricpreprocessor ' newFile '&'],'-echo');


