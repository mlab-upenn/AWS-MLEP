function data = ExtractData( filename, row, col, days )
%EXTRACTDATA Summary of this function goes here
%   Detailed explanation goes here


% if nargin < 2
%     row = 1;
%     col = 1;
%     size = 4; 
% end

raw_data = csvread(filename, row, col);
data = zeros(1,days * 24 * size(raw_data,2));
step = floor(size(raw_data,1)/ days);
count = 1;
data_chunk_size = 24 * size(raw_data,2);
for i = 1:step:size(raw_data,1)
    temp = reshape(raw_data(i:i+23,:)',1,data_chunk_size);
    data(count:count+data_chunk_size-1) = temp;
    count = count + data_chunk_size;
end
end

