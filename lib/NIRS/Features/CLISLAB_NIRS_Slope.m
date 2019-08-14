function feature = CLISLAB_NIRS_Slope(indata)
% indata.od = channelXtimepointsXtrials
% indata.fs = double
% feature.featuresLabels = string;
% feature.features = trialXfeatures

data = indata.od;
fs = indata.fs;

feature.featuresLabels = "Slope";

chNum = size(data, 1);
sampleNum = size(data, 2);
trialNum = size(data, 3);
sampelWindow = floor(fs);
% % Old version
% slope = [];
% for n = 1:trialNum
%     Rdata = (squeeze(data(:,:,n)'));
%     
%     for h = 1:chNum
%         k = 1;
%         for startPoint = 1 : (floor(sampleNum/sampelWindow))
%             
%             slope = [slope,((Rdata(sampelWindow + k,h) - Rdata(k,h))/sampelWindow)];
%             k = k + sampelWindow;
%             
%         end
%     end
% end
% feature.features = zeros(trialNum, floor(sampleNum/sampelWindow)*chNum)';
% feature.features(:) = slope;
% feature = feature';

% New version from Ale CHECK IF IT IS CORRECT
slope = [];
Rdata = permute(data,[2,1,3]);

sdata = Rdata(1:7:end,:,:);
sdata = sdata/sampelWindow;
slope = [slope, diff(sdata,1,1)];

slope = reshape(slope,[size(slope,1)*chNum,trialNum]);
feature.featuresLabels = repmat(feature.featuresLabels,size(slope,1),1);
feature.features = slope';