function scinfo = Plot_bars_setup(cfg,window)

[screenXpixels, screenYpixels] = Screen('WindowSize', window);

scinfo.barbottom = 0.9*screenYpixels;

for c = 1:length(cfg.params)
    scinfo.barpos(c) = screenXpixels*c/(length(cfg.params)+1);
    scinfo.scaleConst(c) = screenYpixels*0.55/cfg.params(c).threshold;
end

Screen('TextSize', window, 48);
