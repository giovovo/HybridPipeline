function features = CLISLAB_Andres_FeaturesDimensionReduction(features, K)
% minimum Redundance-Maximum Relevance algorithm, adapted (by AT) to work with continous (instead of discretized) data. 
% Modified and optimized by AJG,
% Input arguments:
% features.features:           N*M matrix, indicating N trials, each having M features. Must be integers
% features.classLabels:        N*1 vector, indicating the class/category of each N trial. Must be categorical
% features.featuresLabels:     M*3 matrix, indicating the labels identifying each of the extracted feature 
% K:                           The number of features to select, to be determined by the user
% This Features Dimension Reduction funcion is based on the mRMR recursive
% algorithm writen by Hanchuan Peng, but using the Kernel estimate for
% (Conditional) Mutual Information writen by Mikhail
% (https://de.mathworks.com/matlabcentral/fileexchange/30998-kernel-estimate-for-conditional-mutual-information)
% Kernel Mutual Information. This function depends in three auxiliary
% functions stored in "\HybridBCI\ext\KernelMI".
 
% Directory with the auxiliary functions needed for "kernelmi"
addpath(['KernelMI']);

% If there is no K argument, this is the number of features to be selected by the algorithm
if nargin < 2
    K = 15;
end

% Calling the main function of  mRMR
index_selected_features = mRMR(features.features, features.classLabels, features.featuresLabels,K);

% Substituting the actual "features" structure, by the selected shortened version
features.features = features.features(:,index_selected_features);
features.featuresLabels = features.featuresLabels(index_selected_features,:);

end


% Main function of minimum Redundance-Maximum Relevance
function index_selected_features = mRMR(feature_data,class_labels,features_Labels,K)

    number_trials = size(feature_data,2);   % The number of observations (trials)
    
    % MAXIMUM DEPENDENCY: Determining the maximum Mutual Information to start ordering the ranking
    for i=1:number_trials
        MI_values(i) = kernelmi(feature_data(:,i)', class_labels');
    end

    [~, MI_values_indexes] = sort(-MI_values);

    index_selected_features(1) = MI_values_indexes(1);          % The first Feature according to his MI value
    KMAX = min(1000,number_trials);                             % The mRMR limits the analysis to 1000 features if necessary
    MI_values_indexes_short = MI_values_indexes(2:KMAX);
    
    
    % For the feature ranked as first by MI
    % According to the algorithm, the feature with maximum Mutual Information with the classes is the first in the ranking
    first_feature = 1;                      
    k = 1;
    if first_feature == 1
        fprintf('k = 1; Current Selected Feature: %d; Type of Feature: %s, %s, %s\n', ...
            index_selected_features(k), char(features_Labels{index_selected_features(k),1}), char(features_Labels{index_selected_features(k),2}), char(features_Labels{index_selected_features(k),3}));
    end
    
    
    % For the rest of ranking 2:K features 
    for k=2:K
        available_features = length(MI_values_indexes_short);
        current_last_feature = length(index_selected_features);
        
        for i=1:available_features
            % RELEVANCE: MI between feature-sets and classes
            relevance_MI(i) = kernelmi(feature_data(:,MI_values_indexes_short(i))', class_labels');

            % REDUNDANCY: MI between feature-sets and feature-sets                
            for j=1:size(feature_data(:,index_selected_features(current_last_feature)),2)
                MI_array(MI_values_indexes_short(i),current_last_feature) = kernelmi(feature_data(:,index_selected_features(current_last_feature))', feature_data(:,MI_values_indexes_short(i))');
            end

            redundancy_MI(i) = mean(MI_array(MI_values_indexes_short(i), :));
        end
               
        % mRMR = RELEVANCE - REDUNDANCY
        [~, index_selected_features(k)] = max(relevance_MI(1:available_features) - redundancy_MI(1:available_features));

        % Sorting the data
        temporal_index = index_selected_features(k); 
        index_selected_features(k) = MI_values_indexes_short(temporal_index); 
        MI_values_indexes_short(temporal_index) = [];

        % Displaying the 2:K ranked feature for MI
        if first_feature==1
            fprintf('k = %u; Current Selected Feature: %d; Type of Feature: %s, %s, %s\n', ...
                k, index_selected_features(k), char(features_Labels{index_selected_features(k),1}), char(features_Labels{index_selected_features(k),2}), char(features_Labels{index_selected_features(k),3}));
        end
        
    end
    
end
