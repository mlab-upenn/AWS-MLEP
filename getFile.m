function [amazonEC2Client] = getFile(amazonEC2Client, publicDnsName, lfile, rfile)

% JSch
jsch = com.jcraft.jsch.JSch();
session=jsch.getSession('ubuntu', publicDnsName, 22);
jsch.addIdentity('/Users/willyg/Dropbox/AWS_MLEP/EnergyPlusKey.pem');
jsch.setConfig('StrictHostKeyChecking', 'no');

session.connect();

prefix = java.lang.String('');
str_lfile = java.lang.String(lfile);

if java.io.File(str_lfile).isDirectory()
    prefix = java.lang.String([char(lfile) char(java.io.File.separator)]);
end

% exec 'scp -f rfile' remotely
%command="scp " + (ptimestamp ? "-p" :"") +" -t "+rfile;
command = java.lang.String(['scp -f ' rfile]);
channel=session.openChannel('exec');
channel.setCommand(command);

% get I/O streams for remote scp
out = channel.getOutputStream();
in = channel.getInputStream();

channel.connect();

% send '\0'
b = java.lang.Byte(0);
out.write(b.byteValue);
out.flush();

%while true
c = checkAck(in); 
if ~strcmp(char(c),'C')
    disp('Did not get C');
    return;
end

% read '0644'
sb = java.lang.StringBuffer();
for i = 1:5
    c = in.read();
    sb.append(char(c));
end
disp(['GOT ' char(sb)]);


filesize = 0;
while true
    c = in.read;
    if c < 0
        % error
        break;
    end
    if strcmp(char(c),' ')
        break;
    end
    filesize = filesize*10 + (c - uint8('0'));
end

file = java.lang.String();
buf = java.lang.StringBuffer();
while in.available
    c = in.read;
    if c == 10
        disp(buf.toString);
        break;
    else
        buf.append(char(c));
    end
end
disp(buf.toString);

disp(['Filesize: ' num2str(double(filesize)) ', file=' char(buf.toString)]);

% send '\0'
b = java.lang.Byte(0);
out.write(b.byteValue);
out.flush();

% read a content of lfile
if prefix.isEmpty
    temp = java.lang.String(lfile);
else
    temp = java.lang.String([char(prefix) char(buf.toString)]);
end

fos = java.io.FileOutputStream(temp);
 
sb = java.lang.StringBuffer();
while true
    
    if in.available < filesize 
        len = in.available;
    else
        len = filesize;
    end
    
    if(len<0)
        % error
        break; 
    else
        foo = in.read; 
        if foo ~= 0
            sb.append(char(foo));
            fos.write(foo);
        else
            len = -1;
            %sb.append(0);
            fos.write(10);
            break;
            
        end    
    end
end
disp(sb);
fos.close();

if checkAck(in) ~=0
    java.lang.System.exit(0); 
end
%end

b = java.lang.Byte(0);
out.write(b.byteValue); 
out.flush();

channel.disconnect();
session.disconnect();
end

% Check Ack
function resp = checkAck(in)
cnt = 0;
while ~in.available
    pause(0.2);
    cnt = cnt + 1;
    if cnt > 3
        resp = 0;
        disp('NO AVAILABLE INPUT');
        return;
    end
end

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


