function feature = CLISLAB_NIRS_Slope_Windowed(indata)
% indata.od = channelXtimepointsXtrials
% feature.featuresLabels = string;
% feature.features = trialXfeatures

labels = "Slope Windowed";

signal = ["HbO" "HbR" "HbT"];
signal = signal(find(indata.source));
feature.featuresLabels = (labels + " - " + signal)';

numSignal = sum(indata.source);

data = indata.od;

chNum = size(data, 1);
sampleNum = size(data, 2);
trialNum = size(data, 3);
sampleWindow = floor(indata.fs);

% New version from Ale CHECK IF IT IS CORRECT
slope = [];
Rdata = permute(data,[2,1,3]);

sdata = Rdata(1:sampleWindow:end,:,:);
sdata = sdata/sampleWindow;
slope = [slope, diff(sdata,1,1)];

slope = reshape(slope,[size(slope,1)*chNum,trialNum]);
feature.featuresLabels = repmat(feature.featuresLabels,size(slope,1)/numSignal,1);
feature.featuresLabels = feature.featuresLabels(:);
feature.features = slope';