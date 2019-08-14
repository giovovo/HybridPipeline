function [tempFeature] = eeg_Online_ExtractFeatures_Amplitude_Standard_Deviation(Data, fs, passbandInterval)
 
% % Conversion factor to obtain microVolts
% Data = 0.0488281 * Data;

%Obtaining the feature
tempFeature = nanstd(Data);
      
end