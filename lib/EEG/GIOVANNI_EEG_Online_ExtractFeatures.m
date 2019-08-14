function [structOutput] = GIOVANNI_EEG_Online_ExtractFeatures(preprocessedData, fs, featureListEeg)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%% ReshapingInput
temp = [];
if (isfield(preprocessedData,'eegBaseline'))
    temp.eeg = preprocessedData.eegBaseline;
end
if (isfield(preprocessedData,'eogBaseline'))
    temp.eog = preprocessedData.eogBaseline;
end
if (isfield(preprocessedData,'emgBaseline'))
    temp.emg = preprocessedData.emgBaseline;
end
[baselineValues, baselineFeaturesLabels] = CLISLAB_EEG_Online_ExtractFeatures(temp, fs, featureListEeg');

temp = [];
if (isfield(preprocessedData,'eegThinkingPeriod'))
    temp.eeg = preprocessedData.eegThinkingPeriod;
end
if (isfield(preprocessedData,'eogThinkingPeriod'))
    temp.eog = preprocessedData.eogThinkingPeriod;
end
if (isfield(preprocessedData,'emgThinkingPeriod'))
    temp.emg = preprocessedData.emgThinkingPeriod;
end

[thinkingValues, thinkingFeaturesLabels] = CLISLAB_EEG_Online_ExtractFeatures(temp, fs, featureListEeg');

assert(isequal(baselineFeaturesLabels , thinkingFeaturesLabels))
structOutput.baseline = baselineValues;
structOutput.thinking = thinkingValues;
assert(isequal(baselineFeaturesLabels , thinkingFeaturesLabels))
structOutput.featureLabels = baselineFeaturesLabels;

structOutput.questionLabels = preprocessedData.questionLabels;

end

