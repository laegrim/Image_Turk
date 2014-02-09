function varargout = interface_test(varargin)
% INTERFACE_TEST M-file for interface_test.fig
%      INTERFACE_TEST, by itself, creates a new INTERFACE_TEST or raises the existing
%      singleton*.
%
%      H = INTERFACE_TEST returns the handle to a new INTERFACE_TEST or the handle to
%      the existing singleton*.
%
%      INTERFACE_TEST('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INTERFACE_TEST.M with the given input arguments.
%
%      INTERFACE_TEST('Property','Value',...) creates a new INTERFACE_TEST or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before interface_test_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to interface_test_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help interface_test

% Last Modified by GUIDE v2.5 08-Feb-2014 15:13:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @interface_test_OpeningFcn, ...
                   'gui_OutputFcn',  @interface_test_OutputFcn, ...
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


% --- Executes just before interface_test is made visible.
function interface_test_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to interface_test (see VARARGIN)

% Choose default command line output for interface_test
handles.output = hObject;

clc;


s = load('dbImageIndex.mat');
handles.imageIndex = s.imageIndex;




s = load('dbUserInteractionsName.mat');
handles.UserIntName = s.UserIntName;

handles.nImages = length(handles.imageIndex)

% set(handles.slider1,'max',handles.nImages)
% set(handles.slider1,'min',1)
% set(handles.slider1,'value',randi(length(handles.nImages)))
% set(handles.slider1,'sliderstep',[1 1])


imageNames = cell(handles.nImages,1);
for i = 1:handles.nImages
%   imageNames{i} = handles.imageIndex(i).path;
  imageNames{i} = sprintf('image %4d',i);
end
imageNames
set(handles.listbox2,'string',imageNames);

% handles.imgdir = 'imgs';
% 
% filelist0 = dir(handles.imgdir);
% 
% % filelist(filelist.isdir)
% handles.filelist = filelist0(3:end);
% 
handles = refresh(handles);






% Update handles structure
guidata(hObject, handles);

% UIWAIT makes interface_test wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = interface_test_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;







function handles = refresh(handles)

cla(handles.axes1);
s = load('dbImageIndex.mat');
handles.imageIndex = s.imageIndex;


handles.nImages = length(handles.imageIndex)

% set(handles.slider1,'max',handles.nImages)

imageNames = cell(handles.nImages,1);
for i = 1:handles.nImages
  imageNames{i} = handles.imageIndex(i).path;
  imageNames{i} = sprintf('image %4d',i);
end
set(handles.listbox2,'string',imageNames);



s = load('dbUserInteractionsName.mat');
handles.UserIntName = s.UserIntName;


idx = get(handles.listbox2,'value')
% idx = round(get(handles.slider1,'value'));

% filename=handles.filel;

A = imread(sprintf('%s',handles.imageIndex(idx).path));


[matches,cnt] = matchImageUID(handles.UserIntName,handles.imageIndex(idx).path)

displayStr = cell(length(matches),1);
for i = 1:length(matches)
  displayStr{i} = matches(i).objectName;
end

set(handles.listbox1,'string',displayStr);

if get(handles.listbox1,'value')>length(displayStr)
  objIdx = 1;
else

  objIdx = get(handles.listbox1,'value');
end

objectName = displayStr{objIdx};

s = load('dbUserInteractionsLocate.mat');
handles.UserIntLocate = s.UserIntLocate;


[matches,cnt] = matchImageUID(handles.UserIntLocate,handles.imageIndex(idx).path)

[matches,cnt] = matchObjectName(matches,objectName)



% set([handles.editX,handles.editY,handles.editName],'string','');

I = rgb2gray(A);
% BW = im2bw(A);
% BW2 = edge(I,'sobel');


% hsvImage = rgb2hsv(A);  %# Convert the image to HSV space
% hsvImage(:,:,2) = .2;           %# Maximize the saturation
% A = hsv2rgb(hsvImage);

imshow(I)
% imshow(A)
% axis on
axis tight

for i = 1:length(matches)
  x = matches(i).x_pos;
  y = matches(i).y_pos;
  [x,y]
  hold on;
  plot3(handles.axes1,x,y,+100,'sg','markersize',16,'linewidth',2)
  plot3(handles.axes1,x,y,+100,'or','markersize',10,'markerfacecolor','r')
end




% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonUpFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dat = get(handles.axes1,'currentpoint');
cursorpos = dat(1,1:2)

% set(handles.editY,'string',sprintf('%d',round(cursorpos(1))));
% set(handles.editX,'string',sprintf('%d',round(cursorpos(2))));

% handles = refresh(handles);
guidata(gcf,handles);



% --- Executes on button press in button_refresh.
function button_refresh_Callback(hObject, eventdata, handles)
% hObject    handle to button_refresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = refresh(handles);
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


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1
handles = refresh(handles);

% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles = refresh(handles);

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on selection change in listbox2.
function listbox2_Callback(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox2
handles = refresh(handles);

% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
