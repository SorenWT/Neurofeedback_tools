function Plot_bars(cfg,window,scinfo)

for c = 1:length(cfg.params)
    Screen('FillRect',window,cfg.params(c).colour,[scinfo.barpos(c)-20,...
        scinfo.barbottom-scinfo.scaleConst(c)*measure(c),scinfo.barpos(c)+20,scinfo.barbottom]);
    if ~cfg.observe
        if (cfg.params(c).inhibit*cfg.params(c).threshold - measure(c)) > 0
            Screen('FillRect',window,[0 1 0],[scinfo.barpos(c)-30,...
                scinfo.barbottom-scinfo.scaleConst(c)*cfg.params(c).threshold-5,scinfo.barpos(c)+30,scinfo.barbottom-scinfo.scaleConst(c)*cfg.params(c).threshold+5]);
        else
            Screen('FillRect',window,[1 0 0],[scinfo.barpos(c)-30,...
                scinfo.barbottom-scinfo.scaleConst(c)*cfg.params(c).threshold-5,scinfo.barpos(c)+30,scinfo.barbottom-scinfo.scaleConst(c)*cfg.params(c).threshold+5]);
        end
    end
end

Screen('FillRect',window,[1 1 1],[scinfo.barpos(c)-5,scinfo.barbottom+5,scinfo.barpos(c)+5,scinfo.barbottom+15]);

if ~cfg.observe
    DrawFormattedText(window,['Score: ' num2str(score)],...
        'center',200,[1 1 1]);
end

Screen('Flip',window)
end