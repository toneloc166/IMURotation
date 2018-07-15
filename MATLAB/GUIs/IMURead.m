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

% Last Modified by GUIDE v2.5 01-Jul-2018 16:01:40

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
s1 = serial('COM4','Baudrate',115200);
s2 = serial('COM5','Baudrate',115200);
s1.Terminator = 10;
s2.Terminator = 10; 
fopen(s1);
fopen(s2);

% Sphere Model
% [x,y,z] = sphere;
% sphereShape = surf(x,y,z);
% hold on;

% Cube Model
% [X,Y] = meshgrid(linspace(-2,2,20),linspace(-2,2,20));
% Z = 2 * ones(length(X),length(Y));
% h(1) = surf(X,Y,Z);
% hold on;
% h(2) = surf(Y,Z,X);
% h(3) = surf(Z,X,Y);
% h(4) = surf(-Y,-Z,-X);
% h(5) = surf(-Z,-X,-Y);
% h(6) = surf(-X,-Y,-Z);

% Rectangular Prism Model (iphone case)
% Axis of rotation initializes to X,Y,Z = 0,0,0
front = imread('front1.jpg');
back = imread('back1.jpg');
smallside = imread('smallside1.jpg');
smallsideflip = flip(smallside,1);
bigside = imread('bigside1.jpg');
bigsideflip = flip(bigside,1);
[X1,Y1] = meshgrid(linspace(-1.8,0,20),linspace(-1.65,1.65,20));
[X2,Y2] = meshgrid(linspace(-1.8,0,20),linspace(-3.05,3.05,20));
[X3,Y3] = meshgrid(linspace(-1.65,1.65,20),linspace(-3.05,3.05,20));
Z11 = -3.05 * ones(length(X1),length(Y1));
Z21 = -1.65 * ones(length(X2),length(Y2));
Z31 = -1.8 * ones(length(X3),length(Y3));
Z12 = 3.05 * ones(length(X1),length(Y1));
Z22 = 1.65 * ones(length(X2),length(Y2));
Z32 = zeros(length(X3),length(Y3));
h(1) = surf(Z21,Y2,X2, "FaceColor", "texturemap", "CData", bigsideflip,...
    "FaceAlpha", 1, "EdgeColor", "none");
hold on;
h(2) = surf(Y1,Z11,X1, "FaceColor", "texturemap", "CData", smallside,...
    "FaceAlpha", 1, "EdgeColor", "none");
h(3) = surf(X3,Y3,Z31, "FaceColor", "texturemap", "CData", back,...
    "FaceAlpha", 1, "EdgeColor", "none");
h(4) = surf(Y1,Z12,X1, "FaceColor", "texturemap", "CData", smallsideflip,...
    "FaceAlpha", 1, "EdgeColor", "none");
h(5) = surf(X3,Y3,Z32, "FaceColor", "texturemap", "CData", front,...
    "FaceAlpha", 1, "EdgeColor", "none");
h(6) = surf(Z22,Y2,X2, "FaceColor", "texturemap", "CData", bigside,...
    "FaceAlpha", 1, "EdgeColor", "none");

% Cylinder with cone (probe device)
% Axis of rotation initializes to X,Y,Z = 0,0,0
% Cylinder
r1 = 0.2;
h1 = 6;
[x1,y1,z1] = cylinder(r1);
z1 = z1 * h1;

% Cone
h2 = 1;
[x2,y2,z2] = cylinder([r1,0]);
z2 = z2 + 6;
z2 = z2 * h2;

probe(1) = surf(x1,y1,-z1, "Facecolor", [0.4,0.4,0.4]);
probe(2) = surf(x2,y2,-z2, "Facecolor", [0.75,0.75,0.75]);

% Grid setup
axis([-10, 10, -10, 10, -10, 10]);
set(gca, "color", [0.1 0.1 0.1], "GridAlpha", 0.5, "GridColor", [1 1 1], ...
    "Xtick", (-100:1:100));
xlabel('X');
ylabel('Y');
zlabel('Z');

% Transform
tform1 = hgtransform("parent", gca);
tform2 = hgtransform("parent", gca);
set(h, "parent", tform1);
set(probe, "parent", tform2);

% Trajectory.
t = 0:0.1:2000*pi;
X = 4*cos(t/1.6);
Y = 4*sin(t/1.6);
Z = 2*sin(t/1.6);
idx = 1;

while (1)
    % Read sensor data and assign values to quaternion array
    SerialData1 = fscanf(s1);
    SerialData2 = fscanf(s2);
    flushinput(s1);
    flushinput(s2);
    t1 = strsplit(SerialData1,'\t');
    t2 = strsplit(SerialData2,'\t');
    t1 = str2double(t1);
    t2 = str2double(t2);

    % Make sure buffer is correct before we process the data
    if (length(t1) == 9) && (length(t2) == 9)
        quatArray1 = [t1(1), t1(2), t1(3), t1(4)];
        quatArray2 = [t2(1), t2(2), t2(3), t2(4)];
        calArray1 = [t1(5), t1(6), t1(7), t1(8)];
        calArray2 = [t2(5), t2(6), t2(7), t2(8)];

        % Convert quaternion to 4x4 dcm
        dcm1 = quat2dcm(quatArray1);
        dcm2 = quat2dcm(quatArray2);
        dcm1 = rotm2tform(dcm1);
        dcm2 = rotm2tform(dcm2);

        % Check if dcm is finite - if not we can't process it
        if (sum(sum(isnan(dcm1))) > 0) || (sum(sum(isnan(dcm2))) > 0)
            continue;
        end
        
        % Apply rotation and translation
%         dcm1(1,4) = 0.7 * X(idx);
%         dcm1(2,4) = 0.7 * Y(idx);
%         dcm1(3,4) = 0.7 * Z(idx);
%         dcm2(1,4) = 0.7 * (X(idx));
%         dcm2(2,4) = 0.7 * (Y(idx));
%         dcm2(3,4) = 0.7 * (Z(idx));

        set(tform1,"Matrix",dcm1);
        set(tform2,"Matrix",dcm2);
        idx = idx + 1;
        
        % Calibration parameters
        % set(handles.system, "string", calArray1(1));
        set(handles.gyroscope, "string", calArray1(2));
        set(handles.accelerometer, "string", calArray1(3));
        % set(handles.magnetometer, "string", calArray1(4));
        
        % set(handles.systemObject, "string", calArray2(1));
        set(handles.gyroscopeObject, "string", calArray2(2));
        set(handles.accelerometerObject, "string", calArray2(3));
        % set(handles.magnetometerObject, "string", calArray2(4));
        
        drawnow;
        
        pause(0.1)
    end
end
