function varargout=dev3dpos(cmd,varargin)
% Make P3 Data by Cell-array From Files.

persistent fnc; % �f�o�C�X���ɕω�������֐�

if  isempty(fnc) || ~isa(fnc, 'function_handle')
  % �e��ϐ��̏�����
  %read ini file
  IniFile='BenriButton\D3Mapping\ini\D3_ini.txt';
  try
        fid=fopen(IniFile,'r');
  catch
        error(['Ini-File not opend: ' IniFile]);
        return;
  end
  [Serial Std_Ref GuiAppli Navigation D3View]=Ini_file_read(fid);
  fclose(fid);
  if(strcmp(lower(Serial.Device),'isotrak2'))
        fnc=@dev3dpos_isotrack;
  
  elseif(strcmp(lower(Serial.Device),'patriot'))
        fnc=@dev3dpos_patriot;
  end
  
end

if nargout,
  [varargout{1:nargout}] = feval(fnc, cmd, varargin{:});
else
  feval(fnc, cmd, varargin{:});
end