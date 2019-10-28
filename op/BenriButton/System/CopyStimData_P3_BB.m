function str=CopyStimData_P3_BB(hs)
% �I�𒆂̃t�@�C���̎h���f�[�^���A�I������t�@�C���̎h���f�[�^�ɒu��������
%   �֗��{�^��
%         2013.09.13  

str='CopyStimData';
if nargin<=0,return;end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Lock �p
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%hs=guidata(OSP_DATA('GET','POTATOMAINHANDLE'));
 
try
    
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % �R�s�[ �� (to) �ƌ�(from)�̊�{�f�[�^�쐬
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  vls      = get(hs.lbx_fileList,'Value');
  %if length(vls)>1, warndlg('please select one file.');return;end
  datalist = get(hs.lbx_fileList,'UserData');
  fromlist = datalist(setdiff(1:length(datalist),vls));
  fromstr   ={fromlist.filename};
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % GUI ����
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  p0=get(hs.figure1,'Position');
  p2=[p0(1), p0(2)+500-100 400, 100];

  % Figure
  h=figure;
  set(h,'Units','Pixels','Position',p2)
  set(h,'MenuBar','none','toolBar','none')
  set(h,'FileName','Copy Stim-Data','NumberTitle','off');
  
  % �^�C�g��
  ht=uicontrol(h,'Units','pixels','Position',[10 70 200 30]);
  set(ht,'style','text','String','copy stim-data from:','horizontalAlignment','left');

  % �R�s�[���I��p
  hp=uicontrol(h,'Units','pixels','Position',[20 40 360 30]);
  set(hp,'style','popupmenu','String',fromstr);
  
  % OK �{�^��
  hok=uicontrol(h,'Units','pixels','Position',[250 10 50 30]);
  set(hok,'style','pushbutton','String','OK','Callback','set(gcbf,''Visible'',''off'');');

  % Cancel �{�^��
  hcl=uicontrol(h,'Units','pixels','Position',[310 10 50 30]);
  set(hcl,'style','pushbutton','String','Cancel','Callback','delete(gcbf);');

  % �{�^�����͂܂�
  set(h,'WindowStyle','modal');
  waitfor(h,'Visible');
  if ~ishandle(h)
      % Cancel
      return;
  end
  fromdata = fromlist(get(hp,'Value'));
  delete(h);

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % �R�s�[�� Stim-Data�擾 (RAW)
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  an=DataDef2_Analysis('load',fromdata);
  rd=DataDef2_RawData('loadlist',an.data.name);
  [hdata,data]=DataDef2_RawData('load',rd);
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % �R�s�[�惋�[�v
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  for  ii=vls
      %----------
      % �Ăяo��
      %----------
      dii   = datalist(ii);
      anii=DataDef2_Analysis('load',dii);
      rdii=DataDef2_RawData('loadlist',anii.data.name);
      [hdataii,dataii]=DataDef2_RawData('load',rdii);

      %----------
      % �R�s�[
      %----------
      hdataii=copystim(hdata,hdataii);

      %----------
      % �ۑ�
      %----------
      DataDef2_RawData('save_ow',hdataii,dataii);
  end

catch ME
  rethrow(ME);
end


function toh=copystim(frmh,toh)
% Copy Stim Data from frmh to toh

ln=length(toh.stimTC);
% Stim�R�s�[
stim=frmh.stim;
stim((stim(:,3)>ln) | (stim(:,2)>ln)  ,:)=[];
toh.stim=stim;

% StimTC�R�s�[
ln0=length(frmh.stimTC);
if (ln0>ln)
    toh.stimTC(:)=frmh.stimTC(1:ln);
else
    toh.stimTC(1:ln0)=frmh.stimTC(:);
    toh.stimTC(ln0+1:end)=0;
end




