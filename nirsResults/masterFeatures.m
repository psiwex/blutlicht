inString='subBlock01.mat';
channel=5;
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

vt1h = mean(vft1m).*ones(vftPost,1);
vt2h = mean(vft2m).*ones(vftPost,1);
vt3h = mean(vft3m).*ones(vftPost,1);
vt4h = mean(detrend(vft1m)).*ones(vftPost,1);

vt1d = mean(vft1mD).*ones(vftPost,1);
vt2d = mean(vft2mD).*ones(vftPost,1);
vt3d = mean(vft3mD).*ones(vftPost,1);
vt4d = mean(detrend(vft1mD)).*ones(vftPost,1);

dlvft0=[vt1h; vt2h; vt3h; vt4h];
dlvft4=[vt1d; vt2d; vt3d; vt4d];
dlvft0=dlvft0(:,channel);
dlvft4=dlvft4(:,channel);
x12=(1/fs):(1/fs):((vftPost*4)/fs);

figure;
plot(x12,dlvft0,'r')
hold on;
plot(x12,dlvft4,'b')
xlabel('Time (s)')
ylabel('Oxy-Hb (mMol.mm)')
title('Smooth DLPFC Oxygenation During VFT')
legend('OxyHb','DeoxyHb')
hold off;


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
title('Left-DLPFC Average OxyHb During Doors')
hold on;
plot(xdoors,dlos,'r');
legend('Win','Loss')
hold off;

figure;
plot(xdoors,dwin,'r');
xlabel('Time (s)')
ylabel('Oxy-Hb (mMol.mm)')
title('Left-DLPFC OxyHb and DeoxyHb During Doors Win')
hold on;
plot(xdoors,dwinD,'b');
legend('OxyHb','DeoxyHb')
hold off;

figure;
plot(xdoors,dlos,'r');
xlabel('Time (s)')
ylabel('Oxy-Hb (mMol.mm)')
title('Left-DLPFC OxyHb and DeoxyHb During Doors Loss')
hold on;
plot(xdoors,dlosD,'b');
legend('OxyHb','DeoxyHb')
hold off;

dwav=mean(doorsWm)';
dlav=mean(doorsLm)';

dwavm=std(doorsWm)/sqrt(length(dwav))';
dlavm=std(doorsLm)/sqrt(length(dwav))';

dlos=mean(dlos).*ones(doorsPost,1);
dlosD=mean(dlosD).*ones(doorsPost,1);
figure;
plot(xdoors,dlos,'r');
xlabel('Time (s)')
ylabel('Oxy-Hb (mMol.mm)')
title('Loss Signal in Left-DLPFC OxyHb and Deoxy')
hold on;
plot(xdoors,dlosD,'b');
legend('OxyHb','DeoxyHb')
hold off;

dwin=mean(dwin).*ones(doorsPost,1);
dwinD=mean(dwinD).*ones(doorsPost,1);
figure;
plot(xdoors,dwin,'r');
xlabel('Time (s)')
ylabel('Oxy-Hb (mMol.mm)')
title('Win Signal in Left-DLPFC OxyHb and Deoxy')
hold on;
plot(xdoors,dwinD,'b');
legend('OxyHb','DeoxyHb')
hold off;



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
conAll1=[inctime; contime]';
conDAll1=[inctimeD; contimeD]';


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
pdd1 = polyfit(xflank,conAll1,ordR);
conFit = polyval(pdd1,xflank);
pdd2 = polyfit(xflank,conDAll1,ordR);
dincFit = polyval(pdd2,xflank);
clc;
% figure;
% plot(xflank,conFit,'r');
% xlabel('Time (s)')
% ylabel('Oxy-Hb (mMol.mm)')
% title('Smoothed Flanker Blocks Left-DLPFC OxyHb and Deoxy')
% hold on;
% plot(xflank,dincFit,'b');
% legend('OxyHb','DeoxyHb')
% hold off;
% 
% 
% figure;
% plot(xflank,conAll1,'r');
% xlabel('Time (s)')
% ylabel('Oxy-Hb (mMol.mm)')
% title('Raw Flanker Blocks Left-DLPFC OxyHb and Deoxy')
% hold on;
% plot(xflank,conDAll1,'b');
% legend('OxyHb','DeoxyHb')
% hold off;
% 

flc = mean(inctime).*ones(flPost,1);
fli = mean(contime).*ones(flPost,1);

flcD = mean(inctimeD).*ones(flPost,1);
fliD = mean(contimeD).*ones(flPost,1);

