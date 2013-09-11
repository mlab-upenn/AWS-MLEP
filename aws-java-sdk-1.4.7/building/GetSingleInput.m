function [ data ] = GetSingleInput( filename )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%   Output  data    1 by 15

C = textread('1ZoneEvapCooler.idf','%s','delimiter', '\n');

data(1) = str2double(regexp(C{182},'(\d+.+\d+\d)','match'));
data(2) = str2double(regexp(C{183},'(\d+.+\d+\d)','match'));
data(3) = str2double(regexp(C{184},'(\d+.+\d+\d)','match'));
data(4) = str2double(regexp(C{185},'(\d+.+\d+\d)','match'));
data(5) = str2double(regexp(C{190},'(\d+.+\d+\d)','match'));
data(6) = str2double(regexp(C{191},'(\d+.+\d+\d)','match'));
data(7) = str2double(regexp(C{192},'(\d+.+\d+\d)','match'));
data(8) = str2double(regexp(C{193},'(\d+.+\d+\d)','match'));
data(9) = str2double(regexp(C{198},'(\d+.+\d+\d)','match'));
data(10) = str2double(regexp(C{199},'(\d+.+\d+\d)','match'));
data(11) = str2double(regexp(C{200},'(\d+.+\d+\d)','match'));
data(12) = str2double(regexp(C{201},'(\d+.+\d+\d)','match'));
data(13) = str2double(regexp(C{202},'(\d+.+\d+\d)','match'));
data(14) = str2double(regexp(C{203},'(\d+.+\d+\d)','match'));
data(15) = str2double(regexp(C{204},'(\d+.+\d+\d)','match'));

end

