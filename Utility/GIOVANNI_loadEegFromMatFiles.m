function [outputEeg] = GIOVANNI_loadEegFromMatFiles(datapaths)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here


%% Preallocation
outputEeg.baseLines = [];
outputEeg.thinkingPeriodes =[];
outputEeg.questionLabels = [];
outputEeg.channelLabels =[];


    
for i = 1 : length(datapaths)
    load(datapaths(i,:))
    outputEeg.baseLines = cat(3, outputEeg.baseLines, dataRecived.baseLines);
    outputEeg.thinkingPeriodes = cat(3, outputEeg.thinkingPeriodes, dataRecived.thinkingPeriodes);
    outputEeg.questionLabels =  cat(2, outputEeg.questionLabels , dataRecived.questionLabels);
    outputEeg.channelLabels = including_channel_labels('p11','v01','d01');

end
end

