clear all,clc

tic
%% Add libraries to the path
addpath(genpath([pwd,filesep,'..',filesep,'ext']),genpath([pwd,filesep,'..',filesep,'lib']),[pwd,filesep,'..',filesep,'Utility']);
inputData=[];
questionLabels = [];

%% What do you want to analyze?
analyzeNirs = true;
analyzeEeg = true;


%% Load all NIRx from raw files
if (analyzeNirs)
    
    % put inside the datapaths variable all the paths to the nirs raw files
    
    %%%%%%%%%%% DAY 24-03-2018 %%%%%%%%%%%
%     %datapaths(1,1) ="/home/giovovo/Desktop/Università/Università/TesiMagi/BCI/Lab/pipelinEEG+NIRS/InputData/p11/v01/raw/NIRS/2018-03-24/2018-03-24_001";%Corrupted
%     datapaths(1,1) = "/home/giovovo/Desktop/Università/Università/TesiMagi/BCI/Lab/pipelinEEG+NIRS/InputData/p11/v01/raw/NIRS/2018-03-24/2018-03-24_002";
%     datapaths(2,1) = "/home/giovovo/Desktop/Università/Università/TesiMagi/BCI/Lab/pipelinEEG+NIRS/InputData/p11/v01/raw/NIRS/2018-03-24/2018-03-24_003";
%     datapaths(3,1) = "/home/giovovo/Desktop/Università/Università/TesiMagi/BCI/Lab/pipelinEEG+NIRS/InputData/p11/v01/raw/NIRS/2018-03-24/2018-03-24_004";
%     %datapaths(5,1) = "/home/giovovo/Desktop/Università/Università/TesiMagi/BCI/Lab/pipelinEEG+NIRS/InputData/p11/v01/raw/NIRS/2018-03-24/2018-03-24_005";%Corrupted
%     %datapaths(6,1) = "/home/giovovo/Desktop/Università/Università/TesiMagi/BCI/Lab/pipelinEEG+NIRS/InputData/p11/v01/raw/NIRS/2018-03-24/2018-03-24_006";%Corrupted
%     %datapaths(7,1) = "/home/giovovo/Desktop/Università/Università/TesiMagi/BCI/Lab/pipelinEEG+NIRS/InputData/p11/v01/raw/NIRS/2018-03-24/2018-03-24_007";%Corrupted
%     %%%%%%%%%%% DAY 24-03-2018 %%%%%%%%%%%

      %%%%%%%%%%% DAY 25-03-2018 %%%%%%%%%%%
      datapaths(1,1) = "/home/giovovo/Desktop/Università/Università/TesiMagi/BCI/Lab/pipelinEEG+NIRS/InputData/p11/v01/raw/NIRS/2018-03-25/2018-03-25_001";
      datapaths(2,1) = "/home/giovovo/Desktop/Università/Università/TesiMagi/BCI/Lab/pipelinEEG+NIRS/InputData/p11/v01/raw/NIRS/2018-03-25/2018-03-25_002";
      
      %%%%%%%%%%% DAY 25-03-2018 %%%%%%%%%%%
    
    
    inputData.inputNirs = GIOVANNI_loadNirsFromRawFiles(datapaths);
    questionLabels = inputData.inputNirs.questionLabels;
end

%% Load all EEG  from mat files

if (analyzeEeg)
    
    % put inside the datapaths variable all the paths to the eeg .mat files
    
