function [y]=nirsChannelCombine(yold)


%--------------------------------------------------------------------------
 % nirsChannelCombine

 % Last updated: Nov 2023, J. LaRocco

 % Details: Combine and consolidate channels into 7 regions for NIRS.

%VLPFC-RITE: Ventrolateral Prefrontal Cortex (right) [1-4]
%OFFPC-RITE: Orbitofrontal Prefrontal Cortex (right)/Frontopolar Prefrontal Cortex (left) [5-7]
%DLPFC-RITE: Dorsolateral Prefrontal Cortex (right)/Frontopolar Prefrontal Cortex (right) [8-10]
%OFPFC-MID: Orbitofrontal Prefrontal Cortex [11-13]
%DLPFC-LEFT: Dorsolateral Prefrontal Cortex (left)/Frontopolar Prefrontal Cortex (left) [14-16]
%OFFPC-LEFT: Orbitofrontal Prefrontal Cortex (left)/Frontopolar Prefrontal Cortex (left) [17-19]
%VLPFC-LEFT: Ventrolateral Prefrontal Cortex (left) [20-23]


 % Usage:
 % [y]=nirsChannelCombine(yold)

 % Input:
 %  yold: Input data matrix in 2 dimensions. First dimension is features,
 %        second is channels.  

 % Output:
 %  y: Reorganized data matrix.

%--------------------------------------------------------------------------
r1=mean(yold(:,1:4)');
r2=mean(yold(:,5:7)');
r3=mean(yold(:,8:10)');
r4=mean(yold(:,11:13)');
r5=mean(yold(:,14:16)');
r6=mean(yold(:,17:19)');
r7=mean(yold(:,20:23)');
y=[r1; r2; r3; r4; r5; r6; r7];
y=y';
end