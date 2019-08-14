function features = CLISLAB_FeaturesDimensionReduction(features, K)
% Use mRMR with a modification of the original code in order to use
% continous data. The parameters:
%  features.features - a N*M matrix, indicating N samples, each having M dimensions. Must be integers.
%  features.classLabels - a N*1 matrix (vector), indicating the class/category of the N samples. Must be categorical.
%  features.featuresLabels - M*3 matrix (string) indicating the name of the
%  extracted feature
%  K - the number of features need to be selected

addpath(['ext' filesep 'KernelMI']);

d = features.features;
f = features.classLabels;

if nargin < 2
    K = 10;
end

idxFeatures = mrmr_kernel(d,f,K);

features.features = features.features(:,idxFeatures);
features.featuresLabels = features.featuresLabels(idxFeatures,:);

end

function fea = mrmr_kernel(d,f,K)

    bdisp=0;

    nd = size(d,2);
    nc = size(d,1);

    t1=cputime;
    for i=1:nd,
        t(i) = kernelmi(d(:,i)', f');
    end;
    if bdisp==1
        fprintf('calculate the marginal dmi costs %5.1fs.\n', cputime-t1);
    end
    [tmp, idxs] = sort(-t);
    fea_base = idxs(1:K);

    fea(1) = idxs(1);

    KMAX = min(1000,nd); %500

    idxleft = idxs(2:KMAX);

    k=1;
    if bdisp==1,
        fprintf('k=1 cost_time=(N/A) cur_fea=%d #left_cand=%d\n', ...
            fea(k), length(idxleft));
    end;

    for k=2:K,
        t1=cputime;
        ncand = length(idxleft);
        curlastfea = length(fea);
        for i=1:ncand,
            t_mi(i) = kernelmi(d(:,idxleft(i))', f');
            mi_array(idxleft(i),curlastfea) = getmultikernelmi(d(:,fea(curlastfea)), d(:,idxleft(i)));
            c_mi(i) = mean(mi_array(idxleft(i), :));
        end;

        [tmp, fea(k)] = max(t_mi(1:ncand) - c_mi(1:ncand));

        tmpidx = fea(k); fea(k) = idxleft(tmpidx); idxleft(tmpidx) = [];

        if bdisp==1,
            fprintf('k=%d cost_time=%5.4f cur_fea=%d #left_cand=%d\n', ...
                k, cputime-t1, fea(k), length(idxleft));
        end;
    end
end
%=====================================
function c = getmultikernelmi(da, dt)
    for i=1:size(da,2),
        c(i) = kernelmi(da(:,i)', dt');
    end;
end
