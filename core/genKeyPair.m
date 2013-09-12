function [ amazonEC2Client, keyInfo ] = genKeyPair( keyName, amazonEC2Client )
%GENKEYPAIR Summary of this function goes here
%   Detailed explanation goes here
keyInfo.keyName = keyName;
% keyName = java.lang.String(keyName);
ckpr = com.amazonaws.services.ec2.model.CreateKeyPairRequest(keyName);
newKeyPair = amazonEC2Client.createKeyPair(ckpr);
key_material = char(newKeyPair);
key_material = key_material((111+length(keyName)):end-2);
fName = strcat(keyName,'.pem');
fid = fopen(fName,'w');
fprintf(fid,'%s',key_material);
fclose(fid);
cmd = ['chmod 400 ', fName];
system(cmd,'-echo');
keyInfo.key = newKeyPair;
end

