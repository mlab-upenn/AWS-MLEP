function addJavaPath(dirJar)
%ADDJAVAPATH Add java libraries found in dirJar to dynamic path.
%   This function adds all existing jar files in the given directory to the
%   java dynamic path.
%
%   Call syntax:
%       addJavaPath(dirPath);
%
%
% (C) 2013 by Willy Bernal (willyg@seas.upenn.edu)

% Last update: 2013-09-11 by Willy Bernal
% HISTORY:
%   2013-09-11  Created. 

javaPath = dir([dirJar filesep '*.jar']);

for i = 1:length(javaPath)
   javaaddpath([dirJar filesep javaPath(i).name]); 
end

javaclasspath
