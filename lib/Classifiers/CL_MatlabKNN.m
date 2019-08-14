function [X, Y] = CL_MatlabKNN(mode, varargin)
% CL_MATLABKNN Build a k-nearest neighbor classifier using the Matlab's function
% fitcknn, or predict the labels using the function predict.
%   [MDL,ACC] = CL_MATLABKNN('classification',FEATURES,LABELS) returns the
%   KNN model and its accuracy. The function uses the automatic hyperparameters 
%   optimization.
%
%   [PRED,PROB] = CL_MATLABKNN('prediction',MODEL,FEATURES) returns the
%   prediction of the input features using the specified model and its a
%   posteriori probability.

switch mode
    case 'classification'

        features = varargin{1};
        labels = varargin{2};
        
        param_optimization = 'auto';
        param_opts = 1;

        disp('KNN Model is building...');
        h = helpdlg({'KNN Model is building...','Please wait...'},'Building model');

        % Build the SVM model
        if param_opts == 1
            mdl = fitcknn(features,labels,...
                'OptimizeHyperparameters',param_optimization,...
                'HyperparameterOptimizationOptions',struct('ShowPlots',false,'Verbose',0,'Repartition',false));
        else
            mdl = fitcknn(features,labels);
        end
        
        % Calculate crossvalidation accuracy
        CVMdl = crossval(mdl);
        kloss = kfoldLoss(CVMdl);
        accuracy = 100*(1 - kloss);

        fprintf('KNN Model is built. Estimated accuracy: %g\n', accuracy);
        close(h);
        
        X = mdl;
        Y = accuracy;
    
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