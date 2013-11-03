function [ data line_end rate_line] = GetSingleInput( filename, lineofinterest )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%   Output  data    1 by 15
%           rate_line indicate the line with value less than 1    


C = textread(filename,'%s','delimiter', '\n');

data = zeros(1,size(lineofinterest,2));

rate_line_count = 0;
rate_line = [];
for i = 1:size(data,2)
    exp = (regexp(C{lineofinterest(i)},'.*[;,]','match'));
    unit_exp = regexp(C{lineofinterest(i)},'{.*}', 'match');
    str = exp{1};
    data(i) = str2double(str(1:end-1));
    line_end(i) = str(end);
    if isempty(unit_exp)
        rate_line_count = rate_line_count + 1;
        rate_line(rate_line_count) = i;
    end
end
% data(1) = str2double(regexp(C{92},'(\d+.+\d+\d)','match'));
% data(2) = str2double(regexp(C{93},'(\d+.+\d+\d)','match'));
% data(3) = str2double(regexp(C{94},'(\d+.+\d+\d)','match'));
% data(4) = str2double(regexp(C{372},'(\d+.+\d+\d)','match'));
% data(5) = str2double(regexp(C{373},'(\d+.+\d+\d)','match'));
% data(6) = str2double(regexp(C{374},'(\d+.+\d+\d)','match'));
% data(7) = str2double(regexp(C{375},'(\d+.+\d+\d)','match'));
% data(8) = str2double(regexp(C{380},'(\d+.+\d+\d)','match'));
% data(9) = str2double(regexp(C{381},'(\d+.+\d+\d)','match'));
% data(10) = str2double(regexp(C{382},'(\d+.+\d+\d)','match'));
% data(11) = str2double(regexp(C{383},'(\d+.+\d+\d)','match'));
% data(12) = str2double(regexp(C{388},'(\d+.+\d+\d)','match'));
% data(13) = str2double(regexp(C{389},'(\d+.+\d+\d)','match'));
% data(14) = str2double(regexp(C{390},'(\d+.+\d+\d)','match'));
% data(15) = str2double(regexp(C{391},'(\d+.+\d+\d)','match'));

end

