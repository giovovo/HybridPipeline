function matdata = NIRS_NIRx2mat(datapath, varargin)
%% Convert NIRx wl data to mat variable or file in the newHybridBCI format
% 
% M = NIRS_NIRx2mat(X) returns a matlab structure M with the fields for
% thinking period (10s), baseline (10s), question labels, sampling rate and
% channel labels
% 
% M = NIRS_NIRx2mat(X,T,B) load the NIRx files from the path X and returns
% a mat variable considering the thinking period length T (default 10) and
% the baseline length B (default 10)
%
% M = NIRS_NIRx2mat(X,params) possible parameters:
%   'Save' ['Off' (default), 'On']: save the results
%
%   'Outpath' [default: the path of NIRx files]: path for the saved file
%
%   'SaveName' [default: 'NIRSdata']: name of the saved files

%% Parse inputs
p = inputParser;

defaultEpochLength = 10; %10 seconds answer

defaultBlLength = 10; %10 seconds baseline

defaultSave = 'off';
validSave = {'on','off'};
checkSave = @(x) any(validatestring(x,validSave));

defaultOutpath = '';

defaultSaveName = 'NIRSdata';

addRequired(p,'datapath',@ischar)
addOptional(p,'epochLength',defaultEpochLength,@isnumeric)
addOptional(p,'blLength',defaultBlLength,@isnumeric)
addOptional(p,'save',defaultSave,checkSave)
addOptional(p,'outpath',defaultOutpath,@ischar)
addOptional(p,'saveName',defaultSaveName,@ischar)

parse(p,datapath,varargin{:})

%% Load NIRx file(s)

all_file = dir(fullfile(p.Results.datapath));
all_file(startsWith({all_file.name},'.')) = [];
num_files = length(all_file);
if num_files > 1
    warning([num2str(num_files) ' files detected. Output will be one multidimensional structure']);
end

%% Preallocate the structure

matdata = struct('baseLines',cell(1,num_files),...
    'thinkingPeriodes',cell(1,num_files),...
    'questionLabels',cell(1,num_files),...
    'sRate', cell(1,num_files),...
    'ChannelLabels',cell(1,num_files));

%% Convert the files

blockNum = 0;

