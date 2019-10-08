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
    
%     patient = ['p',char(extractBetween(datapaths(i), "Data/p", "/v"))];
%     if isequal(patient,'p')
%         patient = 'p11'
%     end
%     visit = ['v',char(extractBetween(datapaths(i), "/v", "/d"))];
%     day = ['d',char(extractBetween(datapaths(i), "/d", "/EEG/mat"))];
    
%     outputEeg.channelLabels = including_channel_labels(patient,visit,day);

    outputEeg.sRate = dataRecived.sRate;
    outputEeg.channelLabels = dataRecived.ChannelLabels;
    
end

end

