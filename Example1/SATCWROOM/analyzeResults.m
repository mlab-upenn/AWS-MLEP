load runCWSATROOM.mat

varNo = 19;
startTime = 13;
endTime = 17;
 
result = resultAnalyzing(csvData, varNo, startTime, endTime);

% Plot All of them 
for i = 1:27
    plotCSV(csvData,19,i);
    str = input('');
end
% DR function area & Kickback 
% 