%     %%%%%%%%%%% DAY 24-03-2018 %%%%%%%%%%%
%     datapaths(1,1) = "/home/giovovo/Desktop/Università/Università/TesiMagi/BCI/Lab/pipelinEEG+NIRS/InputData/p11/v01/d01/EEG/mat/24-Mar-2018_Block2_EEGdata.mat";
%     datapaths(2,1) = "/home/giovovo/Desktop/Università/Università/TesiMagi/BCI/Lab/pipelinEEG+NIRS/InputData/p11/v01/d01/EEG/mat/24-Mar-2018_Block3_EEGdata.mat";
%     datapaths(3,1) = "/home/giovovo/Desktop/Università/Università/TesiMagi/BCI/Lab/pipelinEEG+NIRS/InputData/p11/v01/d01/EEG/mat/24-Mar-2018_Block4_EEGdata.mat";
%     %%%%%%%%%%% DAY 24-03-2018 %%%%%%%%%%%

      %%%%%%%%%%% DAY 25-03-2018 %%%%%%%%%%%
      
      datapaths(1,1) = "/home/giovovo/Desktop/Università/Università/TesiMagi/BCI/Lab/pipelinEEG+NIRS/InputData/p11/v01/d02/EEG/mat/25-Mar-2018_Block1_EEGdata.mat";
      datapaths(2,1) = "/home/giovovo/Desktop/Università/Università/TesiMagi/BCI/Lab/pipelinEEG+NIRS/InputData/p11/v01/d02/EEG/mat/25-Mar-2018_Block2_EEGdata.mat";
      
      %%%%%%%%%%% DAY 25-03-2018 %%%%%%%%%%%
    
    
    inputData.inputEeg = GIOVANNI_loadEegFromMatFiles(datapaths);
    questionLabels = inputData.inputEeg.questionLabels;
end
clear datapaths
%% Check consistency between egg and nirs
questionLabel = [];
if (analyzeNirs == 1 && analyzeEeg == 1)
    assert(isequal(~inputData.inputEeg.questionLabels,inputData.inputNirs.questionLabels))
    inputData.inputEeg.questionLabels = ~inputData.inputEeg.questionLabels;
end


%%%%%%%%%%%%%%                                  %%%%%%%%%%%%%%
%%%%%%%%%%%%%% FROM NOW ON: 1 --> YES, 0 --> NO %%%%%%%%%%%%%%
%%%%%%%%%%%%%%                                  %%%%%%%%%%%%%%


%% Parameters for NIRS preprocessing

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
% NIRS conversion function from wavelengths to oxy/deoxy

conversion_type = 'GIOVANNI_NIRS_LBG';
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
% Filtering (beware Nyquist !! )

filteringParameters.mode = 'bandpass';
filteringParameters.passingHertz =[.1,.3]; % Hz
filteringParameters.stoppingHertz = [0.001,.5]; % Hz
filteringParameters.ripplePassBand =1; % [db]
filteringParameters.rippleStopBand = 10;%[db]
filteringParameters.name = 'GIOVANNI_NIRS_IIR_butter_filter';
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
% Amplitude correction

amplitude_correction = 'GIOVANNI_NIRS_Baseline_Correction';
amplitude_correction = 'none';
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%


%% Parameters for EEG preprocessing

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%     ASK ANDRES !!!
% Preprocessing for the segmented data 

filter_type         =       convertCharsToStrings('CLISLAB_EEG_IIR_butter_filter');
interprocess        =       [];
amplitude_correction_eeg =      convertCharsToStrings('CLISLAB_EEG_normalization');
selectSource        =       [1 1 1];
%frequencyBands      =       [1 1 1 1 1];

frequencyBands(1).low = 0.5;  % wideband : 0.5,30  
frequencyBands(1).high = 30;
frequencyBands(1).used = 1;
frequencyBands(2).low = 1;  % delta:1,4
frequencyBands(2).high = 4;
frequencyBands(2).used = 1;
frequencyBands(3).low = 4; % theta : 4, 7 
frequencyBands(3).high = 7;
frequencyBands(3).used = 1;
frequencyBands(4).low = 7; % alpha: 7,13
frequencyBands(4).high = 13;
frequencyBands(3).used = 1;
frequencyBands(5).low = 13; % beta: 13,30
frequencyBands(5).high = 30;
frequencyBands(5).used = 1;


%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%% Preprocess data


preprocessedData = [];
if (analyzeNirs)
   [preprocessedData.nirs] = CLISLAB_NIRS_Online_Preprocessing...
       (inputData.inputNirs.baseLines, inputData.inputNirs.thinkingPeriodes,inputData.inputNirs.questionLabels,inputData.inputNirs.ChannelLabels,....
       inputData.inputNirs.sRate, conversion_type, amplitude_correction,filteringParameters);
   
 
