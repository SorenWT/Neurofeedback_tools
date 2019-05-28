function [voltage] = pk2pk(datain)
% pk2pk is a convenience function for the peak-to-peak voltage

voltage = max(datain) - min(datain);