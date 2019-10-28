function R = POTATo_sub_FiveNumberSummaries(x, varargin)
%----
% ver 1.0
% This function returns 
% five number summaries calculated from input vector "x"
% for boxplot.
% 
% example 1)
% R = P3_subFiveNumberSummaries(x)
% R: structure
%
% example 2)
% R = P3_subFiveNumberSummaries(x, gca)
% Calculate R and draw box-plot and return handles in R.
%
% Create date: 2011/05/16 TK@HARL
% Modified: 2011/06/02 TK
% Modified: 2011/06/15 TK: routine for nan data
% Modified: 2015/03/27 TK: Nan data support fixed
%
% $Id: POTATo_sub_FiveNumberSummaries.m 457 2015-03-27 07:27:44Z katura7pro $
%----

% ======================================================================
% Copyright(c) 2019, 
% National Institute of Advanced Industrial Science and Technology
%
% Released under the MIT license 
% https://opensource.org/licenses/MIT 
% ======================================================================


if nargin==0
	help POTATo_sub_FiveNumberSummaries
	return;
end


%- for nan data
if sum(~isnan(x))<2
	R=nan;
	return;
end
x0=x;
x(isnan(x))=[];


x=sort(x);
x=x(:); %- vectorization
LG = length(x);

%- for logical data
u=unique(x);
if length(u)==2
	R.Median=sum(u)/2;
	R.Quartile_Lower=R.Median-sum(u)/4;
	R.Quartile_Upper=R.Median+sum(u)/4;
	R.Max=max(u);R.Min=min(u);
	R.outlier1=[];R.outlier2=[];
	return;
end
%
if mod(LG,2) == 0 %- Even number
	
	idx.Median = [LG/2, LG/2+1];
	
	LG2 = LG/2;
	if mod(LG2,2) == 0 %- Even number
		idx.Quartile_Lower = [LG2/2, LG2/2+1];
		idx.Quartile_Upper = [LG2 + LG2/2, LG2 + LG2/2+1];
	else %- Odd number
		idx.Quartile_Lower = (LG2-1)/2 + 1;
		idx.Quartile_Upper = LG2 + (LG2-1)/2 + 1;
	end
	
	
else %- Odd number
	
	idx.Median = (LG-1)/2 + 1;
	
	LG2 = (LG-1)/2;	
	if mod(LG2,2) == 0 %- Even number
		idx.Quartile_Lower = [LG2/2, LG2/2+1];
		idx.Quartile_Upper = [LG2+2 + LG2/2, LG2+2 + LG2/2+1]-1;
	else %- Odd number
		idx.Quartile_Lower = (LG2-1)/2 + 1;
		idx.Quartile_Upper = LG2+2 + (LG2-1)/2 + 1;
	end
	
end
R.TotalNumber=length(x0);
R.Median = nanmean(x(idx.Median));
R.Quartile_Lower = nanmean(x(idx.Quartile_Lower));
R.Quartile_Upper = nanmean(x(idx.Quartile_Upper));

W1 = (R.Quartile_Upper - R.Quartile_Lower)*1.5;%- IQR:Interquartile range *1.5
W2 = W1*2;%- IQR*3
W1Up = R.Quartile_Upper + W1;
W1Lo = R.Quartile_Lower - W1;
W2Up = R.Quartile_Upper + W2;
W2Lo = R.Quartile_Lower - W2;

x_in = x( (x<=W1Up) & (x>=W1Lo) );
R.Max = nanmax(x_in);
R.Min = nanmin(x_in);

R.outlier1 = [x( (x>W1Up)&(x<=W2Up) ); x( (x<W1Lo)&(x>=W2Lo) )];
R.outlier2 = [x(x>W2Up); x(x<W2Lo)];

R.innerMember1=x( x<=R.Quartile_Upper & x>=R.Quartile_Lower);
R.innerMember2=x( x<=R.Max & x>=R.Min);

R.NanData=sum(isnan(x0));


%== check draw
if ~isempty(varargin)
	if ishandle(varargin{1}) %- DRAW mode
		if nargin<3
			xpos=0;
		else
			xpos=varargin{2};
		end
		hold on;
		dx = [0.1 -0.1];
		dxc=[0 0]+xpos;
		ht(1) = patch([dx -dx]+xpos,[R.Quartile_Lower R.Quartile_Lower R.Quartile_Upper R.Quartile_Upper],'k');
		set(ht(1),'Facecolor','none','EdgeColor','k');
		ht(2) = line(dx+xpos,[R.Median R.Median]);set(ht(2),'Color','k','Linewidth',2);
		ht(3) = line(dxc, [R.Quartile_Lower R.Min]);set(ht(3),'Color','k','LineStyle',':');
		ht(4) = line(dx*.8+xpos,[R.Min R.Min]);set(ht(4),'Color','k');
		ht(5) = line(dxc, [R.Quartile_Upper R.Max]);set(ht(5),'Color','k','LineStyle',':');
		ht(6) = line(dx*.8+xpos,[R.Max R.Max]);set(ht(6),'Color','k');
		if ~isempty(R.outlier1)
			tmp = plot(xpos,R.outlier1,'ok');ht=[ht tmp'];
		end
		if ~isempty(R.outlier2)
			tmp = plot(xpos,R.outlier2,'sk');ht=[ht tmp'];
		end
		
		R.handles = ht;
		%xlim([-0.5 0.5]);
	elseif ischar(varargin{1}) %- Mode select
		tg1=ismember(x0,R.outlier1);
		tg2=ismember(x0,R.outlier2);
		switch lower(varargin{1})
			case 'ret_ol1'
				R=x0(~tg1);
			case 'ret_ol2'
				R=x0(~tg2);
			case 'ret_olall'
				R=x0(~tg1 & ~tg2);
			case 'quartile'
				R=x0(x0>R.Quartile_Lower & x0<R.Quartile_Upper);
		end
	end
end




