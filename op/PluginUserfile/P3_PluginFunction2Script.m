function P3_PluginFunction2Script(plugindir)
% �v���O�C���֐����X�N���v�g�`���ɕϊ�����v���O����


% ======================================================================
% Copyright(c) 2019, 
% National Institute of Advanced Industrial Science and Technology
%
% Released under the MIT license 
% https://opensource.org/licenses/MIT 
% ======================================================================



% ��{�ݒ�
%-------------------
logname='transPluginScript';

% ����
%-------------------
if nargin<1
  % �f�o�b�O
  %disp('�f�o�b�O�R�[�h');
  %disp(C__FILE__LINE__CHAR);
  %plugindir='C:\Users\Katura\Desktop\shoji\P38_20140203\PluginDir\EvalString';
  %plugindir='D:\shoji\P38_Source\PluginDir\EvalString';
  plugindir=uigetdir;
  if isequal(plugindir,0)
    return;
  end
end
[s m]=mkdir(plugindir,'private');
if s==false
  myfprint(2,'[E] %s\n',m);
  return;
end

% ���O�t�@�C����
%-------------------
fid_mlog = fopen([plugindir filesep logname '.log'],'w');
if (fid_mlog==-1)
  myfprint(2,'Can not make Logfile [%s]\n',[plugindir filesep logname '.log']);
  return;
end

try
  % 1.�X�N���v�g���X�g(slist)�쐬
  %-------------------------------
  d=dir([plugindir filesep '*.m']);

  myfprint(fid_mlog,'-- Function List ---\n');
  slist=struct([]);
  for ii=1:length(d)
    d0=d(ii);
    % �ϊ��t�@�C��/�֐������擾
    [msg, sdata]=getFname(plugindir, d0);
    % �ΏۊO�H
    if isempty(sdata)
      if msg
        % �G���[�H
        myfprint(-fid_mlog,'[Error] %s :%s\n',d0.name, msg);
      end
      continue;
    end
    
    % ���X�g�ɒǉ�
    if isempty(slist)
      slist=sdata;
    else
      slist(end+1)=sdata; %#ok<AGROW>
    end
    myfprint(fid_mlog,'* %s to %s\n',sdata.oldfname1,sdata.newfname1);
  end


  % 2.�e�֐����[�v
  %-------------------------------
  for ii=1:length(slist)
    myfprint(fid_mlog,'\n********************************\n');
    myfprint(fid_mlog,'[Function] %s\n',slist(ii).newfname1);
    myfprint(fid_mlog,'********************************\n');
    msg=transfile(plugindir,slist,ii,fid_mlog);
    if msg
      myfprint(-fid_mlog,' [E] transfile %s\n',msg);
    end
	end

	% ���ʂ�zip��
	%-------------------------------
	% ����: CD���K�v�̂��� CD�� Overwrite�͋�����Ȃ�
		myfprint(fid_mlog,'\n********************************\n');
	myfprint(fid_mlog,' Make Zip-File\n');
	p0=pwd;
	if p0(1)=='.'
		warning('Do not make zip, because "cd" is overwitten.');
		fclose(fid_mlog);
		return;
	end
	cd(plugindir);
	[px, f]=fileparts(plugindir);
	zipname=[plugindir filesep f '.zip'];
	myfprint(fid_mlog,' Filename : %s\n',zipname);
	myfprint(fid_mlog,'********************************\n');
	
	fs={};
	for ii=1:length(slist)
		fs{end+1}=[slist(ii).newfname1 '.m'];
		myfprint(fid_mlog,' [%d] %s\n',length(fs),slist(ii).oldfname0);
	end
	f0=find_file('P3Scrpt_[\w\W]*.m', [plugindir filesep 'private'],'-i');
	for ii=1:length(f0)
		f=strrep(f0{ii},plugindir,'.');
		fs{end+1}=f;
		myfprint(fid_mlog,' [%d] %s\n',length(fs),f0{ii});
	end
	zip(zipname, fs);
	delete(fs{:});
	cd(p0);

catch
  myfprint(-fid_mlog,'[E] %s\n',lasterr);
end
fclose(fid_mlog);



%##########################################################################
% �c�[��
%##########################################################################
function cn=myfprint(fid0,fmt,varargin)
% ���b�Z�[�W�o�͊֐�
%==========================================================================

fid=abs(fid0);
% �ʏ�o��
cn=fprintf(fid,fmt,varargin{:});

% �W���G���[�o�͂܂ł͂��I���B
if fid<=2
  return;
end

% �W���o�͂ɂ���
if fid0<0
  fprintf(2,fmt,varargin{:});
else
  fprintf(1,fmt,varargin{:});
end


%##########################################################################
% �t�@�C�������K��
%##########################################################################
function [msg, sdata]=getFname(pdir,d0)
% �t�@�C�����ϊ��K��
%==========================================================================
msg=[];

% �X�N���v�g�w�b�_�� P3_PluginEvalScript �ɂ����f������K�v������B
headname1='PlugInWrapPS1_';  % �X�N���v�g�E�v���O�C��
headname2='P3Scrpt_';        % �ʏ�̃X�N���v�g

% �t�@�C����ޕ���
oldf = d0.name(1:end-2);

% �u���ς݂̃t�@�C��?
%-------------------
if strncmpi(headname1,d0.name,length(headname1)) || ...
    strncmpi(headname2,d0.name,length(headname2))
  % �ϊ��ΏۂłȂ�/�G���[�łȂ�
  sdata=[];
  return;
end

% sdata������
%-------------
sdata.type    =0;
sdata.oldfname1=oldf;
sdata.oldfname0=[pdir filesep d0.name];
sdata.newfname1=[headname2 oldf];

% �v���O�C���֐��̏ꍇ��type,newfname1�X�V
wk='pluginwrap_';
if strncmpi(wk,d0.name,length(wk))
  sdata.type=1;
  sdata.newfname1=[headname1 oldf(length(wk)+1:end)];
end
wk='pluginwrapp1_';
if strncmpi(wk,d0.name,length(wk))
  sdata.type=1;
  sdata.newfname1=[headname1 oldf(length(wk)+1:end)];
end

% �V�����t�@�C���̃t���p�X
sdata.newfname0=[pdir filesep sdata.newfname1 '.m'];

%##########################################################################
% �Ǎ��c�[��
%  cmd=myfgetcmd(fid) :  "..." �ŘA�������s�������� MATLAB��1�s���Ƃ肾���B
%                        �󔒍s�͔�΂�
%  myfbuf             : mygfgetcmd�œǂݍ��񂾂��A�o�͂��Ă��Ȃ��s���Ǘ�
%      line=myfbuf('get')  :  myfbuf���̍s���擾
%      myfbuf('put',line)  :  myfbuf���ɍs��o�^
%      myfbuf('clear')     :  myfbuf���N���A
%      myfbuf('flush',fid) :  myfbuf���N���A
%##########################################################################

function cmd=myfgetcmd(fid)
%  "..." �ŘA�������s�������� MATLAB��1�s���Ƃ肾���B
%==========================================================================
cmd   = [];

while 1
  % 1�s�Ǎ� & Buf �o�^
  %--------
  tline = fgetl(fid);
  if ~ischar(tline)
    break; % EOF?
  end
  myfbuf('put',tline);
  
  % ��s?
  %--------
  s=regexp(tline,'\S', 'once'); % ��󔒕���
  if isempty(s) 
    % ��s�F ����ǂݔ�΂�
    if  isempty(cmd)
      continue;
    end
    % 2��ڈȍ~�@�I�� (�ʏ킠�肦�Ȃ�)
    break;
  end
  
  % �p���s�H
  %--------
  s=regexp(tline,'\.\.\.\s*$', 'once'); % ...
  if isempty(s)
    % �p���s�łȂ�
    s=regexp(tline,'\S','once');
    cmd=[cmd tline(s(1):end)]; % ����
    break;
  end
  
  d=regexp(tline,'\S','once');
  cmd=[cmd tline(d(1):s(1)-1)];
end

function line=myfbuf(cmd,arg1)
% mygfgetcmd�œǂݍ��񂾂��A�o�͂��Ă��Ȃ��s���Ǘ�
%==========================================================================
persistent mybuf;
switch cmd
  case 'clear',
    mybuf=[];
  case 'get',
    if isempty(mybuf)
      line=[];
    else
      line=mybuf{1};
      mybuf(1)=[];
    end
  case 'put'
    line=arg1;
    if isempty(mybuf)
      mybuf={line};
    else
      mybuf{end+1}=line;
    end
  case 'flush'
    fid=arg1;
    for ii=1:length(mybuf)
      fprintf(fid,'%s\n',mybuf{ii});
    end
    mybuf=[];
end

%##########################################################################
% �p�[�X�c�[��
%   t =iscommentline(str):�@�R�����g�s���� (�󔒂��R�����g�Ƃ݂Ȃ�)
%   kw=getKeyWords(str):    str���Ŏg���Ă���L�[���[�h���擾
%  [name, vin, vout]=myParseFunction(cmd): �֐����擾����
%##########################################################################
function c=cellcell2cell(cc)
% regexp��tokens �̌��� cell��cell�z����Acell�ɕύX����

% ��H
if isempty(cc)
  c={};
  return;
end

c=cell([1,length(cc)]);
% �ϊ�
for ii=1:length(cc)
  if iscell(cc{ii})
    c(ii)=cc{ii};
  else
    % cell-cell�łȂ��ꍇ�̑Ή�(���̂Ƃ���ʂ�Ȃ�)
    c(ii)=cc(ii);
  end
end


function t=iscommentline(str)
% �R�����g���C�����ۂ��̔���
%==========================================================================
t=true;
% �ŏ��̋󔒈ȊO�̕������擾
[s e]=regexpi(str,'^\s*\S','once');
if isempty(e)
  % �󔒍s
  return; % true����
end
if str(e)=='%'
  return;
end
t=false;

function kw=getKeyWords(str,flg)
% str���Ŏg���Ă���L�[���[�h���擾
%==========================================================================
if nargin<2
  flg=false;
end

if flg
  % �R�[�e�[�V��������������
  s=regexp(str,'''');
  idx=[];
  for ii=2:2:length(s)
    idx=[idx s(ii-1):s(ii)];
  end
  str(idx)=[];
end
[kw s t]=regexp(str,'[\W]*([a-zA-Z]\w*)[\s,]*','tokens');
kw=cellcell2cell(kw);

function [name, vin, vout]=myParseFunction(str0)
% �֐��錾�����߂��A�֐���, ����/�o�͈���
%==========================================================================
name=[];vin=[];vout=[];
str=str0;  % �f�o�b�O�p�� str0�͕ۑ�

% �֐� ?
[s e]=regexpi(str,'^\s*function\s+');
if isempty(s)
  return;
end

str=str(e:end);
% �o��
s=regexp(str,'=','once');
if ~isempty(s)
  outstr=str(1:s(1)-1);
  str   =str(s(1)+1:end);
  vout=regexp(outstr,'\s*([a-zA-Z]\w*)[\s,]*','tokens');
  vout=cellcell2cell(vout);
end

% ���O
s=regexp(str,'\(','once');
if isempty(s)
  name=str;
  s=regexp(name,'[a-zA-Z]','once');
  name=name(s(1):end);
  return;
end
name=str(1:s(1)-1);
s0=regexp(name,'[a-zA-Z]','once');
name=name(s0(1):end);
str=str(s(1):end);

s=regexp(str,'\)','once');
str=str(1:s(1));
% ����
vin=regexp(str,'\s*([a-zA-Z]\w*)[\s,]*','tokens');
vin=cellcell2cell(vin);

%##########################################################################
% �ϊ�
%##########################################################################
function msg=transfile(plugindir,slist,ii,fid_mlog)
% 1�t�@�C���ϊ����C��
%==========================================================================
sdata=slist(ii);

% �e��`�F�b�N
if exist([sdata.oldfname1 '.fig'],'file')
  %myfprint(fid_mlog,' [W] Fig���܂ރt�@�C���ł��B���삵�Ȃ��ꍇ������܂�.\n',slist(ii).newfname1)
	myfprint(fid_mlog,' [W] M-File, named %s, include ".fig" file.\n',slist(ii).newfname1)
