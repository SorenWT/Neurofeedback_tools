function cfg = protocol_theta_dfa

cfg.protocolname = 'Enhance Theta DFA';
cfg.debug = false;
cfg.observe = false;
cfg.tlimit = 600; % time limit in seconds of the session
%cfg.scaleConst = 'auto';
%cfg.scaleConst = 0.07; %change this depending on what the rms values settle at
cfg.srate = 250;
cfg.chan = 6; %use orange wire
cfg.chanloc = 'Fz';
cfg.updatetime = 0.10; 
cfg.seglength = cfg.srate*20;

cfg.getthresh.tlimit = 180;
cfg.getthresh.prctile = [70 70 70];
cfg.getthresh.save = 'yes';

cfg.params(1).name = 'theta_dfa';
%cfg.params(2).name = 'alpha_power';
%cfg.params(3).name = 'high_beta_power';

%cfg.params(1).threshold = 10.48;
%cfg.params(2).threshold = 4.94;
%cfg.params(3).threshold = 4.58;

cfg.params(1).inhibit = false;
%cfg.params(2).inhibit = true;
%cfg.params(3).inhibit = true;

cfg.params(1).filter = [4 8];
%cfg.params(2).filter = [8 13];
%cfg.params(3).filter = [18 36];

cfg.params(1).colour = [1 0 0.5];
%cfg.params(2).colour = [0 0.25 1];
%cfg.params(3).colour = [1 1 0];

cfg.params(1).func = @(channel)nfb_dfa(channel,0,[1.1 1.3 1.7 2.2 2.7 3.5 4.4 5.5 7.0 8.9]*cfg.srate);
%cfg.params(2).func = @rms;
%cfg.params(3).func = @rms;

initData = rand(1,cfg.seglength);

for c = 1:length(cfg.params)
    [~,cfg.params(c).filtcoeffs.b,cfg.params(c).filtcoeffs.a] = iirfilt(initData,cfg.srate,cfg.param(c).filter(1),cfg.param(c).filter(2));
end
end