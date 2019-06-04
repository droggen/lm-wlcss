%% plotlcss
% 
% Pretty plots the dynamic programmming solution. 
% Requieres to use a 'debug' version of the lcss to show the internal
% variables.
%
% Input:
%   stream:     data stream
%   template:   template
%   dbscore:    score selected at each element of the matrix
%   dbgsul:     score if coming from upper left
%   dbgsu:      score if coming from up
%   dbgsl:      score if coming from left
%   btrack:     backtracking variable.

function plotlcss(stream,template,dbgscore,dbgsul,dbgsu,dbgsl,btrack)

arrowlength = 1/6;
textspace = 0.3;

figure;
axis([-1 size(dbgscore,2)+1 -1 size(dbgscore,1)+1]);
set(gca,'YDir','reverse');
axis off;
axis equal;

for i=1:length(stream)
    h=text(i,0,num2str(stream(i)));
    set(h,'HorizontalAlignment','center');
end
for i=1:length(template)
    h=text(0,i,num2str(template(i)));
    set(h,'HorizontalAlignment','center');
end

% Draw squares around symbols
y=0;
for x=1:size(dbgscore,2)
    h=line([x-0.5 x+0.5],[y-0.5 y-0.5]);
    set(h,'Color','k');
    set(h,'LineStyle','-.');
    h=line([x-0.5 x+0.5],[y+0.5 y+0.5]);
    set(h,'Color','k');
    set(h,'LineStyle','-.');
    h=line([x-0.5 x-0.5],[y-0.5 y+0.5]);
    set(h,'Color','k');
    set(h,'LineStyle','-.');
    h=line([x+0.5 x+0.5],[y-0.5 y+0.5]);
    set(h,'Color','k');
    set(h,'LineStyle','-.');
end
x=0;
for y=1:size(dbgscore,1)
    h=line([x-0.5 x+0.5],[y-0.5 y-0.5]);
    set(h,'Color','k');
    set(h,'LineStyle','-.');
    h=line([x-0.5 x+0.5],[y+0.5 y+0.5]);
    set(h,'Color','k');
    set(h,'LineStyle','-.');
    h=line([x-0.5 x-0.5],[y-0.5 y+0.5]);
    set(h,'Color','k');
    set(h,'LineStyle','-.');
    h=line([x+0.5 x+0.5],[y-0.5 y+0.5]);
    set(h,'Color','k');
    set(h,'LineStyle','-.');
end
% Draw squares around cells for path
for y=1:size(dbgscore,1)
    for x=1:size(dbgscore,2)
        h=line([x-0.5 x+0.5],[y-0.5 y-0.5]);
        set(h,'Color','k');
        h=line([x-0.5 x+0.5],[y+0.5 y+0.5]);
        set(h,'Color','k');
        h=line([x-0.5 x-0.5],[y-0.5 y+0.5]);
        set(h,'Color','k');
        h=line([x+0.5 x+0.5],[y-0.5 y+0.5]);
        set(h,'Color','k');
    end
end


for y=1:size(dbgscore,1)
    for x=1:size(dbgscore,2)
        % Print all texts only if no match
        if stream(x) == template(y)
            h1=text(x,y,num2str(dbgsul(y,x)));
            set(h1,'HorizontalAlignment','center');
            set(h1,'Color','r');
            set(h1,'FontWeight','bold');        % light, normal, demi, bold
            set(h1,'FontSize',11.5)
        else
            h1=text(x,y-textspace,num2str(dbgsul(y,x)));
            set(h1,'HorizontalAlignment','center');
            set(h1,'FontSize',9.5);
            h2=text(x,y,num2str(dbgsu(y,x)));
            set(h2,'HorizontalAlignment','center');
            h3=text(x,y+textspace,num2str(dbgsl(y,x)));
            set(h2,'FontSize',9.5);
            set(h3,'HorizontalAlignment','center');
            set(h3,'FontSize',9.5);
            [m,idx] = max([dbgsul(y,x) dbgsu(y,x) dbgsl(y,x)]);
            h=[h1 h2 h3];
            set(h(idx),'Color','r');
            set(h(idx),'FontWeight','bold');        % light, normal, demi, bold
            set(h(idx),'FontSize',11.5)
        end
    end
end



for y=1:size(dbgscore,1)
   for x=1:size(dbgscore,2)
        if btrack(y,x) == 0
            px = x-1;
            py = y-1;
        elseif btrack(y,x) == 1
            px = x;
            py = y-1;
        else
            px = x-1;
            py = y;
        end
        lx = [x px];
        ly = [y py];

        lx = [mean(lx)+abs(lx(1)-lx(2))*arrowlength mean(lx)-abs(lx(1)-lx(2))*arrowlength];
        ly = [mean(ly)+abs(ly(1)-ly(2))*arrowlength mean(ly)-abs(ly(1)-ly(2))*arrowlength];
        drawarrow(lx,ly,15,.15);
    end
end

