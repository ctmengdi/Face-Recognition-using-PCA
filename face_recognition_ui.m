function varargout = face_recognition_ui(varargin)
% FACE_RECOGNITION_UI MATLAB code for face_recognition_ui.fig
%      FACE_RECOGNITION_UI, by itself, creates a new FACE_RECOGNITION_UI or raises the existing
%      singleton*.
%
%      H = FACE_RECOGNITION_UI returns the handle to a new FACE_RECOGNITION_UI or the handle to
%      the existing singleton*.
%
%      FACE_RECOGNITION_UI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FACE_RECOGNITION_UI.M with the given input arguments.
%
%      FACE_RECOGNITION_UI('Property','Value',...) creates a new FACE_RECOGNITION_UI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before face_recognition_ui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to face_recognition_ui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help face_recognition_ui

% Last Modified by GUIDE v2.5 28-Dec-2016 22:44:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @face_recognition_ui_OpeningFcn, ...
                   'gui_OutputFcn',  @face_recognition_ui_OutputFcn, ...
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


% --- Executes just before face_recognition_ui is made visible.
function face_recognition_ui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to face_recognition_ui (see VARARGIN)

% Choose default command line output for face_recognition_ui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
set(handles.axes3,'xtick',[],'ytick',[])
set(handles.axes4,'xtick',[],'ytick',[])

% UIWAIT makes face_recognition_ui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = face_recognition_ui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in training_button.
function training_button_Callback(hObject, eventdata, handles)
% hObject    handle to training_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[featureV_train, data_mean, K, evec_real, data] = training_database();
handles.mystuff.featureV_train = featureV_train;
handles.mystuff.data_mean = data_mean;
handles.mystuff.K = K;
handles.mystuff.evec_real = evec_real;
handles.mystuff.data = data;
guidata(gcbo, handles);


% --- Executes on button press in update_button.
function update_button_Callback(hObject, eventdata, handles)
% hObject    handle to update_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in testImg_listbox.
function testImg_listbox_Callback(hObject, eventdata, handles)
% hObject    handle to testImg_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns testImg_listbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from testImg_listbox
%axes(handles.axes3);
axes(handles.axes3);
listValue = get(handles.testImg_listbox, 'value');
test_img = select_test(listValue);
imshow(test_img);
handles.mystuff.test_img = test_img;
guidata(gcbo, handles);


% --- Executes during object creation, after setting all properties.
function testImg_listbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to testImg_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes4);
test_img = handles.mystuff.test_img;
data_mean = handles.mystuff.data_mean;
featureV_train = handles.mystuff.featureV_train;
evec_real = handles.mystuff.evec_real;
K = handles.mystuff.K;
data = handles.mystuff.data;
[match_image, match1_name, match2_name, match3_name] = face_recog(test_img, data_mean, featureV_train, evec_real, K, data);
imshow(match_image, []);
set(handles.matchedImg_listbox, 'String', {match1_name, match2_name, match3_name});



% --- Executes on selection change in matchedImg_listbox.
function matchedImg_listbox_Callback(hObject, eventdata, handles)
% hObject    handle to matchedImg_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns matchedImg_listbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from matchedImg_listbox
axes(handles.axes4);
order = get(handles.matchedImg_listbox, 'Value');
global match1_im;
global match2_im;
global match3_im;
switch order
    case 1
        imshow(match1_im, []);
    case 2
        imshow(match2_im, []);
    case 3
        imshow(match3_im, []);
end 

% --- Executes during object creation, after setting all properties.
function matchedImg_listbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to matchedImg_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
