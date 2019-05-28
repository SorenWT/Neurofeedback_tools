function [H] = nfb_dfa(channel,transformed,winsizes)

if ~transformed
    channel = abs(hilbert(channel));
end

if ~strcmpi(winsizes,'auto')
    H = dfa(channel,winsizes);
else
    H = dfa(channel);
end
