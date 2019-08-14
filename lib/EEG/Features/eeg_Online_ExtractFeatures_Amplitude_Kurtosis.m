function [tempFeature] = eeg_Online_ExtractFeatures_Amplitude_Kurtosis(Data, fs, passbandInterval)

% % Conversion factor to obtain microVolts
% Data = 0.0488281 * Data;

% Feature obtention
tempFeature = kurtosis(Data);
      
end