%% PROGRAM TO CHECK AMAZON EC@ instances
function [] = javaAWS()


% Import JAVA
import java.io.*;
import java.util.*;

% Import Jsch
import com.jcraft.jsch.ChannelSftp;
import com.jcraft.jsch.JSch;
import com.jcraft.jsch.Session;

% Import AWS
import com.amazonaws.AmazonServiceException;
import com.amazonaws.auth.AWSCredentials;
import com.amazonaws.auth.PropertiesCredentials;
import com.amazonaws.services.ec2.AmazonEC2;
import com.amazonaws.services.ec2.AmazonEC2Client;
import com.amazonaws.services.ec2.model.*;
import com.amazonaws.services.s3.*;
import com.amazonaws.services.simpledb.*;
import com.amazonaws.*;
import com.amazonaws.services.ec2.AmazonEC2Client;
import org.apache.http.client.methods.HttpUriRequest;

% Global Variable
amazonEC2Client = com.amazonaws.services.ec2.AmazonEC2Client();

% Main Function

% Init EC2 Client
amazonEC2Client = init(amazonEC2Client);

% Init Instance
% [amazonEC2Client, ec2Inst] = initInstance(amazonEC2Client);

% List Instances
amazonEC2Client = listInstance(amazonEC2Client);

% Start Instance
% imageID = java.lang.String('i-346aec5a');
% amazonEC2Client = startInstance(amazonEC2Client, imageID);

% Stop Instance
% imageID = java.lang.String('i-346aec5a');
% amazonEC2Client = stopInstance(amazonEC2Client, imageID);

% Terminate Instance
%imageID = java.lang.String('i-346aec5a');
%amazonEC2Client = terminateInstance(amazonEC2Client, imageID);


% Connect to Instance
% amazonEC2Client = connectInstance(amazonEC2Client, ec2Inst.instanceId, ec2Inst.publicDns);

ec2Inst.publicDns = 'ec2-50-17-138-234.compute-1.amazonaws.com';

% Connect to Instance
cmd = 'cd /home/ubuntu/mlep/Test1;ls';
amazonEC2Client = sendCommand(amazonEC2Client, ec2Inst.publicDns, cmd);

% Copy CFG
lfile = '/home/tao/Documents/MATLAB/aws/socket2.cfg';
rfile = '/home/ubuntu/mlep/Test1';
% amazonEC2Client = sendFile1(amazonEC2Client, ec2Inst.publicDns, lfile, rfile); % amazonEC2Client, publicDnsName, cmd, filename


% copy 
keyName = '/home/tao/Documents/MATLAB/aws/EnergyPlusKey.pem';
lfile = '/home/tao/Documents/MATLAB/aws/socket2.cfg';
rfile = '/home/ubuntu/mlep/Test1';
cmd = ['scp -i ' keyName ' ' lfile ' ubuntu@' ec2Inst.publicDns ':' rfile ' &'];
[stastus, msg] = system(cmd, '-echo');

% Connect to Instance
cmd = 'cd /home/ubuntu/mlep/Test1;ls';
amazonEC2Client = sendCommand(amazonEC2Client, ec2Inst.publicDns, cmd);

% Connect to Instance
cmd = 'runenergyplus /home/ubuntu/mlep/Test1/SmOffPSZ USA_IL_Chicago-OHare.Intl.AP.725300_TMY3';
amazonEC2Client = sendCommand(amazonEC2Client, ec2Inst.publicDns, cmd);

% Connect to Instance
lfile = '.';
rfile = '/home/ubuntu/mlep/Test1/Output';
cmd = ['scp -r -i '  keyName ' ubuntu@' ec2Inst.publicDns ':' rfile ' ' lfile ];
[stastus, msg] = system(cmd, '-echo');

% Connect to Instance
% lfile = '.';
% rfile = '/home/ubuntu/mlep/Test1/SmOffPSZ.idf';
% cmd = ['scp ' 'ubuntu@' ec2Inst.publicDns ':' rfile ' ' lfile ];
% amazonEC2Client = sendCommand(amazonEC2Client, ec2Inst.publicDns, cmd);

% Run EnergyPlus Instance
% cmd = 'cd /home/ubuntu/mlep/Test1;runenergyplus /home/ubuntu/mlep/Test1/SmOffPSZ USA_IL_Chicago-OHare.Intl.AP.725300_TMY3';
% %ec2Inst.publicDns = 'ec2-107-20-30-227.compute-1.amazonaws.com';
% amazonEC2Client = sendCommand(amazonEC2Client, ec2Inst.publicDns, cmd);

