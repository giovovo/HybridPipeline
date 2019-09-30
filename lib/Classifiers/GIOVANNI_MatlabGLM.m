function [X, Y] = GIOVANNI_MatlabGLM(mode, varargin)
% GIOVANNI_MatlabRANDOMFOREST Generalized linear regression model using the Matlab's function
% fitglm, or predict the labels using the function predict.
% [MDL,~] = GIOVANNI_MatlabGLM('classification',FEATURES,LABELS) returns the
% BaggTree model and hardcoded '-1' as no model accuracy is provided. For extra paramters 
% please refere to "help fitglm" and structure the input as follows.

%       |   classifierOptions = {numberOfTree,...
%       |   'OOBPrediction','On',...
%       |   'Surrogate','on'
%       |   };
%       |   [model,~] = classifierFunction('classification',X,Y,classifierOptions);
%       |
%       | classifierOptions = []; if no optional parameters is set


%
%   [PRED,PROB] = GIOVANNI_MatlabGLM('prediction',MODEL,FEATURES) returns the
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
        


        disp('GLM is building...');
        %h = helpdlg({'GLM is building...','Please wait...'},'Building model');

        % Build the LDA model
        mdl = fitglm(inputAndParameters{:});
        
        fprintf('GLM is built.');
        %close(h);
        
        X = mdl;
        Y = -1; % no model accuracy
    
    case 'prediction'
        
        model = varargin{1};
        features = varargin{2};
        
        [pred,prob] = predict(model,features);
        %pred = cell2mat(pred) == '1';
        prob = max(prob,[],2);
        
        X = pred;
        Y = prob;
        
    otherwise
        error('Wrong mode: only `classification` and `prediction` are allowed');
end