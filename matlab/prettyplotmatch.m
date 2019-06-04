function prettyplotmatch(data,templateidx,score,peaks,backtracking,threshold)

linewidth=2;

figure;
clf;
ax(1) = subplot(2,1,1);
plot(data(1:end));
hold on;
h=plot(templateidx,data(templateidx),'r-');
set(h,'LineWidth',linewidth);

h=xlabel('Samples');
set(h,'FontSize',12);
h=ylabel('Signal');
set(h,'FontSize',12);

axisrange=axis;

ax(2) = subplot(2,1,2);
plot(score);
hold on;
h=line([1 length(data)],[threshold threshold]);
set(h,'Color','k');

% peaks x is off by one 
peaks(:,2) = peaks(:,2)+1;
% 
% % eliminate all negative entries
% peaks = peaks(find(peaks(:,2)>=1),:);
% 

for i=1:size(peaks,1)
    
    plot(peaks(i,2),peaks(i,1),'ro');
    
    if ~isempty(backtracking) 
    	start = findback(backtracking,peaks(i,2));
        if start==0
            start=1;
        end
    	%plot(start,data(start),'kx');
    	h=line([start peaks(i,2)],[peaks(i,1) peaks(i,1)]);
    	set(h,'Color','r');
    end
end

h=xlabel('Samples');
set(h,'FontSize',12);
h=ylabel('Matching score');
set(h,'FontSize',12);
% 
% 
% 
% 
% 
%     ax(3) = subplot(3,1,3);    
%     for i=1:size(peaks,1)
%         h = plot(peaks(i,2)+wfind,peaks(i,1),'bo');
%         h = plot(peaks(i,2)+wfind,1,'bo');
%         set(h,'LineWidth',2);
%         line([peaks(i,2) peaks(i,2)]+wfind,[0 1]);
%         hold on;
%     end
%     set(gca,'YTick',[0 1]);
%     set(gca,'YTickLabel',{'No' 'Yes'});
%     h=xlabel('Samples');
%     set(h,'FontSize',12);
%     h=ylabel('Motif found');
%     set(h,'FontSize',12);
%     a=axis;
%     a(1) = axisrange(1);
%     a(2) = axisrange(2);
%     axis(a);
% 

linkaxes(ax,'x');
