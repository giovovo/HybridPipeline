function feature = CLISLAB_NIRS_RMS(indata)
% indata.od = channelXtimepointsXtrials
% feature.featuresLabels = string;
% feature.features = trialXfeatures
data = indata.od;
feature.featuresLabels = "RMS";

% % Old Version
% trainfeature=[];
% 
% for n = 1:size(data,3)
%     
%     trainfeature= [trainfeature; rms(squeeze(data(:,:,n)'))];
%     
% end

% New version by Ale
r = rms(data,2);
r = squeeze(r);
feature.featuresLabels = repmat(feature.featuresLabels,size(r,1),1);
feature.features = r';

