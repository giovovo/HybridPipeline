function allNirs = NIRS_loadfile(datapath,fileExtension)

if nargin < 2
    fileExtension = 'mat';
end

fileExtension = lower(fileExtension);

switch fileExtension
    case 'mat'
%         allNirs = NIRS_loadmat(fullfile(datapath, '*.mat'));
        allNirs = NIRS_loadmat(fullfile(datapath));
    case 'nirs'
        allNirs = NIRS_loadnirs(fullfile(datapath, '*.nirs'));
    case 'wl1'
        allNirs = NIRS_loadNIRxraw(fullfile(datapath, '*.wl1'));
    case 'nirx'
        allNirs = NIRS_loadNIRxraw(fullfile(datapath, '*.wl1'));
    otherwise
        warning('File format not supported')
        allNirs = [];
end