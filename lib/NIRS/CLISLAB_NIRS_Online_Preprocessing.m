function [baselinCorrected] = CLISLAB_NIRS_Online_Preprocessing(wl_baseline, wl_thinking, questionLabels, channelLabels, fs, conversion_type, amplitude_correction, filteringParam, referenceForConversion)


% Modified by Giovanni start
oxydeoxyConversion = str2func(conversion_type);
baselineCorrection = str2func(amplitude_correction);
if (~isempty(filteringParam))
    filteringFunction = str2func(filteringParam.name);
end


% Conversion to oxy/deoxy (messy code for consistency with previous function) 

convertedData=[];
if isequal(conversion_type,'GIOVANNI_NIRS_LBG')
    [convertedData] = oxydeoxyConversion(wl_thinking, wl_baseline, fs, referenceForConversion);
end
if isequal(conversion_type,'CLISLAB_NIRS_LBG')
    [thinking,baseline] = oxydeoxyConversion(wl_thinking, wl_baseline,fs);
    convertedData.baselineHbo = baseline(1:size(baseline,1)/2,:,:);
    convertedData.baselineHbr = baseline(size(baseline,1)/2+1:end,:,:);
    convertedData.thinkingHbo = thinking(1:size(thinking,1)/2,:,:);
    convertedData.thinkingHbr = thinking(size(thinking,1)/2+1:end,:,:);
    
    
    % developing 4 newHybridBci start
    preproc_baseline.hbo = baseline(1:end/2,:,:);
    preproc_baseline.hbr = baseline(end/2+1:end,:,:);
    preproc_baseline.hbt = preproc_baseline.hbo+preproc_baseline.hbr;

    preproc_thinking.hbo = thinking(1:end/2,:,:);
    preproc_thinking.hbr = thinking(end/2+1:end,:,:);
    preproc_thinking.hbt = preproc_thinking.hbo+preproc_thinking.hbr;
    
    
    % developing 4 newHybridBci finish
end


% Filtering

filteredSignal = convertedData;
if (~isempty(filteringParam))
    [filteredSignal] = filteringFunction(convertedData, fs, filteringParam);    %,Wp,Ws,Rp,Rs
end


% Baseline corrections

baselinCorrected = filteredSignal;
if (~isequal(amplitude_correction, 'none'))
    [baselinCorrected,baselinesAverages]=  baselineCorrection(filteredSignal);
else
    
    
end
%% Calculating Hbt
baselinCorrected.baselineHbt = baselinCorrected.baselineHbo + baselinCorrected.baselineHbr ;
baselinCorrected.thinkingHbt = baselinCorrected.thinkingHbo + baselinCorrected.thinkingHbr ;

baselinCorrected.questionLabels = questionLabels;


baselinCorrected.channelLabels = extractBefore(string(channelLabels(1:20)),'>');

% Output Reshaping

% preproc_baseline.hbo = baselinCorrected.baselineHbo;
% preproc_thinking.hbo = baselinCorrected.thinkingHbo;
% preproc_baseline.hbr = baselinCorrected.baselineHbr;
% preproc_thinking.hbr = baselinCorrected.thinkingHbr;
% preproc_baseline.hbt = preproc_baseline.hbo+preproc_baseline.hbr;  
% preproc_thinking.hbt = preproc_thinking.hbo+preproc_thinking.hbr;

% Modified by Giovanni finish



% 
% % Conversion to oxy/deoxy (messy code for consistency with previous function) 
% convertedData=[];
% switch  conversion_type
%     
%     case 'CLISLAB_NIRS_LBG'
%         
%         [od_thinking, od_baseline] = oxydeoxyConversion(wl_thinking, wl_baseline,fs);
%         
%         convertedData.baselineHbo = od_baseline(1:end/2,:,:);
%         convertedData.baselineHbr = od_baseline(end/2+1:end,:,:);
%         convertedData.thinkingHbo = od_thinking(1:end/2,:,:);
%         convertedData.thinkingHbr = od_thinking(end/2+1:end,:,:);
%         
%         
%     case 'GIOVANNI_NIRS_LBG'
%         
%         [convertedData] = oxydeoxyConversion(wl_thinking, wl_baseline,fs);
%         
%         
% end


% %%
% % Some trials
% close all
% l1=length(preproc_baseline.hbo(1,:,1));
% l2=length(preproc_thinking.hbo(1,:,1));
% figure
% plot([preproc_baseline.hbo(1,:,1),zeros(1,10),preproc_thinking.hbo(1,:,1)])
% hold on
% plot([preproc_baseline.hbr(1,:,1),zeros(1,10),preproc_thinking.hbr(1,:,1)])
% plot([oxy_baselineGiovanni(1,:,1),zeros(1,10),oxy_thinkingGiovanni(1,:,1)])
% plot([deoxy_baselineGiovanni(1,:,1),zeros(1,10),deoxy_thinkingGiovanni(1,:,1)])
% legend('Old preprocessing  Hbo','Old preprocessing  Hbr','New preprocessing  Hbo','New preprocessing  Hbr')
% 
% 
% % After filtering
% 
% %Low pass filter the activation signal
% 
% lk = 0.5*2/fs;
% 
% %butterworth filter of 3rd order
% [m,n]=butter(3,lk,'low');
% 
% filteredBaselineHbo =    filtfilt(m,n,oxy_baselineGiovanni(1,:,1));
% filteredBaselineHbr =    filtfilt(m,n,deoxy_baselineGiovanni(1,:,1));
% filteredTaskPeriodHbo =    filtfilt(m,n,oxy_thinkingGiovanni(1,:,1));
% filteredTaskPeriodHbr =    filtfilt(m,n,deoxy_thinkingGiovanni(1,:,1));
% 
% % %Obtain the basleine
% % bl_loweWL = mean(lp_loweWL);
% % bl_highWL = mean(lp_highWL);
% 
% figure 
% plot([preproc_baseline.hbo(1,:,1),zeros(1,10),preproc_thinking.hbo(1,:,1)]) %[preproc_baseline.hbo(1,:,1),zeros(1,10),preproc_thinking.hbo(1,:,1)]
% hold on
% plot([preproc_baseline.hbr(1,:,1),zeros(1,10),preproc_thinking.hbr(1,:,1)])
% plot([filteredBaselineHbo,zeros(1,10),filteredTaskPeriodHbo])
% plot([filteredBaselineHbr,zeros(1,10),filteredTaskPeriodHbr])
% legend('Old preprocessing  Hbo','Old preprocessing  Hbr','New preprocessing  Hbo','New preprocessing Hbr')
% 
% errHbo = preproc_baseline.hbo(1,:,1) - filteredBaselineHbo -mean(preproc_baseline.hbo(1,:,1)) -mean(filteredBaselineHbo);
% errHbr = preproc_baseline.hbr(1,:,1) - filteredBaselineHbr - mean(preproc_baseline.hbr(1,:,1)) -mean(filteredBaselineHbr);
% rssHbo = errHbo*errHbo';
% rssHbor = errHbr*errHbr';
% 
% 
% 
% disp(1)