%% load files
load('mega1.mat')
load('mega10.mat')
load('mega2.mat')
load('mega3.mat')
load('mega4.mat')
load('mega5.mat')
load('mega6.mat')
load('mega7.mat')
load('mega8.mat')
load('mega9.mat')
%% consolidate
d1u=[mega1(2,:) mega2(2,:) mega3(2,:) mega4(2,:) mega5(2,:) mega6(2,:) mega7(2,:) mega8(2,:) mega9(2,:) mega10(2,:)];
d1d=[mega1(3,:) mega2(3,:) mega3(3,:) mega4(3,:) mega5(3,:) mega6(3,:) mega7(3,:) mega8(3,:) mega9(3,:) mega10(3,:)];

d2u=[mega1(5,:) mega2(5,:) mega3(5,:) mega4(5,:) mega5(5,:) mega6(5,:) mega7(5,:) mega8(5,:) mega9(5,:) mega10(5,:)];
d2d=[mega1(6,:) mega2(6,:) mega3(6,:) mega4(6,:) mega5(6,:) mega6(6,:) mega7(6,:) mega8(6,:) mega9(6,:) mega10(6,:)];


d1u=[mega1(2,:) mega3(2,:) mega4(2,:) mega5(2,:) mega6(2,:) mega8(2,:) mega9(2,:)];
d1d=[mega1(3,:) mega3(3,:) mega4(3,:) mega5(3,:) mega6(3,:) mega8(3,:) mega9(3,:)];

d2u=[mega1(5,:) mega3(5,:) mega4(5,:) mega5(5,:) mega6(5,:) mega7(5,:) mega8(5,:) mega9(5,:)];
d2d=[mega1(6,:) mega3(6,:) mega4(6,:) mega5(6,:) mega6(6,:) mega7(6,:) mega8(6,:) mega9(6,:)];



vft1=[mega1(7,:) mega2(7,:) mega3(7,:) mega4(7,:) mega5(7,:) mega6(7,:) mega7(7,:) mega8(7,:) mega9(7,:) mega10(7,:)];
vft2=[mega1(8,:) mega2(8,:) mega3(8,:) mega4(8,:) mega5(8,:) mega6(8,:) mega7(8,:) mega8(8,:) mega9(8,:) mega10(8,:)];
vft3=[mega1(9,:) mega2(9,:) mega3(9,:) mega4(9,:) mega5(9,:) mega6(9,:) mega7(9,:) mega8(9,:) mega9(9,:) mega10(9,:)];


flcon=[mega1(11,:) mega2(11,:) mega3(11,:) mega4(11,:) mega5(11,:) mega6(11,:) mega7(11,:) mega8(11,:) mega9(11,:) mega10(11,:)];
flinc=[mega1(12,:) mega2(12,:) mega3(12,:) mega4(12,:) mega5(12,:) mega6(12,:) mega7(12,:) mega8(12,:) mega9(12,:) mega10(12,:)];

fcon=[mega1(14,:) mega2(14,:) mega3(14,:) mega4(14,:) mega5(14,:) mega6(14,:) mega7(14,:) mega8(14,:) mega9(14,:) mega10(14,:)];
finc=[mega1(15,:) mega2(15,:) mega3(15,:) mega4(15,:) mega5(15,:) mega6(15,:) mega7(15,:) mega8(15,:) mega9(15,:) mega10(15,:)];


fcon=[mega1(14,:) mega2(14,:) mega3(14,:) mega4(14,:) mega5(14,:) mega6(14,:) mega8(14,:) mega9(14,:) mega10(14,:)];
finc=[mega1(15,:) mega2(15,:) mega3(15,:) mega4(15,:) mega5(15,:) mega6(15,:) mega8(15,:) mega9(15,:) mega10(15,:)];


%% run tests

%Doors: combine for up vs down
[h,p]=ttest(d1u,d1d);
[h,p]=ttest(d2u,d2d);
%du=mean([d1u;d2u]);
%dd=mean([d1d;d2d]);
[h,p]=ttest(d1d,d2d(1:length(d1d)));
[h,p]=ttest(d1u,d2u(1:length(d1u)));
%du=([d1u d2u]);
%dd=([d1d d2d]);
%[h,p]=ttest(du,dd);

%VFT: rest v animals, rest v alphabet, alphabet v animals
[h,p]=ttest(vft1,vft2);
[h,p]=ttest(vft1,vft3);
[h,p]=ttest(vft2,vft3);

% rest v task
[h,p]=ttest(vft1,mean([vft2,vft3]));

% task v other
[h,p]=ttest(vft3,mean([vft2,vft1]));

% alphabet v other
[h,p]=ttest(vft2,mean([vft3,vft1]));

%flanker: con vs inc

[h,p]=ttest(fcon,finc);

%% detect features corresponding to top regions
% doors1 up v down
difs=abs(d1u-d1d);
aden1=find(difs==max(difs));
difs(aden1)=[];
aden2=find(difs==max(difs));
difs(aden2)=[];
aden3=find(difs==max(difs));
difs(aden3)=[];
aden4=find(difs==max(difs));
difs(aden4)=[];
aden5=find(difs==max(difs));
difs(aden5)=[];
roiDoors1=[aden1,aden2,aden3,aden4,aden5];
adoor1Feat=sort(roiDoors1,'ascend');

% doors2 up v down
difs=abs(d2u-d2d);
aden1=find(difs==max(difs));
difs(aden1)=[];
aden2=find(difs==max(difs));
difs(aden2)=[];
aden3=find(difs==max(difs));
difs(aden3)=[];
aden4=find(difs==max(difs));
difs(aden4)=[];
aden5=find(difs==max(difs));
difs(aden5)=[];
roiDoors2=[aden1,aden2,aden3,aden4,aden5];
adoor2Feat=sort(roiDoors2,'ascend');

