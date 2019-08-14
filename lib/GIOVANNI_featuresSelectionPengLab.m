function [structOutput] = GIOVANNI_featuresSelectionPengLab(features, finalNumberOfFeatures)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

featureMean = mean(features.features,1);
featureStd = std(features.features,1);
features.features = features.features - featureMean;
features.features = features.features./ featureStd;
featureIndex = mrmr_miq_d(features.features, features.classLabels', finalNumberOfFeatures); % Feature selection from penglab
structOutput.features = features.features(:,featureIndex);
structOutput.classLabels = features.classLabels;
structOutput.featuresLabels = string(features.featuresLabels(featureIndex,:));

end

