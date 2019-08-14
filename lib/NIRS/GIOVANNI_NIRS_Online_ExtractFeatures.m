function [structOutput] = GIOVANNI_NIRS_Online_ExtractFeatures(preprocessedData, fs, signal, featureList)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here


temp.hbo = preprocessedData.baselineHbo;
temp.hbr = preprocessedData.baselineHbr;
temp.hbt = preprocessedData.baselineHbt;
temp.channelLabels = preprocessedData.channelLabels;

[featuresBaseline, featuresLabelsBaseline] = CLISLAB_NIRS_Online_ExtractFeatures(temp, fs, signal, featureList);


temp.hbo = preprocessedData.thinkingHbo;
temp.hbr = preprocessedData.thinkingHbr;
temp.hbt = preprocessedData.thinkingHbt;
temp.channelLabels = preprocessedData.channelLabels;
[featuresThinking, featuresLabelsThinking] = CLISLAB_NIRS_Online_ExtractFeatures(temp, fs, signal, featureList);


structOutput.baseline = featuresBaseline;
structOutput.thinking = featuresThinking;


assert (isequal(featuresLabelsThinking,featuresLabelsBaseline))
structOutput.featureLabels = featuresLabelsThinking;

structOutput.questionLabels = preprocessedData.questionLabels;

structOutput.channelLabels = preprocessedData.channelLabels;

end

