%% ifindpeak_init
%
% Initialize the incremental search for a local optima in a time series.
%
% Input:
%   threshold:      threshold above which to search for peaks
%   winsize:        size of the peak search window (number of samples)
%
% Output:
%   st:             variable representing the state of the findpeak
%                   function

function st=ifindpeak_init(threshold,winsize)
st=struct;
st.window=uint16(winsize);      % Window size
st.k=uint16(1);                 % Counter for the window
st.thrd=int16(threshold);       % Threshold value
st.active=uint8(0);             % The window is active or not
st.lastscore = realmin;
st.curmax = realmin;            % Current maximum (lowest value)
end
