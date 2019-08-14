function [patient,visit,day,block,isFb,model] = Model_xls2str(file,sheet)

p = inputParser;


addRequired(p,'file',@ischar);
addOptional(p,'sheet','',@ischar);

parse(p,file,sheet)

% Read xls file
[~,t,~] = xlsread(p.Results.file,p.Results.sheet);
% Remove header
header = t(1,:);
t(1,:) = [];

% Find feedback blocks
isFb = contains(t(:,6),'feedback','IgnoreCase',true) & ~contains(t(:,6),'text','IgnoreCase',true);

% Retrieve patient
patient = t(:,1);
patient = fillEmptyCells(patient);
patient = regexprep(patient,'p','');
patient = cellfun(@str2num,patient,'un',0);
patient = cell2mat(patient);

% Retrieve visits
visit = t(:,2);
visit = fillEmptyCells(visit);
visit = regexprep(visit,'v','');
visit = cellfun(@str2num,visit,'un',0);
visit = cell2mat(visit);

% Retrieve days
day = t(:,3);
day = fillEmptyCells(day);
day = regexprep(day,'d','');
day = cellfun(@str2num,day,'un',0);
day = cell2mat(day);

% Extract blocks
block = t(:,4);
block = lower(block);
block = regexprep(block,'b','');
block = cellfun(@str2num,block,'un',0);
block = cell2mat(block);

% Extract models
model = t(:,8);

end

function y = fillEmptyCells(x)
y = x;
last = '';
for i = 1:length(x)
    if isempty(x{i})
        y{i} = last;
    else
        last = y{i};
    end
end
end