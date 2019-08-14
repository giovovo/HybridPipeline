function data = Data_concatenate(allData)
% Concatenate baseline, thinking periods and question labels from many
% blocks

data.baseLines = [];
data.thinkingPeriodes = [];
data.questionLabels = [];
data.sRate = [];
data.ChannelLabels = [];
for i = 1:length(allData)
    data.baseLines = cat(3,data.baseLines, allData{i}.baseLines);
    data.thinkingPeriodes = cat(3,data.thinkingPeriodes, allData{i}.thinkingPeriodes);
    data.questionLabels = [data.questionLabels, allData{i}.questionLabels];
    data.sRate = allData{i}.sRate;
    data.ChannelLabels = allData{i}.ChannelLabels;
end
