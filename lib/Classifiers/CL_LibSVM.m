function [X, Y] = CL_LibSVM(mode, varargin)
% CL_LIBSVM Build a support vector machine using libsvm's function 
%   svmtrain, or predict the labels using the function svmpredict. The
%   maximum and minimum values of the data are stored during the
%   classification mode, and are used in the prediction mode to scale the
%   data.
%   
%   [MDL,ACC] = CL_MATLABSVM('classification',FEATURES,LABELS) returns the
%   SVM model and its accuracy. The function does a 5 fold crossvalidation
%   and optimizes the SVM parameters with a grid search.
%
%   [MDL,ACC] = CL_MATLABSVM('prediction',MODEL,FEATURES) returns the
%   prediction of the input features using the specified model.

use_mapminmax = 0;
switch mode
    case 'classification'
        
        features = varargin{1};
        labels = varargin{2};
        
        % Parameters
        numFold = 5;
        param_c = [-10:10];
        param_g = [-10:10];
        % Scale data between 0 and 1
        if use_mapminmax
            [scaled,PS] = mapminmax(features');
            scaled = double(scaled)';
        else
            [scaled, minVal, maxVal] = scaleSVM(features);
        end
        
        
        % Grid search for parameter selection
        bestcv = 0;
        for log2c = param_c
            for log2g = param_g
                cmd = ['-v ', num2str(numFold), ' -c ', num2str(2^log2c), ' -g ', num2str(2^log2g), ' -q'];
                cv = svmtrain(labels, scaled, cmd);
                % delete command window output
                %fprintf(repmat('\b',1,32));
                
                if (cv >= bestcv)
                    bestcv = cv; bestc = 2^log2c; bestg = 2^log2g;
                end
            end
        end
        fprintf('SELECTED PARAMETER: c = %g, g = %g (rate = %g)\n', bestc, bestg, bestcv);
        
        param = ['-c ', num2str(bestc), ' -g ', num2str(bestg), ' -q'];
        svmmodel = svmtrain(labels, scaled, param);
        
        model.mdl = svmmodel;
        if use_mapminmax
            model.PS=PS;
        else
            model.minVal = minVal;
            model.maxVal = maxVal;
        end
        
        
        X = model;
        Y = bestcv;
        
    case 'prediction'
        
        model = varargin{1};
        features = varargin{2};
        
        if use_mapminmax
            scaled = mapminmax('apply',features',model.PS);
            scaled = double(scaled)';
        else
            scaled = scaleSVM(features,model.minVal,model.maxVal);
        end
        
        
        label_vector = repmat(-999,[size(scaled,1),1]);
        
        [predicted_label, ~, prob] = svmpredict(label_vector, scaled, model.mdl, '-q');
        
        X = predicted_label;
        Y = prob;
        
    otherwise
        error('Wrong mode: only `classification` and `prediction` are allowed');
end
end

function [scaled,minValue,maxValue] = scaleSVM(data,lower,upper)

% convert the input data do double
data = double(data);

if nargin < 3
    % normalize all the data between 0 and 1
    lower = min(data,[],1);
    upper = max(data,[],1);
end

scaled = (data - repmat(lower,size(data,1),1))*spdiags(1./(upper-lower)',0,size(data,2),size(data,2));


if nargout > 1
    minValue = min(data,[],1);
    maxValue = max(data,[],1);
end
end