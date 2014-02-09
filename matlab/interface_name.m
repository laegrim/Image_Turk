function varargout = interface_name(varargin)
% INTERFACE_NAME M-file for interface_name.fig
%      INTERFACE_NAME, by itself, creates a new INTERFACE_NAME or raises the existing
%      singleton*.
%
%      H = INTERFACE_NAME returns the handle to a new INTERFACE_NAME or the handle to
%      the existing singleton*.
%
%      INTERFACE_NAME('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INTERFACE_NAME.M with the given input arguments.
%
%      INTERFACE_NAME('Property','Value',...) creates a new INTERFACE_NAME or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before interface_name_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to interface_name_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help interface_name

% Last Modified by GUIDE v2.5 08-Feb-2014 15:08:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @interface_name_OpeningFcn, ...
                   'gui_OutputFcn',  @interface_name_OutputFcn, ...
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


% --- Executes just before interface_name is made visible.
function interface_name_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to interface_name (see VARARGIN)

% Choose default command line output for interface_name
handles.output = hObject;

clc;


s = load('dbImageIndex.mat');
handles.imageIndex = s.imageIndex;

handles.curImgIdx = 0;
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

% UIWAIT makes interface_name wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = interface_name_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function handles = submit(handles)

if handles.disable
  return
end

handles.disable = 1;

user_input = strtrim(get(handles.editName,'string'));

if isempty(user_input)
  return
end


% read the database
s = load('dbUserInteractionsName.mat');
UserIntName = s.UserIntName
idx = length(UserIntName)+1;


UserIntName(idx).objectName = user_input;
UserIntName(idx).time_stamp = system('date -j -f "%a %b %d %T %Z %Y" "`date`" "+%s"');
UserIntName(idx).image_uid = handles.img_uid
UserIntName(idx).userID = 0;
UserIntName
save('dbUserInteractionsName.mat','UserIntName')


handles=feedback(handles,user_input);


%%%%

function handles = feedback(handles,user_input)


A = imread(sprintf('%s',handles.imageIndex(handles.curImgIdx).path));
I = rgb2gray(A);

cla;
imshow(I)
axis tight


s = load('dbUserInteractionsLocate.mat');
handles.UserIntLocate = s.UserIntLocate;

[matches,cnt] = matchImageUID(handles.UserIntLocate,handles.imageIndex(handles.curImgIdx).path);

[matches,cnt] = matchObjectName(matches,user_input);

if isempty(matches)
  
  text(round(size(A,2)/2),round(size(A,1)/2),...
    sprintf('you are the first to find a %s!',user_input),...
    'horizontalalignment','center',...
    'verticalalignment','middle',...
    'fontsize',20,'color','red','fontweight','bold');
  
else

  for i = 1:length(matches)
    x = matches(i).x_pos;
    y = matches(i).y_pos;
    [x,y]
    hold on;
    plot3(handles.axes1,x,y,+100,'sg','markersize',16,'linewidth',2)
    plot3(handles.axes1,x,y,+100,'or','markersize',10,'markerfacecolor','r')
  end


end


function handles = refresh(handles)
handles.disable = 0;
idx = randi(length(handles.imageIndex))
while idx==handles.curImgIdx
  idx = randi(length(handles.imageIndex))
end
% idx = 

handles.img_uid = handles.imageIndex(idx).path
handles.curImgIdx = idx;

% filename=handles.filel;

A = imread(sprintf('%s',handles.imageIndex(idx).path));

set([handles.editName],'string','');

% I = rgb2gray(A);
% BW = im2bw(A);
% BW2 = edge(I,'sobel');
cla;
imshow(A)
axis tight




% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonUpFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% dat = get(handles.axes1,'currentpoint');
% cursorpos = dat(1,1:2);
% 
% set(handles.editY,'string',sprintf('%d',round(cursorpos(1))));
% set(handles.editX,'string',sprintf('%d',round(cursorpos(2))));
% 
% handles = refresh(handles);
% guidata(gcf,handles);
if handles.disable
  handles=refresh(handles);
  guidata(gcf,handles);
end

% --- Executes on button press in button_submit.
function button_submit_Callback(hObject, eventdata, handles)
% hObject    handle to button_submit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = submit(handles);
% handles = refresh(handles);

guidata(gcf,handles);





function editName_Callback(hObject, eventdata, handles)
% hObject    handle to editName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editName as text
%        str2double(get(hObject,'String')) returns contents of editName as a double
% handles = submit(handles);
% handles = refresh(handles);
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
