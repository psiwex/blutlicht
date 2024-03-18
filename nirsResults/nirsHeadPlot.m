function [splName]=nirsHeadPlot(rawData,chanLocs)

%--------------------------------------------------------------------------
 % nirsHeadPlot

 % Last updated: Jan 2024, J. LaRocco

 % Details: Make a 3D plot of each time series data.

%VLPFC-RITE: Ventrolateral Prefrontal Cortex (right) [1-4]
%OFFPC-RITE: Orbitofrontal Prefrontal Cortex (right)/Frontopolar Prefrontal Cortex (left) [5-7]
%DLPFC-RITE: Dorsolateral Prefrontal Cortex (right)/Frontopolar Prefrontal Cortex (right) [8-10]
%OFPFC-MID: Orbitofrontal Prefrontal Cortex [11-13]
%DLPFC-LEFT: Dorsolateral Prefrontal Cortex (left)/Frontopolar Prefrontal Cortex (left) [14-16]
%OFFPC-LEFT: Orbitofrontal Prefrontal Cortex (left)/Frontopolar Prefrontal Cortex (left) [17-19]
%VLPFC-LEFT: Ventrolateral Prefrontal Cortex (left) [20-23]


 % Usage:
 % [splName]=nirsChannelCombine(yold)

 % Input:
 %  rawData: Input data matrix in 2 dimensions. First dimension is samples,
 %        second is channels.
 % chanLocs: Struct table in EEGLAB format of channels to plot. 
 % .  

 % Output:
 %  splName: Spline file name used.

%--------------------------------------------------------------------------
splName='STUDY_headplot.spl';
%xx = readlocs('testFile.ced');
%timeArt=[8,2,7,6,5,1,4];
%x=xx(timeArt);

x=chanLocs;

headplot('setup', x, splName)
%close;
figure; 
headplot(rawData', splName)

end