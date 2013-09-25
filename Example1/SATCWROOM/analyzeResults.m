clear all;
load runCWSATROOM.mat

startTime = 13;
endTime = 17;
%% DURING DR 
varNo = 19; % CHILLER
chillerParam = resultAnalyzing(csvData, varNo, startTime, endTime);
varNo = 18; % FAN
fanParam = resultAnalyzing(csvData, varNo, startTime, endTime);
varNo = 22; % CW PUMP
pumpParam = resultAnalyzing(csvData, varNo, startTime, endTime);
varNo = 12; % PPD
ppdParam = resultAnalyzing(csvData, varNo, startTime, endTime);

%% DISPLAY 
chillerArray = cell2mat(chillerParam);
chillPoint = [chillerArray.P6]/1000;
fanArray = cell2mat(fanParam);
fanPoint = [fanArray.P6]/1000;
pumpArray = cell2mat(pumpParam);
pumpPoint = [pumpArray.P6]/1000;
ppdArray = cell2mat(ppdParam);
ppdPoint = [ppdArray.P6]; 
 
figure;
scatter(ppdPoint,chillPoint,'b*');
hline([chillPoint(1), fanPoint(1), pumpPoint(1)],{'b','r','k'},{'Chiller','Fan','Pump'});
hold on;
scatter(ppdPoint,pumpPoint,'k*');
hold on;
scatter(ppdPoint,fanPoint,'r*');
hold on;
for i = 1:27
    text(ppdPoint(i), chillPoint(i), ['  ' num2str(i)], 'FontSize', 12, 'color', 'b');
    text(ppdPoint(i), fanPoint(i), ['  ' num2str(i)], 'FontSize', 12, 'color', 'r');
    text(ppdPoint(i), pumpPoint(i), ['  ' num2str(i)], 'FontSize', 12, 'color', 'k');
end
hold on;
grid on;
xlabel('PPD');
ylabel('PowerkW');


%% 
% Plot All of them 
for i = [1 2 3 4 7 10 19]
    plotCSV(csvData,19,i);
    str = input('');

end
% DR function area & Kickback 
% 