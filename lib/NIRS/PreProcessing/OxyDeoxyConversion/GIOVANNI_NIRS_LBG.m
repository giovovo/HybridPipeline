function [convertedData] = GIOVANNI_NIRS_LBG(wl_thinking, wl_baseline,fs)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                      %
% The original code was written by Paul Koch, BNIC2007 %
% and has been adapted by NIRx Medical Technologies.   %
% Current version (below) as of November 16th, 2016    %
%                                                      %
% Questions can be submitted to the NIRx Help Center.  %
%                                                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Modified by Giovanni

% The Lambert beer law doesn't allow to calculate absolute values of
% Hbo/Hbr concentration, but just a difference of concentration instead.
% For this reason a "baseline" must be chosen as a reference. In this
% function  the average values of "wl_baseline"are chosen as reference for
% both the resting state and the task period. The output values are thus 
% intended as difference of concentration from the above mentioned
% reference.

% define param
taskLength = size(wl_thinking,2);
baselineLength = size(wl_baseline,2);

% preallocations

oxy_baselineGiovanni = zeros(size(wl_thinking,1)/2,size(wl_thinking,2),size(wl_thinking,3));
deoxy_baselineGiovanni = zeros(size(wl_thinking,1)/2,size(wl_thinking,2),size(wl_thinking,3));
oxy_thinkingGiovanni = zeros(size(wl_thinking,1)/2,size(wl_thinking,2),size(wl_thinking,3));
deoxy_thinkingGiovanni = zeros(size(wl_thinking,1)/2,size(wl_thinking,2),size(wl_thinking,3));


for currentTrial = 1 : size(wl_thinking,3)
    
    
    %currentTrial =1;
    % Data rearranged as timepoints ( base + task period) X channels ([w1, w2])
    % X trials
    wholeDataRearranged = [permute(wl_baseline,[2,1,3])  ;permute(wl_thinking,[2,1,3])];
    dat =wholeDataRearranged(:,:,currentTrial);
    s1=size(dat,1);
    s2=size(dat,2);
    dat=dat+eps;
    
    
    %Baseline based on entire time series
    
    bl_loweWL =    mean(dat(:,1     :  s2/2));%lower Wavelength
    bl_highWL =    mean(dat(:,s2/2+1:  end));%higher Wavelength
    
    %Giovanni changed reference start Now using only the basline as common
    %reference trial-wise
    
    bl_loweWL =    mean(dat(1:s1/2,1     :  s2/2));%lower Wavelength
    bl_highWL =    mean(dat(1:s1/2,s2/2+1:  end));%higher Wavelength
    
    %Giovanni changed reference finished
    
    
    notFiltered_highWL = dat(:,s2/2+1:end);
    notFiltered_loweWL = dat(:,1:s2/2);
    
    %Initialize variables
    Att_highWL = zeros(s1,s2/2);
    Att_loweWL = zeros(s1,s2/2);
    oxy = zeros(s1,s2/2);
    deoxy = zeros(s1,s2/2);
    
    %Optical Density Computation
    %Tring with a constant start
     %bl_highWL(1,:) = ones(size( bl_highWL(1,:)));
     %bl_loweWL(1,:) = ones(size( bl_loweWL(1,:)));
    %Tring with a constant finish
    for i=1:s2/2
        Att_highWL(:,i)= real(-log( notFiltered_highWL(:,i) / bl_highWL(1,i) ))    ;
        Att_loweWL(:,i)= real(-log( notFiltered_loweWL(:,i) / bl_loweWL(1,i) ))    ;
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
    
    oxy_baselineGiovanni(:,1:baselineLength,currentTrial) = oxy(1:baselineLength,:)';
    deoxy_baselineGiovanni(:,1:baselineLength,currentTrial) = deoxy(1:baselineLength,:)';
    oxy_thinkingGiovanni(:,1:taskLength,currentTrial) = oxy(baselineLength+1:end,:)'; 
    deoxy_thinkingGiovanni(:,1:taskLength,currentTrial) = deoxy(baselineLength+1:end,:)'; 
 
    
end

convertedData.baselineHbo = oxy_baselineGiovanni;
convertedData.thinkingHbo = oxy_thinkingGiovanni;
convertedData.baselineHbr = deoxy_baselineGiovanni;
convertedData.thinkingHbr = deoxy_thinkingGiovanni;
%%convertedData.baselineHbt = oxy_baselineGiovanni + deoxy_baselineGiovanni;
%%convertedData.thinkingHbt = oxy_thinkingGiovanni + deoxy_thinkingGiovanni;


 

end