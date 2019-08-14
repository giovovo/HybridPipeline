function feature = CLISLAB_NIRS_Max(indata)
% indata.od = channelXtimepointsXtrials
% feature.featuresLabels = string;
% feature.features = trialXfeatures

feature.featuresLabels = "Max";
%    using peak values of each channel as feature
data = indata.od;

% % Old version
% trainfeature=[];
% 
% for n = 1:size(data,3)
%     
%     trainfeature= [trainfeature; max(squeeze(data(:,:,n)'))];
%     
% end

% New version by Ale
m = max(data,[],2);
m = squeeze(m);
feature.featuresLabels = repmat(feature.featuresLabels,size(m,1),1);
feature.features = m';
