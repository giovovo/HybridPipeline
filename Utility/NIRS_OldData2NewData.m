function newdata = NIRS_OldData2NewData(olddata, fs)
    if nargin < 2
        fs = 'new';
    end
    newdata.baseLines = olddata.baselinedata;
    newdata.thinkingPeriodes = olddata.NIRSdata;
    newdata.questionLabels = olddata.classlabel';
    % Guess the sRate based on num of channels and if the new or old
    % dataset
    if strcmp(fs,'new')
        totalSampRate = 50;
    else
        totalSampRate = 62.5;
    end
    
    numChannels = size(newdata.thinkingPeriodes,1)/2;
    if numChannels > 30
        newdata.sRate = totalSampRate/18;
    else
        newdata.sRate = totalSampRate/8;
    end
    newdata.ChannelLabels = cell(1,size(newdata.thinkingPeriodes,1));
    for i = 1:size(newdata.thinkingPeriodes)
        newdata.ChannelLabels{i} = num2str(i);
    end
end