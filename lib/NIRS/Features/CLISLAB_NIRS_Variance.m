function feature = CLISLAB_NIRS_Variance(indata)
% indata.od = channelXtimepointsXtrials
% feature.featuresLabels = string;
% feature.features = trialXfeatures

data = indata.od;

feature.featuresLabels = "Variance";
%    using variance values of each channel as feature
% % Old version
% trainfeature=[];
% 
% for n = 1:size(data,3)
%     
%     trainfeature= [trainfeature; var(squeeze(data(:,:,n)'))];
%     
% end
% feature = trainfeature;

% New version by Ale

v = var(data,0,2);
v = squeeze(v);
feature.featuresLabels = repmat(feature.featuresLabels,size(v,1),1);
feature.features = v';