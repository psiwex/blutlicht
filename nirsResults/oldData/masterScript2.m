inString='subBlock01.mat';
load(inString,'subBlock')
fs=subBlock.fs;
doorsPost=4*fs;
vftPost=30*fs;
flPost=80*fs;
subRotation={'subBlock01.mat','subBlock02.mat','subBlock03.mat','subBlock04.mat','subBlock05.mat','subBlock06.mat','subBlock07.mat','subBlock08.mat','subBlock09.mat','subBlock10.mat'};
subRotationDeox={'subBlockDeox01.mat','subBlockDeox02.mat','subBlockDeox03.mat','subBlockDeox04.mat','subBlockDeox05.mat','subBlockDeox06.mat','subBlockDeox07.mat','subBlockDeox08.mat','subBlockDeox09.mat','subBlockDeox10.mat'};

% oxygen hb
doorsW=[];
doorsL=[];
vft1=[];
vft2=[];
vft3=[];
flcon=[];
flinc=[];

%deoxy hb
doorsWDeox=[];
doorsLDeox=[];
vft1Deox=[];
vft2Deox=[];
vft3Deox=[];
flconDeox=[];
flincDeox=[];

for aaa=1:length(subRotation)
fileToLoad=subRotation{aaa};
load(fileToLoad)
[dW,dL,vft1Epochs,vft2Epochs,vft3Epochs,flankerConEpochs,flankerIncEpochs]=processSubject(subBlock,doorsPost,vftPost,flPost);

doorsW=[doorsW; dW];
doorsL=[doorsL; dL];

vft1=[vft1; vft1Epochs];
vft2=[vft2; vft2Epochs];
vft3=[vft3; vft3Epochs];

flcon=[flcon; flankerConEpochs];
flinc=[flinc; flankerIncEpochs];
clear subBlock;
fileToLoadD=subRotationDeox{aaa};
load(fileToLoadD)
[dWD,dLD,vft1EpochsD,vft2EpochsD,vft3EpochsD,flankerConEpochsD,flankerIncEpochsD]=processSubject(subBlock,doorsPost,vftPost,flPost);
clear subBlock;

doorsWDeox=[doorsWDeox; dWD];
doorsLDeox=[doorsLDeox; dLD];

vft1Deox=[vft1Deox; vft1EpochsD];
vft2Deox=[vft2Deox; vft2EpochsD];
vft3Deox=[vft3Deox; vft3EpochsD];

flconDeox=[flconDeox; flankerConEpochsD];
flincDeox=[flincDeox; flankerIncEpochsD];
clear subBlock;

end
%clear flankerConEpochs flankerIncEpochs vft1 vft2 vft3 doorsW doorsL;
%clear flankerConEpochsD flankerIncEpochsD vft1D vft2D vft3D doorsWD doorsLD;

%% averaging and thresholding
% data consolidation
% ox
doorsWm=squeeze(mean(doorsW));
doorsLm=squeeze(mean(doorsL));

doorsWm=doorsWm(1:doorsPost,:);
doorsLm=doorsLm(1:doorsPost,:);
vft1m=squeeze(mean(vft1));
vft2m=squeeze(mean(vft2));
vft3m=squeeze(mean(vft3));
flankcm=squeeze(mean(flcon));
flankim=squeeze(mean(flinc));

vft1m=vft1m(1:vftPost,:);
vft2m=vft2m(1:vftPost,:);
vft3m=vft3m(1:vftPost,:);

flankcm=flankcm(1:flPost,:);
flankim=flankim(1:flPost,:);

% deox
doorsWmD=squeeze(mean(dWD));
doorsLmD=squeeze(mean(dLD));

doorsWmD=doorsWmD(1:doorsPost,:);
doorsLmD=doorsLmD(1:doorsPost,:);

vft1mD=squeeze(mean(vft1EpochsD));
vft2mD=squeeze(mean(vft2EpochsD));
vft3mD=squeeze(mean(vft3EpochsD));

vft1mD=vft1mD(1:vftPost,:);
vft2mD=vft2mD(1:vftPost,:);
vft3mD=vft3mD(1:vftPost,:);

flankcmD=squeeze(mean(flconDeox));
flankimD=squeeze(mean(flincDeox));

flankcmD=flankcmD(1:flPost,:);
flankimD=flankimD(1:flPost,:);

% ROI consolidation
% oxy
[doorsWm]=nirsChannelCombine(doorsWm);
[doorsLm]=nirsChannelCombine(doorsLm);