% Send Command
% cmd = 'cd /home/ubuntu/mlep/Test1/Output;cat SmOffPSZ.err';
% amazonEC2Client = sendCommand(amazonEC2Client, ec2Inst.publicDns, cmd);


end


function amazonEC2Client = init(amazonEC2Client)
disp('===========================================');
disp('Initialize EC2CLIENT!');
disp('===========================================');

% Create Path Name to Credentials
str1 = java.lang.String('/home/tao/Documents/MATLAB/aws/AwsCredentials.properties');

% Create File
file1 = java.io.File(str1);

% Load Property Credentials
propCred = com.amazonaws.auth.PropertiesCredentials(file1);

% Get Access Key
accKey = propCred.getAWSAccessKeyId()

% Get Secret Key
SecKey = propCred.getAWSSecretKey()

% AmazonClient
amazonEC2Client = com.amazonaws.services.ec2.AmazonEC2Client(propCred);

% Specify Region
amazonEC2Client.setEndpoint(java.lang.String('http://ec2.us-east-1.amazonaws.com'));
end


function amazonEC2Client = listInstance(amazonEC2Client)
disp('===========================================');
disp('Initialize EC2CLIENT!');
disp('===========================================');

try
    % Availability Zones
    availabilityZonesResult = amazonEC2Client.describeAvailabilityZones();
    availabilityZonesResult.getAvailabilityZones().size();
    
    % Describe Instances
    describeInstancesRequest = amazonEC2Client.describeInstances();
    reservations = describeInstancesRequest.getReservations();
    if isempty(reservations.isEmpty())
        disp('No Reservations Running');
    else
        count = 1;
        for i = 1:reservations.size
            instances  = reservations.get(i-1).getInstances();
            for j = 1:instances.size
                instance(count) = instances.get(j-1);
                ami(count) = instances.get(j-1).getAmiLaunchIndex();
                imageId(count) = instances.get(j-1).getImageId();
                pubDnsName(count) = instances.get(j-1).getPublicDnsName();
                instanceId(count) = instances.get(j-1).getInstanceId()
                count = count+1;
            end
        end
        
        disp(['You have ' num2str(count-1) ' Amazon EC2 Intance(s) Running'])
    end
catch ase
    disp(ase)
    rethrow(ase);
end
end

function [amazonEC2Client, ec2Inst] = initInstance(amazonEC2Client)
disp('===========================================');
disp('Run Instance!');
disp('===========================================');

% Prepare Inputs
imageID = java.lang.String('ami-8397e7ea');
securityGroup = 'mlepSecurityGroup2';
instanceType = java.lang.String('m1.medium');
keyName = java.lang.String('EnergyPlusKey');

% Create Request
runInstancesRequest = com.amazonaws.services.ec2.model.RunInstancesRequest();
runInstancesRequest.withImageId(imageID)...
    .withInstanceType(instanceType)...
    .withKeyName(keyName)...
    .withMinCount(java.lang.Integer(1))...
    .withMaxCount(java.lang.Integer(1)).withSecurityGroups(securityGroup);

% Launch Instance
runInstancesResult = amazonEC2Client.runInstances(runInstancesRequest);
reservation = runInstancesResult.getReservation();

% Gather Instance Info
instances = reservation.getInstances();
masterInstance = instances.get(0);
masterID = masterInstance.getInstanceId();
masterState = masterInstance.getState().getName();

while ~strcmp(char(masterInstance.getState.getName),'running')
    describeInstancesRequest = amazonEC2Client.describeInstances();
    reservations = describeInstancesRequest.getReservations();
    for i = 1:reservations.size
        instances  = reservations.get(i-1).getInstances();
        for j = 1:instances.size
            if strcmp(char(instances.get(j-1).getInstanceId()), char(masterID))
                masterInstance = instances.get(j-1);
                %disp('Found It')
                break;
            end
        end
    end
    
end
disp(['Intance with ID ' char(masterInstance.getInstanceId()) ' is ' char(masterInstance.getState.getName)]);

% Prepare Instance
ec2Inst = struct();
ec2Inst.instanceId = char(masterInstance.getInstanceId());
ec2Inst.publicDns = char(masterInstance.getPublicDnsName());
end

function [amazonEC2Client] = startInstance(amazonEC2Client,imageID)
disp('===========================================');
disp('Start Instance!');
disp('===========================================');
% Prepare Inputs
% imageID = java.lang.String('ami-8397e7ea');

