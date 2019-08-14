function [filteredSignal] = GIOVANNI_NIRS_IIR_butter_filter(inputSignal,fs,filteringParam)
%UNTITLED Butterworth filtering the input signal 
%   Please specify the mode
% mode = 'low'
% mode = 'high'
% mode = 'bandpass'
% mode = 'stop'
% fs : sample frequency [Hz]
% The filtering will have a passband ripple of no more than Rp dB and a stopband attenuation of at least Rs dB. Wp and Ws are
% the passband and stopband edge frequencies, in Hz.
%     (where 1 corresponds to pi radians/sample). For example,
%         Lowpass:    Wp = 10,      Ws = 20
%         Highpass:   Wp = 20,      Ws = 10
%         Bandpass:   Wp = [20 70], Ws = [10 80]
%         Bandstop:   Wp = [10 80], Ws = [20  70]

WpNormalized = filteringParam.passingHertz*2/fs;
WsNormalized = filteringParam.stoppingHertz*2/fs;
Rp = filteringParam.ripplePassBand;
Rs = filteringParam.rippleStopBand;
mode = filteringParam.mode;

[N, Wn] = buttord(WpNormalized, WsNormalized, Rp, Rs);
[B,A] = butter(N,Wn,mode);

baselineHbo=inputSignal.baselineHbo;
thinkingHbo=inputSignal.thinkingHbo ;
baselineHbr=inputSignal.baselineHbr;
thinkingHbr=inputSignal.thinkingHbr;


% filtfilt operates just along the first dimension > 1
filteredSignal.baselineHbo = permute(filtfilt(B, A,permute(baselineHbo,[2,1,3])),[2,1,3]);
filteredSignal.thinkingHbo = permute(filtfilt(B, A,permute(thinkingHbo,[2,1,3])),[2,1,3]);
filteredSignal.baselineHbr = permute(filtfilt(B, A,permute(baselineHbr,[2,1,3])),[2,1,3]);
filteredSignal.thinkingHbr = permute(filtfilt(B, A,permute(thinkingHbr,[2,1,3])),[2,1,3]);

% baselineHboFiltered= zeros(size(baselineHbo));
% thinkingHboFiltered= zeros(size(thinkingHro));
% baselineHbrFiltered= zeros(size(baselineHbr));
% thinkingHbrFiltered= zeros(size(thinkingHbr));
% 
% sdfdf
% 
% 
% for i = 1: size(baselineHbo,1)
%     
%     for j = 1: size(baselineHbo,3)
%         baselineHboFiltered(i,:,j) = filtfilt(B, A, baselineHbo);
%         thinkingHboFiltered(i,:,j) = filtfilt(B, A, thinkingHbo);
%         baselineHbrFiltered(i,:,j) = filtfilt(B, A, baselineHbr);
%         thinkingHbrFiltered(i,:,j) = filtfilt(B, A, thinkingHbr);
%     end
%     
% end
% filteredSignal.baselineHbo = baselineHboFiltered;
% filteredSignal.thinkingHbo = thinkingHboFiltered;
% filteredSignal.baselineHbr = baselineHbrFiltered;
% filteredSignal.thinkingHbr = thinkingHbrFiltered;
% 
% 




%% Assertion maybe not needed
% if (isequal(mode , 'Lowpass') || isequal(mode , 'Highpass'))
%     if(length(Wp)~=1 || length(Ws)~=1)
%         warning('Check the mode and the cutoff size')
%     end
% end
% if (isequal(mode , 'Bandpass') || isequal(mode , 'Bandstop'))
%     if(length(Wp)~=2 || length(Ws)~=2)
%         warning('Check the mode and the cutoff size')
%     end
%     if (isequal(mode , 'Bandpass') && Wp(1)>Wp(2))
%         error('Inconsistent mode/cutoffs design')
%     end
%     if (isequal(mode , 'Bandpass') && Wp(1)>Wp(2))
%         error('Inconsistent mode/cutoffs design')
%     end
% end