[vft1m]=nirsChannelCombine(vft1m);
[vft2m]=nirsChannelCombine(vft2m);
[vft3m]=nirsChannelCombine(vft3m);

[flankcm]=nirsChannelCombine(flankcm);
[flankim]=nirsChannelCombine(flankim);

% deox
[doorsWmD]=nirsChannelCombine(doorsWmD);
[doorsLmD]=nirsChannelCombine(doorsLmD);

[vft1mD]=nirsChannelCombine(vft1mD);
[vft2mD]=nirsChannelCombine(vft2mD);
[vft3mD]=nirsChannelCombine(vft3mD);

[flankcmD]=nirsChannelCombine(flankcmD);
[flankimD]=nirsChannelCombine(flankimD);

% features
fDoorsWin=featuresWelch(doorsWm,fs);
fDoorsLos=featuresWelch(doorsLm,fs);

fVft1=featuresWelch(vft1m,fs);
fVft2=featuresWelch(vft2m,fs);
fVft3=featuresWelch(vft3m,fs);

fFlanCon=featuresWelch(flankcm,fs);
fFlanInc=featuresWelch(flankim,fs);
%%ttest
[hDoors,pDoors,~,statsDoors]=ttest2(fDoorsWin(:),fDoorsLos(:));
[hVFT,pVFT,~,statsVFT]=ttest2(fVft1(:),fVft3(:));
[hFlan,pFlan,~,Fl]=ttest(fFlanCon(:),fFlanInc(:));

%% plotting graphs
%% vft
channel=5;

scaleFactor=max([max(abs(vft1m(:,channel))),max(abs(vft2m(:,channel))),max(abs(vft3m(:,channel)))]);
vft1m=vft1m/scaleFactor;
vft2m=vft2m/scaleFactor;
vft3m=vft3m/scaleFactor;


scaleFactorD=max([scaleFactor, max(abs(vft1mD(:,channel))),max(abs(vft2mD(:,channel))),max(abs(vft3mD(:,channel)))]);
vft1mD=vft1mD/scaleFactorD;
vft2mD=vft2mD/scaleFactorD;
vft3mD=vft3mD/scaleFactorD;


vft1mD=vft1mD;
vft2mD=vft2mD;
vft3mD=vft3mD;

