function [data_bl_corrected] = CLISLAB_NIRS_Baseline_Correction(thinking_data, baseline_data)
% CLISLAB_NIRS_Baseline_Correction Perform baselien correction trial by
% trial, channel by channel
%   
% THINKING_DATA = channelXtimepointsXtrials
% BASELINE_DATA = channelXtimepointsXtrials


data_bl_corrected = thinking_data- mean(baseline_data,2); % Giovanni Hbo/Hbr ?

end