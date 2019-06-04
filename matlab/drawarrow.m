% aa: angle
% as: length
function drawarrow(x,y,aa,as)

l=line(x,y);
set(l,'Color','k');

aex = x(2);
aey = y(2);

angle = atan((y(2)-y(1))/(x(2)-x(1)));

angle2 = pi+angle;

if x(2)<x(1)
    da = aa;
    dx = cos(angle2+2*pi/360*da)*as;
    dy = sin(angle2+2*pi/360*da)*as;

    l=line([aex-dx aex],[aey-dy aey]);
    set(l,'Color','k');

    da = -aa;
    dx = cos(angle2+2*pi/360*da)*as;
    dy = sin(angle2+2*pi/360*da)*as;
    l=line([aex-dx aex],[aey-dy aey]);
    set(l,'Color','k');
else
    da = aa;
    dx = cos(angle2+2*pi/360*da)*as;
    dy = sin(angle2+2*pi/360*da)*as;

    l=line([aex+dx aex],[aey+dy aey]);
    set(l,'Color','k');

    da = -aa;
    dx = cos(angle2+2*pi/360*da)*as;
    dy = sin(angle2+2*pi/360*da)*as;
    l=line([aex+dx aex],[aey+dy aey]);
    set(l,'Color','k');
end

