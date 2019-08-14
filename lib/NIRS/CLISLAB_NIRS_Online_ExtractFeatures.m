function [nirsFeatures, nirsFeaturesLabels]=CLISLAB_NIRS_Online_ExtractFeatures(data, fs, selectSource, featureList)
%function [structOutput]=CLISLAB_NIRS_Online_ExtractFeatures(data, fs, selectSource, featureList)
%
% thinkingData = struct containing the signals from which extract the
% features.
%
% channelsLabels = labels of all the channels of the signals in thinkingData
%
% fs = sampling rate
%
% featIndex = index of the features to extract. if missing or empty,
% all the possible features are extracted
%
% selectSource = select the source with a 1x3 vector [HbO HbR HbT], 1 for selecting the
% source, 0 for discarding the source, default [1 1 1]

%% Giovanni input reshaping start

%% Giovanni input reshaping finish

HbO = selectSource(1);
HbR = selectSource(2);
HbT = selectSource(3);

% Modified by Giovanni


    OD = [];
    if HbO
        OD = cat(1,OD,data.hbo);
    end
    if HbR
        OD = cat(1,OD,data.hbr);
    end
    if HbT
        OD = cat(1,OD,data.hbt);
    end
    
    data.od = OD;
    data.fs = fs;
    
    nirsFeatures = [];
    nirsFeaturesLabels = [];
    nirsIdxChLabels = [];
    nirsFeatFunc = [];
    
    for i = 1:length(featureList)
        featureFunction = str2func(featureList{i});
        feature = featureFunction(data);
        %[newFeatures, newFeaturesLabels] = feval(string(featureList(i)), thinkingData, sRate);
        
        nirsFeatures = [nirsFeatures feature.features];
        nirsFeaturesLabels = [nirsFeaturesLabels; feature.featuresLabels];
        nirsIdxChLabels =   [nirsIdxChLabels; (1:length(feature.featuresLabels))']; %Todo by Giovanni keep the channel labels!!!!
        %nirsIdxChLabels =  [nirsIdxChLabels; repmat(data.channelLabels',[sum(selectSource),1])]; % Modified by Giovanni
        nirsFeatFunc = [nirsFeatFunc; repmat(featureList(i),length(feature.featuresLabels),1)];
    end
    
    %nirsIdxChLabels =  repmat(data.channelLabels',[sum(selectSource),1]); % Modified by Giovanni
    nirsFeaturesLabels = [nirsFeatFunc nirsFeaturesLabels nirsIdxChLabels];
    
%     %% Output Reshaping By Giovanni
%     if (i == 1)
%         structOutput.baselineFeatures = nirsFeatures;
%         structOutput.baselineLabels = nirsFeaturesLabels;
%     else
%         structOutput.thinkingFeatures = nirsFeatures;
%         structOutput.thinkingLabels = nirsFeaturesLabels;        
%     end
    
    

    



end
