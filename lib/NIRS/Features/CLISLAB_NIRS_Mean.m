function feature = CLISLAB_NIRS_Mean(indata)
% indata.od = channelXtimepointsXtrials
% feature.featuresLabels = string;
% feature.features = trialXfeatures
data = indata.od;
feature.featuresLabels = "Mean";
% % OLD VERSION
% trainfeature=[];
% 
% for n = 1:size(rdata,3)
%     
%     trainfeature= [trainfeature; mean((squeeze(rdata(:,:,n)')))];
%     
% end

% NEW Version by Ale
m = mean(data,2);
m = squeeze(m);
feature.featuresLabels = repmat(feature.featuresLabels,size(m,1),1);
feature.features = m';