for block = 1:num_files
    blockname = all_file(block).name(1:end-4);
    blockpath = all_file(block).folder;
    
    % check the output path (if the data will be saved)

    blockNum = blockNum +1;
    
    % load the data
    errorFlag = 0;
    
    if ~exist(fullfile(all_file(block).folder,[blockname,'.wl2']),'file')
        warning([blockpath ': The folder does not contain .wl2 data file'])
        errorFlag=1;
    end
    if ~exist(fullfile(all_file(block).folder,[blockname,'_config.txt']),'file')
        warning([blockpath ': The folder does not contain configuration file'])
        errorFlag=1;
    end
    if ~exist(fullfile(all_file(block).folder,[blockname,'.hdr']),'file')
        warning([blockpath ': The folder does not contain header file'])
        errorFlag=1;
    end
    if errorFlag
        %warning('Please select correct folder!');
        continue
    end
    
    wl1=fopen(fullfile(all_file(block).folder,[blockname,'.wl1']));
    wl2=fopen(fullfile(all_file(block).folder,[blockname,'.wl2']));
    config=fopen(fullfile(all_file(block).folder,[blockname,'_config.txt']));
    hdr=fopen(fullfile(all_file(block).folder,[blockname,'.hdr']));
    
    while 1 % get scan info
        temp=fgetl(config);
        if temp==-1
            temp='';
            fclose(config);
            break;
        end
        
        if strncmp(temp, 'Subject=',length('Subject='))
            nirs_data.Subject=strtrim(temp(length('Subject=')+1:end));
        elseif  strncmp(temp, 'SamplingRate=',length('SamplingRate='))
            nirs_data.SamplingRate=str2num(temp(length('SamplingRate=')+1:end)); %#ok<ST2NM>
        elseif  strncmp(temp, 'source_N=',length('source_N='))
            nirs_data.source_N=str2num(temp(length('source_N=')+1:end)); %#ok<ST2NM>
        elseif  strncmp(temp, 'detector_N=',length('detector_N='))
            nirs_data.detector_N=str2num(temp(length('detector_N=')+1:end)); %#ok<ST2NM>
        elseif  strncmp(temp, 'time_point_N=',length('time_point_N='))
            nirs_data.time_point_N=str2num(temp(length('time_point_N=')+1:end)); %#ok<ST2NM>
        end
    end
    
    %%%%%% EVENTS%%%%
    nirs_data.vector_onset=zeros(nirs_data.time_point_N,1);
    nirs_data.fs=nirs_data.SamplingRate;
    nirs_data.LBsf = nirs_data.SamplingRate; %7.8125; %added in accordance to LBG_data2
    
    while 1
        hdr_end = 0;
        temp=fgetl(hdr);
        
        if strncmp(temp, 'Events="#',length('Events="#'))
            while 1
                temp=fgetl(hdr);
                if strncmp(temp, '#"',length('#"'))
                    %                         fclose(hdr);
                    %                         hdr_end = 1;
                    break;
                end
                nnn=str2num(temp); %#ok<ST2NM>
                if nnn(1,3)
                    nirs_data.vector_onset(nnn(1,3),1)=nnn(1,2);
                end
                
            end
        end
        % find channel combination using hdr instead of tpl (sometime
        % tpl file is missing)
        if strncmp(temp, 'S-D-Mask="#',length('S-D-Mask="#'))
            structure = zeros(nirs_data.source_N,nirs_data.detector_N);
            row_num = 0;
            while 1
                temp=fgetl(hdr);
                if strncmp(temp, '#"',length('#"'))
                    nirs_data.channel = find(structure');
                    [nirs_data.detector,nirs_data.source] = find(structure');
                    fclose(hdr);
                    hdr_end = 1;
                    break;
                end
                row_num = row_num+1;
                row = str2num(temp);
                structure(row_num,:) = row;
            end
        end
        if hdr_end
            break;
        end
    end
    
    %%%%%% Channels' name %%%%%%
    wlName = [760 850];
    chanName = string([nirs_data.source,nirs_data.detector]);
    chanName = join(chanName,'-',2);
    chanName(:,2) = chanName;
    chanName = chanName + ' > ' + wlName;
    chanName = chanName(:);
    chanName = cellstr(chanName');
    
    
    %%%% get optical data %%%%%%%
    precision=repmat('%f',[1,nirs_data.source_N* nirs_data.detector_N]);
    
    nirs_data.data_wl1=fscanf (wl1,precision,[nirs_data.source_N* nirs_data.detector_N,nirs_data.time_point_N ])';
    nirs_data.data_wl2=fscanf (wl2,precision,[nirs_data.source_N* nirs_data.detector_N,nirs_data.time_point_N])';
    nirs_data.wl1 = nirs_data.data_wl1(:,nirs_data.channel);
    nirs_data.wl2 = nirs_data.data_wl2(:,nirs_data.channel);
    
    nirs_data.all_data = [nirs_data.data_wl1, nirs_data.data_wl2];
    
    
    fclose(wl1);
    fclose(wl2);
    
    % extract nirs data and triggers
    data_epoch = p.Results.epochLength;
    bl_epoch = p.Results.blLength;
    data_framecount = floor(nirs_data.fs*data_epoch);
    bl_framecount = floor(nirs_data.fs*bl_epoch);
    
    % TRIGGER
    % start:    9
    %           yes     no      open
    % baseline: 10      11      12
    % present.: 5       6       7
    % answer:   4       8       13
    % feedback: 1       2       3
    %
    % end:      15
    wl1 = nirs_data.wl1';
    wl2 = nirs_data.wl2';
    trig_all = nirs_data.vector_onset;
    
    trig_start = find(nirs_data.vector_onset == 9);
    trig_end = find(nirs_data.vector_onset == 15);
    trig_all([1:trig_start-1,trig_end+1:end]) = 0;
    
    trig_baseline = [10 11 12];
    index_baseline = ismember(trig_all,trig_baseline);
    index_baseline = find(index_baseline);
    trig_presenta = [5 6 7];
    index_presenta = ismember(trig_all,trig_presenta);
    index_presenta = find(index_presenta);
    trig_answer = [4 8 13];
    index_answer = ismember(trig_all,trig_answer);
    index_answer = find(index_answer);
    trig_feedback = [1 2 3];
    index_feedback = ismember(trig_all,trig_feedback);
    index_feedback = find(index_feedback);
    all_classLabels = [1 0 2]; % True, False, Open
    
    if ~isequal(length(index_baseline),length(index_presenta),length(index_answer),length(index_feedback))
        warning([blockpath ': Wrong number of triggers:'...
            ' bl: ' num2str(length(index_baseline)) ...
            ', pr: ' num2str(length(index_presenta)) ...
            ', an: ' num2str(length(index_answer)) ...
            ', fb: ' num2str(length(index_feedback))])
        continue
    end
    
    num_questions = length(index_baseline);
    wl1_bldata = zeros(size(wl1,1),bl_framecount,num_questions);
    wl1_nirsdata = zeros(size(wl1,1),data_framecount,num_questions);
    wl2_bldata = zeros(size(wl1_bldata));
    wl2_nirsdata = zeros(size(wl1_nirsdata));
    baselinelabel = zeros(1,num_questions);
    datlabel = zeros(1,num_questions);
    classlabel = zeros(1,num_questions);
    
    for q = 1:num_questions
        wl1_bldata(:,:,q) = wl1(:,index_baseline(q):index_baseline(q)+bl_framecount-1);
        wl1_nirsdata(:,:,q) = wl1(:,index_answer(q):index_answer(q)+data_framecount-1);
        wl2_bldata(:,:,q) = wl2(:,index_baseline(q):index_baseline(q)+bl_framecount-1);
        wl2_nirsdata(:,:,q) = wl2(:,index_answer(q):index_answer(q)+data_framecount-1);
        baselinelabel(q) = trig_all(index_baseline(q));
        datlabel(q) = trig_all(index_answer(q));
        classlabel(q) = all_classLabels(trig_answer==datlabel(q));
    end
    
    baselinedata = [wl1_bldata; wl2_bldata];
    NIRSdata = [wl1_nirsdata; wl2_nirsdata];
    
    matdata(block).baseLines = baselinedata;
    matdata(block).thinkingPeriodes = NIRSdata;
    matdata(block).questionLabels = classlabel;
    matdata(block).sRate = nirs_data.fs;
    matdata(block).ChannelLabels = chanName;
    
    %% Save data
    if strcmpi(p.Results.save,'on')
        saveName = p.Results.saveName;
        if isempty(p.Results.outpath)
            outpath = blockpath;
        else
            outpath = p.Results.outpath;
        end
        if ~exist(outpath,'dir')
            mkdir(outpath)
        elseif exist(fullfile(outpath,[saveName '.mat']),'file')
            numSavedFiles = length(dir(fullfile(outpath,[saveName '*.mat'])));
            saveName = [saveName '_' num2str(numSavedFiles+1)]; 
        end
        dataRecived = matdata(block);
        save(fullfile(outpath,saveName),'dataRecived');
        fprintf('Data saved in: %s\n',outpath);
    end
end
end