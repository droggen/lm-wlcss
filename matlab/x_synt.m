%% Test LM-WLCSS with synthetic data

data = [13 11 12 9 10 12 11 11 10 10 12 9 9 11 12 10];
templateidx = [2:5];
template = data(templateidx);


penalty=1;
reward=8;
accepteddist=0;
threshold=20;
wfind=5;
ws=5;

%% Shows the dynamic programming solution
% This can only be used with the dbg version as it requires internal variables

% Double debug
[score,btrackall,dbgscore,dbgsul,dbgsu,dbgsl] = wlcss_double_bt_dbg(template,data,penalty,reward,accepteddist);
peaks = findpeak(score,wfind,threshold);
prettyplotmatch(data,templateidx,score,peaks,btrackall,threshold);
plotlcss(data,template,dbgscore,dbgsul,dbgsu,dbgsl,btrackall);
print('-dpng','-r300','x1.png');


% Integer debug
[score,btrackall,dbgscore,dbgsul,dbgsu,dbgsl] = wlcss_int_bt_dbg(int16(template),int16(data),int16(penalty),int16(reward),int16(accepteddist),'int16');
peaks = findpeak(score,wfind,threshold);
prettyplotmatch(data,templateidx,score,peaks,btrackall,threshold);
plotlcss(data,template,dbgscore,dbgsul,dbgsu,dbgsl,btrackall);

% Uncomment to plot an animation, saved as png files.
%plotlcss_anim(data,template,dbgscore,dbgsul,dbgsu,dbgsl,btrackall);