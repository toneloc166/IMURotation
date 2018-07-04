function varargout = IMURead(varargin)
% IMUREAD MATLAB code for IMURead.fig
%      IMUREAD, by itself, creates a new IMUREAD or raises the existing
%      singleton*.
%
%      H = IMUREAD returns the handle to a new IMUREAD or the handle to
%      the existing singleton*.
%
%      IMUREAD('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IMUREAD.M with the given input arguments.
%
%      IMUREAD('Property','Value',...) creates a new IMUREAD or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before IMURead_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to IMURead_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help IMURead

% Last Modified by GUIDE v2.5 12-Jun-2018 20:32:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @IMURead_OpeningFcn, ...
                   'gui_OutputFcn',  @IMURead_OutputFcn, ...
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


% --- Executes just before IMURead is made visible.
function IMURead_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to IMURead (see VARARGIN)

% Choose default command line output for IMURead
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes IMURead wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = IMURead_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This script reads and displays the IMU data for a particular object

% Create serial object and connect device
s1 = serial('COM3','Baudrate',115200);
s1.Terminator = 10; 
fopen(s1);

% Teapot Model
ptCloud = pcread('teapot.ply');
% Counter for translational movement
translationCounter = 0;

% Center = H/2; % Rotate Model around this point

while (1)
    % Read sensor data and assign values to quaternion array
    SerialData = fscanf(s1); 
    flushinput(s1);
    t = strsplit(SerialData,'\t');
    t = str2double(t);

    % Make sure buffer is correct before we process the data
    if length(t) == 9
        quatArray = [t(1), t(2), t(3), t(4)];
        calArray = [t(5), t(6), t(7), t(8)];

    %     % Move figure so when rotated, it is rotated about the center
    %     for i = 1:length(P)
    %         P(i,:) = P(i,:) - Center;
    %     end

        % Convert quaternion to 4x4 dcm
        dcm = quat2dcm(quatArray);
        dcm = rotm2tform(dcm);

        % Check if dcm is finite - if not we can't process it
        if sum(sum(isnan(dcm))) > 0
            continue;
        end
        
        % Translate a distance of 0.10 every 100 ticks
        if mod(translationCounter, 100) == 0
            dcm = dcm * makehgtform("translate", [0, 0, 0.1]);
        end
        
        % Rotate vectors using dcm
        tform = affine3d(dcm);
        
        

    %     % Bring figure back to original coordinates
    %     for i = 1:length(P)
    %         P(i,:) = P(i,:) + Center;
    %     end

        % Transform
        ptCloudOut = pctransform(ptCloud,tform);

        % Increment counter
        translationCounter = translationCounter + 1;
        
        % Plotting stuff
        set(handles.system, "string", calArray(1));
        set(handles.gyroscope, "string", calArray(2));
        set(handles.accelerometer, "string", calArray(3));
        set(handles.magnatometer, "string", calArray(4));
        
        pcshow(ptCloudOut);
        hold off;
        axis([-4 4 -4 4 -4 4]);
        grid on;
        view([1,1,1]);
        xlabel('X');
        ylabel('Y');
        zlabel('Z');
        drawnow;
    end
end
