%Funcion to create ChannelLabels in the .mat files, when such field does not exist
function [ChannelLabels] = including_channel_labels(patient_label, visit, day_label)
%% p11
    if strcmp(patient_label,'p11') && strcmp(visit,'v01') 
        ChannelLabels = {'R1' 'R2' 'L1'	'L2' 'Cz' 'C1' 'C2' 'EOGD' 'EOGL' 'EOGR'};
    
    elseif strcmp(patient_label,'p11') && strcmp(visit,'v02') 
        ChannelLabels = {'EOGU'	'EOGD' 'EOGR' 'EOGL' 'R1' 'R2' 'L1' 'L2' 'Cz' 'C1' 'C2'};
    
    elseif strcmp(patient_label,'p11') && strcmp(visit,'v03') 
        ChannelLabels = {'EOGU'	'EOGD' 'EOGR' 'EOGL' 'R1' 'R2' 'L1' 'L2' 'Cz' 'C1' 'C2'};    
    
    elseif strcmp(patient_label,'p11') && strcmp(visit,'v04') 
        if strcmp(day_label,'d01')
%               ChannelLabels = {'AF4' 'F2' 'F4' 'FC2' 'FC4' 'C2' 'Cz' 'Fz' 'AF3' 'F1' 'F3' 'FC1' 'FC3' 'C1' 'EOGR' 'EOGL'};    
            ChannelLabels = {'R1' 'F2' 'R2' 'FC2' 'FC4' 'C2' 'Cz' 'Fz' 'L1' 'F1' 'L2' 'FC1' 'FC3' 'C1' 'EOGR' 'EOGL'};     
        elseif strcmp(day_label,'d02') || strcmp(day_label,'d03') || strcmp(day_label,'d04')
%               ChannelLabels = {'AF4' 'F2' 'F4' 'FC2' 'FC4' 'Cz' 'Fz' 'AF3' 'F1' 'F3' 'FC1' 'FC3' 'EOGU' 'EOGD' 'EOGR' 'EOGL'};
            ChannelLabels =     {'R1'  'F2' 'F4' 'C2'  'R2'  'Cz' 'Fz' 'L1'  'F1' 'F3' 'C1'  'L2'  'EOGU' 'EOGD' 'EOGR' 'EOGL'};
        end
            
    elseif strcmp(patient_label,'p11') && strcmp(visit,'v05')
%       ChannelLabels = {'AF4' 'F2'	'F4' 'FC2' 'FC4' 'Cz' 'Fz' 'AF3' 'F1' 'F3' 'FC1' 'FC3' 'EOGU' 'EOGD' 'EOGR' 'EOGL'};    
        ChannelLabels = {'R1' 'F2'	'R2' 'C2' 'FC4' 'Cz' 'Fz' 'L1' 'F1' 'L2' 'C1' 'FC3' 'EOGU' 'EOGD' 'EOGR' 'EOGL'};    
    
    elseif strcmp(patient_label,'p11') && strcmp(visit,'v06') 
        ChannelLabels = {'F2' 'R1' 'FC2' 'R2' 'C4' 'C2' 'Cz' 'C1' 'FC1' 'L2' 'F1' 'L1' 'EOGU' 'EOGR' 'EOGL'};        
        
    elseif strcmp(patient_label,'p11') && strcmp(visit,'v07') 
%         ChannelLabels = {'F2','F4','FC2','FC4','C2','Cz','C1','FC1','FC3','F1','F3','EOGU','EOGD','EOGR','EOGL'};
        ChannelLabels = {'F2','R1','FC2','R2','C2','Cz','C1','FC1','L2','F1','L1','EOGU','EOGD','EOGR','EOGL'};
        
    elseif strcmp(patient_label,'p11') && strcmp(visit,'v08') 
%         ChannelLabels = {'F2','F4','FC2','FC4','C4','C2','Cz','C1','FC1','F3','F1','Fz','EOGR','EOGL','EOGUR','EOGDR','EOGUL','EOGDL','EOGDiagR','EOGDiagLU'};
        ChannelLabels = {'R1','F4','R2' ,'FC4','C4','C2','Cz','C1','L2' ,'F3','L1','Fz','EOGR','EOGL','EOGU', 'EOGD', 'EOGUL','EOGDL','EOGDiagR','EOGDiagLU'};
 
    elseif strcmp(patient_label,'p11') && strcmp(visit,'v09') 
%         ChannelLabels = {'C1' 'CZ','C2','F4','FC4','F3','FC3','EOGRU','EOGRD','EOGR','EOGL'};
        ChannelLabels = {'C1' 'Cz','C2','R1','R2','L1','L2','EOGU','EOGD','EOGR','EOGL'};
        
    elseif strcmp(patient_label,'p11') && strcmp(visit,'v10') 
%         ChannelLabels = {'F4', 'FC2', 'FC4', 'C2', 'Cz', 'C1', 'FC1', 'FC3', 'F3', 'EOGU', 'EOGD', 'EOGR', 'EOGL', 'EOGDUR', 'EOGDDL'};
        ChannelLabels = {'R1', 'FC2', 'R2', 'C2', 'Cz', 'C1', 'FC1', 'L2', 'L1', 'EOGU', 'EOGR', 'EOGL', 'EOGD', 'EOGDUR', 'EOGDDL'}; %Warning, wrong labeling in Raw
   
