function allNirs = NIRS_loadnirs(datapath)

allNirsData = dir(datapath);
allNirsData(startsWith({allNirsData.name},'.')) = [];

allNirs = cell(size(allNirsData));
curr_path = pwd;

cd('/Users/ale/Documents/MATLAB/Toolboxes/homer2');

setpaths;

cd(curr_path);
for i = 1:length(allNirs)
    nirs = importdata(fullfile(allNirsData(i).folder, allNirsData(i).name),'-mat');

dod = hmrIntensity2OD(nirs.d);

% [dod,svs,nSV] = enPCAFilter(dod,nirs.SD,nirs.tIncMan,0.8);

dod = hmrBandpassFilt(dod,nirs.t,0,0.18);

dc = hmrOD2Conc(dod,nirs.SD,[6  6]);

[~,bl,th,ql,fs,ch] = NIRS_nirs2mat(dc,nirs.t,nirs.s,nirs.CondNames,nirs.SD);

if isempty(bl)
    warning([allNirsData(i).name ' skipped: Wrong number of trigger'])
    continue
end
allNirs{i}.baseLines = bl;
allNirs{i}.thinkingPeriodes = th;
allNirs{i}.questionLabels = ql;
allNirs{i}.sRate = fs;
allNirs{i}.ChannelLabels = ch;
end
allNirs(cellfun(@isempty,allNirs)) = [];
cd('/Users/ale/Documents/MATLAB/Toolboxes/homer2');
setpaths(0);
cd(curr_path);