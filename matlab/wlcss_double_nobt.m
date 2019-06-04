%% wlcss_double_nobt
% Compute the LM-WLCSS matching score between a data stream and a motif.
%
% Use this version if only the score is required.
% 
% Characteristics:
%   * No backtracking
%   * No debug info
%   * Floating point
%
%
% Input: 
% - motif:          1xNT row vector comprising the motif
% - stream:         1xNS row vector comprising the data stream
% - penalty:        penalty in case of mismatch
% - reward:         reward in case of match
% - accepteddist:   tolerance for mismatch between data sample and motif
%                   sample
%
% Output:
% - score:         NTx1 column vector containing the matching score
%


function  score = wlcss_double_nobt(motif,stream,penalty,reward,accepteddist)

% Initialize the returned matching score
score = zeros(1,size(motif,2));

% Initialization of incremental version
iscore = iwlcss_double_nobt_init(motif);

% Iteration through the data stream
for i=1:size(stream,2)
    iscore = iwlcss_double_nobt_step(iscore,motif,stream(i),penalty,reward,accepteddist);
    score(i) = iscore(end);
end