conAll=[fli; flc]';
conDAll=[fliD; flcD]';
% figure;
% plot(xflank,conAll,'r');
% xlabel('Time (s)')
% ylabel('Oxy-Hb (mMol.mm)')
% title('Flanker Blocks Left-DLPFC OxyHb and Deoxy')
% hold on;
% plot(xflank,conDAll,'b');
% legend('OxyHb','DeoxyHb')
% hold off;

% pre baseline


flc = mean(inctime).*ones(flPost,1);
fli = mean(contime).*ones(flPost,1);


flipp = (mean(fli)-mean(inctime(1:fs))).*ones(flPost,1);
flcpp = (mean(flc)-mean(contime(1:fs))).*ones(flPost,1);

flipt = (mean(fli)-mean(inctime((length(inctime)-fs):end))).*ones(flPost,1);
flcpt = (mean(flc)-mean(contime((length(contime)-fs):end))).*ones(flPost,1);


fliD = mean(inctimeD).*ones(flPost,1);
flcD = mean(contimeD).*ones(flPost,1);


flippD = (mean(fliD)-mean(inctimeD(1:fs))).*ones(flPost,1);
flcppD = (mean(flcD)-mean(contimeD(1:fs))).*ones(flPost,1);

fliptD = (mean(fliD)-mean(inctime((length(inctimeD)-fs):end))).*ones(flPost,1);
flcptD = (mean(flcD)-mean(contime((length(contimeD)-fs):end))).*ones(flPost,1);


conAll=[flipp(1:fs); fli; flc; flcpt(1:fs)]';
conDAll=[flippD(1:fs); fliD; flcD; flcptD(1:fs)]';


xflank=.1:.1:(length(conAll)/fs);

% figure;
% plot(xflank,conAll,'r');
% xlabel('Time (s)')
% ylabel('Oxy-Hb (mMol.mm)')
% title('Flanker Blocks Left-DLPFC OxyHb and Deoxy')
% hold on;
% plot(xflank,conDAll,'b');
% legend('OxyHb','DeoxyHb')
% hold off;

conAll=[flipp; fli; flc; flcpt]';
conDAll=[flippD; fliD; flcD; flcptD]';
xflank=.1:.1:(length(conAll)/fs);
% figure;
% plot(xflank,conAll,'r');
% xlabel('Time (s)')
% ylabel('Oxy-Hb (mMol.mm)')
% title('Flanker Blocks Left-DLPFC Trial')
% hold on;
% plot(xflank,conDAll,'b');
% legend('OxyHb','DeoxyHb')
% hold off;

conAll=[flipp; fli; flc; flipp]';
conDAll=[flippD; fliD; flcD; flippD]';

figure;
plot(xflank,conAll-min(flipp),'r');
xlabel('Time (s)')
ylabel('Oxy-Hb (mMol.mm)')
title('Flanker Blocks Left-DLPFC Trial')
hold on;
plot(xflank,conDAll-min(flippD),'b');
legend('OxyHb','DeoxyHb')
hold off;



%others
% 
% dc=fFlanCon(35,:);
% di=fFlanInc(35,:);
% scaleFactor=max([max(abs(dc)),max(abs(di))]);
% 
% dcD=fFlanCon(35,:);
% diD=fFlanInc(35,:);
% scaleFactorD=max([max(abs(dcD)),max(abs(diD))]);

%% area plot


conAll=[flipp(1:fs); fli; flc; flipp(1:fs)]';
conDAll=[flippD(1:fs); fliD; flcD; flippD(1:fs)]';
y = (conAll);
x = .1:.1:(length(y)/fs);

sins=(sin(x/((fs/2)*(fs/2))));
sin1=max(fli).*sins(1:flPost)';
sin2=max(flc).*sins(1:flPost)';
conAll=[flipp(1:fs); sin1; sin2; flipp(1:fs)]';
y = (conAll-min(abs(flipp)));
%y=smoothdata(y);
% y = abs(conAll1-conDAll1); % your mean vector;
x = .1:.1:(length(y)/fs);
std_dev = std(y);
curve1 = y + std_dev;
curve2 = y - std_dev;
x2 = [x, fliplr(x)];
figure;
inBetween = [curve1, fliplr(curve2)];
fill(x2, inBetween, 'g');
xlabel('Time (s)')
ylabel('Oxy-Hb (mMol.mm)')
title('Flanker Blocks')
hold on;
plot(x, y, 'r', 'LineWidth', 2);
hold off;
