function EEG = EEG_loadAndConcatenate(datapath,varargin)

%% Define inputs

p = inputParser;

defaultRejected = [];
defaultExtension = 'EEGdata.mat';
addRequired(p,'datapath',@ischar);
addOptional(p,'reject', defaultRejected, @isnumeric);
addParameter(p,'extension',defaultExtension,@ischar)

parse(p,datapath,varargin{:});

%% Load data

allEEGData = dir(fullfile(p.Results.datapath,['*' p.Results.extension]));
allEEGData(startsWith({allEEGData.name},'.')) = [];

allEEG = cell(size(allEEGData));

for i = 1:length(allEEG)
    data = importdata(fullfile(allEEGData(i).folder,allEEGData(i).name));
    
    allEEG{i} = data;

end

%% Reject blocks

allEEG(p.Results.reject) = [];

%% Concatenate data
EEG.baseline = [];
EEG.thinking = [];
EEG.labels = [];
EEG.channels = {};

if size(allEEG,1) < 1
    warning('No blocks to concatenate')
    return
end
EEG.baseline = allEEG{1}.baseLines;
EEG.thinking = allEEG{1}.thinkingPeriodes;
EEG.labels = allEEG{1}.questionLabels;
EEG.channels = allEEG{1}.ChannelLabels;

for i = 2:length(allEEG)
    % Check if the commond channels
    [EEG.channels,oldCh,newCh] = intersect(EEG.channels,allEEG{i}.ChannelLabels,'stable');
    
    % Remove the not common channels from old blocks
    EEG.baseline = EEG.baseline(oldCh,:,:);
    EEG.thinking = EEG.thinking(oldCh,:,:);
    
    % Concatenate the new block
    EEG.baseline = cat(3,EEG.baseline, allEEG{i}.baseLines(newCh,:,:));
    EEG.thinking = cat(3,EEG.thinking, allEEG{i}.thinkingPeriodes(newCh,:,:));
    
    % Concatenate the labels
    EEG.labels = [EEG.labels allEEG{i}.questionLabels];
end