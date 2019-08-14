function [tempFeature] = eeg_Online_ExtractFeatures_Amplitude_Absolute_Mean(Data, fs, passbandInterval)

% % Conversion factor to obtain microVolts
% Data = 0.0488281 * Data;

% Feature obtention
tempFeature = mean(abs(Data));
      
end