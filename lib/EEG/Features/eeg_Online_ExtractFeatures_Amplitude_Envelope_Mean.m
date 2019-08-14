function [tempFeature] = eeg_Online_ExtractFeatures_Amplitude_Envelope_Mean(Data, fs, passbandInterval)

% % Conversion factor to obtain microVolts
% Data = 0.0488281 * Data;

% Obtaining the envelope
Data(isnan(Data)) = [];
env = abs( hilbert(Data) ).^2;

% Feature obtention
tempFeature = nanmean(env);

end