end

fid_in =fopen(sdata.oldfname0,'r');
fid_out=fopen(sdata.newfname0,'w');
try
  
  % �֐�
  % * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 

  % �w�b�_����
  %------------------------------------------------------------------------
  [msg vout ssdata]=makeHead(fid_mlog,fid_in,fid_out);
  if msg
    error(['makeHead:' msg]);
  end
   
  
  % �T�u�֐����X�g�̍쐬
  %------------------------------------------------------------------------
  [msg sslist]=getSubfunc(fid_mlog,fid_in, ssdata);
  if msg
    error(['getSubfunc:' msg]);
  end

  % ���C���֐�: �{�f�B
  %------------------------------------------------------------------------
  msg=makeBody0(fid_mlog,fid_in, fid_out,slist,ii,sslist);
  
  % �o�͈�����ݒ肷��
  %------------------------------------------------------------------------
  msg=makeFoot(fid_out,vout);
  if msg
    error(['makeFoot:' msg]);
  end
  fclose(fid_out);fid_out=-1;

  % �T�u�֐�
  % * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
  disp(C__FILE__LINE__CHAR);
  for ii2=2:length(sslist)
    try
      msg=makeSubfunction(fid_mlog,fid_in, slist,ii,sslist,ii2);
    catch
      msg=lasterr;
      myfprint(-fid_mlog,'[E] subfunction\t%s\n',msg);
    end
  end
  
catch
  msg=lasterr;
  myfprint(-fid_mlog,'[E] transfile:main-function\n\t%s\n',msg);
  msg=[];
  % �I������
  fclose(fid_in);
  if (fid_out~=-1)
    fclose(fid_out);
  end
  delete(sdata.newfname0);
  return;
end
if (fid_out~=-1)
  fclose(fid_out);
end
fclose(fid_in);
return;


function  [msg vout ssdata]=makeHead(fid_mlog,fid_in,fid_out)
% �w�b�_
%   �������߂����Cvin1, vin2,,, 
%   �o�͗p�f�[�^�Ƃ��ā@vout���쐬����
%==========================================================================
msg=[];
myfbuf('clear');

% ������
ssdata.subfname='';
ssdata.fpos_st =-1;
ssdata.fpos_ed =-1;
ssdata.vin		 =[];
ssdata.vout		 =[];
ssdata.cmd      ='';

% �֐����擾
%----------------
while 1
  fpos=ftell(fid_in);
  cmd=myfgetcmd(fid_in);
  % �R�����g�͏o�͂��Ď���
  if iscommentline(cmd)
    myfbuf('flush',fid_out);
    continue;
  end
  % �֐��p�[�X
  [name, vin, vout]=myParseFunction(cmd);
  if isempty(name)
    % ���������X�N���v�g�H
    msg=['Function Parse Error:' cmd];
    return;
  end
  ssdata.subfname=name;
  ssdata.fpos_st =ftell(fid_in);
  ssdata.vin     =vin;
  ssdata.vout    =vout;
  ssdata.cmd     =cmd;
  myfbuf('clear');
  func=cmd;
  break;
end

% �w���v�R�����g�o��
%----------------
while 1
  fpos=ftell(fid_in); % �Ō�̈ʒu
  cmd=myfgetcmd(fid_in);
  % �R�����g�͏o�͂��Ď���
  if iscommentline(cmd)
    myfbuf('flush',fid_out);
    continue;
  end
  break;
end
fprintf(fid_out,'\n%% %s\n%% converted by\n%%   $Id: $\n%%   Date: %s\n',...
  func,datestr(now));

ssdata.fpos_st =fpos; % ����!! ���񂱂�����o��
ssdata.fpos_ed =fpos;

msg=makeHead0(fid_out,vin);

function msg=makeHead0(fid_out,vin)
% ���͈�������
% See also : P3_PluginEvalScript/fevalScriptMCR
%==========================================================================
msg=[];
% �C���f���g�p�X�y�[�X
if nargin<3 
  indentstr='';
end

fprintf(fid_out,'\n');
fprintf(fid_out,'\n%% Input Variable\n');
fprintf(fid_out,'nargin=nin;\n');
for ii=1:length(vin)
  if strcmpi('varargin',vin{ii})
    fprintf(fid_out,'varargin=cell(1,nin-%d+1);\n',ii);
    fprintf(fid_out,'for ii=%d:nin\n',ii);
    fprintf(fid_out,'  varargin{ii-%d+1}=eval(sprintf(''vin%%d'',ii));\n',ii);
    fprintf(fid_out,'end\n');
    break;
	else
		fprintf(fid_out,'if nin>=%d\n',ii);
    fprintf(fid_out,'  %s\t= vin%d;\n',vin{ii},ii);
		fprintf(fid_out,'end\n');
  end
end
fprintf(fid_out,'\n');

function  [msg sslist]=getSubfunc(fid_mlog,fid_in, ssdata)
% �T�u�֐����X�g���擾����
%==========================================================================
msg=[];
sslist=ssdata;

% ������
fpos=ssdata.fpos_ed;
fseek(fid_in,fpos,'bof');
myfbuf('clear');

% ������ (��`)
ssdata.subfname='';
ssdata.fpos_st =-1;
ssdata.fpos_ed =-1;
ssdata.vin		 =[];
ssdata.vout		 =[];
ssdata.cmd     ='';
% �֐����擾
%----------------
while 1
  fpos=ftell(fid_in);
  % 1�s�Ǎ�
  cmd=myfgetcmd(fid_in);
  if isempty(cmd)
    sslist(end).fpos_ed=fpos;
    break;
  end
  
  % �֐��p�[�X
  [name, vin, vout]=myParseFunction(cmd);
  if isempty(name)
    % �֐�?
    continue;
  end
  
  % �֐����X�g�ǉ�
  ssdata.subfname=name;
  ssdata.fpos_st =ftell(fid_in);
  ssdata.vin     =vin;
  ssdata.vout    =vout;
  ssdata.fpos_ed =-1;
  ssdata.cmd     =cmd;
  sslist(end).fpos_ed=fpos;
  sslist(end+1)=ssdata;
  myfbuf('clear');
   
  myfprint(fid_mlog,'\tsubfunction : %s(at%d)\n',cmd,ssdata.fpos_st);
  
end

function msg=makeBody0(fid_mlog,fid_in, fid_out,slist,sid,sslist)
% ���C�������̃{�f�B����
%==========================================================================
msg=[];
% ������
ssdata=sslist(1);
fpos=ssdata.fpos_st;
fseek(fid_in,fpos,'bof');
myfbuf('clear');

% �ǂݍ���/�ϊ�
%----------------
while 1
  fpos=ftell(fid_in);
  % �֐��I��?
  if fpos >= ssdata.fpos_ed;
    break;
  end

  cmd=myfgetcmd(fid_in);
  % �R�����g�͏o�͂��Ď���
  if iscommentline(cmd)
    myfbuf('flush',fid_out);
    continue;
  end

  % �L�[���[�h�u��
  %----------------
  %myfprint(fid_mlog,'[DBG] %s\n',cmd);
  % �L�[���[�h���X�g�擾
  kw=getKeyWords(cmd,true); % �����񕔕�����
	
	% return (�P�̍s)
	if length(kw)==1 && strcmpi(kw{1},'return')
		s=regexpi(cmd,'return');
		if s(1)~=1
			msg=makeFoot(fid_out,ssdata.vout,cmd(1:s(1)-1));
		else
			msg=makeFoot(fid_out,ssdata.vout);
		end
		if msg
			error(['makeFoot:' msg]);
		end
		myfprint(fid_mlog,'[LOG] Add output-variable-setting before return-statement.\n',cmd);
		myfbuf('flush',fid_out);
		continue;
	end
	
		cmdX=cmd;
  ischange=false;
  
  for ii=1:length(kw)
    %myfprint(fid_mlog,'     %s\n',kw{ii});
    % ���C���֐��ł� feval ��u��
    if strcmpi(kw{ii},'feval')
      ischange=true;
      [s e]=regexpi(cmdX,'feval[\s]*\(');
      if ~isempty(s)
        cmdX=[cmdX(1:s(1)-1) ...
          sprintf('P3_PluginEvalScript(''%s'',',slist(sid).newfname1)...
          cmdX(e(1)+1:end)];
      end
    end
    
    % �e�֐�
    idx=find(strcmpi(kw{ii},{slist.oldfname1}));
    if ~isempty(idx)
      ischange=true;
      cmdX=strrep(cmdX,kw{ii},slist(idx(1)).newfname1);
    end
    
    % �T�u�֐�
    if any(strcmpi(kw{ii},{sslist.subfname}))
      ischange=true;
      [s e]=regexpi(cmdX,[kw{ii} '[\s]*\(']);
      if isempty(s)
        cmdX=strrep(cmdX,kw{ii},...
          sprintf('P3_PluginEvalScript(''%s'',''%s'')',...
          slist(sid).newfname1,kw{ii}));
      else
        cmdX=[cmdX(1:s(1)-1) ...
          sprintf('P3_PluginEvalScript(''%s'',''%s'',',...
          slist(sid).newfname1,kw{ii}) ...
          cmdX(e(1)+1:end)];
      end
		end

			% mfilename
			if strcmpi(kw{ii},'mfilename')
				ischange=true;
				[s, e]=regexpi(cmdX,[kw{ii} '[\s]*\([\w\W]\)']);
				if isempty(s)
					cmdX=strrep(cmdX,kw{ii},'myScriptName');
				else
					% �����������Ēu������
					if e(1)<length(cmdX)
						cmdX=[cmdX(1:s(1)-1) 'myScriptName' cmdX(e(1)+1:end)];
					else
						cmdX=[cmdX(1:s(1)-1) 'myScriptName'];
					end
				end
			end
			
			% return
			if strcmpi(kw{ii},'return')
				% �O��ŉ��s�ł���͂�
				ischange=true;
				[s, e]=regexpi(cmdX,[kw{ii} '[\s;]']);
				% �O���o��
				fprintf(fid_out,'%s\n',cmdX(1:s(1)-1));

				% Footer�o��
				makeFoot(fid_out,ssdata.vout,'  ');
				fprintf(fid_out,'  return;\n');
				
				% �㔼�͂��̂܂�
				if e(1)<length(cmdX)
					cmdX=cmdX(e(1)+1:end);
				else
					cmdX='';
				end
			end
		
  end
  
  if ischange
    % �ϊ���������o��
    fprintf(fid_out,'%s\n',cmdX);
    myfbuf('clear',fid_out);
    myfprint(fid_mlog,'[LOG] Change-Line\n      %s\n      -> %s\n',cmd,cmdX);
  else
    % �P���Ƀt���b�V�����Ď���
    myfbuf('flush',fid_out);
    continue;
  end
end


function msg=makeFoot(fid_out,vout,indentstr)
% �t�b�^
%   �o�͈�����ݒ肷��
%   �o�͗p�f�[�^�Ƃ��ā@vout���쐬����
%==========================================================================
msg=[];
% �C���f���g�p�X�y�[�X
if nargin<3 
  indentstr='';
end

% �o�͈����̉���
%----------------------
% See also : P3_PluginEvalScript/fevalScriptMCR
fprintf(fid_out,'\n%% Output Variable\n');
for ii=1:length(vout)
  
  if strcmpi('varargout',vout{ii})
    fprintf(fid_out,'%sfor ii=%d:nout\n',indentstr,ii);
    fprintf(fid_out,'%s  eval(sprintf(''vout%%d=varargout{ii-%d+1};'',ii));\n',indentstr,ii);
    fprintf(fid_out,'%send\n',indentstr);
    break;
  else
    fprintf(fid_out,'%svout%d\t= %s;\n',indentstr,ii,vout{ii});
  end
end
fprintf(fid_out,'\n');


function msg=makeSubfunction(fid_mlog,fid_in, slist,sid,sslist,ssid)
% �T�u�֐��̏o��
%==========================================================================
msg=[];

% �Ǎ��t�@�C��������
ssdata=sslist(ssid);
fpos=ssdata.fpos_st;
fseek(fid_in,fpos,'bof');
myfbuf('clear');

ignoreStringFlg=true;
squot   =''''; % �V���O���R�[�e�[�V���� ������
if strcmpi(ssdata.subfname,'write')
  ignoreStringFlg=false;
  squot   =''''''; % �V���O���R�[�e�[�V���� ������
end
% �o�̓t�@�C��
fullname= P3_PluginGetScript(slist(sid).newfname1, ssdata.subfname,...
	fileparts(slist(sid).newfname0));
fid_out=fopen(fullname,'w');

try
  myfprint(fid_mlog,'\n--------------------------------\n');
  myfprint(fid_mlog,'[sub-function] %s(%s)\n',ssdata.subfname,fullname);
  myfprint(fid_mlog,'--------------------------------\n');

  fprintf(fid_out,'%% [Syntax] %s\n',ssdata.cmd);

  % �w�b�_
  msg=makeHead0(fid_out,ssdata.vin);
  if msg
    error(['makeHead0:' msg]);
  end

  % ���C������

  % �ǂݍ���/�ϊ�
  %----------------
  while 1
    fpos=ftell(fid_in);
    % �֐��I��?
    if fpos >= ssdata.fpos_ed;
      break;
    end

    cmd=myfgetcmd(fid_in);
    % �R�����g�͏o�͂��Ď���
    if iscommentline(cmd)
      myfbuf('flush',fid_out);
      continue;
    end

    % �L�[���[�h�u��
    %----------------
    %myfprint(fid_mlog,'[DBG] %s\n',cmd);
    % �L�[���[�h���X�g�擾
    kw=getKeyWords(cmd,ignoreStringFlg); % �����񕔕�����

		% return (�P�̍s)
		if length(kw)==1 && strcmpi(kw{1},'return')
			s=regexpi(cmd,'return');
			if s(1)~=1
				msg=makeFoot(fid_out,ssdata.vout,cmd(1:s(1)-1));
			else
				msg=makeFoot(fid_out,ssdata.vout);
			end
			if msg
				error(['makeFoot:' msg]);
			end
			myfprint(fid_mlog,'[LOG] Add output-variable-setting before return-statement.\n',cmd);
			myfbuf('flush',fid_out);
			continue;
		end
		
    cmdX=cmd;
    ischange=false;
    for ii=1:length(kw)
      %myfprint(fid_mlog,'     %s\n',kw{ii});

			% �e�֐�
			idx=find(strcmpi(kw{ii},{slist.oldfname1}));
			if ~isempty(idx)
				ischange=true;
				%cmdX=strrep(cmdX,kw{ii},slist(idx(1)).newfname1);
				[s, e]=regexpi(cmdX,['\{[\s]*@' kw{ii} '[\s]*,']);
				if ~isempty(s)
					% @�֐�
					cmdX=[cmdX(1:s(1)-1) ...
						'{@P3_PluginEvalScript,' ...
						sprintf('%s%s%s,[]',...
						squot,slist(idx(1)).newfname1,squot) ...
						cmdX(e(1):end)];
				else
					[s, e]=regexpi(cmdX,[kw{ii} '[\s]*\(']);
					if isempty(s)
						cmdX=strrep(cmdX,kw{ii},...
							sprintf('P3_PluginEvalScript(%s%s%s,[])',...
							squot,slist(idx(1)).newfname1,squot));
					else
						if e(1)<length(cmdX)
							cmdX=[cmdX(1:s(1)-1) ...
								sprintf('P3_PluginEvalScript(%s%s%s,[],',...
								squot,slist(idx(1)).newfname1,squot) ...
								cmdX(e(1)+1:end)];
						else
							cmdX=[cmdX(1:s(1)-1) ...
								sprintf('P3_PluginEvalScript(%s%s%s,[],',...
								squot,slist(idx(1)).newfname1,squot)];
						end
					end
				end
			end

      % �T�u�֐�
			if any(strcmpi(kw{ii},{sslist.subfname}))
				ischange=true;
				[s, e]=regexpi(cmdX,['\{[\s]*@' kw{ii} '[\s]*,']);
				if ~isempty(s)
					% @�֐�
					cmdX=[cmdX(1:s(1)-1) ...
						'{@P3_PluginEvalScript,' ...
						sprintf('%s%s%s,%s%s%s',...
						squot,slist(sid).newfname1,squot,squot,kw{ii},squot) ...
						cmdX(e(1):end)];
				else
					[s, e]=regexpi(cmdX,[kw{ii} '[\s]*\(']);
					if isempty(s)
						cmdX=strrep(cmdX,kw{ii},...
							sprintf('P3_PluginEvalScript(%s%s%s,%s%s%s)',...
							squot,slist(sid).newfname1,squot,squot,kw{ii},squot));
					else
						if e(1)<length(cmdX)
							cmdX=[cmdX(1:s(1)-1) ...
								sprintf('P3_PluginEvalScript(%s%s%s,%s%s%s,',...
								squot,slist(sid).newfname1,squot,squot,kw{ii},squot) ...
								cmdX(e(1)+1:end)];
						else
							cmdX=[cmdX(1:s(1)-1) ...
								sprintf('P3_PluginEvalScript(%s%s%s,%s%s%s,',...
								squot,slist(sid).newfname1,squot,squot,kw{ii},squot)];
						end
					end
				end
			end
			
			% mfilename
			if strcmpi(kw{ii},'mfilename')
				ischange=true;
				[s, e]=regexpi(cmdX,[kw{ii} '[\s]*\([\w\W]\)']);
				if isempty(s)
					cmdX=strrep(cmdX,kw{ii},'myScriptName');
				else
					% �����������Ēu������
					if e(1)<length(cmdX)
						cmdX=[cmdX(1:s(1)-1) 'myScriptName' cmdX(e(1)+1:end)];
					else
						cmdX=[cmdX(1:s(1)-1) 'myScriptName'];
					end
				end
			end
			
			% return
			if strcmpi(kw{ii},'return')
				% �O��ŉ��s�ł���͂�
				ischange=true;
				[s, e]=regexpi(cmdX,kw{ii});
				% �O���o��
				fprintf(fid_out,'%s\n',cmdX(1:s(1)-1));
				

				% Footer�o��
				sini=repmat(' ',1,s(1));
				makeFoot(fid_out,ssdata.vout,sini);
				
				% �㔼�͂��̂܂�
				if e(1)<length(cmdX)
					
					cmdX=cmdX(e(1)+1:end);
				else
					cmdX='';
				end
			end

    end

    if ischange
      % �ϊ���������o��
      fprintf(fid_out,'%s\n',cmdX);
      myfbuf('clear',fid_out);
      %myfprint(fid_mlog,'[LOG] �ϊ����s\n      %s\n      -> %s\n',cmd,cmdX);
			myfprint(fid_mlog,'[LOG] Change Line\n      %s\n      -> %s\n',cmd,cmdX);
    else
      % �P���Ƀt���b�V�����Ď���
      myfbuf('flush',fid_out);
      continue;
    end
  end % �Ǎ����[�v

  % �t�b�^
  msg=makeFoot(fid_out,ssdata.vout);
  if msg
    error(['makeFoot:' msg]);
  end
catch
  myfprint(-fid_mlog,'[E] %s\n',lasterr);
  msg='in makeSubfunction';
end
fclose(fid_out);

if 0
  edit(fullname);
end



