classdef mlepAwsProcess < handle
    %MLEPAWSPROCESS A class for dispatching simulation into the cloud
    %   This class represents a dispatching process. It enables to create,
    %   send commands to AWS instacnes, send/retrieve files to/form AWS.
    %
    %   This class wraps the mlepAws* functions.
    %
    %   See also:
    %       <a href="http://aws.amazon.com/sdkforjava/">AWS SDK for Java(hyperlink)</a>
    %
    % (C) 2013 by Willy Bernal(willyg@seas.upenn.edu)
    
    % Last update: 2013-09-11 by Willy Bernal
    
    % HISTORY:
    %   2013-09-11  Created.
    
    
    properties
        ec2Client = [];
        ec2Info = [];
        secGroup = {};
        keyPath = {}; % Arguments to the client program
        credPath = {}; % Arguments to the client program
        accKey = {};
        secKey ={};
        indMap = [];
        status = 0;
        msg = '';
    end
    
    properties (SetAccess=private, GetAccess=public)
        rwTimeout = 0;      % Timeout for sending/receiving data (0 = infinite)
        isRunning = false;  % Is co-simulation running?
        serverSocket = [];  % Server socket to listen to client
        commSocket = [];    % Socket for sending/receiving data
        writer;             % Buffered writer stream
        reader;             % Buffered reader stream
        pid = [];           % Process ID for E+
    end
    
    properties (Constant)
        CRChar = sprintf('\n');
    end
    
    methods
        function obj = mlepAwsProcess()
            defaultSettings(obj);
    %        customSettings(obj,keyPath,credPath,numOfInst);
        end
        
        function [status, msg] = start(obj)
            % status and msg are returned from the client process
            % status = 0 --> success
            status = 0;
            msg = 0;
            
        end
        
        %%==============================================================
        function [status, msg, amazonEC2Client] = createEC2Client(obj)
            % Check if EC2 client already defined
            if isempty(obj.ec2Client)
                obj.ec2Client = com.amazonaws.services.ec2.AmazonEC2Client();
            else
                amazonEC2Client = obj.ec2Client;
            end
            status = 0;
            msg = '';
        end
        %%==============================================================
        function [status, msg, amazonEC2Client] = initEC2Client(obj)
            % Create Path Name to Credentials
            str1 = java.lang.String(obj.credPath);
            % Create File
            file1 = java.io.File(str1);
            % Load Property Credentials
            propCred = com.amazonaws.auth.PropertiesCredentials(file1);
            % Get Access Key
            obj.accKey = propCred.getAWSAccessKeyId();
            % Get Secret Key
            obj.secKey = propCred.getAWSSecretKey();
            % AmazonClient
            obj.ec2Client = com.amazonaws.services.ec2.AmazonEC2Client(propCred);
            % Specify Region
            region = 'http://ec2.us-east-1.amazonaws.com';
            obj.ec2Client.setEndpoint(java.lang.String(region));
            status = 0;
            msg = '';
        end
        %%==============================================================
        function [status, msg, amazonEC2Client] = initAWSInstance(obj, numInst)
            for i=1:numInst
                initAWSInstance(obj.ec2Client, obj.keyPath, obj.secGroup);
            end
        end         
        %%==============================================================
        function [status, msg, EC2_info] = getAWSInstanceInfo(obj)
            [~, EC2_info] = getAWSInstanceInfo(obj.ec2Client);
            obj.ec2Info = EC2_info;
            status = 0;
            msg = '';
        end
        %%==============================================================
        function removeFolderOnAws(obj)
            if ~isempty(obj.ec2Info)
                obj.ec2Client = removeFolderOnAWS(obj.ec2Client, obj.ec2Info, obj.keyPath);
            else
                error('Need to call first getAWSInstanceInfo');
            end
        end
        %%==============================================================
        function status = pushToAWS(obj, dirName)
            [obj.indMap] = pushToAWS(dirName, obj.ec2Client, obj.ec2Info, obj.keyPath);
            status = 0;
        end
        %%==============================================================
        function status = runSimulationOnAWS(obj)
            obj.ec2Client = runSimulationOnAWS(obj.ec2Client, obj.ec2Info, obj.keyPath);
            status = 0;
        end
        %%==============================================================
        function status = moveFileOnAWS(obj)
            obj.ec2Client = moveFileOnAWS(obj.ec2Client, obj.ec2Info, obj.keyPath);
            status = 0;
        end
        %%==============================================================
        function fetchDataOnAWS(obj)
            obj.ec2Client = fetchDataOnAWS(obj.ec2Client, obj.ec2Info, obj.keyPath);
        end
        %%==============================================================
        function delete(obj)
            if obj.isRunning
                obj.stop;
            end
            
        end
        
    end
    
    methods (Access=private)
        function closeCommSockets(obj)
            
        end
        
        function createStreams(obj)
            obj.writer = java.io.BufferedWriter(java.io.OutputStreamWriter(obj.commSocket.getOutputStream));
            obj.reader = java.io.BufferedReader(java.io.InputStreamReader(obj.commSocket.getInputStream));
        end
        
        function defaultSettings(obj)
            % Obtain default settings from the global variable MLEPSETTINGS
            % If that variable does not exist, assign default values to
            % settings.
            global MLEPAWSSETTINGS
            
            noSettings = isempty(MLEPAWSSETTINGS) || ~isstruct(MLEPAWSSETTINGS);
            if noSettings
                % Try to run mlepInit
                if exist('mlepInit', 'file') == 2
                    mlepInit;
                    noSettings = isempty(MLEPAWSSETTINGS) || ~isstruct(MLEPAWSSETTINGS);
                end
            end
            
            if noSettings || ~isfield(MLEPAWSSETTINGS, 'keyPath')
                obj.keyPath = 'keyPair.pem';    % Current version of the protocol
            else
                obj.keyPath = MLEPAWSSETTINGS.keyPath;
            end
            
            if noSettings || ~isfield(MLEPAWSSETTINGS, 'credPath')
                obj.credPath = 'AwsCredentials.properties';    % Current version of the protocol
            else
                obj.credPath = MLEPAWSSETTINGS.credPath;
            end
            
            if noSettings || ~isfield(MLEPAWSSETTINGS, 'secGroup')
                obj.secGroup = 'default';    % Current version of the protocol
            else
                obj.secGroup = MLEPAWSSETTINGS.secGroup;
            end            
        end
        function customSettings(obj,credPath, keyPath, numOfInst)
            global MLEPAWSSETTINGS
            
            noSettings = isempty(MLEPAWSSETTINGS) || ~isstruct(MLEPAWSSETTINGS);
            if noSettings
                % Try to run mlepInit
                if exist('mlepInit', 'file') == 2
                    mlepInit;
                    noSettings = isempty(MLEPAWSSETTINGS) || ~isstruct(MLEPAWSSETTINGS);
                end
            end
            obj.keyPath = keyPath;
            obj.credPath = credPath;
            obj.numOfInst = numOfInst;
        end
    end
end