% Create Start Instance Request
startInstancesRequest = com.amazonaws.services.ec2.model.StartInstancesRequest();

% Set Instance ID
imageID = char(imageID);
startInstancesRequest.withInstanceIds(imageID);

% Start Instance
startInstanceResult = amazonEC2Client.startInstances(startInstancesRequest);

% Check Instance
disp(startInstanceResult.toString());
end


function [amazonEC2Client] = stopInstance(amazonEC2Client, imageID)
disp('===========================================');
disp('Stop Instance!');
disp('===========================================');
% Prepare Inputs
% imageID = java.lang.String('ami-8397e7ea');
% securityGroup = 'mlepSecurityGroup2';
% instanceType = java.lang.String('m1.medium');
% keyName = java.lang.String('EnergyPlusKey');

% Create Stop Instance Request
stopInstancesRequest = com.amazonaws.services.ec2.model.StopInstancesRequest();

% Set Instance ID
imageID = char(imageID);
stopInstancesRequest.withInstanceIds(imageID);

% Stop Instance
stopInstanceResult = amazonEC2Client.stopInstances(stopInstancesRequest);

% Check Instance
disp(stopInstanceResult.toString());
end

function [amazonEC2Client] = terminateInstance(amazonEC2Client, imageID)
disp('===========================================');
disp('Terminate Instance!');
disp('===========================================');
% Prepare Inputs
%imageID = java.lang.String('ami-8397e7ea');

% Create Stop Instance Request
terminateInstancesRequest = com.amazonaws.services.ec2.model.TerminateInstancesRequest();

% Set Instance ID
imageID = char(imageID);
terminateInstancesRequest.withInstanceIds(imageID);

% Stop Instance
terminateInstanceResult = amazonEC2Client.terminateInstances(terminateInstancesRequest);

% Check Instance
disp(terminateInstanceResult.toString());
end

%% CONNECT TO SSH
function [amazonEC2Client] = connectInstance(amazonEC2Client, imageID, publicDNSname)
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
end

% cmd = 'ls'; % EnergyPlus/
% writer.println(cmd);
% Thread.sleep(3000);
% System.out.println(in.ready());
% while(in.ready())
%     System.out.println(in.readLine());
% end
% cmd = 'cd /home/ubuntu/'; % EnergyPlus/
% writer.println(cmd);
% Thread.sleep(3000);
% System.out.println(in.ready());
% while(in.ready())
%     System.out.println(in.readLine());
% end
% cmd = 'pwd';
% writer.println(cmd);
% Thread.sleep(3000);
% System.out.println(in.ready());
% while(in.ready())
%     System.out.println(in.readLine());
% end
% System.out.println('Done');
%
% cmd = 'runenergyplus ./5ZoneAirCooled.idf /usr/local/EnergyPlus-7-2-0/WeatherData/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.epw ';
% writer.println(cmd);
% Thread.sleep(5000);
% System.out.println(in.ready());
% while(in.ready())
%     System.out.println(in.readLine());
%     Thread.sleep(100);
% end
%
% % Copy Results
% cmd = 'cp -r Output ' + '/dev/';
% writer.println(cmd);
% Thread.sleep(5000);
% System.out.println(in.ready());
% while(in.ready())
%     System.out.println(in.readLine());
%     Thread.sleep(100);
% end
%
% cmd = 'exit';
% writer.println(cmd);
% Thread.sleep(3000);
% while(in.ready())
%     System.out.println(in.readLine());
% end
%
% p.waitFor();
% System.out.println('Done');



end


function [amazonEC2Client] = sendCommand(amazonEC2Client, publicDnsName, cmd)

% JSch
jsch = com.jcraft.jsch.JSch();
jsch.addIdentity('/home/tao/Documents/MATLAB/aws/EnergyPlusKey.pem');
jsch.setConfig('StrictHostKeyChecking', 'no');

% enter your own EC2 instance IP here
session=jsch.getSession('ubuntu', publicDnsName, 22);
session.connect();

% run stuff
command = cmd;
channel = session.openChannel('exec');
channel.setCommand(command);
channel.setErrStream(java.lang.System.err);
channel.connect();

