%% ifindpeak_step
% 
% Updates the incremental search for a local optima in a time series. This
% function is to be called after each new sample is acquired.
%
% Note that a local optima is detected after a latency equal to the search
% window size.
%
% Input:
% - curscore:   current sample of the stream in which to find local optima
% - st:         status variables
%
% Output:
% - st:         updated status variables
% - ret:        1x2 row vector. ret(2) is 1 to indicate a local optima, 0 otherwise. 
%               ret(1) is the value of the local optima. 
%               

function [st,ret]=ifindpeak_step(curscore,st)

% If we have a potential local optima....
if st.active==1
   st.k=st.k+1;                     % Count how far from peak
end

if curscore>st.lastscore            % Positive slope
    if curscore>st.curmax;          % Higher than current max in window
        st.curmax=curscore;         % Save max
        st.active=1;                % Flag we've a peak
        st.k=0;                     % count...
    end
end


if st.active==1 && st.k>=(st.window-1) && st.curmax>=st.thrd
    % Found a peak
    ret = [st.curmax 1];    
    st.active=0;
    st.curmax=realmin;
else
    % Did not find a peak
    ret = [realmin 0];
end


st.lastscore=curscore;

end
