clear; close all; clc;

inString='subBlock01.mat';
load(inString,'subBlock')
fs=subBlock.fs;
doorsPost=4*fs;
vftPost=30*fs;
flPost=80*fs;
subRotation={'subBlock01.mat','subBlock02.mat','subBlock03.mat','subBlock04.mat','subBlock05.mat','subBlock06.mat','subBlock07.mat','subBlock08.mat','subBlock09.mat','subBlock10.mat'};
subRotationDeox={'subBlockDeox01.mat','subBlockDeox02.mat','subBlockDeox03.mat','subBlockDeox04.mat','subBlockDeox05.mat','subBlockDeox06.mat','subBlockDeox07.mat','subBlockDeox08.mat','subBlockDeox09.mat','subBlockDeox10.mat'};

chanLabels=[zeros(1,length(subRotation)) ones(1,length(subRotation)) 2*ones(1,length(subRotation)) 3*ones(1,length(subRotation)) 4*ones(1,length(subRotation)) 5*ones(1,length(subRotation)) 6*ones(1,length(subRotation)) 7*ones(1,length(subRotation)) 8*ones(1,length(subRotation)) 9*ones(1,length(subRotation)) 10*ones(1,length(subRotation)) 11*ones(1,length(subRotation)) 12*ones(1,length(subRotation)) 13*ones(1,length(subRotation)) 14*ones(1,length(subRotation)) 15*ones(1,length(subRotation)) 16*ones(1,length(subRotation)) 17*ones(1,length(subRotation)) 18*ones(1,length(subRotation)) 19*ones(1,length(subRotation)) 20*ones(1,length(subRotation)) 21*ones(1,length(subRotation)) 22*ones(1,length(subRotation))];
chanLabels=chanLabels';

doorsWi=[];
doorsLo=[];

doorsW=[];
doorsL=[];
vft1=[];
vft2=[];
vft3=[];
flcon=[];
flinc=[];

for aaa=1:length(subRotation)
fileToLoad=subRotation{aaa};
load(fileToLoad)
[dW,dL,vft1Epochs,vft2Epochs,vft3Epochs,flankerConEpochs,flankerIncEpochs]=processSubject(subBlock,doorsPost,vftPost,flPost);

doorsW=[doorsW; squeeze(mean(dW))];
doorsL=[doorsL; squeeze(mean(dL))];

doorsWi(aaa,:,:)=squeeze(mean(dW));
doorsLo(aaa,:,:)=squeeze(mean(dL));

vft1=[vft1; vft1Epochs];
vft2=[vft2; vft2Epochs];
vft3=[vft3; vft3Epochs];

flcon=[flcon; flankerConEpochs];
flinc=[flinc; flankerIncEpochs];

end
%clear flankerConEpochs flankerIncEpochs vft1 vft2 vft3 doorsW doorsL;
%% averaging and thresholding
% data consolidation
%% vft
[sessSub,~,~]=size(vft1);

evens=1:2:sessSub;
odds=2:2:sessSub;
vt1m=squeeze(mean(vft1,2));
vt1m=.5*([vt1m(odds,:)+ vt1m(evens,:)]);
vft1Means=nirsChannelCombine(vt1m);


vt2m=squeeze(mean(vft2,2));
vt2m=.5*([vt2m(odds,:)+ vt2m(evens,:)]);
vft2Means=nirsChannelCombine(vt2m);

vt3m=squeeze(mean(vft3,2));
vt3m=.5*([vt3m(odds,:)+ vt3m(evens,:)]);
vft3Means=nirsChannelCombine(vt3m);

vft1Means=(vt1m);
vft2Means=(vt2m);
vft3Means=(vt3m);

%% doors
drL=squeeze(mean(doorsLo,2));
%dorLoss=nirsChannelCombine(drL);
dorLoss=(drL);
drW=squeeze(mean(doorsWi,2));
%dorWins=nirsChannelCombine(drW);
dorWins=(drW);


%% flanker
[sessSub,~,~]=size(flcon);

b1=1:3:sessSub;
b2=2:3:sessSub;
b3=3:3:sessSub;

flaCon=squeeze(mean(flcon,2));
flaInc=squeeze(mean(flinc,2));

flaCon=.33*(flaCon(b1,:)+flaCon(b2,:)+flaCon(b3,:));
flaInc=.33*(flaInc(b1,:)+flaInc(b2,:)+flaInc(b3,:));
% 
flankCons=(flaCon);
flankIncs=(flaInc);

%flankCons=nirsChannelCombine(flaCon);
%flankIncs=nirsChannelCombine(flaInc);

%% stats tests
% vft
[hV0,pV0]=ttest2(vft1Means,vft3Means);

% doors
[hD0,pD0]=ttest2(dorLoss,dorWins);

%col vector
% flanker
[hF0,pF0]=ttest2(flankCons,flankIncs);

% flattened
% vft
[hV1,pV1]=ttest2(vft1Means(:),vft3Means(:));

% doors
[hD1,pD1]=ttest2(dorLoss(:),dorWins(:));

% flanker
[hF1,pF1]=ttest2(flankCons(:),flankIncs(:));

% avg all
% vft
[hV2,pV2]=ttest2(mean(vft1Means),mean(vft3Means));

% doors
[hD2,pD2]=ttest2(mean(dorLoss),mean(dorWins));

% flanker
[hF2,pF2]=ttest2(mean(flankCons),mean(flankIncs));

