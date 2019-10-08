function feature = CLISLAB_NIRS_Polyfit(indata)
% indata.od = channelXtimepointsXtrials
% feature.featuresLabels = string;
% feature.features = trialXfeatures
data = indata.od;
fs = indata.fs;

feature.featuresLabels = "Polyfit";

chNum = size(data, 1);
sampleNum = size(data, 2);
trialNum = size(data, 3);
sampelWindow = floor(fs);
fitslope=[];

for n = 1:trialNum
    Rdata=(squeeze(data(:,:,n)'));
    
    for h=1:chNum
        k=1;
        j=sampelWindow;
        for startPoint=1:1:(floor(sampleNum/floor(fs)))
            y=((Rdata(k:j)));
            X=1:length(y);
            fit=polyfit(X,y,1);
            fitslope=[fitslope ,fit(1,1)];
            k=j;
            j=j+sampelWindow-1;
            
            
        end
    end
end
trainfeature = zeros(trialNum, floor(sampleNum/sampelWindow)*chNum)';
trainfeature(:) = fitslope;
feature.featuresLabels = repmat(feature.featuresLabels,size(trainfeature,1),1);
feature.features = trainfeature';