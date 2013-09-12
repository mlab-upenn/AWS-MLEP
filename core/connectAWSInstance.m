function [amazonEC2Client] = connectAWSInstance(amazonEC2Client, imageID, publicDNSname)%CONNECTAWSINSTANCE Summary of this function goes here
disp('===========================================');
disp('Connect to Instance!');
disp('===========================================');

%static Runtime runtime;

%public static void main(String[] args) throws Exception {

% Connect to Instance
%Runtime runtime;
keyName = 'C:\Users\wbernal\Documents\AWS_MLEP\EnergyPlusKey.pem';
% runtime = java.lang.Runtime.getRuntime();
% runtime.getRuntime().exec('cmd /C dir');
% p = runtime.getRuntime().exec('cmd /C dir');
% class(p)
% cmd = 'C:\Windows\system32\cmd.exe';
% 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Microsoft Windows SDK v6.1'

% [status, result] = system([cmd ' &', '-echo']);

cmd = ['ssh -i ' keyName ' ubuntu@' publicDNSname];

cmd = 'C:\EnergyPlusV8-0-1\RunEPlus.bat &';
p = java.lang.Runtime.getRuntime.exec(cmd, '-echo');

%Process p = runtime.exec(cmd);
% [status, result] = system([cmd ' &']);

% PrintWriter
writer = java.io.PrintWriter(java.io.OutputStreamWriter(java.io.BufferedOutputStream(p.getOutputStream())), true);
% BufferedReader
in = java.io.BufferedReader(java.io.InputStreamReader(p.getInputStream()));
% Thread.sleep(4000);
System.out.println(in.ready());
while(in.ready())
    % System.out.println(in.ready());
    java.lang.System.out.println(in.readLine());
    % Thread.sleep(500);
end%   Detailed explanation goes here


end