end

if (analyzeEeg)
    [preprocessedData.eeg] = CLISLAB_EEG_Online_Preprocessing...
        (inputData.inputEeg.baseLines, inputData.inputEeg.thinkingPeriodes, inputData.inputEeg.channelLabels,inputData.inputEeg.questionLabels,...
        500,filter_type, interprocess, selectSource, frequencyBands,amplitude_correction_eeg);
 
end


%% Parameters for NIRS feature extraction

% Features functions (Select from the folder lib/NIRS/Features)
featureList =   {'CLISLAB_NIRS_Max'      ,...
                'CLISLAB_NIRS_Mean'     ,...
                'CLISLAB_NIRS_MeanNew'	,...
                'CLISLAB_NIRS_Polyfit'	,...
                'CLISLAB_NIRS_RMS'      ,...	
                'CLISLAB_NIRS_Skewness' ,...
                'CLISLAB_NIRS_Kurtosis',...
                'CLISLAB_NIRS_Variance'};
                %'CLISLAB_NIRS_Slope'	,...
            
% Signal used for feature extraction (HbO and/or HbR and/or HbT)
HbO = 1; HbR = 1; HbT = 0;
signal = [HbO HbR HbT];
            
            

%% Parameters for EEG feature extraction
testAccuracyEegBigMatrix=-ones(19,26,3);
featureSelectionMethod(1) ="CLISLAB_FeaturesDimensionReduction";
featureSelectionMethod(2) = "GIOVANNI_featuresSelectionPengLab";
featureSelectionMethod(3) = "CLISLAB_Andres_FeaturesDimensionReduction";
for inputEegFeatures = 1 :19
    analyzeNirs = false; %test
    indexInputEegFeatures = inputEegFeatures;
    
    temp = ['eeg_Online_ExtractFeatures_'];
    featureListEeg =...
        {
        'eeg_Online_ExtractFeatures_Amplitude_Absolute_Mean',...
        'eeg_Online_ExtractFeatures_Amplitude_Area_under_Curve',...
        'eeg_Online_ExtractFeatures_Amplitude_Envelope_Mean',...
        'eeg_Online_ExtractFeatures_Amplitude_Kurtosis',...
        'eeg_Online_ExtractFeatures_Amplitude_Maximum_Location',...
        'eeg_Online_ExtractFeatures_Amplitude_Maximum_Value',...
        'eeg_Online_ExtractFeatures_Amplitude_Minimum_Location',...
        'eeg_Online_ExtractFeatures_Amplitude_Minimum_Value',...
        'eeg_Online_ExtractFeatures_Amplitude_Range',...
        'eeg_Online_ExtractFeatures_Amplitude_Standard_Deviation',...
        'eeg_Online_ExtractFeatures_Range_Assymetrys',...
        'eeg_Online_ExtractFeatures_Range_LowerMargin',...
        'eeg_Online_ExtractFeatures_Range_Mean',...
        'eeg_Online_ExtractFeatures_Range_StandardDeviation',...
        'eeg_Online_ExtractFeatures_Range_UpperMargin',...
        'eeg_Online_ExtractFeatures_Range_Width',...
        'eeg_Online_ExtractFeatures_Spectral_Absolute_Power',...
        'eeg_Online_ExtractFeatures_Spectral_Entropy',...
        'eeg_Online_ExtractFeatures_Spectral_Mean',...
        };
    
    
    %% Extract features
    
    features = [];
    currentFeatureList=featureListEeg(1:inputEegFeatures); %test
    if (analyzeNirs)
        disp([newline 'Extracting NIRS features...'])
        [features.nirs] = GIOVANNI_NIRS_Online_ExtractFeatures(preprocessedData.nirs, inputData.inputNirs.sRate, signal, featureList);
        disp([newline 'NIRS features extracted!'])
        
    end
    
    if (analyzeEeg)
        disp([newline 'Extracting EEG features...' ])
        %addpath(['lib',filesep,'EEG',filesep,'Features'])
        [features.eeg] = GIOVANNI_EEG_Online_ExtractFeatures(preprocessedData.eeg, 500, currentFeatureList);
        disp([newline 'EEG features extracted!'])
        
    end
    
    
    %% Split train/test
    % train percentage (between 0 and 1, if 1 no test will be performed)
    %assert(size(features.nirs.baseline,1) == size(features.nirs.thinking,1) && size(features.eeg.nirs,1))
    trainPerc = 0.7;
    
    [trainFeatures,testFeatures] = GIOVANNIsplitTrainTest(features,trainPerc,analyzeNirs,analyzeEeg);
    
    
    
    %% Feature Selection
    
    outputEegFeaturesIndex=1;
    for outputEegFeatures = [5 10 15 20 25 30 38]
        
    indexOutputEegFeatures =outputEegFeatures;   
    performFeatureReduction = true;
    finalNumberOfFeaturesNirs = 30;
    finalNumberOfFeaturesEeg = 30;
    finalNumberOfFeaturesOverall = 30; 
    
    
    finalNumberOfFeaturesEeg = outputEegFeatures;

    
    
    
    selectedTrainFeatures = trainFeatures;
    selectedTestFeatures = testFeatures;
    
    for methodIndex = 1 :length(featureSelectionMethod)
        currentMethod = featureSelectionMethod(methodIndex);
        indexMethodIndex = methodIndex;
    if (performFeatureReduction)
        
        [selectedTrainFeatures, selectedTestFeatures] = GIOVANNIFeaturesDimensionReduction(trainFeatures,testFeatures,currentMethod,...
            finalNumberOfFeaturesNirs,finalNumberOfFeaturesEeg,finalNumberOfFeaturesOverall);
         testAccuracyEeg = buildAndPredictDummyModel(selectedTrainFeatures,selectedTestFeatures);
         
         
         testAccuracyEegBigMatrix(inputEegFeatures,outputEegFeatures,methodIndex) = testAccuracyEeg;
        
    end
    
    
    
    
    end
    
    
    
    
    outputEegFeaturesIndex = outputEegFeaturesIndex+1;
    end
    save([pwd,filesep,'..',filesep,'tempFolder',filesep,'testAccuracyEegBigMatrix',num2str(inputEegFeatures)],'testAccuracyEegBigMatrix');
