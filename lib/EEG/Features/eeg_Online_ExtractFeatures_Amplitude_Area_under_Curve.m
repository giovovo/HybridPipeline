function [tempFeature] = eeg_Online_ExtractFeatures_Amplitude_Area_under_Curve(Data, fs, passbandInterval)

% % Conversion factor to obtain microVolts
% Data = 0.0488281 * Data;

% Feature obtention
tempFeature = trapz(Data);
      
end