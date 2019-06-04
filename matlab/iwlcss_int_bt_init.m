%% iwlcss_int_bt_dbg_init
% Incremental LM-WLCSS: initialization of state variables
% 
% Use this version if the score, backtracking and debug info are required.
% 
% Characteristics:
%   * Backtracking
%   * Debug info
%   * Integer
%
% Input: 
% - motif:          1xNT row vector comprising the motif
% - ws:             Size of the limited-memory backtracking window
%
% Output:
% - iscore:         NTx1 column vector containing the initial matching
%                   scores
% - btrack:         btrack: limited-memory backtracking window
%



function [iscore,btrack] = iwlcss_int_bt_dbg_init(motif,ws,dtype)


iscore = zeros(length(motif),1,dtype);
btrack = zeros(length(motif),ws,'int8');

