function [absdifs,coeffs] = nfb_debrief(cfg,sessionRecord)

for c = 1:length(sessionRecord)
    %tmp = voltageRecord.(fields{c})(find((voltageRecord.(fields{c}) - median(voltageRecord.(fields{c}))) < 4*mad(voltageRecord.(fields{c}),1)));
    tmp = sessionRecord{c};
    if mod(round(length(tmp)*0.1),2)
        tmp = sgolayfilt(tmp,5,round(length(tmp)*0.1));
    else
        tmp = sgolayfilt(tmp,5,round(length(tmp)*0.1)+1);
    end
    coeffs(:,c) = regress(tmp',horzcat(ones(length(tmp),1),(1:length(tmp))'));
    figure
    plot(tmp)
    hold on
    plot(1:length(tmp),coeffs(1,c)+(1:length(tmp))*coeffs(2,c));
    ylabel(cfg.params(c).name)
    absdifs(1,c) = coeffs(1,c);
    absdifs(2,c) = coeffs(1,c) + coeffs(2,c)*length(tmp);
end