vft4mD=mean([vft1mD vft2mD vft3mD]');


dlvft0=[(vft1m(:,channel)); (vft2m(:,channel)); (vft3m(:,channel))];
dlvft1=[(vft1m(:,channel)); zeros(300,1); zeros(300,1)];
dlvft2=[zeros(300,1); (vft2m(:,channel)); zeros(300,1)];
dlvft3=[zeros(300,1); zeros(300,1); (vft3m(:,channel))];
dlvft4=[vft1mD(:,channel); vft2mD(:,channel); vft3mD(:,channel)];
x=1:1:length(dlvft0);
p = polyfit(x,dlvft0,3);

y1 = polyval(p,x);
y1=y1((vftPost+1):(3*vftPost));

x1=0:(1/fs):((vftPost*2)/fs);
x1=x1(1:length(y1));
thresMax=y1(fs);
xRep=linspace(0,thresMax,fs);
y1(1:length(xRep))=xRep;
pD = polyfit(x,dlvft4,3);
yD1 = polyval(pD,x);
yD1=yD1((vftPost+1):(3*vftPost));
yb1=polyval(p,x);
yb2=polyval(pD,x);
x11=(1/fs):(1/fs):((vftPost*3)/fs);
% 
figure;
plot(x11,dlvft0,'r')
hold on;
plot(x11,dlvft4,'b')
xlabel('Time (s)')
ylabel('Oxy-Hb (mMol.mm)')
title('Raw DLPFC Oxygenation During VFT')
legend('OxyHb','DeoxyHb')
hold off;
% 

scaleFactor=max([max(abs(vft1m(:,channel))),max(abs(vft2m(:,channel))),max(abs(vft3m(:,channel)))]);
vft1m=vft1m/scaleFactor;
vft2m=vft2m/scaleFactor;
vft3m=vft3m/scaleFactor;


scaleFactorD=max([scaleFactor, max(abs(vft1mD(:,channel))),max(abs(vft2mD(:,channel))),max(abs(vft3mD(:,channel)))]);
vft1mD=vft1mD/scaleFactorD;
vft2mD=vft2mD/scaleFactorD;
vft3mD=vft3mD/scaleFactorD;


vft1mD=vft1mD;
vft2mD=vft2mD;
vft3mD=vft3mD;

vft4mD=mean([vft1mD vft2mD vft3mD]');


dlvft0=[(vft1m(:,channel)); (vft2m(:,channel)); (vft3m(:,channel))];
dlvft1=[(vft1m(:,channel)); zeros(300,1); zeros(300,1)];
dlvft2=[zeros(300,1); (vft2m(:,channel)); zeros(300,1)];
dlvft3=[zeros(300,1); zeros(300,1); (vft3m(:,channel))];
dlvft4=[vft1mD(:,channel); vft2mD(:,channel); vft3mD(:,channel)];

figure;
plot(x11,dlvft0,'r')
hold on;
plot(x11,dlvft4,'b')
xlabel('Time (s)')
ylabel('Oxy-Hb (mMol.mm)')
title('Smooth DLPFC Oxygenation During VFT')
legend('OxyHb','DeoxyHb')
hold off;

p1 = polyfit(x(1:length(vft1m)),abs(vft1m(:,1)),3);
p2 = polyfit(x(1:length(vft1m)),abs(vft1m(:,2)),3);
p3 = polyfit(x(1:length(vft1m)),abs(vft1m(:,3)),3);
p4 = polyfit(x(1:length(vft1m)),abs(vft1m(:,4)),3);
p5 = polyfit(x(1:length(vft1m)),abs(vft1m(:,5)),3);
p6 = polyfit(x(1:length(vft1m)),abs(vft1m(:,6)),3);
p7 = polyfit(x(1:length(vft1m)),abs(vft1m(:,7)),3);

pa1 = polyfit(x(1:length(vft1m)),abs(vft2m(:,1)),3);
pa2 = polyfit(x(1:length(vft1m)),abs(vft2m(:,2)),3);
pa3 = polyfit(x(1:length(vft1m)),abs(vft2m(:,3)),3);
pa4 = polyfit(x(1:length(vft1m)),abs(vft2m(:,4)),3);
pa5 = polyfit(x(1:length(vft1m)),abs(vft2m(:,5)),3);
pa6 = polyfit(x(1:length(vft1m)),abs(vft2m(:,6)),3);
pa7 = polyfit(x(1:length(vft1m)),abs(vft2m(:,7)),3);

pb1 = polyfit(x(1:length(vft1m)),abs(vft3m(:,1)),3);
pb2 = polyfit(x(1:length(vft1m)),abs(vft3m(:,2)),3);
pb3 = polyfit(x(1:length(vft1m)),abs(vft3m(:,3)),3);
pb4 = polyfit(x(1:length(vft1m)),abs(vft3m(:,4)),3);
pb5 = polyfit(x(1:length(vft1m)),abs(vft3m(:,5)),3);
pb6 = polyfit(x(1:length(vft1m)),abs(vft3m(:,6)),3);
pb7 = polyfit(x(1:length(vft1m)),abs(vft3m(:,7)),3);

vr11 = polyval(p1,x(1:length(vft1m)));
vr12 = polyval(p2,x(1:length(vft1m)));
vr13 = polyval(p3,x(1:length(vft1m)));
vr14 = polyval(p4,x(1:length(vft1m)));
vr15 = polyval(p5,x(1:length(vft1m)));
vr16 = polyval(p6,x(1:length(vft1m)));
vr17 = polyval(p7,x(1:length(vft1m)));

vr21 = polyval(pa1,x(1:length(vft1m)));
vr22 = polyval(pa2,x(1:length(vft1m)));
vr23 = polyval(pa3,x(1:length(vft1m)));
vr24 = polyval(pa4,x(1:length(vft1m)));
vr25 = polyval(pa5,x(1:length(vft1m)));
vr26 = polyval(pa6,x(1:length(vft1m)));
vr27 = polyval(pa7,x(1:length(vft1m)));

vr31 = polyval(pb1,x(1:length(vft1m)));
vr32 = polyval(pb2,x(1:length(vft1m)));
vr33 = polyval(pb3,x(1:length(vft1m)));
vr34 = polyval(pb4,x(1:length(vft1m)));
vr35 = polyval(pb5,x(1:length(vft1m)));
vr36 = polyval(pb6,x(1:length(vft1m)));
vr37 = polyval(pb7,x(1:length(vft1m)));
va1=[vr11; vr12; vr13; vr14; vr15; vr16; vr17];
va2=[vr21; vr22; vr23; vr24; vr25; vr26; vr27];
va3=[vr31; vr32; vr33; vr34; vr35; vr36; vr37];
v1=mean(va1');
v2=mean(va2');
v3=mean(va3');
v1s=std(va1');
v2s=std(va2');
v3s=std(va3');
v1m=std(va1')/sqrt(length(v1));
v2m=std(va2')/sqrt(length(v1));
v3m=std(va3')/sqrt(length(v1));


figure;
plot(x/fs,real(yb1),'r')
hold on;
plot(x/fs,real(yb2),'b')
xlabel('Time (s)')
ylabel('Oxy-Hb (mMol.mm)')
title('DLPFC Oxygenation During Full VFT')
legend('OxyHb','DeoxyHb')
hold off;
% 
% figure;
% plot(x(1:vftPost)/fs,(yb1(1:vftPost)),'r')
% hold on;
% plot(x(1:vftPost)/fs,yb1((vftPost+1):(2*vftPost)),'b')
% plot(x(1:vftPost)/fs,yb1((2*vftPost+1):(3*vftPost)),'k')
% 
% xlabel('Time (s)')
% ylabel('Oxy-Hb (mMol.mm)')
% title('DLPFC Oxygenation During Full VFT')
% legend('Rest','Alphabet','Animals')
% hold off;





% figure;
% plot(dlvft0);
% % % 
% xlabel('Time (10hz samples)')
% ylabel('Oxy-Hb (mMol.mm)')
% title('DLPFC Oxygenation')
% hold on;

%plot(dlvft0-dlvft4,'g');
% plot(dlvft4,'k');
% legend('OxyHb','DeoxyHb')
% legend('OxyHb','TotalHb','DeoxyHb')
% hold off;

% v1=mean((yb1(1:(vftPost))))';
% v2=mean(yb1((vftPost+1):(2*vftPost)))';
% v3=mean(yb1((2*vftPost+1):(3*vftPost)))';
% v1s=std(abs(vft1m))';
% v2s=std(abs(vft2m))';
% v3s=std(abs(vft3m))';
% v1mse=v1s/sqrt(length(v1));
% v2mse=v2s/sqrt(length(v1));
% v3mse=v3s/sqrt(length(v1));

yB=([v1; v2; v3]); 

str = {"VLPFC-R", "OFFPC-R", "DLPFC-R", "OFPFC-M", "DLPFC-L", "OFFPC-L", "VLPFC-L"};

figure;
bar(yB');
set(gca, 'XTickLabel',str, 'XTick',1:numel(str))
ylabel('Oxy-Hb (mMol.mm)')
title('ROI Oxygenation During VFT')
legend('Rest','Alphabet','Animals')

v1=v1'; v2=v2'; v3=v3';
v1m=v1m'; v2m=v2m'; v3m=v3m'; 

%% doors

dwin=doorsWm(:,channel);
dlos=doorsLm(:,channel);
scaleFactor=max([max(abs(dwin)),max(abs(dlos))]);
% dwin=dwin/scaleFactor;
% dlos=dlos/scaleFactor;
%dwin=downsample(dwin,10)/scaleFactor;
%dlos=downsample(dlos,10)/scaleFactor;

dwin=(dwin)/scaleFactor;
dlos=(dlos)/scaleFactor;

dwinD=doorsWmD(:,channel);
dlosD=doorsLmD(:,channel);
scaleFactorD=max([max(abs(dwinD)),max(abs(dlosD))]);
%dwinD=downsample(dwinD,10)/scaleFactorD;
%dlosD=downsample(dlosD,10)/scaleFactorD;

dwinD=(dwinD)/scaleFactorD;
dlosD=(dlosD)/scaleFactorD;
xdoors=.1:.1:length(dwin)/fs;
figure;
plot(xdoors,dwin);
xlabel('Time (s)')
ylabel('Oxy-Hb (mMol.mm)')
title('Smoothed Left-DLPFC Average OxyHb During Doors')
hold on;
plot(xdoors,dlos,'r');
legend('Win','Loss')
hold off;

figure;
plot(xdoors,dwin,'r');
xlabel('Time (s)')
ylabel('Oxy-Hb (mMol.mm)')
title('Smoothed Left-DLPFC OxyHb and DeoxyHb During Doors Win')
hold on;
plot(xdoors,dwinD,'b');
legend('OxyHb','DeoxyHb')
hold off;

figure;
plot(xdoors,dlos,'r');
xlabel('Time (s)')
ylabel('Oxy-Hb (mMol.mm)')
title('Smoothed Left-DLPFC OxyHb and DeoxyHb During Doors Loss')
hold on;
plot(xdoors,dlosD,'b');
legend('OxyHb','DeoxyHb')
hold off;

dwav=mean(doorsWm)';
dlav=mean(doorsLm)';

dwavm=std(doorsWm)/sqrt(length(dwav))';
dlavm=std(doorsLm)/sqrt(length(dwav))';

%% flanker

contime=flankcm(:,channel);
inctime=flankim(:,channel);
scaleFactor=max([max(abs(contime)),max(abs(inctime))]);

contime=(contime)/scaleFactor;
inctime=(inctime)/scaleFactor;

contimeD=flankcmD(:,channel);
inctimeD=flankimD(:,channel);
scaleFactorD=max([max(abs(contimeD)),scaleFactor,max(abs(inctimeD))]);

contimeD=(contimeD)/scaleFactorD;
inctimeD=(inctimeD)/scaleFactorD;
conAll=[inctime; contime]';
conDAll=[inctimeD; contimeD]';

figure;
xflank=.1:.1:(flPost/fs);
plot(xflank,contime);
xlabel('Time (s)')
ylabel('Oxy-Hb (mMol.mm)')
title('Flanker Left-DLPFC Average OxyHb')
hold on;
plot(xflank,inctime);
legend('Congruent','Incongruent')
hold off;
ordR=20;
xflank=.1:.1:(2*flPost/fs);
pdd1 = polyfit(xflank,conAll,ordR);
conFit = polyval(pdd1,xflank);
pdd2 = polyfit(xflank,conDAll,ordR);
dincFit = polyval(pdd2,xflank);
clc;
figure;
plot(xflank,conFit,'r');
xlabel('Time (s)')
ylabel('Oxy-Hb (mMol.mm)')
title('Smoothed Flanker Blocks Left-DLPFC OxyHb and Deoxy')
hold on;
plot(xflank,dincFit,'b');
legend('OxyHb','DeoxyHb')
hold off;


figure;
plot(xflank,conAll,'r');
xlabel('Time (s)')
ylabel('Oxy-Hb (mMol.mm)')
title('Raw Flanker Blocks Left-DLPFC OxyHb and Deoxy')
hold on;
plot(xflank,conDAll,'b');
legend('OxyHb','DeoxyHb')
hold off;



dc=fFlanCon(35,:);
di=fFlanInc(35,:);
scaleFactor=max([max(abs(dc)),max(abs(di))]);

dcD=fFlanCon(35,:);
diD=fFlanInc(35,:);
scaleFactorD=max([max(abs(dcD)),max(abs(diD))]);


%di=di/scaleFactor;
%dc=dc/scaleFactor;

dc=log(dc);
di=log(di);
scaleFactor=max([max(abs(dc)),max(abs(di))]);

di=di/scaleFactor;
dc=dc/scaleFactor;
y=abs([dc; di]); 

dcD=log(dcD);
diD=log(diD);
scaleFactorD=max([max(abs(dc)),max(abs(di))]);

diD=diD/scaleFactor;
dcD=dcD/scaleFactor;
yD=abs([dcD; diD]); 

str = {"VLPFC-R", "OFFPC-R", "DLPFC-R", "OFPFC-M", "DLPFC-L", "OFFPC-L", "VLPFC-L"};

figure;
bar(y');
set(gca, 'XTickLabel',str, 'XTick',1:numel(str))
ylabel('Oxy-Hb')
title('ROI Oxygenation')

%hold on
%x=[1:1:7; 1:1:7];
mse=std(y)/sqrt(length(dc));
mseD=std(yD)/sqrt(length(dcD));
%err=[mse; mse];
%er = errorbar(x',y',err','k','linestyle','none');    
%hold off

con=mean(fFlanCon(1:18,:)');
inc=mean(fFlanCon(1:18,:)');
dFlank=abs(con-inc);
%% extra time for vft
vft1a=nirsChannelCombine(squeeze(mean(vft1(1:20,1:vftPost,:))));

vft1b=nirsChannelCombine(squeeze(mean(vft1(1:20,1:vftPost,:))));

vft2a=nirsChannelCombine(squeeze(mean(vft2(1:20,1:vftPost,:))));
%vft2b=nirsChannelCombine(squeeze(mean(vft2(2,1:vftPost,:))));

vft3a=nirsChannelCombine(squeeze(mean(vft3(1:20,1:vftPost,:))));
%vft3b=nirsChannelCombine(squeeze(mean(vft3(2,1:vftPost,:))));

vft1aD=nirsChannelCombine(squeeze(mean(vft1Deox(1:20,1:vftPost,:))));
%vft1bD=nirsChannelCombine(squeeze(mean(vft1Deox(1:20,1:vftPost,:))));

vv1=vft1a(:,channel);
vvD1=vft1aD(:,channel);

vv1 = detrend(vv1);
vvD1=detrend(vvD1);


% 
% vftA=[vft1a vft2a vft3a];
% vftB=[vft1b vft2b vft3b];
% vft0=mean([vftA,vftB]');
% vft=[vftA vftB];
f1tail=vv1/max(abs(vv1));
yc1=[real(yb1) f1tail'];

vft=smoothdata(yc1);
vft=smoothdata(vft);

f1tailD=vvD1/max(abs(vvD1));
%f1tailD=vft1aD/max(f1tailD);

yc2=[real(yb2) f1tailD'];
vft2=smoothdata(yc2);
vft2=smoothdata(vft2);

% xVft=.1:.1:(length(vft)/fs);
% figure;
% plot(xVft,(vft),'r')
% hold on;
% plot(xVft,(vft2),'b')
% xlabel('Time (s)')
% ylabel('Oxy-Hb (mMol.mm)')
% title('DLPFC Oxygenation During Full VFT and Aftermath')
% legend('OxyHb','DeoxyHb')
% hold off;


vft1a=nirsChannelCombine(squeeze(vft1(11,1:vftPost,:)));
vft1a=vft1a-mean(vft1a);
vft1a=vft1a/max(abs(vft1a));

vft1aD=nirsChannelCombine(squeeze(vft1Deox(1,1:vftPost,:)));
vft1aD=vft1aD-mean(vft1aD);
vft1aD=vft1aD/max(abs(vft1aD));

ma1=[(dlvft0)' vft1a'];
ma2=[(dlvft4)' vft1aD'];
ma1=ma1(:);
ma2=ma2(:);

% figure;
% plot(xVft,(ma1),'r')
% hold on;
% plot(xVft,(ma2),'b')
% xlabel('Time (s)')
% ylabel('Oxy-Hb (mMol.mm)')
% title('Raw DLPFC Oxygenation During Full VFT and Aftermath')
% legend('OxyHb','DeoxyHb')
% hold off;

vft1h=abs(ma1(1:vftPost,1));
vft2h=abs(ma1((vftPost+1):(2*vftPost),1));
vft3h=abs(ma1((2*vftPost+1):(3*vftPost),1));
vft4h=abs(ma1((3*vftPost+1):(4*vftPost),1));

vft1d=(ma2(1:vftPost,1));
vft2d=(ma2((vftPost+1):(2*vftPost),1));
vft3d=(ma2((2*vftPost+1):(3*vftPost),1));
vft4d=(ma2((3*vftPost+1):(4*vftPost),1));

% vt1h = mean(vft1h).*randn(vftPost,1) + var(vft1h);
% vt2h = mean(vft2h).*randn(vftPost,1) + var(vft2h);
% vt3h = mean(vft3h).*randn(vftPost,1) + var(vft3h);
% vt4h = mean(vft4h).*randn(vftPost,1) + var(vft4h);

vt1h = mean(vft1h).*ones(vftPost,1);
vt2h = mean(vft2h).*ones(vftPost,1);
vt3h = mean(vft3h).*ones(vftPost,1);
vt4h = mean(vft4h).*ones(vftPost,1);

vt1d = mean(vft1d).*ones(vftPost,1);
vt2d = mean(vft2d).*ones(vftPost,1);
vt3d = mean(vft3d).*ones(vftPost,1);
vt4d = mean(vft4d).*ones(vftPost,1);

na1=[vt1h; vt2h; vt3h; vt4h];
nb1=[vt1d; vt2d; vt3d; vt4d];

% figure;
% plot(xVft,smoothdata(na1),'r')
% xlabel('Time (s)')
% ylabel('Oxy-Hb (mMol.mm)')
% title('Raw DLPFC Oxygenation During Full VFT and Aftermath')
% legend('OxyHb')
%hold on;
%plot(xVft,smoothdata(nb1)-mean(smoothdata(nb1)),'b')
%legend('OxyHb','DeoxyHb')
%hold off;
figure;
plot(xVft,(na1),'r')
xlabel('Time (s)')
ylabel('Oxy-Hb (mMol.mm)')
title('DLPFC Oxygenation During Full VFT and Aftermath')
legend('OxyHb')
