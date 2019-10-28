function varargout = uigetFilterData_ExportData(varargin)
% Exe�ŗp Export���@�I�� GUI


% ======================================================================
% Copyright(c) 2019, 
% National Institute of Advanced Industrial Science and Technology
%
% Released under the MIT license 
% https://opensource.org/licenses/MIT 
% ======================================================================



gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @uigetFilterData_ExportData_OpeningFcn, ...
                   'gui_OutputFcn',  @uigetFilterData_ExportData_OutputFcn, ...
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


function uigetFilterData_ExportData_OpeningFcn(hObject, eventdata, handles, varargin)
% �N��
%   ���I���F�@�o��[]

% Choose default command line output for uigetFilterData_ExportData
handles.output = [];
if length(varargin)>=2
	handles.FilterDataManager=varargin{1};
	handles.EvalFile         =varargin{2};
end
guidata(hObject, handles);

% error
if length(varargin)<2
	warndlg('File I/O Error');
	return;
end
% wait for user response (see UIRESUME)
set(handles.figure1,'WindowStyle','modal')
uiwait(handles.figure1);

function varargout = uigetFilterData_ExportData_OutputFcn(hObject, eventdata, handles)
% �o�͐���
varargout{1} = handles.output;
delete(handles.figure1);

function myresume(hs,FilterData)
% �o�͐ݒ肵�CResume
hs.output = FilterData;
guidata(hs.figure1, hs);
uiresume(hs.figure1);

%-------------------------------------------------------------------------
% Figure ��{�ݒ�
%-------------------------------------------------------------------------
function figure1_CloseRequestFcn(hObject, eventdata, handles)
%
if isequal(get(hObject, 'waitstatus'), 'waiting')
	uiresume(hObject);
else
	delete(hObject);
end

function figure1_KeyPressFcn(hObject, eventdata, handles)
%
if isequal(get(hObject,'CurrentKey'),'escape')
	handles.output = [];
	guidata(hObject, handles);
	uiresume(handles.figure1);
end

if isequal(get(hObject,'CurrentKey'),'return')
	%uiresume(handles.figure1);
	beep;
end

%======================================================================
% �I��
%======================================================================
function psb_Callback(h,ev,hs)
% �I�����s�{�^��
%   �e�{�^������̃R�[���o�b�N�i���ʁj
ud= get(h,'UserData');
filData =ud{1};

fdm=hs.FilterDataManager;
ef =hs.EvalFile;
fmd=OspFilterDataFcn('makeData',fdm,filData.name,ef);
myresume(hs,fmd);

if 0
	% �t�B���^�擾
	filData = P3_PluginEvalScript(filData.wrap,'getArgument',filData,[]);
	if isempty(filData)
		% cancel��
		return;
	end
	
	fd.region=ud{2};
	fd.Filter= filData;
	% OK���F�ۑ����ďo��
	%save(h,'UserData',filData);
	myresume(hs,fd);
end

%======================================================================
% CreateFcn:�@�֐����蓖��
%======================================================================
function psb_CreateFcn(h,hs,name)
% �{�^���� Filter�����蓖�Ă�
set(h,'UserData',[]);

filData.name=name; % ���O���猟������

%  ���@�ȉ��͊ȈՉ����Ă��悢
[FilterList, wrapper, FilterAllowed]= OspFilterDataFcn('list_io');
id0 = strfind(FilterList,filData.name);
id = find(~cellfun(@isempty,id0));
if isempty(id)
	% �Ȃ�
	set(h,'Visible','off');
	return;
end

id=id(1);
% 
%region=max(FilterAllowed{id});
region=FilterAllowed{id};
filData.name=FilterList{id}; % update
filData.wrap=wrapper{id};
set(h,'UserData',{filData,region},...
	'String',name,...
	'Visible','on')

function psb1_CreateFcn(h,ev,hs)
psb_CreateFcn(h,hs,'Save Data to XLS file');

function psb2_CreateFcn(h,ev,hs)
psb_CreateFcn(h,hs,'Save Value to Text File');
function psb3_CreateFcn(h,ev,hs)
psb_CreateFcn(h,hs,'hoge');
