function [structuredOutput,baselines] = GIOVANNI_NIRS_Baseline_Correction(structuredInput)
%BASELINE CORRECTION removing baseline average to both baseline and
%thinking period
%   Takes as input the structured variable containing Hbo/hbt of
%   baslines/thinkingPeriods and returns as output the baseline corrected
%   structured variables and the baselines averages;


baselines.hbo = mean(structuredInput.baselineHbo,2 );
baselines.hbr = mean(structuredInput.baselineHbr,2 );
structuredOutput.baselineHbo = structuredInput.baselineHbo - baselines.hbo;
structuredOutput.baselineHbr = structuredInput.baselineHbr - baselines.hbr;
structuredOutput.thinkingHbo = structuredInput.thinkingHbo - baselines.hbo;
structuredOutput.thinkingHbr = structuredInput.thinkingHbr - baselines.hbr;


end

