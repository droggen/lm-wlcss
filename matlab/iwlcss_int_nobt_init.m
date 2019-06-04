%% iwlcss_int_nobt_init
% Incremental LM-WLCSS: initialization of state variables
% 
% Use this version if only the score is required.
% 
% Characteristics:
%   * No backtracking
%   * No debug info
%   * Integer
%
% Input: 
% - motif:          1xNT row vector comprising the motif
%
% Output:
% - iscore:         NTx1 column vector containing the initial matching
%                   scores
%


function score = iwlcss_int_nobt_init(motif,dtype)

score = zeros(length(motif),1,dtype);


