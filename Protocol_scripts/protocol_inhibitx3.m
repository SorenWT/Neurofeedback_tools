function cfg = protocol_inhibitx3

cfg.protocolname = 'Inhibit Theta, Alpha, Beta';
cfg.debug = false;
cfg.observe = false;
cfg.tlimit = 600; % time limit in seconds of the session
%cfg.scaleConst = 'auto';
%cfg.scaleConst = 0.07; %change this depending on what the rms values settle at
cfg.srate = 250;
cfg.chan = 6; %use orange wire
cfg.chanloc = 'Fz';
cfg.updatetime = 0.05; % update every 50 ms
cfg.seglength = cfg.srate*2;
cfg.plotfunc = 'Plot_bars';

cfg.getthresh.tlimit = 120;
cfg.getthresh.prctile = [70 70 70];
cfg.getthresh.save = 'yes';

cfg.params(1).name = 'theta_power';
cfg.params(2).name = 'alpha_power';
cfg.params(3).name = 'high_beta_power';

%cfg.params(1).threshold = 10.48;
%cfg.params(2).threshold = 4.94;
%cfg.params(3).threshold = 4.58;

cfg.params(1).inhibit = true;
cfg.params(2).inhibit = true;
cfg.params(3).inhibit = true;

cfg.params(1).filter = [4 7];
cfg.params(2).filter = [8 13];
cfg.params(3).filter = [18 36];

cfg.params(1).colour = [1 0 0.5];
cfg.params(2).colour = [0 0.25 1];
cfg.params(3).colour = [1 1 0];

cfg.params(1).func = @rms;
cfg.params(2).func = @rms;
cfg.params(3).func = @rms;

initData = rand(1,cfg.seglength);

for c = 1:length(cfg.params)
    [~,cfg.params(c).filtcoeffs.b,cfg.params(c).filtcoeffs.a] = iirfilt(initData,cfg.srate,cfg.params(c).filter(1),cfg.params(c).filter(2));
end
end