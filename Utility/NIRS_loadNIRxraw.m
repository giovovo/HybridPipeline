function allNirs = NIRS_loadNIRxraw(datapath)

allNirsData = dir(datapath);
allNirsData(startsWith({allNirsData.name},'.')) = [];

allNirs = cell(size(allNirsData));

for i = 1:length(allNirs)
    data = NIRS_NIRx2mat(fullfile(allNirsData(i).folder,allNirsData(i).name));
    allNirs{i} = data;
end