function [tempFeature] = eeg_Online_ExtractFeatures_Amplitude_Maximum_Location(Data, fs, passbandInterval)

% % Conversion factor to obtain microVolts
% Data = 0.0488281 * Data;

%Obtaining the feature
[maxValue,maxLoc] = max(Data, [],2);

% Converting the datapoint in time location
tempFeature = maxLoc/fs;
      
end