input = channel.getInputStream();
% start reading the input from the executed commands on the shell
str = ones(1,200);
while (true)
    while (input.available() > 0)
        i = 1;
        cnt = 0;
        while (i > 0)
            i = input.read();
            cnt = cnt+1;
            str(cnt) = i;
            if (i < 0)
                break;
            end
        end
        disp(char(str(1:cnt-1)));
    end
    
    if (channel.isClosed())
        %java.lang.System.out.println('exit-status: ' + channel.getExitStatus());
        disp(java.lang.String(['exit-status: ' num2str(channel.getExitStatus())]));
        break;
    end
    
    pause(1);
end

channel.disconnect();
session.disconnect();

end

function [amazonEC2Client] = sendFile1(amazonEC2Client, publicDnsName, lfile, rfile)

% JSch
jsch = com.jcraft.jsch.JSch();

session=jsch.getSession('ubuntu', publicDnsName, 22);
jsch.addIdentity('/home/tao/Documents/MATLAB/aws/EnergyPlusKey.pem');
jsch.setConfig('StrictHostKeyChecking', 'no');

session.connect();

ptimestamp = false;
% exec 'scp -t rfile' remotely
%command="scp " + (ptimestamp ? "-p" :"") +" -t "+rfile;
command = java.lang.String(['scp -t ' rfile]);
%command="scp " + (ptimestamp ? "-p" :"") +" -t "+rfile;
channel=session.openChannel('exec');
channel.setCommand(command);
 
% get I/O streams for remote scp
out = channel.getOutputStream();
in = channel.getInputStream();

channel.connect();

if checkAck(in) ~= 0
	java.lang.System.exit(0);
end

Lfile = java.io.File(lfile);
 
% if ptimestamp
%     command = ['T ' num2str(Lfile.lastModified()/1000) ' 0'];
%     % The access time should be sent here,
%     % but it is not accessible with JavaAPI ;-<
%     command = [command ' ' num2str(Lfile.lastModified()/1000) ' 0\n'];
%     str = java.lang.String(command);
%     out.write(str.getBytes());
%     out.flush();
%     if checkAck(in) ~= 0
%         java.lang.System.exit(0);
%     end
% end

% send "C0644 filesize filename", where filename should not include '/'
% filesize= Lfile.length();
% command=['C0644 ' num2str(filesize) ' '];
% if lfile.lastIndexOf('/') > 0
%     command = [command lfile.substring(lfile.lastIndexOf('/')+1)];
%     
% else
%     command = [command lfile];
% end
% command =[command '\n'];
% str = java.lang.String(command);
% out.write(str.getBytes());
% out.flush();
% if checkAck(in) ~= 0
%     java.lang.System.exit(0);
% end

% send content of lfile
fis = java.io.FileInputStream(lfile);
sb = java.lang.StringBuffer();
    
while true
    if fis.available >0
        b=fis.read(); % buf, 0, buf.length
        if b > 0
            sb.append(char(b));
            out.write(b); %out.flush();
        else
            break;
        end
    
    else
        break;
    end
end
disp(sb.toString);
fis.close();
%fis=null;
% send '\0'
buf =java.lang.Byte(0); 
out.write(buf); % buf, 0, 1 
out.flush();
      
if checkAck(in) ~= 0
    java.lang.System.exit(0);
end
out.close();


%%

% byte[] buf=new byte[1024];

% send '\0'
buf(1) = 0;
out.write(buf, 0, 1);
out.flush();


% read '0644 '
str = ones(1,200);
cnt = 0;
%
% filesize = '0L';
% while true
%     r = in.read;
%     if r < 0
%         % error
%         break;
%     end
%
%     if r == ' '
%         break;
%     end
%     i = r;
%     cnt = cnt+1;
%     str(cnt) = i;
%     if (i < 0)
%         break;
%     end
%
%     disp(char(str(1:cnt-1)));
%     %filesize=filesize*10L+(long)(buf[0]-'0');
% end

str = ones(1,200);
while (true)
    while (in.available() > 0)
        i = 1;
        cnt = 0;
        while (i > 0)
            i = in.read();
            cnt = cnt+1;
            str(cnt) = i;
            if (i < 0)
                break;
            end
        end
        disp(char(str(1:cnt-1)));
    end
    
    if (channel.isClosed())
        %java.lang.System.out.println('exit-status: ' + channel.getExitStatus());
        disp(java.lang.String(['exit-status: ' num2str(channel.getExitStatus())]));
        break;
    end
    
    pause(1);
end


file = java.lang.String('');
%     for(int i=0;;i++)
%         in.read(buf, i, 1);
%         if(buf[i]==(byte)0x0a)
%             file= java.lang.String(buf, 0, i);
%             break;
%         end
%     end

