function [ data ] = decodeChromos( strChromos,rangeBit )
%DECODECHROMOS Summary of this function goes here
%   Detailed explanation goes here
data = zeros(size(strChromos,2) / rangeBit, size(strChromos,1));
for i = 1:size(strChromos,1)
    for j = 1:size(strChromos,2) / rangeBit
        data(j,i) = bin2dec(strChromos(i,(((j-1)*rangeBit+1):j*rangeBit)));
        
    end

end

end

% data = zeros(length(strChromos{1}) / rangeBit, size(strChromos,1));
% for i = 1:size(strChromos,1)
%     for j = 1:length(strChromos{1}) / rangeBit
%         data(j,i) = bin2dec(strChromos{i}(((j-1)*5+1):j*5));
%         
%     end
% 
% end
% 
% end
% 
