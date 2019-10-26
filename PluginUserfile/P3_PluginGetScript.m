function fullname= P3_PluginGetScript(scriptname, subscriptname,mypath)
% �X�N���v�g�v���O�C���F���s�t�@�C�����擾�֐�
% syntax: fullname= P3_PluginGetScript(scriptname, subscriptname)
%����
%  scriptname   : �X�N���v�g�� (=�X�N���v�g�E�v���O�C�� �t�@�C����)
%  subscriptname: �T�u�֐��ɑ�������T�u�X�N���v�g��
%�o��
% fullname: �t���p�X �t�@�C���� (���ۂ̃X�N���v�g��)

% ======================================================================
% Copyright(c) 2019, 
% National Institute of Advanced Industrial Science and Technology
%
% Released under the MIT license 
% https://opensource.org/licenses/MIT 
% ======================================================================


persistent plugin_path;
global     WinP3_EXE_PATH;
%================================================================
% �����p�X�ݒ�
%=================================================================
if isempty(plugin_path)
  osp_path=OSP_DATA('GET','OspPath');
  if isempty(osp_path)
    osp_path=fileparts(which('POTATo'));
  end
  [pp ff] = fileparts(osp_path);
  if( strcmp(ff,'WinP3')~=0 )
    plugin_path = [osp_path filesep '..' filesep 'PluginDir'];
  else
    plugin_path = [osp_path filesep 'PluginDir'];
  end
end
if isempty(WinP3_EXE_PATH)
	plugin_path2=plugin_path;
	plugin_path3=[];
else
	plugin_path2=[WinP3_EXE_PATH filesep 'PluginDir'];
	plugin_path3=[WinP3_EXE_PATH filesep 'BenriButton'];
end



%================================================================
% �{�t�@�C������
%=================================================================
if nargin==3
  pth=mypath; % �ݒ�p�X (�V�K�쐬��)
else
  files=find_file(['^' scriptname '.m$'], plugin_path2,'-i');
  if isempty(files)
		if ~isempty(plugin_path3)
			files=find_file(['^' scriptname '.m$'], plugin_path3,'-i');
		end
		if isempty(files)
			files=find_file(['^' scriptname '.m$'], plugin_path,'-i');
		end
	end
	if isempty(files)
    % ������Ȃ�������G���[�@/ �f�t�H���g�l?
    error('No such file.');
    %pth=plugin_path;
  else
    % ��������ꍇ�͍ŏ��Ɍ�����������
    pth=fileparts(files{1}); % �p�X�擾
  end
end

if isempty(subscriptname)
  fname=[scriptname '.m'];
else
  fname=['P3Scrpt_' scriptname '_' subscriptname '.m'];
  pth=[pth filesep 'private'];
end

fullname=[pth filesep fname];
%-- no exist
% fullname�̃t�@�C�������݂��Ȃ��Ă����Ȃ��B
%   (�������ݗp�r�ŗ��p���邱�Ƃ�����̂�)


