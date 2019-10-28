function varargout= P3_PluginEvalScript(scriptname, subscriptname,varargin)
% �X�N���v�g�v���O�C���p�F���s�֐�
%
% syntax: varargout= P3_PluginEvalScript(scriptname, subscriptname,varargin)
% -------------------------------------------------------------------------
% scriptname: �t�@�C����
% subscriptname: �T�u�֐���: �ʏ� "createBasicInfo"�Ȃ�
%  (�ʏ�̃X�N���v�g�������\)


% ======================================================================
% Copyright(c) 2019, 
% National Institute of Advanced Industrial Science and Technology
%
% Released under the MIT license 
% https://opensource.org/licenses/MIT 
% ======================================================================



% �ύX����
%  2014.03.12: �V�K�쐬 MS

%----------------------
% �������� �F�ʏ�� feval
%----------------------
if nargin==1
  if nargout,
    [varargout{1:nargout}]=feval(scriptname);
  else
    feval(scriptname);
  end
  return;
end

%----------------------
% ���� Callback �o�R
%----------------------
if ishandle(scriptname)
  % !!-- �o�[�W�����ˑ�����\���L�� --!!
  a=scriptname;
  b=subscriptname;
  scriptname=varargin{1};
  subscriptname=varargin{2};
  varargin{1}=a;
  varargin{2}=b;
  %varargin(1:2)=[];
end

%----------------------
% Feval �Ŏ��s
%----------------------
isnormal=true;
% �֐��|�C���^?
if ischar(scriptname)
  % *** MCR �p�̔z�z�X�N���v�g�@�H ****** (�X�N���v�g�쐬�c�[���ƍ��킹��)
  wk='PlugInWrapPS1_';
  if strncmpi(wk,scriptname,length(wk))
    isnormal=false; % �v���O�C��
  end
  % *** MCR �p�̔z�z�X�N���v�g�@�H ****** (�X�N���v�g�쐬�c�[���ƍ��킹��)
  wk='P3Scrpt_';
  if strncmpi(wk,scriptname,length(wk))
    isnormal=false; % �X�N���v�g
  end
end

%----------------------
% Feval �Ŏ��s
%----------------------
if isnormal 
  if nargout,
    [varargout{1:nargout}]=feval(scriptname,subscriptname,varargin{:});
  else
    feval(scriptname,subscriptname,varargin{:});
  end
  return;
end


%================================================================
% �����p�X�ݒ�
%=================================================================
fullname= P3_PluginGetScript(scriptname, subscriptname);

% �X�N���v�g���s
if nargout
  [varargout{1:nargout}]=fevalScriptMCR(fullname,nargout,varargin{:});
else
  fevalScriptMCR(fullname,nargout,varargin{:});
end

%=================================================================
function varargout = fevalScriptMCR(fname,nout,varargin)
% �X�N���v�g���s
%    fname �̃X�N���v�g��varargin/varargout�Ŏ��s����B
%=================================================================
if nargin<2,
  error('too few arguments');
end

myScriptName=fname;
vai0=varargin;
%vao0=varargout;
nin=length(varargin);
for ii=1:nin
  % vin1=varargin{1};
  % vin2=varargin{2}; ....
  eval(sprintf('vin%d=varargin{%d};',ii,ii));
end

% �t�@�C���Ǎ�
[fd,msg]=fopen(fname,'r');
if(msg), error(msg);end
try
  c_s = fread(fd,inf,'*char');
  fclose(fd);
catch
  fclose(fd);
  rethrow(lasterror);
end

% ���s
%  -- �Y���t�@�C���̓��� --
%    nin   = ���͈����̐�
%    vin1  = �������c
%    nout  = �o�͕ϐ��̐�
%  -- �Y���t�@�C���̏o�� --
%    vout1 = ���o�͈���: �c
eval(c_s);

% ���ʏo��
for tmp_loop_index_xx__ = 1: nout
  voutstr=sprintf('vout%d',tmp_loop_index_xx__);
  if exist(voutstr,'var'),
    varargout{tmp_loop_index_xx__} = eval(voutstr);
  else
    fprintf(2,'[%s]\n\t[Warn] varargout error in %s\n',fname,voutstr);
    disp(C__FILE__LINE__CHAR);
    varargout{tmp_loop_index_xx__} = [];
  end
end

return;

