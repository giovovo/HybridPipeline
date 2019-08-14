%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                      %
% This is a code example that automatically calculates %
% hemodynamic states for N = subjs. Each subject's raw %
% data should be placed in the same folder and renamed %
% as, for example, "Subj1_wl1.txt" and "Subj1_wl2.txt" %
%                                                      %
% In the end of each for-iteration, oxy and deoxy are  % 
% saved similarly: "Subj1_oxy.txt" , "Subj1_deoxy.txt" %
% These files will also be located in the same folder. %
%                                                      %
% The original code was written by Paul Koch, BNIC2007 %
% and has been adapted by NIRx Medical Technologies.   %
% Current version (below) as of November 16th, 2016    %
%                                                      %
% Questions can be submitted to the NIRx Help Center.  %
%                                                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Number of subjects
subjs = 45;

for s=1:subjs
    
    str = ['Subj' num2str(s)];
    
    wl1 = load([str '_wl1.txt']); %load wl1
    wl2 = load([str '_wl2.txt']); %load wl2
    
    dat = [wl1 wl2];
    
    s1=size(dat,1);
    s2=size(dat,2);
    dat=dat+eps;
    
    %Baseline based on entire time series
    bl_loweWL =    mean(dat(:,1     :  s2/2));%lower Wavelength
    bl_highWL =    mean(dat(:,s2/2+1:  end));%higher Wavelength
    
    %% nirsLAB Filter
    raw_data = dat;
    
    filterparameters.filter_type = 3; %Low-Pass = 1; High-Pass = 2; Band-Pass = 3; No Filter = 4
    filterparameters.SamplingRate = 7.8125; %Sampling Frequency
    filterparameters.cutoff_frequency = [0.01 0.2]; %Filtering Band
    filterparameters.widthdrop = [15 15]; %Roll-off width
    
    filtered_data = x_filteringData(raw_data,filterparameters);
    %The function above is available within nirsLAB as .p script
    
    dat=filtered_data+dmean;
    
    %% Butterworth Filter
    % raw_data = dat;
    %
    % dmean=repmat(mean(raw_data,1),size(raw_data,1),1);
    % raw_data=raw_data-dmean;
    %
    % order = 4;
    % cutoff = [0.01 0.2];
    % Fs = 62.5/16; %sampling frequency
    % [a,b] = butter(order/2,cutoff./(Fs/2));
    % filtered_data = filtfilt(a,b,dat);
    %
    % dat=filtered_data+dmean;
    %%
    
    lp_highWL = dat(:,s2/2+1:end);
    lp_loweWL = dat(:,1:s2/2);
    
    %Initialize variables
    Att_highWL = zeros(s1,s2/2);
    Att_loweWL = zeros(s1,s2/2);
    oxy = zeros(s1,s2/2);
    deoxy = zeros(s1,s2/2);
    
    %Optical Density Computation
    for i=1:s2/2
        Att_highWL(:,i)= real(-log( lp_highWL(:,i) / bl_highWL(1,i) ))    ;
        Att_loweWL(:,i)= real(-log( lp_loweWL(:,i) / bl_loweWL(1,i) ))    ;
        C= [Att_highWL;Att_loweWL];
    end
    
    A=C;
    
    %Absorption Coefficients
    e = [2.5264 1.7986; %850nm-oxy ; 850nm-deoxy
        1.4866 3.8437]; %760nm-oxy ; 760nm-deoxy
    
    %Differential Pathlength Factor
    DPF = [6.38 7.25]; %Essenpreis et al 1993 - 850nm and 760nm, respectively
    %Alternative calculation: https://www.ncbi.nlm.nih.gov/pubmed/24121731
    
    %Inter-optode distance (mm)
    Loptoddistance  = 30;
    
    %modified Beer-Lambert Law
    e=e/10;
    e2=   e.* [DPF' DPF']  .*  Loptoddistance;
    
    B = A;
    clear A
    
    %Compute oxy and deoxy
    for i=1:s1
        A(1,:) = B(i,:); A(2,:) = B(s1+i,:);
        c= ( inv(e2)*A  )' ;
        oxy(i,:)       =c(:,1)'; %in mmol/l
        deoxy(i,:)       =c(:,2)'; %in mmol/l
    end
    
    %Save hemodynamic states for subject 's'
    save([str '_oxyhb.txt'],'oxy','-ASCII');
    save([str '_deoxyhb.txt'],'deoxy','-ASCII');
    
    clear all;

end