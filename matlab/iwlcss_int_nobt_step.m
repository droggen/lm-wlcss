%% iwlcss_int_nobt_step
% Incremental LM-WLCSS: update of state variables (score) after a new sample
%
% Use this version if only the score is required.
% 
% Characteristics:
%   * No backtracking
%   * No debug info
%   * Integer
%
%
% Input: 
% - iscore:         NTx1 column vector comprising the current matching score
%                   The last entry of iscore is the matching score for the
%                   entire template. 
% - motif:          1xNT row vector comprising the motif
% - newsample:      new sample of the data sream against which the score must
%                   be updated
% - penalty:        penalty in case of mismatch
% - reward:         reward in case of match
% - accepteddist:   tolerance for mismatch between data sample and motif
%                   sample
%
% Output:
% - iscore:         NTx1 column vector containing the updated matching score
%



function iscore = iwlcss_int_nobt_step(iscore,motif,newsample,penalty,reward,accepteddist)
% Initialization
mu = 0;
mul = 0;
% j: motif iteration
for j=1:length(motif)
    ml = iscore(j);
    
    if abs(newsample-motif(j))<=accepteddist
        % Exact match
        nm = mul+reward;
    else
        % No match
        p = penalty*abs(newsample-motif(j));               
        % From top left: align motif as-is
        p1 = mul-p;
        % From up: contract motif
        p2 = mu-p;
        % From left: dilate motif
        p3 = ml-p;
        nm = max([p1 p2 p3]);
    end
    % Modify in-place
    mul = ml;
    mu = nm;    
    iscore(j) = nm;
end


