function initialize_axis(f)
% initialization for axis


% ======================================================================
% Copyright(c) 2019, 
% National Institute of Advanced Industrial Science and Technology
%
% Released under the MIT license 
% https://opensource.org/licenses/MIT 
% ======================================================================



axs=uimenu(f,'Label','$B<4$NA`:n(B');
uimenu(axs,'Label','$B%+%l%s%H$N(BX$B<4$rE,MQ(B','Callback',['xlmd=get(gca,''XLimMode'');',...
    'ylmd=get(gca,''YLimMode'');',...
    'if ~strcmp(xlmd,''Auto'')',...
    'xlim=get(gca,''XLim'');',...
    'for ii=1:112;',...
    'tag_ch=strcat(''ch'',num2str(ii));',...
    'h=findobj(''Tag'',tag_ch);',...
    'set(h,''XLim'',xlim);',...
    'end;',...
    'end']);
uimenu(axs,'Label','$B%+%l%s%H$N(BY$B<4$rE,MQ(B','Callback',['xlmd=get(gca,''XLimMode'');',...
    'ylmd=get(gca,''YLimMode'');',...
    'if ~strcmp(ylmd,''Auto'')',...
    'ylim=get(gca,''YLim'');',...
    'for ii=1:112;',...
    'tag_ch=strcat(''ch'',num2str(ii));',...
    'h=findobj(''Tag'',tag_ch);',...
    'set(h,''YLim'',ylim);',...
    'end;',...
    'end']);

uimenu(axs,'Label','$BA4$F$N<4$r%j%;%C%H(B','Callback',...
    ['for ii=1:112;',...
    'tag_ch=strcat(''ch'',num2str(ii));',...
    'h=findobj(''Tag'',tag_ch);',...
    'reset(h);',...
    'set(h,''Tag'',tag_ch);',...
    'end;'],'Separator','on');

%             uimenu(f,'Label','$B7WB,>r7o(B','Callback',['h=findobj(''Name'',''ETG-7000: 8x8 Mode'');',...
%               'cstr=get(h,''UserData''); msgbox(cstr,''measure conditions'');'],'Separator','on');
%-----------------------------------