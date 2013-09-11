clear;
clc;
filename = '1ZoneEvapCooler.idf';
original_file = textread(filename,'%s','delimiter', '\n');
original_data = GetSingleInput(filename);
fake_data = zeros(1000,15);

for i = [1,5,9,10,11,12]
    fake_data(:,i) = original_data(i) * (0.5 + rand(1,1000)); 
end
for i = setdiff(1:15,[1,5,9,10,11,12])
    fake_data(:,i) = randi([5000 9999],[1 1000])/10000;
 
end

for i = 1:1000
    original_file{182} = strcat(num2str(fake_data(i,1)),',');
    original_file{183} = strcat(num2str(fake_data(i,2)),',');
    original_file{184} = strcat(num2str(fake_data(i,3)),',');
    original_file{185} = strcat(num2str(fake_data(i,4)),';');
    original_file{190} = strcat(num2str(fake_data(i,5)),',');
    original_file{191} = strcat(num2str(fake_data(i,6)),',');
    original_file{192} = strcat(num2str(fake_data(i,7)),',');
    original_file{193} = strcat(num2str(fake_data(i,8)),';');
    original_file{198} = strcat(num2str(fake_data(i,9)),',');
    original_file{199} = strcat(num2str(fake_data(i,10)),',');
    original_file{200} = strcat(num2str(fake_data(i,11)),',');
    original_file{201} = strcat(num2str(fake_data(i,12)),',');
    original_file{202} = strcat(num2str(fake_data(i,13)),',');
    original_file{203} = strcat(num2str(fake_data(i,14)),',');
    original_file{204} = strcat(num2str(fake_data(i,15)),';');
    fName = strcat(num2str(i),'.idf');
    fid = fopen(fName,'w');
    for j=1:length(original_file)
        fprintf(fid,'%s\n',original_file{j});
    end
    fclose(fid);
end
