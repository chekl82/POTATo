function s=POTATo_MessageString(name)
% 

% ======================================================================
% Copyright(c) 2019, 
% National Institute of Advanced Industrial Science and Technology
%
% Released under the MIT license 
% https://opensource.org/licenses/MIT 
% ======================================================================






[names,str]=subMake;

s=str{strcmp(names,name)};

function [n,s]=subMake

n{1000}='Help_Dialog_BetaVerNoticeMessage_JP';
s{1000}={'�w���v��\�����邽�߂Ƀu���E�U���N������܂��B','','�w���v�͖������ł��B�s�������邩������܂��񂪁C���������������B','',...
	'��{����͓�����PDF�t�@�C���i�X�e�b�v�K�C�h�Ȃǁj�ɋL�ڂ�����܂��B'};

