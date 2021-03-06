% This script simulates a supervisory controller for an HVAC system. The
% controller computes the zone temperature set-point based on the current
% time and the outdoor dry-bulb temperature. The building is simulated by
% EnergyPlus. This simulation is the same as that implemented in
% simple.mdl, but uses plain Matlab code instead of Simulink.
%
% This script illustrates the usage of class mlepProcess in the MLE+
% toolbox for feedback control which involves whole building simulation.
% It has been tested with Matlab R2009b and EnergyPlus 6.0.0.
%
% This example is taken from an example distributed with BCVTB version
% 0.8.0 (https://gaia.lbl.gov/bcvtb).
%
% This script is free software.
%
% (C) 2010-2011 by Truong Nghiem (nghiem@seas.upenn.edu)
%
% CHANGES:
%   2012-04-23  Fix an error with E+ 7.0.0: Matlab must read data from E+
%               before sending any data to E+.
%   2011-07-13  Update to new version of MLE+ which uses mlepInit for
%               system settings.
%   2011-04-28  Update to new version of MLE+ which uses Java for running
%               E+.

%% Create an mlepProcess instance and configure it

ep = mlepProcess;
ep.arguments = {'5ZoneAirCooled', 'USA_IL_Chicago-OHare.Intl.AP.725300_TMY3'};
ep.acceptTimeout = 10000;

VERNUMBER = 2;  % version number of communication protocol (2 for E+ 7.2.0)

%% Start EnergyPlus cosimulation
[status, msg] = ep.start;

if status ~= 0
    error('Could not start EnergyPlus: %s.', msg);
end

[status, msg] = ep.acceptSocket;

if status ~= 0
    error('Could not connect to EnergyPlus: %s.', msg);
end

%% The main simulation loop

deltaT = 1*60;  % time step = 15 minutes
kStep = 1;  % current simulation step
MAXSTEPS = 1*24*60+1;  % max simulation time = 4 days

TCRooLow = 22;  % Zone temperature is kept between TCRooLow & TCRooHi
TCRooHi = 26;
TOutLow = 22;  % Low level of outdoor temperature
TOutHi = 24;  % High level of outdoor temperature
ratio = (TCRooHi - TCRooLow)/(TOutHi - TOutLow);

% logdata stores set-points, outdoor temperature, and zone temperature at
% each time step.
logInput = zeros(MAXSTEPS, 0);
logOutput = zeros(MAXSTEPS, 19);

while kStep <= MAXSTEPS
    % Read a data packet from E+
    packet = ep.read;
    if isempty(packet)
        error('Could not read outputs from E+.');
    end
    
    % Parse it to obtain building outputs
    [flag, eptime, outputs] = mlepDecodePacket(packet);
    if flag ~= 0, break; end
    
    t = rem(eptime, 60*60*24)/60/60;
    
    tro1 = outputs(2);
    coosp = 22;
    heasp = 20;
    cooling = true;
    ThSch = 4;

    
    inputs = [];
    
    % Write to inputs of E+
    ep.write(mlepEncodeRealData(VERNUMBER, 0, (kStep-1)*deltaT, inputs));
    
    % Save to logdata
    %logInput(kStep, :) = inputs;
    logOutput(kStep, :) = outputs;
    
    kStep = kStep + 1;
end

% Stop EnergyPlus
ep.stop;

disp(['Stopped with flag ' num2str(flag)]);

% Remove unused entries in logdata
kStep = kStep - 1;
if kStep < MAXSTEPS
    logInput((kStep+1):end,:) = [];
    logOutput((kStep+1):end,:) = [];
end

%%

% Show Results
Tout = logOutput(:,1);
Tro1 = logOutput(:,2);
Tro2 = logOutput(:,3);
Tro3 = logOutput(:,4);
Tro4 = logOutput(:,5);
Tro5 = logOutput(:,6);
Tple = logOutput(:,7);

Fro1 = logOutput(:,8);
Fro2 = logOutput(:,9);
Fro3 = logOutput(:,10);
Fro4 = logOutput(:,11);
Fro5 = logOutput(:,12);

Pfan = logOutput(:,13);
Phpu = logOutput(:,14);
Pcpu = logOutput(:,15);
Pchi = logOutput(:,16);
Ptot = Pfan + Phpu + Pcpu + Pchi;

Tpin = logOutput(:,17);
Tpou = logOutput(:,18);

CWsp = logOutput(:,19);

% Tcoo = logInput(:,1);
% Thea = logInput(:,2);
% Ther = logInput(:,3);

time = [0:(kStep-1)]'*deltaT/3600;

% Plot results
%subplot(3,1,1)
figure(1);plot(time, Tout, 'k', time, Tro1, 'g',  time, Tro2, 'c',  time, Tro3, 'm',  time, Tro4, 'r--', time, Tro5, 'b--', time, Fro5, 'c', time, CWsp, 'b--');
legend('Outdoor', 'Troom1', 'Troom2', 'Troom3', 'Troom4', 'Troom5', 'Air Flow', 'CW SP');
title('Temperatures');
xlabel('Time (hour)');
ylabel('Temperature (C)');
grid on;

figure(2);plot(time, Ptot, 'r', time, Pfan, 'k', time, Phpu, 'g', time, Pcpu, 'b', time, Pchi, 'm');
legend('Total', 'Fan', 'HW Pump', 'CW Pump', 'Chiller');
title('Power Consumption');
xlabel('Time (hour)');
ylabel('Power (W)');
grid on;

figure(3);plot(time, Tpin, 'r', time, Tpou, 'b', time, Tout, 'k');
legend('Pipe In', 'Pipe Out', 'Outdoor');
title('Temperature');
xlabel('Time (hour)');
ylabel('Temperature (C)');
grid on;

save('DR_20to27_20vol_100m.mat', 'time', 'Tout', 'Tro3', 'Tro4', 'Fro3', 'Fro4', 'Ptot', 'Pfan', 'Phpu', 'Pcpu','Pchi', 'Tpin', 'Tpou');

% ==========FLAGS==============
% Flag	Description
% +1	Simulation reached end time.
% 0	    Normal operation.
% -1	Simulation terminated due to an unspecified error.
% -10	Simulation terminated due to an error during the initialization.
% -20	Simulation terminated due to an error during the time integration.

