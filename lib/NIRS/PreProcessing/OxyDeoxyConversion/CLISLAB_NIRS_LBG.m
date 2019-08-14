function [od_thinking, od_baseline] = CLISLAB_NIRS_LBG(wl_thinking, wl_baseline,fs)

% CLISLAB_NIRS_LBG Converts wavelength data to oxy and deoxy 
%   
% WL_THINKING = channelXtimepointsXtrials
% WL_baseline = channelXtimepointsXtrials

if nargin < 2
    wl_baseline = zeros(size(wl_thinking));
end
ni.wl = [850 760]; %inverted the values (2017-11-14)
ni.LBsf = fs;
ni.LBodistance= 30; %changed from 3 to 30 (2017-11-14)
ni.LBlpfreq= 0.5;
ni.LBdpf= [5.9800 7.1500];
ni.LBepsilon = [2.5264    1.7986; 1.4866 3.8437]; %inverted the rows (2017-11-14)
ni.LBmode=1;

if size(wl_thinking,3) ~= size(wl_baseline,3)
    error('Different number of trials in thinking and baseline');
end
od_thinking = onlineLBG(wl_thinking, ni);
od_baseline = onlineLBG(wl_baseline, ni);

end



function oxydeo =onlineLBG(dat,param)

%         calculate OD/Intensity and concentration changes
%----------------------------------------------------------------
% fun:     u_LBG / u_popLBG
%
%
%----------------------------------
%            function
%----------------------------------
%    [inter-optode distance]          : between S&D in cm
%    [baseline]             : In the online version, the activation is
%    computed with all the given points. That means that only those desired
%    to be in the baseline should be given
%    [select from spectrum] : select source of absorbtion-coefficients/epsilon
%       ->the absorbtion coefficients are plottet below (epsilon of oxy-Hb / deoxy-Hb)
%    NOTE     : if not indicated before : select specific wavelengths before selecting a spectrum
%    [DPF]    : select DP-factor (essenpreis)
%
%=======================================================================
%                                                      Paul, BNIC 2007
%=======================================================================

% Permute the arrays in order to have timepointsXchannelsXtrials
dat = permute(dat,[2,1,3]);

%----------------------------------
%         calc concentration changes
%----------------------------------

e              =  param.LBepsilon;
DPF            =  param.LBdpf;

Loptoddistance  =  param.LBodistance;
lpfreq          =  param.LBlpfreq;
sf              =  param.LBsf;

%----------------------------------
%      1. split data to lower and higher wavelength
%----------------------------------

s1=size(dat,1);
s2=size(dat,2);
s3 = size(dat,3);

dat=dat+eps;
dat = double(dat);

%Low pass filter the activation signal

lk = lpfreq*2/sf;

%butterworth filter of 3rd order
[m,n]=butter(3,lk,'low');

lp_loweWL=    filtfilt(m,n,(dat(:,1:s2/2,:)));
lp_highWL=    filtfilt(m,n,(dat(:,s2/2+1:end,:)));

%Obtain the basleine
bl_loweWL = mean(lp_loweWL);
bl_highWL = mean(lp_highWL);

flag = isfield(param,'LBmode');
%----------------------------------
%       2.OD
%----------------------------------


normHighWL = lp_highWL ./ bl_highWL;
normlowWL = lp_loweWL ./ bl_loweWL;

Att_highWL= real(-log( normHighWL ))    ; %changed to natural log (2017-11-14)
Att_loweWL= real(-log( normlowWL ))    ; %changed to natural log (2017-11-14)
A = zeros(size(dat));
A(:,1:2:end,:) = Att_highWL;
A(:,2:2:end,:) = Att_loweWL;

A = permute(A,[2,1,3]);

e=e/10;
e2=   e.* [DPF' DPF']  .*  Loptoddistance;
e2inv = inv(e2);
e2inv = kron(eye(s2/2),e2inv);

cc_oxy = zeros(s1,s2/2,s3);
cc_deo = zeros(s1,s2/2,s3);
for i = 1:s3
    c.dat = e2inv*A(:,:,i) ;
    cc_oxy(:,:,i)  =c.dat(1:2:end,:)'; %in mmol/l
    cc_deo(:,:,i)  =c.dat(2:2:end,:)'; %in mmol/l
end




% Backward Abacktrafo= c/inv(e2');back to OD

%----------------------------------
%         tags
%----------------------------------

oxydeo = cat(2,cc_oxy,cc_deo);
oxydeo = permute(oxydeo,[2,1,3]);
% ni.dat=cat(2,cc_oxy,cc_deo);
% ni1.dat = [cc_oxy1 cc_deo1];
% 
% if isfield(ni,'functions')==0
%     ni.functions{1,1}=[    'ni=u_LBG(1,ni);  % calc concentration changes'];
% else
%     ni.functions{end+1,1}=[ 'ni=u_LBG(1,ni); % calc concentration changes'];
% end
% 
% if isfield(ni,'info')==0
%     ni.info{1,1}=    ['**  concentration changes calculated' ];
% else
%     ni.info{end+1,1}=['**  concentration changes calculated' ];
% end



end