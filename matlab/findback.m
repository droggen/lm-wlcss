%% findback
% 
% backtrack the path
% btrack code: 0=upper left, 1=upper, 2=left
function startpoint=findback(btrack,endpoint)

x = endpoint;
y = size(btrack,1);

while 1
    %if y==1 || x==1
    if y==0 || x==0
        break;
    end
    
    if btrack(y,x) == 0
        x=x-1;
        y=y-1;        
    elseif btrack(y,x) == 1
        y=y-1;
    else
        x=x-1;
    end
    
end

startpoint = x;
end
