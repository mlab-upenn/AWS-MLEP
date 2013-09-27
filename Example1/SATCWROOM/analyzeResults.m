clear all;
load csvData_125.mat

%% DURING DR 
% Start/End Time
startTime = 13;
endTime = 17;

% Get Point
varNo = 19; % CHILLER
chillerParam = resultAnalyzing(csvData, varNo, startTime, endTime);
varNo = 18; % FAN
fanParam = resultAnalyzing(csvData, varNo, startTime, endTime);
varNo = 22; % CW PUMP
pumpParam = resultAnalyzing(csvData, varNo, startTime, endTime);
varNo = 12; % PPD
ppdParam = resultAnalyzing(csvData, varNo, startTime, endTime);

% Get Points
chillerArray = cell2mat(chillerParam);
chillPoint = [chillerArray.P6]/1000;
fanArray = cell2mat(fanParam);
fanPoint = [fanArray.P6]/1000;
pumpArray = cell2mat(pumpParam);
pumpPoint = [pumpArray.P6]/1000;
ppdArray = cell2mat(ppdParam);
ppdPoint = [ppdArray.P6]; 

totalPoint = chillPoint + fanPoint + pumpPoint;

figure;
title('During');
scatter(ppdPoint,chillPoint,'b*');
hline([chillPoint(1), fanPoint(1), pumpPoint(1), totalPoint(1)],{'b','r','k', 'm'},{'Chiller','Fan','Pump', 'Total'});
hold on;
scatter(ppdPoint,totalPoint,'m*');
hold on;
scatter(ppdPoint,pumpPoint,'k*');
hold on;
scatter(ppdPoint,fanPoint,'r*');
hold on;
% for i = 1:125
%     text(ppdPoint(i), chillPoint(i), ['  ' num2str(i)], 'FontSize', 12, 'color', 'b');
%     text(ppdPoint(i), fanPoint(i), ['  ' num2str(i)], 'FontSize', 12, 'color', 'r');
%     text(ppdPoint(i), pumpPoint(i), ['  ' num2str(i)], 'FontSize', 12, 'color', 'k');
%     text(ppdPoint(i), totalPoint(i), ['  ' num2str(i)], 'FontSize', 12, 'color', 'm');
% end

c = 'b';
for i = [2 3 4 5]
    text(ppdPoint(i), chillPoint(i), ['  ' num2str(i)], 'FontSize', 12, 'color', c);
    text(ppdPoint(i), fanPoint(i), ['  ' num2str(i)], 'FontSize', 12, 'color', c);
    text(ppdPoint(i), pumpPoint(i), ['  ' num2str(i)], 'FontSize', 12, 'color', c);
    text(ppdPoint(i), totalPoint(i), ['  ' num2str(i)], 'FontSize', 12, 'color', c);
end

c = 'r';
for i = [6 11 16 21]
    text(ppdPoint(i), chillPoint(i), ['  ' num2str(i)], 'FontSize', 12, 'color', c);
    text(ppdPoint(i), fanPoint(i), ['  ' num2str(i)], 'FontSize', 12, 'color', c);
    text(ppdPoint(i), pumpPoint(i), ['  ' num2str(i)], 'FontSize', 12, 'color', c);
    text(ppdPoint(i), totalPoint(i), ['  ' num2str(i)], 'FontSize', 12, 'color', c);
end

c = 'k';
for i = [26 51 76 101]
    text(ppdPoint(i), chillPoint(i), ['  ' num2str(i)], 'FontSize', 12, 'color', c);
    text(ppdPoint(i), fanPoint(i), ['  ' num2str(i)], 'FontSize', 12, 'color', c);
    text(ppdPoint(i), pumpPoint(i), ['  ' num2str(i)], 'FontSize', 12, 'color', c);
    text(ppdPoint(i), totalPoint(i), ['  ' num2str(i)], 'FontSize', 12, 'color', c);
end

% Convex Hull
K = convhull(ppdPoint, totalPoint);

hold on;
grid on;
xlabel('PPD');
ylabel('PowerkW');

%% KICKBACK

% Start/End Time
startTime = 17;
endTime = 19;

% Get Point
varNo = 19; % CHILLER
chillerParam = resultAnalyzing(csvData, varNo, startTime, endTime);
varNo = 18; % FAN
fanParam = resultAnalyzing(csvData, varNo, startTime, endTime);
varNo = 22; % CW PUMP
pumpParam = resultAnalyzing(csvData, varNo, startTime, endTime);
varNo = 12; % PPD
ppdParam = resultAnalyzing(csvData, varNo, startTime, endTime);

% Get Points
chillerArray = cell2mat(chillerParam);
chillPoint = [chillerArray.P6]/1000;
fanArray = cell2mat(fanParam);
fanPoint = [fanArray.P6]/1000;
pumpArray = cell2mat(pumpParam);
pumpPoint = [pumpArray.P6]/1000;
ppdArray = cell2mat(ppdParam);
ppdPoint = [ppdArray.P6]; 

totalPoint = chillPoint + fanPoint + pumpPoint;

figure;
title('Kickback');
scatter(ppdPoint,chillPoint,'b*');
hline([chillPoint(1), fanPoint(1), pumpPoint(1), totalPoint(1)],{'b','r','k', 'm'},{'Chiller','Fan','Pump', 'Total'});
hold on;
scatter(ppdPoint,totalPoint,'m*');
hold on;
scatter(ppdPoint,pumpPoint,'k*');
hold on;
scatter(ppdPoint,fanPoint,'r*');
hold on;

for i = 1:125
    text(ppdPoint(i), chillPoint(i), ['  ' num2str(i)], 'FontSize', 12, 'color', 'b');
    text(ppdPoint(i), fanPoint(i), ['  ' num2str(i)], 'FontSize', 12, 'color', 'r');
    text(ppdPoint(i), pumpPoint(i), ['  ' num2str(i)], 'FontSize', 12, 'color', 'k');
    text(ppdPoint(i), totalPoint(i), ['  ' num2str(i)], 'FontSize', 12, 'color', 'm');
end


hold on;
grid on;
xlabel('PPD');
ylabel('PowerkW');

%% 
% % Plot All of them 
% for i = [1 2 3 4 7 10 19]
%     plotCSV(csvData,19,i);
%     str = input('');
% 
% end
% % DR function area & Kickback 
% 