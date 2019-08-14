function h = mutualinfo(vec1,vec2)
%=========================================================
%
%This is a prog in the MutualInfo 0.9 package written by 
% Hanchuan Peng.
%
%Disclaimer: The author of program is Hanchuan Peng
%      at <penghanchuan@yahoo.com> and <phc@cbmv.jhu.edu>.
%
%The CopyRight is reserved by the author.
%
%Last modification: April/19/2002
%
%========================================================
%
% h = mutualinfo(vec1,vec2)
% calculate the mutual information of two vectors
% By Hanchuan Peng, April/2002
%



%%%%% Modified By Giovanni start
if (~isequal(size(vec1), size(vec2')))
   vec2 = vec2'; 
end

try
[p12, p1, p2] = estpab(vec1,double(vec2));
h = estmutualinfo(p12,p1,p2);
catch
   disp(1) 
end


% %function I = MutualInformation(X,Y);
% if (size(vec1,2) > 1)  % More than one predictor?
%     % Axiom of information theory
%     h = JointEntropy(vec1) + entropy(vec2) - JointEntropy([vec1 vec2']);
% else
%     % Axiom of information theory
%    % try
%    if (size(vec2) ~= size(vec1) )
%        vec2=vec2';
%    end
%     h = entropy(vec1) + entropy(vec2) - jointentropy([vec1 vec2]);
%    % catch
%      %   disp(1)
%     %end
% end
%%%%%% Modified By Giovanni finish