function [tempFeature] = eeg_Online_ExtractFeatures_Amplitude_Maximum_Value(Data, fs, passbandInterval)
 
% % Conversion factor to obtain microVolts
% Data = 0.0488281 * Data;

%Obtaining the feature
% The first argument is the value of amplitude, the second is the location given in datapoints
[maxValue,maxLoc] = max(Data, [],2);
tempFeature = maxValue;
      
end