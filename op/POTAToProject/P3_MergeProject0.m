function P3_MergeProject0(prjl)
% Merge Current-Project and new-Project
%


% ======================================================================
% Copyright(c) 2019, 
% National Institute of Advanced Industrial Science and Technology
%
% Released under the MIT license 
% https://opensource.org/licenses/MIT 
% ======================================================================

% == History ==
%
% author : Masanori Shoji
% create : 2008.05.22
% $Id: P3_MergeProject0.m 180 2011-05-19 09:34:28Z Katura $

h      =POTATo;
handles=guidata(h);
pdir  = OSP_DATA('get','PROJECTPARENT');
if isempty(pdir)
  %=======================
  % Project Parent
  %=======================
  if isempty(pdir),pdir=pwd;end
  pdir = uigetdir(pdir,'Select Project Directory');

  % Cancel Check
  if isequal(pdir,0),return;end
  % Change Project-Parent-Directory
  POTATo('ChangeProjectParentIO',h,pdir,handles);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Searching
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
prjo=OSP_DATA('GET','PROJECT');
rawlist0=DataDef2_RawData('loadlist');
nraw=length(rawlist0);
analist0=DataDef2_Analysis('loadlist');
nana=length(analist0);

if nargin<1 || isempty(prjl) || ~iscell(prjl)
  uiPOTAToProject('Action','Open','FixAction',true);
  prj =OSP_DATA('GET','PROJECT');
  if isempty(prj),return;end
  prjl ={prj};
end
OSP_DATA('SET','SP_Rename','OriginalName');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Import Each Dir
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
try
% --> �������炪�{�ԂŁ[���B
for id=1:length(prjl)
  prj=prjl{id};
  %  if isequal(prj,prj0),continue;end
  %===================================
  % RAW-DATA���X�g�̎擾
  %===================================
  OSP_DATA('SET','PROJECTPARENT',prj.Path);
  OSP_DATA('SET','PROJECT',prj);
  try
    rawlist=DataDef2_RawData('loadlist');
    analist=DataDef2_Analysis('loadlist');
    myindex  =zeros(size(rawlist));
  catch
    % �_���ȃv���W�F�N�g�͎��ɐi��
    continue;
  end
  
  % Import-->RAW 
  for rid=1:length(rawlist)
    try
      % �O�̃v���W�F�N�g���Z�b�g
      OSP_DATA('SET','PROJECTPARENT',prj.Path);
      OSP_DATA('SET','PROJECT',prj);
      % �f�[�^�ǂݍ���
      [h,d,v]=DataDef2_RawData('load',rawlist(rid));
      % ���v���W�F�N�g���Z�b�g
      OSP_DATA('SET','PROJECTPARENT',prjo.Path);
      OSP_DATA('SET','PROJECT',prjo);
      % --> Raw & Ana �̕ۑ�
      %  !! -- Ana �������ۑ�����邱�Ƃɒ��� -- !!
      DataDef2_RawData('save',h,d,v);
      nraw=nraw+1;
      nana=nana+1;
      myindex(rid)=nana;
    catch
      disp('  XXX Could not Save Raw Data\n');
      disp(lasterr); disp('');
    end
  end
  
  % ���v���W�F�N�g���Z�b�g
  OSP_DATA('SET','PROJECTPARENT',prjo.Path);
  OSP_DATA('SET','PROJECT',prjo);
  analist0=DataDef2_Analysis('loadlist');
  namelist={rawlist.(DataDef2_Analysis('getIdentifierKey'))};
  cp_num   =zeros(size(rawlist));
  % Import ANA
  for aid=1:length(analist)
    try
      % �O�̃v���W�F�N�g���Z�b�g
      OSP_DATA('SET','PROJECTPARENT',prj.Path);
      OSP_DATA('SET','PROJECT',prj);
      % �f�[�^�ǂݍ���
      ana=DataDef2_Analysis('load',analist(aid));
       % �Ή��ۑ��ԍ����擾
      str=ana.data.name;if iscell(str),str=str{1};end
      idx=find(strcmp(namelist,str));idx=idx(1);
      cp_num(idx)=cp_num(idx)+1;
      % ���v���W�F�N�g���Z�b�g
      OSP_DATA('SET','PROJECTPARENT',prjo.Path);
      OSP_DATA('SET','PROJECT',prjo);
      if cp_num(idx)<=1
        % ANA�ɏ㏑��
        ana0=DataDef2_Analysis('load',analist0(myindex(idx)));
        ana0.data.filterdata=ana.data.filterdata;
        %========================
        %% Save (Over Write)
        %========================
        DataDef2_Analysis('save_ow',ana0);
      else
        % �V�K��ANA���쐬
        DataDef2_Analysis('save',ana);
      end

    catch
      fprintf('  XXX Could not Save ANA Data\n');
      disp(lasterr); disp('');
    end
  end
end

catch
end

% + + + + + + + + + + + + + + + + + + + + + + + + +
% Project�̏�Ԃ� P-3 �̐V�K�쐬�������̂ɖ߂��Ă����B
% + + + + + + + + + + + + + + + + + + + + + + + + +
OSP_DATA('SET','PROJECTPARENT',prjo.Path);
OSP_DATA('SET','PROJECT',prjo);
POTATo('ChangeProjectIO',h,[],handles);

