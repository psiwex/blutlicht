
%F8: VLPFC-RITE: Ventrolateral Prefrontal Cortex (right) [1-4]
%FP2: OFFPC-RITE: Orbitofrontal Prefrontal Cortex (right)/Frontopolar Prefrontal Cortex (left) [5-7]
%F4: DLPFC-RITE: Dorsolateral Prefrontal Cortex (right)/Frontopolar Prefrontal Cortex (right) [8-10]
%FZ: OFPFC-MID: Orbitofrontal Prefrontal Cortex [11-13]
%F3: DLPFC-LEFT: Dorsolateral Prefrontal Cortex (left)/Frontopolar Prefrontal Cortex (left) [14-16]
%FP1: OFFPC-LEFT: Orbitofrontal Prefrontal Cortex (left)/Frontopolar Prefrontal Cortex (left) [17-19]
%F7: VLPFC-LEFT: Ventrolateral Prefrontal Cortex (left) [20-23]
%[8,2,7,6,5,1,4]


inString='subBlock01.mat';
channel=5;
load(inString,'subBlock')
fs=subBlock.fs;
doorsPost=4*fs;
vftPost=30*fs;
flPost=80*fs;
subRotation={'subBlock01.mat','subBlock02.mat','subBlock03.mat','subBlock04.mat','subBlock05.mat','subBlock06.mat','subBlock07.mat','subBlock08.mat','subBlock09.mat','subBlock10.mat'};
subRotationDeox={'subBlockDeox01.mat','subBlockDeox02.mat','subBlockDeox03.mat','subBlockDeox04.mat','subBlockDeox05.mat','subBlockDeox06.mat','subBlockDeox07.mat','subBlockDeox08.mat','subBlockDeox09.mat','subBlockDeox10.mat'};
sas=1;
subName=subRotation{sas};
rawData=subBlock.vft;
[EEG,command,dat]=blockLoader(subName,fs,rawData');
%[X,Y] = meshgrid(1:size(rawData,1),1:size(rawData,2));
Z=rawData';
%figure;
%surf(X,Y,Z)
xx = readlocs('testFile.ced');
timeArt=[8,2,7,6,5,1,4];
chanLocs=xx(timeArt);


zz=nirsChannelCombine(Z');
[splName]=nirsHeadPlot(zz,chanLocs);
EEG.data=zz';


EEG.chanlocs = x;
zzz=mean(zz);

%topoplot(zzz,x);
headplot('setup', x, 'STUDY_headplot.spl')
close;
figure; 
headplot(zzz', 'STUDY_headplot.spl')
