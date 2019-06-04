%% iwlcss_double_bt_dbg_step
% Incremental LM-WLCSS: update of state variables (score) after a new sample
% 
% Use this version if the score, backtracking and debug info are required.
% 
% Characteristics:
%   * Backtracking
%   * Debug info
%   * Floating point
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
% - btrack:         btrack: limited-memory backtracking window
% - dbgsul:         Debug info: score matching as-is
% - dbgsu:          Debug info: score matching contracting motif
% - dbgsl:          Debug info: score matching dilating motif
%
% The backtracking is indicated by the following codes: 0=upper left, 1=upper, 2=left
%

function [iscore,btrack,dbgsul,dbgsu,dbgsl] = iwlcss_double_step(iscore,btrack,motif,newsample,penalty,reward,accepteddist)

% add the sample and shift everything
newmatch=zeros(size(iscore));
btrack=[btrack(:,2:end) zeros(size(iscore,1),1)];
dbgsul=zeros(size(iscore,1),1);
dbgsu=zeros(size(iscore,1),1);
dbgsl=zeros(size(iscore,1),1);


% j: motif iteration
for j=1:length(motif)
    % i: stream iteration
    %i = 2;      % Index in the table: last column
    ml = iscore(j);
    if j==1
        mu = 0;
        mul = 0;
    else
        mu = newmatch(j-1);
        mul = iscore(j-1);
    end
    
    
    if abs(newsample-motif(j))<=accepteddist
        newmatch(j) = mul+reward;
        btrack(j,end) = 0;
        dbgsul(j) = newmatch(j);   % upper left
        dbgsu(j) = 0;   % upper
        dbgsl(j) = 0;   % left
    else
        p = penalty*abs(newsample-motif(j));
               
        % From top left: align motif as-is
        p1 = mul-p;
        % From up: contract motif
        p2 = mu-p;
        % From left: dilate motif
        p3 = ml-p;
        [m,pos] = max([p1 p2 p3]);
        dbgsul(j) = p1;
        dbgsu(j) = p2;
        dbgsl(j) = p3;
        newmatch(j) = m;
        if pos==1
            % From top-left
            btrack(j,end) = 0;
        elseif pos==2
            % From up
            btrack(j,end) = 1;
        else
            % From left
            btrack(j,end) = 2;
        end
    end
end
iscore=newmatch;

