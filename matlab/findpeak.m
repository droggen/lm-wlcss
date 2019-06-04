%% findpeak
%
% Find local optima of score that are above a threshold within a sliding
% window wfind.
% This implementation wraps the the incremental find peak functions.
%
% Input:
%   score:      1xN row vector comprising the time series in which to find local optima
%   wfind:      Size of the sliding window within which a local optima is
%               detected
%   threshold:  Threshold above which a local optima is searched
%
% Output:
%   peaks:      Mx2 matrix indicating the peaks that have been found. 
%               The first column indicates the index of the time series
%               where the local optima has been found. 
%               The second column indicates the amplitude of the time
%               series at the local optima.

function peaks=findpeak(score,wfind,threshold)

peak_status=ifindpeak_init(threshold,wfind);
peaks=[];


for i=1:size(score,2)
    [peak_status,ret]=ifindpeak_step(score(i),peak_status);
    if ret(2) == 1
        peaks=[peaks;ret(1) i-wfind];
        % fprintf(1,'Local optima at sample %d. val: %d\n',i,ret(1));
    end
end