% vft rest v alphabet
difs=abs(vft1-vft2);
aden1=find(difs==max(difs));
difs(aden1)=[];
aden2=find(difs==max(difs));
difs(aden2)=[];
aden3=find(difs==max(difs));
difs(aden3)=[];
aden4=find(difs==max(difs));
difs(aden4)=[];
aden5=find(difs==max(difs));
difs(aden5)=[];
roiVft12=[aden1,aden2,aden3,aden4,aden5];
avft12Feat=sort(roiVft12,'ascend');


% vft rest v animals
difs=abs(vft1-vft3);
aden1=find(difs==max(difs));
difs(aden1)=[];
aden2=find(difs==max(difs));
difs(aden2)=[];
aden3=find(difs==max(difs));
difs(aden3)=[];
aden4=find(difs==max(difs));
difs(aden4)=[];
aden5=find(difs==max(difs));
difs(aden5)=[];
roiVft13=[aden1,aden2,aden3,aden4,aden5];
avft13Feat=sort(roiVft13,'ascend');

% vft alphabet v animals
difs=abs(vft2-vft3);
aden1=find(difs==max(difs));
difs(aden1)=[];
aden2=find(difs==max(difs));
difs(aden2)=[];
aden3=find(difs==max(difs));
difs(aden3)=[];
aden4=find(difs==max(difs));
difs(aden4)=[];
aden5=find(difs==max(difs));
difs(aden5)=[];
roiVft13=[aden1,aden2,aden3,aden4,aden5];
avft23Feat=sort(roiVft13,'ascend');

% flanker
difs=abs(fcon-finc);
aden1=find(difs==max(difs));
difs(aden1)=[];
aden2=find(difs==max(difs));
difs(aden2)=[];
aden3=find(difs==max(difs));
difs(aden3)=[];
aden4=find(difs==max(difs));
difs(aden4)=[];
aden5=find(difs==max(difs));
difs(aden5)=[];
roiFlank=[aden1,aden2,aden3,aden4,aden5];
aflankFeat=sort(roiFlank,'ascend');


subLocal=1:805:8050;
% doors1: 4443	4722	4827	5176	5209
% doors2: 33	3252	5212	5247	5282	5313
% vft12: 4841	4959	5048	5063	5079	5082	5095	5295	5380	5460	5596
% vft13: 4849	4921	5013	5017	5253
% vft23: 4856	5087	5159	5582	5599
% flanker: 768	803	7224	7224	7225	7225	7226	7227	7228	7229	7230	7231	7232

%sub7=[7224	7224	7225	7225	7226	7227	7228	7229	7230	7231	7232];
sub1=[33         768         803]; 
sub3=[3252];
sub4=[4443,4722, 4827];
sub7=[4841	4849	4856	4921	4959	5013	5017	5048	5063	5079	5082	5087	5095	5159	5176	5209	5212	5247	5253	5282	5295	5313	5380	5460	5582	5596	5599];
sub9=[7224	7225	7226	7227	7228	7229	7230	7231	7232];
sub9Adj=sub9-subLocal(9);
sub5Adj=sub7-subLocal(7);
sub4Adj=sub4-subLocal(6);
sub3Adj=sub3-subLocal(5);

mf=unique([sub1 sub3Adj sub4Adj sub5Adj sub9Adj]);

locMat=1:1:length(mega1);
locMat=reshape(locMat,23,35);

channelInd=[];
featureInd=[];
for li=1:length(mf)
val2=mf(li);
[x,y]=find(locMat==val2);
featureInd=[featureInd y];
channelInd=[channelInd x];
end

bestChannels=unique(channelInd);
bestFeatures=unique(featureInd);

% NOTE: Add  1 to channel due to Python index vs. Matlab index
%VLPFC-RITE: Ventrolateral Prefrontal Cortex (right) [0-3]
%OFFPC-RITE: Orbitofrontal Prefrontal Cortex (right)/Frontopolar Prefrontal Cortex (left) [4-6]
%DLPFC-RITE: Dorsolateral Prefrontal Cortex (right)/Frontopolar Prefrontal Cortex (right) [7-9]
%OFPFC-MID: Orbitofrontal Prefrontal Cortex [10-12]
%DLPFC-RITE: Dorsolateral Prefrontal Cortex (left)/Frontopolar Prefrontal Cortex (left) [13-15]
%OFFPC-LEFT: Orbitofrontal Prefrontal Cortex (left)/Frontopolar Prefrontal Cortex (left) [16-18]
%VLPFC-LEFT: Ventrolateral Prefrontal Cortex (left) [19-22]

% all channels present. Spectral features (+amplitude) dominate

%doors1: channel 3, feature 19, ROI: OFFPC-RITE: Orbitofrontal Prefrontal Cortex (right)/Frontopolar Prefrontal Cortex (left)
%doors2: channel 10, feature 2, ROI: OFPFC-MID: Orbitofrontal Prefrontal Cortex
%vft12: channel 10, feature 1, ROI: OFPFC-MID: Orbitofrontal Prefrontal Cortex 
%vft13: channel 18, feature 1, ROI: VLPFC-LEFT: Ventrolateral Prefrontal Cortex (left)
%vft23: channel 2, feature 2, ROI: VLPFC-RITE: Ventrolateral Prefrontal Cortex (right)
%flanker: channel 9, feature 34: ROI: DLPFC-RITE: Dorsolateral Prefrontal Cortex (right)/Frontopolar Prefrontal Cortex (right)
