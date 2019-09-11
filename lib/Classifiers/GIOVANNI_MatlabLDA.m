function [X, Y] = GIOVANNI_MatlabLDA(mode, varargin)
% GIOVANNI_MatlabLDA Build a Linear discriminant analysis using the Matlab's function
% fitcdiscr, or predict the labels using the function predict.
% [MDL,ACC] = GIOVANNI_MatlabLDA('classification',FEATURES,LABELS,classifierOptions) returns the
% LDA model and hardcoded '-1' as no model accuracy is provided. For extra paramters 
% pleas refere to "help fitcdiscr" and structure the input as follows

%       |   classifierOptions = {'OptimizeHyperparameters','auto',...
%       |   'HyperparameterOptimizationOptions', struct('AcquisitionFunctionName','expected-improvement-plus') 
%       |   };
%       |   [model,~] = classifierFunction('classification',X,Y,classifierOptions);
%       |
%       | classifierOptions = []; if no optional parameters is set


%
%   [PRED,PROB] = CL_MATLABSVM('prediction',MODEL,FEATURES) returns the
%   prediction of the input features using the specified model and its a
%   posteriori probability.

switch mode
    case 'classification'

        features = varargin{1};
        labels = varargin{2};
        options = varargin{3};
        if isempty(varargin{3})
            inputAndParameters = {features,labels};
        else
            inputAndParameters = {features,labels,options{:}};
        end
        


        disp('LDA Model is building...');
        h = helpdlg({'LDA Model is building...','Please wait...'},'Building model');

        % Build the LDA model
        mdl = fitcdiscr(inputAndParameters{:});
        
        fprintf('LDA Model is built.');
        close(h);
        
        X = mdl;
        Y = -1; % no model accuracy for LDA
    
    case 'prediction'
        
        model = varargin{1};
        features = varargin{2};
        
        [pred,prob] = predict(model,features);
        prob = max(prob,[],2);
        
        X = pred;
        Y = prob;
        
    otherwise
        error('Wrong mode: only `classification` and `prediction` are allowed');
end