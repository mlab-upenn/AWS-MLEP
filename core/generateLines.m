function [data, comb] = generateLines(param)


% Allocate struct for lines
data = struct('lines', repmat({{}}, 1, length(fields(param))));

% Get fieldnames
fieldname = fields(param);

% Calculate how many elements
vec = [];
for i = 1:length(fieldname)
    vec = [vec size(param.(fieldname{i}),2)];
end
totNum = prod(vec);
    
% Get Input Cells
input = {};
for i = 1:length(fields(param))
    input{end+1} = cell2mat(param.(fieldname{i}));
end
output = cell(1,numel(input));
[output{:}] = ndgrid(input{:});

% Combination To be Written
comb = zeros(size(output{1}(:),1),size(output,2));
for i = 1:size(output,2)
    comb(:,i) = output{i}(:);
end

for i = 1:length(fields(param))
    startStr = ['  Parametric:SetValueForRun,' char(13) char(10)];
    startStr = [startStr '    ' '$' char(fieldname{i}) ',' char(13) char(10) '    '];
    for j = 1:size(comb,1)-1
        startStr = [startStr num2str(comb(j,i)) ',']; 
    end
    startStr = [startStr num2str(comb(j+1,i)) ';' char(13) char(10)];
    data(i).lines = startStr;
end






