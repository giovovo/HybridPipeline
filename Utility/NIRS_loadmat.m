function allNirs = NIRS_loadmat(datapath)
allNirsData = dir(datapath);
allNirsData(startsWith({allNirsData.name},'.')) = [];

allNirs = cell(size(allNirsData));

for i = 1:length(allNirs)
    data = importdata(fullfile(allNirsData(i).folder,allNirsData(i).name));
    if ~isfield(data,'ChannelLabels')
        data = NIRS_OldData2NewData(data);
    end
    allNirs{i} = data;
end