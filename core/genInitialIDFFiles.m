function [ data] = genInitialIDFFiles( filename, lineofinterest, nooffiles, offset )
%GENIDFFILES Summary of this function goes here
%   filename  template file
%   lineofinterest specify which lines of interest will be changed
%   nooffiles specify how many idf files to generate
%   offset give an offest to the specified values
numParam = size(lineofinterest,2);
data = randi([1,15],[numParam nooffiles]);
if nargin < 4
    offset = zeros(1,numParam);
end
C = textread(filename,'%s','delimiter', '\n');


for i = 1:nooffiles
   for j = 1:numParam
       strrep(C{lineofinterest(j)}, regexp(C{lineofinterest(j)},',.*,', 'match'), [',' num2str(data(j,i) + offset(j)) ',']);
       
   end
   fName = strcat(num2str(i),'.idf');
   fid = fopen(fName,'w');
   for j=1:length(C)
       fprintf(fid,'%s\n',C{j});
   end
   fclose(fid);
    
end

    


end