end
toc










function testAccuracyEeg = buildAndPredictDummyModel(selectedTrainFeatures,selectedTestFeatures)


% now using only EEG



X = selectedTrainFeatures.eeg.thinking;
Y = selectedTrainFeatures.questionLabels;
model = fitcsvm(X,Y);

X = selectedTestFeatures.eeg.thinking;
Y = selectedTestFeatures.questionLabels;
label = predict(model,X);
testAccuracyEeg = 1-sum(abs(label-Y'))/length(Y);


end

% 
% 
% 
% %% Building the model
% 
% classifier = {'CL_MatlabSVM'};
% 
% %% Nirs
% 
% X = selectedTrainFeatures.nirs.thinking;
% Y = selectedTrainFeatures.questionLabels;
% model = fitcsvm(X,Y);
% 
% X = selectedTestFeatures.nirs.thinking;
% Y = selectedTestFeatures.questionLabels;
% label = predict(model,X);
% testAccuracyNirs = 1-sum(abs(label-Y'))/length(Y)
% 
% 
% %% EEG
% 
% X = selectedTrainFeatures.eeg.thinking;
% Y = selectedTrainFeatures.questionLabels;
% model = fitcsvm(X,Y);
% 
% X = selectedTestFeatures.eeg.thinking;
% Y = selectedTestFeatures.questionLabels;
% label = predict(model,X);
% testAccuracyEeg = 1-sum(abs(label-Y'))/length(Y)
% 
% 
% %% Overall
% 
% X = selectedTrainFeatures.overall.thinking;
% Y = selectedTrainFeatures.questionLabels;
% model = fitcsvm(X,Y);
% 
% X = selectedTestFeatures.overall.thinking;
% Y = selectedTestFeatures.questionLabels;
% label = predict(model,X);
% testAccuracyOverall = 1-sum(abs(label-Y'))/length(Y)
% 
% 
% 
% 
% 
% 
% 
% 
