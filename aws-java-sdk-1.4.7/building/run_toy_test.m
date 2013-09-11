clear;
clc;
input = load('X.mat');
output = load('Y.mat'); 
parts = make_xval_partition(2000, 10 );
w = zeros(15,1728);
error = zeros(max(parts),15);
for i = 1:max(parts) 
   
    w = zeros(15,1728);
   trainX = input.X(parts ~= i,:);
   testX = input.X(parts == i,:);
   
   trainY = output.Y(parts ~= i,:);
   testY = output.Y(parts == i,:);
   
   for j = 1:size(testY,2)
        w(j,:) = regress(trainY(:,j),trainX);
   end
   i
   error(i,:) = mean(abs((testX * w' - testY)./testY))

end

% trainX = input.X(1:1800,:);
% testX = input.X(1801:end,:);
% 
% trainY = output.Y(1:1800,:);
% testY = output.Y(1801:end,:);
% 
% for i = 1:size(testY,2);
%     w(i,:) = regress(trainY(:,i),trainX);
% end
% 
% error = mean((testX * w' - testY)./testY);

