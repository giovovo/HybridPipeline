function [name,mod,days,blocks] = Model_str2num(strmod)
name = [];
mod = [];
days = [];
blocks = [];

if isempty(strmod)
    return
end
strmod = lower(strmod);

% Name
name = extractBefore(strmod,':');

% Find model structure
strmod = extractBetween(strmod,':','=');
strmod = strmod{1};
strmod = strtrim(strmod);

% Find models inside structure
mod = regexp(strmod,'m[\d+\w+]','match');

% Find days
strdays = regexp(strmod,'d\d+','match');
strdays = regexprep(strdays,'d','');
days = cellfun(@str2num,strdays,'un',0);
days = cell2mat(days);

% Find blocks
strblocks = regexp(strmod,'d\d+','split');
strblocks(cellfun('isempty',strblocks)) = [];
strblocks(contains(strblocks,'m')) = [];
strblocks = extractBetween(strblocks,'(',')');
strblocks = regexprep(strblocks,'[b\+]+',' ');
blocks = cellfun(@str2num,strblocks,'un',0);