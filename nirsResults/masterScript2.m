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
clear flankerConEpochs flankerIncEpochs vft1 vft2 vft3 doorsW doorsL;
clear flankerConEpochsD flankerIncEpochsD vft1D vft2D vft3D doorsWD doorsLD;

%% averaging and thresholding
% data consolidation
% ox
doorsWm=squeeze(mean(dW));
doorsLm=squeeze(mean(dL));

doorsWm=doorsWm(1:doorsPost,:);
doorsLm=doorsLm(1:doorsPost,:);
vft1m=squeeze(mean(vft1Epochs));
vft2m=squeeze(mean(vft2Epochs));
vft3m=squeeze(mean(vft3Epochs));
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
vft4mD=mean([vft1mD vft2mD vft3mD]');

dlvft0=[abs(vft1m(:,channel)); abs(vft2m(:,channel)); abs(vft3m(:,channel))];
dlvft1=[abs(vft1m(:,channel)); zeros(300,1); zeros(300,1)];
dlvft2=[zeros(300,1); abs(vft2m(:,channel)); zeros(300,1)];
dlvft3=[zeros(300,1); zeros(300,1); abs(vft3m(:,channel))];
dlvft4=[vft1mD(:,channel); vft2mD(:,channel); vft3mD(:,channel)];

% 
vft1=abs(vft1m(1:300,:));
vft2=abs(vft2m(1:300,:));
vft3=abs(vft3m(1:300,:));

vm1=mean(vft1m)';
vm2=mean(vft2m)';
vm3=mean(vft3m)';
vs1=std(vft1m)';
vs2=std(vft2m)';
vs3=std(vft3m)';
vse1=vs1/sqrt(length(vft1m));
vse2=vs2/sqrt(length(vft2m));
vse3=vs3/sqrt(length(vft3m));

figure;
plot(dlvft1);
% % 
xlabel('Time (10hz samples)')
ylabel('Oxy-Hb')
title('DLPFC Oxygenation')
hold on;
plot(dlvft2,'r');
plot(dlvft3,'g');
plot(dlvft4,'k');
legend('Rest','Alphabet','Animals','DeoxyHb')
hold off;

figure;
plot(dlvft0);
% % 
xlabel('Time (10hz samples)')
ylabel('Oxy-Hb (mMol.mm)')
title('DLPFC Oxygenation')
hold on;

%plot(dlvft0-dlvft4,'g');
plot(dlvft4,'k');
legend('OxyHb','DeoxyHb')
%legend('OxyHb','TotalHb','DeoxyHb')
hold off;


% lamer
% scaleFactor=max([max(abs(vft1m(:,channel))),max(abs(vft2m(:,channel))),max(abs(vft3m(:,channel)))]);
% v1=downsample(vft1m(1:300,channel),10)/scaleFactor;
% v2=downsample(vft2m(1:300,channel),10)/scaleFactor;
% v3=downsample(vft3m(1:300,channel),10)/scaleFactor;
% 
% v1=1/v1;
% v2=1/v2;
% v3=1/v3;
% 
% dlvft1=[abs(v1)'; zeros(30,1); zeros(30,1)];
% dlvft2=[zeros(30,1); abs(v2)'; zeros(30,1)];
% dlvft3=[zeros(30,1); zeros(30,1); abs(v3)'];

% figure;
% plot(dlvft1);
% % 
% xlabel('Time (s)')
% ylabel('Oxy-Hb')
% title('Peak LEFT-DLPFC Location')
% hold on;
% plot(dlvft2,'r');
% plot(dlvft3,'g');
% legend('Rest','Alphabet','Animals')
% hold off;

% vft contrasts
% v12=abs(v2-v1);
% v13=abs(v3-v1);
% x1=fVft1(35,:);
% x2=fVft2(35,:);
% x3=fVft3(35,:);
% scaleFactor=max([max(abs(x1)),max(abs(x2)),max(abs(x3))]);

% x1=(x1/scaleFactor)';
% x2=(x2/scaleFactor)';
% x3=(x3/scaleFactor)';
% xx1=std(fVft1(1:35,:)/scaleFactor)';
% xx2=std(fVft2(1:35,:)/scaleFactor)';
% xx3=std(fVft3(1:35,:)/scaleFactor)';
% mse1=std(x1)/sqrt(length(x1));
% mse2=std(x2)/sqrt(length(x2));
% mse3=std(x3)/sqrt(length(x3));

%% doors

dwin=doorsWm(:,channel);
dlos=doorsLm(:,channel);
scaleFactor=max([max(abs(dwin)),max(abs(dlos))]);
% dwin=dwin/scaleFactor;
% dlos=dlos/scaleFactor;
dwin=downsample(dwin,10)/scaleFactor;
dlos=downsample(dlos,10)/scaleFactor;

dwinD=doorsWmD(:,channel);
dlosD=doorsLmD(:,channel);
scaleFactorD=max([max(abs(dwinD)),max(abs(dlosD))]);
dwinD=downsample(dwinD,10)/scaleFactorD;
dlosD=downsample(dlosD,10)/scaleFactorD;

figure;
plot(dwin);
% 
xlabel('Time (s)')
ylabel('Oxy-Hb (mMol.mm)')
title('Smoothed LEFT-DLPFC Average')
hold on;
plot(dlos,'r');

legend('Win','Loss')
hold off;

% more like yeung
interVal=(1/fs);
xLine = 0:interVal:(vftPost/fs);
xLine=xLine(1:(length(xLine)-1));
yLine = gaussmf(xLine,[2*std(xLine) 1.5*mean(xLine)]);
yLine=max(vft2m(:,channel)).*yLine;
plot(xLine,yLine)

yLine2 = gaussmf(xLine,[1.1*std(xLine) mean(xLine)]);
yLine2=max(vft3m(:,channel)).*yLine2;
xLine2 = 0:interVal:(2*(vftPost/fs));
xLine2=xLine2(1:(2*vftPost));
yFus=[yLine yLine2];
%figure();
%plot(xLine2,yFus)
yLineD = gaussmf(xLine2,[2*std(xLine) 1.5*mean(xLine)]);
% Y = exp(xLine/2);
% Y=Y/abs(Y);
% Y=1-Y;
% plot(xLine,Y)

%% flanker
channel=1;
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
%figure;
%bar(dFlank)