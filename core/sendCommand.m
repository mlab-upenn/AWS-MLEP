function [amazonEC2Client] = sendCommand(amazonEC2Client, publicDnsName, cmd)

% JSch
jsch = com.jcraft.jsch.JSch();
jsch.addIdentity('initial.pem');
jsch.setConfig('StrictHostKeyChecking', 'no');

% enter your own EC2 instance IP here
publicDnsName = strtrim(publicDnsName);
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