function feature = CLISLAB_NIRS_MeanNew(indata)
% indata.od = channelXtimepointsXtrials
% feature.featuresLabels = string;
% feature.features = trialXfeatures
data = indata.od;
fs = indata.fs;

feature.featuresLabels = "Mean New";

chNum = size(data, 1);
sampleNum = size(data, 2);
trialNum = size(data, 3);
sampelWindow = floor(fs);
meannew=[];
for n = 1:size(data,3)
    Rdata=(squeeze(data(:,:,n)'));
    for h=1:size(data,1)
        k=1;
        j=sampelWindow;
        for startPoint=1:(floor(size(data,2)/floor(fs)))
            y=((Rdata(k:j)));
            meannew=[meannew,sum(y)/length(y)];
            k=j;
            j=j+sampelWindow-1;
        end
    end
end

trainfeature = zeros(trialNum, floor(sampleNum/sampelWindow)*chNum)';
trainfeature(:) = meannew;
feature.featuresLabels = repmat(feature.featuresLabels,size(trainfeature,1),1);
feature.features = trainfeature';
