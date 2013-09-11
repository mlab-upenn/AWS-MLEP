% root = 'C:\Users\wbernal\Documents\AWS_MLEP\aws\lib';
root = '/home/tao/Documents/MATLAB/aws/lib';
javaPath = dir([root filesep '*.jar']);

for i = 1:length(javaPath)
   javaaddpath([root filesep javaPath(i).name]); 
end

javaclasspath
