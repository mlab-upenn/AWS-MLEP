function [amazonEC2Client] = sendFile(amazonEC2Client, publicDnsName, lfile, rfile)

% JSch
jsch = com.jcraft.jsch.JSch();
session=jsch.getSession('ubuntu', publicDnsName, 22);
jsch.addIdentity('initial.pem');
jsch.setConfig('StrictHostKeyChecking', 'no');

session.connect();

ptimestamp = false;
% exec 'scp -t rfile' remotely
%command="scp " + (ptimestamp ? "-p" :"") +" -t "+rfile;
command = java.lang.String(['scp -t ' rfile]);
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

% send "C0644 filesize filename", where filename should not include '/'
filesize= Lfile.length();
str_lfile = java.lang.String(lfile);
command=['C0644 ' num2str(filesize) ' '];
if str_lfile.lastIndexOf('/') > 0
    command = [command char(str_lfile.substring(str_lfile.lastIndexOf('/')+1))];
    
else
    command = [command char(str_lfile)];
end
str = java.lang.String(command);
out.write(str.getBytes());
b = java.lang.Byte(10);
out.write(b.byteValue);
out.flush();
if checkAck(in) ~= 0
    java.lang.System.exit(0);
end

% send content of lfile
fis = java.io.FileInputStream(lfile);
sb = java.lang.StringBuffer();
vec = size(143,1);
cnt = 1;
while true
    if fis.available >0
        b=fis.read();
        if b > 0
            vec(cnt) = b;
            cnt = cnt+1;
            sb.append(char(b));
            st = java.lang.String(char(b));
            out.write(st.getBytes);
        else
            break;
        end
        
    else
        break;
    end
end
% for j = 1:143
%     out.write(st.getBytes);
% end

disp(sb.toString);
fis.close();
fis = [];

% send '\0'
buf = java.lang.Byte(0);
out.write(buf.byteValue);
out.flush();

if checkAck(in) ~= 0
    %java.lang.System.exit(0);
    return;
    disp('ERROR EXIT');
end
out.close();

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


