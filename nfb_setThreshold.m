function [cfg] = nfb_setThreshold(cfg,sessionRecord)

for c = 1:length(cfg.params)
    sessionRecord{c} = sessionRecord{c}(find(~isnan(sessionRecord{c})));
   tmp = sessionRecord{c}(find((sessionRecord{c} - median(sessionRecord{c})) < 4*mad(sessionRecord{c},1)));
   if cfg.params(c).inhibit
    cfg.params(c).threshold = prctile(tmp,cfg.getthresh.prctile(c));
   else
     cfg.params(c).threshold = prctile(tmp,100-cfg.getthresh.prctile(c));
   end
end