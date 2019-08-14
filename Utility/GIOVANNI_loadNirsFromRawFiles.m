function [outputNirs] = GIOVANNI_loadNirsFromRawFiles(datapaths)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
fileExtension = 'NIRx';

%% Preallocation

outputNirs.baseLines = [];
outputNirs.thinkingPeriodes = [];
outputNirs.questionLabels = [];
outputNirs.sRate = [];
outputNirs.ChannelLabels  =[];

numBlocks=0;
%% Loading and concatenating
for i = 1:length(datapaths)
    datapath = datapaths(i,:);
%     pathFolders = strsplit(datapath,filesep);
%     if ~strcmp(pathFolders{end},'**')
%         datapath = [datapath filesep '**'];
%     end
    allNirs = NIRS_loadfile(convertStringsToChars(datapath),fileExtension);
    
    if (size(allNirs{1, 1}.baseLines,3) == 20 && size(allNirs{1, 1}.thinkingPeriodes,3 )== 20 && size(allNirs{1, 1}.questionLabels,2) == 20)
        outputNirs.baseLines = cat( 3,outputNirs.baseLines,allNirs{1, 1}.baseLines);
        outputNirs.thinkingPeriodes = cat( 3, outputNirs.thinkingPeriodes, allNirs{1, 1}.thinkingPeriodes);
        outputNirs.questionLabels = cat( 2, outputNirs.questionLabels,allNirs{1, 1}.questionLabels);
        outputNirs.sRate = allNirs{1, 1}.sRate;
        outputNirs.ChannelLabels  = allNirs{1, 1}.ChannelLabels;
        numBlocks=numBlocks+1;
        
    
    else
        warning(['Impossible to load block' num2str(i)])
    end

end

    fprintf('Loading OK\n%d blocks\n', numBlocks);
end

