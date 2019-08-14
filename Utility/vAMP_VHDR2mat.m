function matdata = vAMP_VHDR2mat(input_path, file_name)
%% Convert vAMP data to mat variable or file in the newHybridBCI format

%% Load vhdr file(s)

% eeglab
eegdata = pop_loadbv(input_path, file_name);

%% Preallocate the structure

% num_files = length(all_file);
num_files = 1;

matdata = struct('baseLines',cell(1,num_files),...
    'thinkingPeriodes',cell(1,num_files),...
    'questionLabels',cell(1,num_files),...
    'sRate', cell(1,num_files),...
    'ChannelLabels',cell(1,num_files));

%%
%Moving through eegdata.event.latency to get the datapoints of the different triggers
vector_onset = zeros(1,eegdata.pnts);
for j = 1:length(eegdata.event)
    %Asigning the amplitud of the trigger to the vector_onset vector
    vector_onset(eegdata.event(j).latency) = str2double(eegdata.event(j).type(2:end));
end

startindex = find(strcmp({eegdata.event.type},'boundary'));
startpoint = eegdata.event(startindex(end)).latency;

% eeg.onset has all the information of the triggers as amplitud points
eeg_data.vector_onset = vector_onset(startpoint:end);
trig_all = eeg_data.vector_onset;

% TRIGGER
% start:    9
%           yes     no      open
% baseline: 10      11      12
% present.: 5       6       7
% answer:   4       8       13
% feedback: 1       2       3
%
% end:      15

trig_start = find(eeg_data.vector_onset == 9);
trig_end = find(eeg_data.vector_onset == 15);
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

% To include the triggers as a field in the output structure
matdata.index.start         = trig_start;
matdata.index.baseline      = index_baseline';
matdata.index.presentation  = index_presenta';
matdata.index.thinking      = index_answer';
matdata.index.feedback      = index_feedback';
matdata.index.end           = trig_end;


if ~isequal(length(index_baseline),length(index_presenta),length(index_answer),length(index_feedback))
    warning([blockpath ': Wrong number of triggers:'...
        ' bl: ' num2str(length(index_baseline)) ...
        ', pr: ' num2str(length(index_presenta)) ...
        ', an: ' num2str(length(index_answer)) ...
        ', fb: ' num2str(length(index_feedback))])
%     continue
end

length_seconds_baseline = round(min(index_presenta-index_baseline)/eegdata.srate);
length_seconds_thinking = round(min(index_feedback-index_answer)/eegdata.srate);
length_datapoints_baseline = length_seconds_baseline*eegdata.srate;
length_datapoints_thinking = length_seconds_thinking*eegdata.srate;

num_questions = length(index_baseline);
bl_data = zeros(size(eegdata.data,1),length_datapoints_baseline,num_questions);
th_data = zeros(size(eegdata.data,1),length_datapoints_thinking,num_questions);
baselinelabel = zeros(1,num_questions);
datlabel = zeros(1,num_questions);
classlabel = zeros(1,num_questions);

for q = 1:num_questions
    bl_data(:,:,q) = eegdata.data(:,index_baseline(q):index_baseline(q)+length_datapoints_baseline-1);
    th_data(:,:,q) = eegdata.data(:,index_answer(q):index_answer(q)+length_datapoints_thinking-1);
    baselinelabel(q) = trig_all(index_baseline(q));
    datlabel(q) = trig_all(index_answer(q));
    classlabel(q) = all_classLabels(trig_answer==datlabel(q));
end
 
% To include the complete non-segmented data from the session
matdata.continuousData = eegdata.data; % waveLength_1 and waveLength_2

matdata.baseLines = bl_data;
matdata.thinkingPeriodes = th_data;
matdata.questionLabels = classlabel;
matdata.sRate = eegdata.srate;
matdata.ChannelLabels(:) = {eegdata.chanlocs(:).labels};

end