% System.out.println("filesize="+filesize+", file="+file);

% send '\0'
%buf[0]=0;
out.write(0);
out.flush();

% read a content of lfile
%fos=new FileOutputStream(prefix==null ? lfile : prefix+file);
% int foo;
%     while true
%         if buf.length<filesize
%             foo=buf.length;
%         else foo=(int)
%             filesize;
%         end
%
%         foo=in.read(buf, 0, foo);
%         if(foo<0)
%             % error
%             break;
%         end
%
%         fos.write(buf, 0, foo);
%         filesize = filesize - foo;
%         if(filesize == '0L')
%             break;
%         end
%     end

%     fos.close();
%     fos=null;


if checkAck(in) ~= 0
    java.lang.System.exit(0);
end

% send '\0'
buf(1) = 0;
out.write(0);
out.flush();

session.disconnect();

java.lang.System.exit(0);
end


function [amazonEC2Client] = sendFile(amazonEC2Client, publicDnsName, cmd, filename)

% JSch
jsch = com.jcraft.jsch.JSch();
jsch.addIdentity('C:\Users\wbernal\Documents\AWS_MLEP\EnergyPlusKey.pem');
jsch.setConfig('StrictHostKeyChecking', 'no');

% enter your own EC2 instance IP here
session=jsch.getSession('ubuntu', publicDnsName, 22);
session.connect();

% run stuff
command = cmd;
channel = session.openChannel('exec');
channel.setCommand(command);
channel.setErrStream(java.lang.System.err);
channel.connect();

input = channel.getInputStream();
% start reading the input from the executed commands on the shell
str = ones(1,200);
while (true)
    while (input.available() > 0)
        i = 1;
        cnt = 0;
        while (i > 0)
            i = input.read();
            cnt = cnt+1;
            str(cnt) = i;
            if (i < 0)
                break;
            end
        end
        disp(char(str(1:cnt-1)));
    end
    
    if (channel.isClosed())
        %java.lang.System.out.println('exit-status: ' + channel.getExitStatus());
        disp(java.lang.String(['exit-status: ' num2str(channel.getExitStatus())]));
        break;
    end
    
    pause(1);
end

channel.disconnect();
session.disconnect();

end


function [amazonEC2Client] = sendFile2(amazonEC2Client, publicDnsName, lfile, rfile)
% JSch
jsch = com.jcraft.jsch.JSch();
jsch.addIdentity('/home/tao/Documents/MATLAB/aws/EnergyPlusKey.pem');
jsch.setConfig('StrictHostKeyChecking', 'no');
% enter your own EC2 instance IP here
session=jsch.getSession('ubuntu', publicDnsName, 22);

session.connect();
channel=session.openChannel('exec');
channel.setCommand(['scp ' lfile ' ubuntu@' publicDnsName ':' rfile]);
%channel.setCommand(['scp ' 'ubuntu@' publicDnsName ':/home/ubuntu/mlep/Test1/socket.cfg ' filename]);
%channel.setInputStream(null);
channel.setErrStream(java.lang.System.err);
channel.connect();

input = channel.getInputStream();
% start reading the input from the executed commands on the shell
str = ones(1,200);
while (true)
    while (input.available() > 0)
        i = 1;
        cnt = 0;
        while (i > 0)
            i = input.read();
            cnt = cnt+1;
            str(cnt) = i;
            if (i < 0)
                break;
            end
        end
        disp(char(str(1:cnt-1)));
    end
    
    if (channel.isClosed())
        %java.lang.System.out.println('exit-status: ' + channel.getExitStatus());
        disp(java.lang.String(['exit-status: ' num2str(channel.getExitStatus())]));
        break;
    end
    
    pause(1);
end


% Printing operations
channel.disconnect();
session.disconnect();

end


% Check Ack
function resp = checkAck(in)
b = in.read();
% b may be 0 for success,
%          1 for error,
%          2 for fatal error,
%          -1
resp = b;

if(b==0)
    return;
end

if(b==-1)
    return;
end


if(b==1 || b==2)
    sb = java.lang.StringBuffer();
    
    c = '';
    while in.available
        c=in.read();
        sb.append(char(c));
    end
    
    if(b==1) % error
       java.lang.System.out.print(sb.toString());
    end
    if(b==2) % fatal error
        java.lang.System.out.print(sb.toString());
    end
end

end

