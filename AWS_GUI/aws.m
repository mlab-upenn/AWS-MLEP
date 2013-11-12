function varargout = aws(varargin)
% AWS MATLAB code for aws.fig
%      AWS, by itself, creates a new AWS or raises the existing
%      singleton*.
%
%      H = AWS returns the handle to a new AWS or the handle to
%      the existing singleton*.
%
%      AWS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in AWS.M with the given input arguments.
%
%      AWS('Property','Value',...) creates a new AWS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before aws_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to aws_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help aws

% Last Modified by GUIDE v2.5 31-Oct-2013 15:25:54

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @aws_OpeningFcn, ...
                   'gui_OutputFcn',  @aws_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before aws is made visible.
function aws_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to aws (see VARARGIN)

% Choose default command line output for aws
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes aws wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = aws_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in setCredButton.
function setCredButton_Callback(hObject, eventdata, handles)
% hObject    handle to setCredButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[credFileName,credPath,~] = uigetfile('*.properties');
fullCredPath = strcat(credPath, credFileName);
handles.data.awsCredPath = credPath;
handles.data.awsCredFileName = credFileName;
handles.data.awsFullCredPath = fullCredPath;
set(handles.showCredPath,'String', handles.data.awsCredFileName,'Background','g');
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function showCredPath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to showCredPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in setPEMKeyButton.
function setPEMKeyButton_Callback(hObject, eventdata, handles)
% hObject    handle to setPEMKeyButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[pemFileName, pemPath, ~] = uigetfile('*.pem');
fullPEMPath = strcat(pemPath, pemFileName);
handles.data.awsPEMPath = pemPath;
handles.data.awsPEMName = pemFileName;
handles.data.awsFullKeyPath = fullPEMPath;
set(handles.pemEdit,'String', handles.data.awsPEMName,'Background','g');
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function pemEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pemEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function numInstEdit_Callback(hObject, eventdata, handles)
% hObject    handle to numInstEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of numInstEdit as text
%        str2double(get(hObject,'String')) returns contents of numInstEdit as a double
numInst = str2double(get(hObject, 'String'));
handles.data.numInst = numInst;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function numInstEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numInstEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
handles.data.numInst = 2;
guidata(hObject, handles);


% --- Executes on button press in idfFolderButton.
function idfFolderButton_Callback(hObject, eventdata, handles)
% hObject    handle to idfFolderButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
idfPath = uigetdir();
handles.data.idfPath = idfPath;
set(handles.showIDFFolder,'String', handles.data.idfPath,'Background','g');
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function showIDFFolder_CreateFcn(hObject, eventdata, handles)
% hObject    handle to showIDFFolder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on selection change in instTypePop.
function instTypePop_Callback(hObject, eventdata, handles)
% hObject    handle to instTypePop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns instTypePop contents as cell array
%        contents{get(hObject,'Value')} returns selected item from instTypePop
contents = get(handles.instTypePop, 'String');
instType = contents{get(handles.instTypePop,'Value')};
handles.data.instType = instType;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function instTypePop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to instTypePop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
handles.data.instType = 't1.micro'
guidata(hObject, handles);

% --- Executes on button press in startButton.
function startButton_Callback(hObject, eventdata, handles)
% hObject    handle to startButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
amazonEC2Client = com.amazonaws.services.ec2.AmazonEC2Client();
amazonEC2Client = initClient(amazonEC2Client, handles.data.awsFullCredPath);
[ amazonEC2Client, EC2_info] = getAWSInstanceInfo ( amazonEC2Client );
% Create security group if necessary
if (EC2_info.instCount < handles.data.numInst)
    SGName = strcat('temp',num2str(rand));
    SGDescription = 'temp';
    [ amazonEC2Client, SGName ] = createSecurityGroup( SGName, SGDescription,amazonEC2Client );
end
% Create instances if necessary
for i = (EC2_info.instCount+1):handles.data.numInst
    initAWSInstance(amazonEC2Client, handles.data.awsFullKeyPath, SGName,handles.data.instType);
end

[amazonEC2Client, EC2_info] = getAWSInstanceInfo ( amazonEC2Client );
removeFolderOnAWS(amazonEC2Client, EC2_info,handles.data.awsFullKeyPath);
pushToAWS(handles.data.idfPath, amazonEC2Client, EC2_info, handles.data.awsFullKeyPath);
pause(3);
runSimulationOnAWS(amazonEC2Client, EC2_info, handles.data.awsFullKeyPath,handles.data.idfPath );
moveFileOnAWS(amazonEC2Client, EC2_info, handles.data.awsFullKeyPath);
fetchDataOnAWS(amazonEC2Client, EC2_info, handles.data.awsFullKeyPath);
