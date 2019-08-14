function [selectedTrainFeatures, selectedTestFeatures] = GIOVANNIFeaturesDimensionReduction(trainFeatures,testFeatures,featureSelectionMethod,...
    finalNumberOfFeaturesNirs,finalNumberOfFeaturesEeg,finalNumberOfFeaturesOverall)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here


featureSelectionFunction = str2func(featureSelectionMethod);
features=[];
if(isfield(trainFeatures,'nirs'))
    
    features.features = trainFeatures.nirs.thinking;
    features.classLabels = trainFeatures.questionLabels';
    features.featuresLabels = trainFeatures.nirs.featureLabels;
    disp([newline 'Selecting NIRS features...'])
    %selectedNirsFeatures = CLISLAB_FeaturesDimensionReduction(features, finalNumberOfFeaturesNirs);
    %[selectedNirsFeatures] = GIOVANNI_featuresSelectionPengLab(features, finalNumberOfFeaturesNirs);
    selectedNirsFeatures = featureSelectionFunction(features, finalNumberOfFeaturesNirs);
    
    disp([newline 'NIRS features selected'])

    
    
    
    assert(isequal(selectedNirsFeatures.classLabels,trainFeatures.questionLabels'))
    selectedTrainFeatures.questionLabels = selectedNirsFeatures.classLabels';
    selectedTestFeatures.questionLabels = testFeatures.questionLabels;
    selectedTrainFeatures.nirs.featureLabels = selectedNirsFeatures.featuresLabels;
    selectedTestFeatures.nirs.featureLabels = selectedNirsFeatures.featuresLabels;
    
    % To make sure about consistency between features selected
    idx=[];
    for i = 1 :length(trainFeatures.nirs.featureLabels)
        for j = 1: length(selectedNirsFeatures.featuresLabels)
            if ((isequal( trainFeatures.nirs.featureLabels(i,:),  selectedNirsFeatures.featuresLabels(j,:))  ))
                idx=[idx i];
            end
            
        end
    end
    selectedTrainFeatures.nirs.baseline = trainFeatures.nirs.baseline(:,idx);
    selectedTrainFeatures.nirs.thinking = trainFeatures.nirs.thinking(:,idx);
    selectedTestFeatures.nirs.baseline = testFeatures.nirs.baseline(:,idx);
    selectedTestFeatures.nirs.thinking = testFeatures.nirs.thinking(:,idx);
    
    
    
end

if(isfield(trainFeatures,'eeg'))
    features.features = trainFeatures.eeg.thinking;
    features.classLabels = trainFeatures.questionLabels';
    features.featuresLabels = trainFeatures.eeg.featureLabels;
    disp([newline 'Selecting EEG features...'])
    %selectedEegFeatures = CLISLAB_FeaturesDimensionReduction(features, finalNumberOfFeaturesEeg);
    %[selectedEegFeatures] = GIOVANNI_featuresSelectionPengLab(features, finalNumberOfFeaturesEeg);
    selectedEegFeatures = featureSelectionFunction(features, finalNumberOfFeaturesEeg);
    disp([newline 'EEG features selected'])
    
    
    
    
    
    assert(isequal(selectedEegFeatures.classLabels,trainFeatures.questionLabels'))
    selectedTrainFeatures.questionLabels = selectedEegFeatures.classLabels';
    selectedTestFeatures.questionLabels = testFeatures.questionLabels;
    selectedTrainFeatures.eeg.featureLabels = selectedEegFeatures.featuresLabels;
    selectedTestFeatures.eeg.featureLabels = selectedEegFeatures.featuresLabels;
    
    % To make sure about consistency between features selected
    idx=[];
    for i = 1 :length(trainFeatures.eeg.featureLabels)
        for j = 1: length(selectedEegFeatures.featuresLabels)
            if ((isequal( trainFeatures.eeg.featureLabels(i,:),  selectedEegFeatures.featuresLabels(j,:))  ))
                idx=[idx i];
            end
            
        end
    end
    selectedTrainFeatures.eeg.baseline = trainFeatures.eeg.baseline(:,idx);
    selectedTrainFeatures.eeg.thinking = trainFeatures.eeg.thinking(:,idx);
    selectedTestFeatures.eeg.baseline = testFeatures.eeg.baseline(:,idx);
    selectedTestFeatures.eeg.thinking = testFeatures.eeg.thinking(:,idx);
    
    
    
end

if(isfield(trainFeatures,'nirs') && isfield(trainFeatures,'nirs') )
    
    features.features = [trainFeatures.nirs.thinking,trainFeatures.eeg.thinking ];
    features.classLabels = trainFeatures.questionLabels';
    features.featuresLabels = [trainFeatures.nirs.featureLabels; string(trainFeatures.eeg.featureLabels)];
        
    
    disp([newline 'Selecting NIRS/EEG features...'])
    %selectedOverallFeatures = CLISLAB_FeaturesDimensionReduction(features, finalNumberOfFeaturesOverall);
    %[selectedOverallFeatures] = GIOVANNI_featuresSelectionPengLab(features, finalNumberOfFeaturesOverall);
    selectedOverallFeatures = featureSelectionFunction(features, finalNumberOfFeaturesOverall);
    disp([newline 'NIRS/EEG features selected'])
    
    
   % The following code makes sure features order is consistent
    nirsIdx=[];
    eegIdx=[];
    
    for i = 1 : finalNumberOfFeaturesOverall
        
        for j = 1 : length(trainFeatures.nirs.featureLabels)
            if (  isequal(selectedOverallFeatures.featuresLabels(i,:),trainFeatures.nirs.featureLabels(j,:))  )
                %nirsIdx(1,:) = [nirsIdx(1,:) j];
                %nirsIdx(2,:) = [nirsIdx(2,:) i ];
                nirsIdx = [nirsIdx [j; i] ];
            end
        end
        
        for j = 1 : length(trainFeatures.eeg.featureLabels)
            if (  isequal(selectedOverallFeatures.featuresLabels(i,:),string(trainFeatures.eeg.featureLabels(j,:)))  )
                %eegIdx(1,:) = [eegIdx(1,:) j ];
                %eegIdx(2,:) = [eegIdx(2,:) i ];
                eegIdx = [eegIdx [j; i] ];
            end
        end
        
        %ppp=find(isequal(selectedOverallFeatures.featuresLabels(i,:),trainFeatures.nirs.featureLabels));
        %ppp2=find(isequal(selectedOverallFeatures.featuresLabels(i,:) == string(trainFeatures.eeg.featureLabels)));
    end
    
    
    %selectedTrainFeatures.questionLabels = selectedNirsFeatures.classLabels';
    %selectedTestFeatures.questionLabels = testFeatures.questionLabels;
    selectedTrainFeatures.overall.featureLabels([nirsIdx(2,:),eegIdx(2,:)],:) = [trainFeatures.nirs.featureLabels(nirsIdx(1,:),:); string(trainFeatures.eeg.featureLabels(eegIdx(1,:),:))];
    selectedTestFeatures.overall.featureLabels([nirsIdx(2,:),eegIdx(2,:)],:) = [testFeatures.nirs.featureLabels(nirsIdx(1,:),:); string(testFeatures.eeg.featureLabels(eegIdx(1,:),:))];
    selectedTrainFeatures.overall.baseline(:,[nirsIdx(2,:),eegIdx(2,:)]) = [trainFeatures.nirs.baseline(:,nirsIdx(1,:)),trainFeatures.eeg.baseline(:,eegIdx(1,:))];
    selectedTrainFeatures.overall.thinking(:,[nirsIdx(2,:),eegIdx(2,:)]) = [trainFeatures.nirs.thinking(:,nirsIdx(1,:)),trainFeatures.eeg.thinking(:,eegIdx(1,:))];
    selectedTestFeatures.overall.baseline(:,[nirsIdx(2,:),eegIdx(2,:)]) = [testFeatures.nirs.baseline(:,nirsIdx(1,:)),testFeatures.eeg.baseline(:,eegIdx(1,:))];
    selectedTestFeatures.overall.thinking(:,[nirsIdx(2,:),eegIdx(2,:)]) = [testFeatures.nirs.thinking(:,nirsIdx(1,:)),testFeatures.eeg.thinking(:,eegIdx(1,:))];
    
    

   
end


end

