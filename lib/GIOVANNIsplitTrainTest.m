function[trainFeatures,testFeatures] = GIOVANNIsplitTrainTest(features,trainPerc,analyzeNirs,analyzeEeg)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

trainFeatures= [];
testFeatures = [];

if (analyzeNirs)
    numberOfTrainTrials = round(trainPerc*size(features.nirs.baseline,1));
    numberOfTestTrials = size(features.nirs.baseline,1) - numberOfTrainTrials;
    if (numberOfTrainTrials > 0)
        trainFeatures.nirs.baseline = features.nirs.baseline(1:numberOfTrainTrials,:);
        trainFeatures.nirs.thinking = features.nirs.thinking(1:numberOfTrainTrials,:);
        trainFeatures.questionLabels = features.nirs.questionLabels(1:numberOfTrainTrials);
    end
    if (numberOfTestTrials>0)
        testFeatures.nirs.baseline = features.nirs.baseline(numberOfTrainTrials+1: end,:);
        testFeatures.nirs.thinking = features.nirs.thinking(numberOfTrainTrials+1: end,:);
        testFeatures.questionLabels = features.nirs.questionLabels(numberOfTrainTrials+1:end);
    end
    
    trainFeatures.nirs.featureLabels = features.nirs.featureLabels;
    testFeatures.nirs.featureLabels = features.nirs.featureLabels;
    
    
    trainFeatures.nirs.channelLabels = features.nirs.channelLabels;
    testFeatures.nirs.channelLabels = features.nirs.channelLabels;
    

    
end
if (analyzeEeg)
    
    numberOfTrainTrials = round(trainPerc*size(features.eeg.baseline,1));
    numberOfTestTrials = size(features.eeg.baseline,1) - numberOfTrainTrials;
    if (numberOfTrainTrials > 0)
        trainFeatures.eeg.baseline = features.eeg.baseline(1:numberOfTrainTrials,:);
        trainFeatures.eeg.thinking = features.eeg.thinking(1:numberOfTrainTrials,:);
        trainFeatures.questionLabels = features.eeg.questionLabels(1:numberOfTrainTrials);
    end
    if (numberOfTestTrials>0)
        testFeatures.eeg.baseline = features.eeg.baseline(numberOfTrainTrials+1: end,:);
        testFeatures.eeg.thinking = features.eeg.thinking(numberOfTrainTrials+1: end,:);
        testFeatures.questionLabels = features.eeg.questionLabels(numberOfTrainTrials+1:end);
    end
    
    trainFeatures.eeg.featureLabels = features.eeg.featureLabels;
    testFeatures.eeg.featureLabels = features.eeg.featureLabels;

end



end