%% p13  
    elseif strcmp(patient_label,'p13') && strcmp(visit,'v01') 
        ChannelLabels = {'EOGU', 'EOGD', 'EOGR', 'EOGL', 'R1', 'R2', 'L1', 'L2', 'Cz', 'C1', 'C2'}; 

    elseif strcmp(patient_label,'p13') && strcmp(visit,'v02') 
        ChannelLabels = {'EOGU', 'EOGD', 'EOGR', 'EOGL', 'R1', 'R2', 'L1', 'L2', 'Cz', 'C1', 'C2', 'Fz', 'C4', 'EMG1', 'EMG2'};
        
    elseif strcmp(patient_label,'p13') && strcmp(visit,'v03') 
        if strcmp(day_label,'d01')
%             ChannelLabels = {'EOGRU','EOGRD','EOGRH','EOGLH','C1',  'CZ',  'C2',  'AF3',   'F3',    'AF4',   'F4',     'EMG1','EMG2'};
            ChannelLabels = {'EOGU', 'EOGD', 'EOGR', 'EOGL', 'C1',  'Cz',  'C2',  'L1',    'L2',    'R1',    'R2',     'EMG1', 'EMG2'}; 

        elseif strcmp(day_label,'d02') || strcmp(day_label,'d03') || strcmp(day_label,'d04')
%             ChannelLabels = {'L1','L2','C1','CZ','C2','R1','R2','EOGRU','EOGRD','EOGRH','EOGLH'};
            ChannelLabels = {'L1','L2','C1','Cz','C2','R1','R2','EOGU','EOGD','EOGR','EOGL'};
        end
    elseif strcmp(patient_label,'p13') && strcmp(visit,'v04')
        %         ChannelLabels = {'AF3', 'F3', 'C1', 'Cz', 'C2', 'F4', 'AF4', 'EOGRU',  'EOGRH',  'EOGRD', 'EOGLH'}; 
        ChannelLabels = {'L1', 'L2', 'C1', 'Cz', 'C2', 'R2', 'R1', 'EOGU',  'EOGR',  'EOGD', 'EOGL'}; 

%% p15  
    elseif strcmp(patient_label,'p15') && strcmp(visit,'v00') 
        ChannelLabels = {'EOGUL', 'EOGDL', 'EOGU',  'EOGD',  'EOGL', 'EOGR',  'EMG1', 'EMG2', 'C1', 'Cz', 'C2', 'R2', 'R1', 'L2', 'L1', 'Fpz'}; 
        
    elseif strcmp(patient_label,'p15') && strcmp(visit,'v01') 
        if strcmp(day_label,'d01')  
            ChannelLabels =   {'R1',   'R2',   'C1', 'Cz', 'C2',  'L1',    'L2',    'EOGU',     'EOGD',    'EOGR',    'EOGL'}; 
%             ChannelLabels = {'AFF2', 'FFC2', 'C1', 'Cz', 'C2',  'AFF1',  'FCC1',  'EOGRU',    'EOGRD',    'EOGRH',    'EOGLH'}; 
        elseif strcmp(day_label,'d02') || strcmp(day_label,'d03') || strcmp(day_label,'d04') 
            ChannelLabels =   {'L1',   'L2',   'C1', 'Cz', 'C2',  'R1',    'R2',    'EOGU',     'EOGD',    'EOGR',    'EOGL'}; 
        end
        
    elseif strcmp(patient_label,'p15') && strcmp(visit,'v02')
%         ChannelLabels = {'AF3', 'F3', 'C1', 'Cz', 'C2', 'F4', 'AF4', 'EOGRU',  'EOGRH',  'EOGRD', 'EOGLH'}; 
        ChannelLabels = {'L1', 'L2', 'C1', 'Cz', 'C2', 'R2', 'R1', 'EOGU',  'EOGR',  'EOGD', 'EOGL'}; 

 %% p16 
    elseif strcmp(patient_label,'p16') && strcmp(visit,'v00') 
        ChannelLabels = {'C1', 'Cz', 'C2', 'R1', 'R2', 'L1', 'L2', 'EOGU', 'EOGD', 'EOGR',  'EOGL'}; 
        
    elseif strcmp(patient_label,'p16') && strcmp(visit,'v01') 
        ChannelLabels =  {'L1','L2','C1','Cz','C2','R1','R2','EOGU','EOGD','EOGR','EOGL'};
    
    elseif strcmp(patient_label,'p16') && strcmp(visit,'v02') 
%         ChannelLabels = {'C1', 'Cz', 'C2', 'AF3', 'F3',  'AF4', 'F4', 'EOGRU',  'EOGRD',  'EOGRH', 'EOGLH'}; 
        ChannelLabels = {'C1', 'Cz', 'C2', 'L1', 'L2',  'R1', 'R2', 'EOGU',  'EOGD',  'EOGR', 'EOGL'}; 
             
 %%% Empty case 
    else
        ChannelLabels = [];
    end                     

end
       