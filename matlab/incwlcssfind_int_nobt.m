%% incwlcssfind_int_nobt
% Demonstration of how to use incremental WLCSS and incremental findpeak to apply to streaming data.
%
% This demonstration does not include backtracking and is integer only. 
% 
%
% Input: 
% - motif:          1xNT row vector comprising the motif
% - stream:         1xNS row vector comprising the data stream
% - penalty:        penalty in case of mismatch
% - reward:         reward in case of match
% - accepteddist:   tolerance for mismatch between data sample and motif
%                   sample
% - wfind:          size of the findpeak window
% - threshold:      peak detection threshold
%
% Output:
% - score:          NTx1 column vector containing the updated matching score
% - peaks:          ?x2 matrix with detected peaks. The first column is the
%                   peak value at the position indicated in the second
%                   column. The peak position takes into account the window
%                   size.


function  [score,peaks] = incwlcssfind_int_nobt(motif,stream,penalty,reward,accepteddist,wfind,threshold,dtype)

%% Initialization of WLCSS and findpeak
% Initialize incremental findpeak
peak_status=ifindpeak_init(threshold,wfind);
peaks=[];

% Initialize the returned matching score
score = zeros(1,size(motif,2),dtype);

% Initialization of incremental version
iscore = iwlcss_int_nobt_init(motif,dtype);

%% Iteration through the data stream
%
for i=1:size(stream,2)
    % Update the matching score
    iscore = iwlcss_int_nobt_step(iscore,motif,stream(i),penalty,reward,accepteddist);
    score(i) = iscore(end);
    
    % Check if local peak
    [peak_status,ret]=ifindpeak_step(score(i),peak_status);
    if ret(2) == 1
        peaks=[peaks;ret(1) i-wfind];
        fprintf(1,'Local optima at sample %d. val: %d\n',i,ret(1));
    end
    
end




