function [allNirs,bl,th,ql,fs,ch] = NIRS_nirs2mat(dc,t,allonset,condName,SD,t_bl,t_th)

if nargin < 6
    t_bl = 15;
    t_th = 15;
end
% Calculate fs based on time vector
fs = 1/t(2);

% Create channel names
ml = SD.MeasList;
ml(:,3) = [];
ml(:,3) = SD.Lambda(ml(:,3));

ch = join(string(ml),{'-',' '});
ch = cellstr(ch)';

% Trigger number
bl_y = 10;
bl_n = 11;
bl_o = 12;
pr_y = 5;
pr_n = 6;
pr_o = 7;
th_y = 4;
th_n = 8;
th_o = 13;
fb_y = 1;
fb_n = 2;
fb_o = 3;

% Find index trigger
numName = extractAfter(condName,1);
numName = string(numName);
numName = str2double(numName);

% Create onset
[r,c] = find(allonset);
onset = zeros(1,size(allonset,1));
onset(r) = numName(c);
onset = onset';

% Find index trigger in onset
i_bl_y = find(onset==bl_y);
i_bl_n = find(onset==bl_n);
i_bl_o = find(onset==bl_o);
i_th_y = find(onset==th_y);
i_th_n = find(onset==th_n);
i_th_o = find(onset==th_o);
i_pr_y = find(onset==pr_y);
i_pr_n = find(onset==pr_n);
i_pr_o = find(onset==pr_o);
i_fb_y = find(onset==fb_y);
i_fb_n = find(onset==fb_n);
i_fb_o = find(onset==fb_o);

if length(i_bl_y)+length(i_bl_n)+length(i_bl_o) ~= length(i_th_y)+length(i_th_n)+length(i_th_o)
 bl = [];
 th = [];
 ql = [];
 fs = [];
 ch = [];
 return
end

% If no information about the timing, estimate it from the onset
if t_bl == 0 || t_th == 0

    t_bl = [t(onset==pr_y)-t(onset==bl_y) ...
        t(onset==pr_n)-t(onset==bl_n)...
        t(onset==pr_o)-t(onset==bl_o)];
    t_bl = mean(t_bl);
    
    t_th = [t(onset==fb_y)-t(onset==th_y) ...
        t(onset==fb_n)-t(onset==th_n)...
        t(onset==fb_o)-t(onset==th_o)];
    t_th = mean(t_th);
end

% Calculate number of sample for bl and th

nsample_bl = floor(t_bl*fs)+1;
nsample_th = floor(t_th*fs)+1;

% Extract the baseline data and determine the question_label
bl_hbo = [];
bl_hbr = [];
all_bl = [i_bl_y; i_bl_n; i_bl_o];
all_bl = sort(all_bl);

ql = zeros(1,length(all_bl));

for i = 1:length(all_bl)
    data = dc(all_bl(i):all_bl(i)+nsample_bl,:,:);
    bl_hbo = cat(3,bl_hbo,squeeze(data(:,1,:)));
    bl_hbr = cat(3,bl_hbr,squeeze(data(:,2,:)));
    if ismember(all_bl(i),i_bl_y)
        ql(i) = 1;
    elseif ismember(all_bl(i),i_bl_n)
        ql(i) = 0;
    else
        ql(i) = 2;
    end
end
bl_hbo = permute(bl_hbo,[2,1,3]);
bl_hbr = permute(bl_hbr,[2,1,3]);
bl = cat(1,bl_hbo,bl_hbr);

% Extract the thinking data and check the question_label
th_hbo = [];
th_hbr = [];
all_th = [i_th_y;i_th_n;i_th_o];
all_th = sort(all_th);

for i = 1:length(all_th)
    data = dc(all_th(i):all_th(i)+nsample_th,:,:);
    th_hbo = cat(3,th_hbo,squeeze(data(:,1,:)));
    th_hbr = cat(3,th_hbr,squeeze(data(:,2,:)));
    if ismember(all_th(i),i_th_y) && ql(i) ~= 1
        warning(['ql(' num2str(i) ')=' num2str(ql(i)) ': Wrong question label'])
    elseif ismember(all_th(i),i_th_n) && ql(i) ~= 0
        warning(['ql(' num2str(i) ')=' num2str(ql(i)) ': Wrong question label'])
    elseif ismember(all_th(i),i_th_o) && ql(i) ~= 2
        warning(['ql(' num2str(i) ')=' num2str(ql(i)) ': Wrong question label'])
    end
end
th_hbo = permute(th_hbo,[2,1,3]);
th_hbr = permute(th_hbr,[2,1,3]);
th = cat(1,th_hbo,th_hbr);

allNirs.baseLines = bl;
allNirs.thinkingPeriodes = th;
allNirs.questionLabels = ql;
allNirs.sRate = fs;
allNirs.ChannelLabels = ch;

