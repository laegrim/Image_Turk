function varargout = interface_locate(varargin)
% INTERFACE_LOCATE M-file for interface_locate.fig
%      INTERFACE_LOCATE, by itself, creates a new INTERFACE_LOCATE or raises the existing
%      singleton*.
%
%      H = INTERFACE_LOCATE returns the handle to a new INTERFACE_LOCATE or the handle to
%      the existing singleton*.
%
%      INTERFACE_LOCATE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INTERFACE_LOCATE.M with the given input arguments.
%
%      INTERFACE_LOCATE('Property','Value',...) creates a new INTERFACE_LOCATE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before interface_locate_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to interface_locate_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help interface_locate

% Last Modified by GUIDE v2.5 08-Feb-2014 15:35:41

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @interface_locate_OpeningFcn, ...
                   'gui_OutputFcn',  @interface_locate_OutputFcn, ...
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


% --- Executes just before interface_locate is made visible.
function interface_locate_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to interface_locate (see VARARGIN)

% Choose default command line output for interface_locate
handles.output = hObject;

clc;


s = load('dbImageIndex.mat');
handles.imageIndex = s.imageIndex;

handles.curImgIdx = -1;

handles.disable = 1;
handles = refresh(handles);






% Update handles structure
guidata(hObject, handles);

% UIWAIT makes interface_locate wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = interface_locate_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function editY_Callback(hObject, eventdata, handles)
% hObject    handle to editY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editY as text
%        str2double(get(hObject,'String')) returns contents of editY as a double


% --- Executes during object creation, after setting all properties.
function editY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function handles = feedback(handles,cursorpos)
handles.disable = 1;
A = imread(sprintf('%s',handles.imageIndex(handles.curImgIdx ).path));
I = rgb2gray(A);

cla;
imshow(I)
axis tight


s = load('dbUserInteractionsLocate.mat');
handles.UserIntLocate = s.UserIntLocate;

[matches,cnt] = matchImageUID(handles.UserIntLocate,handles.imageIndex(handles.curImgIdx).path)

[matches,cnt] = matchObjectName(matches,handles.objName)


for i = 1:length(matches)
  x = matches(i).x_pos;
  y = matches(i).y_pos;
  [x,y]
  hold on;
  plot3(handles.axes1,x,y,+100,'sg','markersize',16,'linewidth',2,'color',[0.5,0.7,0.5])
  plot3(handles.axes1,x,y,+100,'or','markersize',10,'color',[1,0.5,0.6],'markerfacecolor',[1,0.5,0.6])
end

plot3(handles.axes1,cursorpos(1),cursorpos(2),+100,'sg','markersize',16,'linewidth',2)
  plot3(handles.axes1,cursorpos(1),cursorpos(2),+100,'or','markersize',10,'markerfacecolor','r')

function handles = refresh(handles)
cla;
handles.disable = false;
idx = randi(length(handles.imageIndex))
while idx==handles.curImgIdx
  idx = randi(length(handles.imageIndex))
end
idx = randi(length(handles.imageIndex));
handles.curImgIdx = idx;

% filename=handles.filel;
handles.img_uid = handles.imageIndex(idx).path

A = imread(sprintf('%s',handles.imageIndex(idx).path));

s = load('dbUserInteractionsName.mat');
handles.UserIntName = s.UserIntName;

[matches,cnt] = matchImageUID(handles.UserIntName,handles.imageIndex(idx).path)

for i = 1:length(matches)
  matches(i).objectName
end

objIdx = randi(length(matches))
set(handles.editName,'string',matches(objIdx).objectName);

handles.objName = matches(objIdx).objectName;

% handles=feedback(handles);

% set([handles.editX,handles.editY,handles.editName],'string','');

% I = rgb2gray(A);
% BW = im2bw(A);
% BW2 = edge(I,'sobel');

imshow(A)
axis tight




% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonUpFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.disable
  return
end

dat = get(handles.axes1,'currentpoint');
cursorpos = round(dat(1,1:2));

% hold on;
% plot(cursorpos(1),cursorpos(2),'or')
% hold off;



% read the database
s = load('dbUserInteractionsLocate.mat');
UserIntLocate = s.UserIntLocate
idx = length(UserIntLocate)+1


UserIntLocate(idx).objectName = handles.objName;
UserIntLocate(idx).time_stamp = system('date -j -f "%a %b %d %T %Z %Y" "`date`" "+%s"');
UserIntLocate(idx).image_uid = handles.img_uid
UserIntLocate(idx).userID = 0;

UserIntLocate(idx).LFound = 1;
UserIntLocate(idx).x_pos = cursorpos(1)
UserIntLocate(idx).y_pos = cursorpos(2)
UserIntLocate(idx).z_pos = -1
UserIntLocate(idx).time_to_locate = 0

UserIntLocate
save('dbUserInteractionsLocate.mat','UserIntLocate')

handles = feedback(handles,cursorpos);

% pause(0.5);

% handles=refresh(handles);

% set(handles.editY,'string',sprintf('%d',round(cursorpos(1))));
% set(handles.editX,'string',sprintf('%d',round(cursorpos(2))));

% handles = refresh(handles);
guidata(gcf,handles);




function editName_Callback(hObject, eventdata, handles)
% hObject    handle to editName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editName as text
%        str2double(get(hObject,'String')) returns contents of editName as a double
handles = refresh(handles);
guidata(gcf,handles);

% --- Executes during object creation, after setting all properties.
function editName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in buttonSkip.
function buttonSkip_Callback(hObject, eventdata, handles)
% hObject    handle to buttonSkip (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles=refresh(handles);
guidata(gcf,handles);
