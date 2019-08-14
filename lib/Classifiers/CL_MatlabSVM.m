function [X, Y] = CL_MatlabSVM(mode, varargin)
% CL_MATLABSVM Build a support vector machine using the Matlab's function
% fitcsvm, or predict the labels using the function predict.
%   [MDL,ACC] = CL_MATLABSVM('classification',FEATURES,LABELS) returns the
%   SVM model and its accuracy. The function uses the automatic
%   hyperparameters optimization.
%
%   [PRED,PROB] = CL_MATLABSVM('prediction',MODEL,FEATURES) returns the
%   prediction of the input features using the specified model and its a
%   posteriori probability.

switch mode
    case 'classification'

        features = varargin{1};
        labels = varargin{2};
        
        param_opts = 1;
        
        param_optimization = 'auto';

        disp('SVM Model is building...');
        h = helpdlg({'SVM Model is building...','Please wait...'},'Building model');

        % Build the SVM model
        if param_opts == 1
            mdl = fitcsvm(features,labels,...
                'OptimizeHyperparameters',param_optimization,...
                'HyperparameterOptimizationOptions',struct('ShowPlots',false,'Verbose',0,'Repartition',false));
        else
            mdl = fitcsvm(features,labels);
        end
        % Calculate Score Transform to estimate the probability
        model = fitSVMPosterior(mdl);

        loss = resubLoss(model);
        accuracy = 100*(1 - loss);
        
        fprintf('SVM Model is built. Estimated accuracy: %g\n', accuracy);
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