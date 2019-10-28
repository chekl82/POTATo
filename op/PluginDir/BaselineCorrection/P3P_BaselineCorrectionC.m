function data=P3P_BaselineCorrectionC(data,hdata, Deg, IgP)
% data=P3P_BaselineCorrectionC(data,hdata, Deg, IgP)


% ======================================================================
% Copyright(c) 2019, 
% National Institute of Advanced Industrial Science and Technology
%
% Released under the MIT license 
% https://opensource.org/licenses/MIT 
% ======================================================================

IgP=subParseIgP(IgP,data,hdata);

if isempty(IgP)
	IgP=[];
else
  try
    % bugfix
    IgP=eval(['[' IgP ']']);
  catch
    IgP=eval(IgP);
  end
end

Deg=eval(Deg);

x=1:size(data,1);
for k1=1:size(data,3)
	for k2=1:size(data,2)
		x1=x;
		x1(IgP)=0;
		x1(hdata.flag(1,:,k2)~=0)=0;
		
		x1(isnan(data(:,k2,k1)))=0;
		
		if all(x1==0), continue;end
		if all(data(x1>0,k2,k1)==0), continue;end
		if all(isnan(data(x1>0,k2,k1))), continue;end
		
		p=polyfit(x1(x1>0),data(x1>0,k2,k1)',Deg);
		pv=polyval(p,x);
		data(:,k2,k1)=data(:,k2,k1)-pv';
	end
end

function s=subParseIgP(s,data,hdata)

if ~isempty(findstr(s,'ed'))
	s=strrep(s,'ed',num2str(size(data,1)));
end
