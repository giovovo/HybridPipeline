function [X, Y] = GIOVANNI_MatlabRANDOMFOREST(mode, varargin)
% GIOVANNI_MatlabRANDOMFOREST Build Bootstrap-aggregated (bagged) decision trees model using the Matlab's function
% TreeBagger, or predict the labels using the function predict.
% [MDL,~] = GIOVANNI_MatlabRANDOMFOREST('classification',FEATURES,LABELS) returns the
% BaggTree model and hardcoded '-1' as no model accuracy is provided. For extra paramters 
% please refere to "help TreeBagger" and structure the input as follows.
% Please notice "numberOfTree" parameters MUST be specified

%       |   classifierOptions = {numberOfTree,...
%       |   'OOBPrediction','On',...
%       |   'Surrogate','on'
%       |   };
%       |   [model,~] = classifierFunction('classification',X,Y,classifierOptions);
%       |
%       | classifierOptions = []; if no optional parameters is set


%
%   [PRED,PROB] = GIOVANNI_MatlabRANDOMFOREST('prediction',MODEL,FEATURES) returns the
%   prediction of the input features using the specified model and its a
%   posteriori probability.

switch mode
    case 'classification'

        features = varargin{1};
        labels = varargin{2};
        options = varargin{3};
        
        if isempty(varargin{3})
            error('Number of trees must be specified as first option parameter!')
        else
            numTrees =options{1};
            options = options(2:end);
            if isempty(options)
                inputAndParameters = {features,labels};
            else
                inputAndParameters = {features,labels,options{:}};
            end
            
        end
        


        disp('TreeBagg Model is building...');
        h = helpdlg({'TreeBagg Model is building...','Please wait...'},'Building model');

        % Build the LDA model
        mdl = TreeBagger(numTrees,inputAndParameters{:});
        
        fprintf('TreeBagg Model is built.');
        close(h);
        
        X = mdl;
        Y = -1; % no model accuracy for LDA
    
    case 'prediction'
        
        model = varargin{1};
        features = varargin{2};
        
        [pred,prob] = predict(model,features);
        pred = cell2mat(pred) == '1';
        prob = max(prob,[],2);
        
        X = pred;
        Y = prob;
        
    otherwise
        error('Wrong mode: only `classification` and `prediction` are allowed');
end