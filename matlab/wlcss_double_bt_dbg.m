%% wlcss_double_bt_dbg
% Compute the LM-WLCSS matching score between a data stream and a motif.
%
% Use this version if the score, backtracking and debug info are required.
% 
% Characteristics:
%   * Backtracking
%   * Debug info
%   * Floating point
%
%
% Input: 
% - motif:          1xNT row vector comprising the motif
% - stream:         1xNS row vector comprising the data stream
% - penalty:        penalty in case of mismatch
% - reward:         reward in case of score
% - accepteddist:   tolerance for mismatch between data sample and motif
%                   sample

%
% Output:
% - score:          NTx1 column vector containing the matching score
% - btrackall:      Complete backtracking data
% - dbgscore:       Debug info: matching score matrix with best alignment
% - dbgsul:         Debug info: score matching as-is
% - dbgsu:          Debug info: score matching contracting motif
% - dbgsl:          Debug info: score matching dilating motif
%
% The backtracking is indicated by the following codes: 0=upper left, 1=upper, 2=left
%


function  [score,btrackall,dbgscore,dbgsul,dbgsu,dbgsl] = wlcss_double_bt_dbg(motif,stream,penalty,reward,accepteddist)

%% Error checking
if ~isrow(motif)
    error('Motif must be a row vector');
end
if ~isrow(stream)
    error('Stream must be a row vector');
end

%% Initialization

% limited-memory backtracking window size set to 1 as we reconstruct the
% non limited-memory backtracking data anyways
ws=1;

% Initialize the return variables
score = zeros(1,size(motif,2));
dbgscore = zeros(size(motif,2),size(stream,2));
btrackall = zeros(size(motif,2),size(stream,2));
dbgsul = btrackall;
dbgsu = btrackall;
dbgsl = btrackall;

% Initialization of incremental parameterss
[iscore,btracklm] = iwlcss_double_bt_init(motif,ws);


%% Stream iteration

% Iteration through the data stream
for i=1:size(stream,2)
    [iscore,btracklm,im1,im2,im3] = iwlcss_double_bt_dbg_step(iscore,btracklm,motif,stream(i),penalty,reward,accepteddist);
   
    btrackall(:,i) = btracklm(:,end);
    dbgscore(:,i) = iscore;
    dbgsul(:,i) = im1;
    dbgsu(:,i) = im2;
    dbgsl(:,i) = im3;
    score(i) = iscore(end);
    
end


% 
% % check that score matches
% if ~isempty(find(score~=score(end,:)))
%     error('!');
% end














