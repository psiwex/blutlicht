inString='subBlockDeox01.mat';
load(inString,'subBlock')
fs=subBlock.fs;
doorsPost=4*fs;
vftPost=30*fs;
flPost=80*fs;
subRotation={'subBlockDeox01.mat','subBlockDeox02.mat','subBlockDeox03.mat','subBlockDeox04.mat','subBlockDeox05.mat','subBlockDeox06.mat','subBlockDeox07.mat','subBlockDeox08.mat','subBlockDeox09.mat','subBlockDeox10.mat'};

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

doorsW=[doorsW; dW];
doorsL=[doorsL; dL];

vft1=[vft1; vft1Epochs];
vft2=[vft2; vft2Epochs];
vft3=[vft3; vft3Epochs];

flcon=[flcon; flankerConEpochs];
flinc=[flinc; flankerIncEpochs];

end
clear flankerConEpochs flankerIncEpochs vft1 vft2 vft3 doorsW doorsL;
%% averaging and thresholding
% data consolidation
doorsWm=squeeze(mean(dW));
doorsLm=squeeze(mean(dL));

vft1m=squeeze(mean(vft1Epochs));
vft2m=squeeze(mean(vft2Epochs));
vft3m=squeeze(mean(vft3Epochs));

flankcm=squeeze(mean(flcon));
flankim=squeeze(mean(flinc));

% ROI consolidation
[doorsWm]=nirsChannelCombine(doorsWm);
[doorsLm]=nirsChannelCombine(doorsLm);

[vft1m]=nirsChannelCombine(vft1m);
[vft2m]=nirsChannelCombine(vft2m);
[vft3m]=nirsChannelCombine(vft3m);

[flankcm]=nirsChannelCombine(flankcm);
[flankim]=nirsChannelCombine(flankim);

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
dlvft1=[abs(vft1m(:,channel)); zeros(300,1); zeros(300,1)];
dlvft2=[zeros(300,1); abs(vft2m(1:300,channel))+.25*mean(abs(vft1m(:,channel))); zeros(300,1)];
dlvft3=[zeros(300,1); zeros(300,1); abs(vft3m(1:300,channel))+.25*mean(abs(dlvft2(301:600)))];
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
legend('Rest','Alphabet','Animals')
hold off;
scaleFactor=max([max(abs(vft1m(1:300,channel))),max(abs(vft2m(1:300,channel))),max(abs(vft3m(1:300,channel)))]);
v1=downsample(vft1m(1:300,channel),10)/scaleFactor;
v2=downsample(vft2m(1:300,channel),10)/scaleFactor;
v3=downsample(vft3m(1:300,channel),10)/scaleFactor;

v1=1/v1;
v2=1/v2;
v3=1/v3;

dlvft1=[abs(v1)'; zeros(30,1); zeros(30,1)];
dlvft2=[zeros(30,1); abs(v2)'; zeros(30,1)];
dlvft3=[zeros(30,1); zeros(30,1); abs(v3)'];

figure;
plot(dlvft1);
% 
xlabel('Time (s)')
ylabel('Oxy-Hb')
title('Peak LEFT-DLPFC Location')
hold on;
plot(dlvft2,'r');
plot(dlvft3,'g');
legend('Rest','Alphabet','Animals')
hold off;

% vft contrasts
v12=abs(v2-v1);
v13=abs(v3-v1);
x1=fVft1(35,:);
x2=fVft2(35,:);
x3=fVft3(35,:);
scaleFactor=max([max(abs(x1)),max(abs(x2)),max(abs(x3))]);

x1=(x1/scaleFactor)';
x2=(x2/scaleFactor)';
x3=(x3/scaleFactor)';
xx1=std(fVft1(1:35,:)/scaleFactor)';
xx2=std(fVft2(1:35,:)/scaleFactor)';
xx3=std(fVft3(1:35,:)/scaleFactor)';
mse1=std(x1)/sqrt(length(x1));
mse2=std(x2)/sqrt(length(x2));
mse3=std(x3)/sqrt(length(x3));

%% doors

dwin=doorsWm(:,channel);
dlos=doorsLm(:,channel);
scaleFactor=max([max(abs(dwin)),max(abs(dlos))]);
% dwin=dwin/scaleFactor;
% dlos=dlos/scaleFactor;
dwin=downsample(dwin,10)/scaleFactor;
dlos=downsample(dlos,10)/scaleFactor;

figure;
plot(dwin);
% 
xlabel('Time (s)')
ylabel('Oxy-Hb')
title('Smoothed LEFT-DLPFC Average')
hold on;
plot(dlos,'r');

legend('Win','Loss')
hold off;

%% flanker
channel=1;
dc=fFlanCon(35,:);
di=fFlanInc(35,:);
scaleFactor=max([max(abs(dc)),max(abs(di))]);

%di=di/scaleFactor;
%dc=dc/scaleFactor;

dc=log(dc);
di=log(di);
scaleFactor=max([max(abs(dc)),max(abs(di))]);

di=di/scaleFactor;
dc=dc/scaleFactor;
y=abs([dc; di]); 

str = {"VLPFC-R", "OFFPC-R", "DLPFC-R", "OFPFC-M", "DLPFC-L", "OFFPC-L", "VLPFC-L"};

figure;
bar(y');
set(gca, 'XTickLabel',str, 'XTick',1:numel(str))
ylabel('Oxy-Hb')
title('ROI Oxygenation')

%hold on
%x=[1:1:7; 1:1:7];
mse=std(y)/sqrt(length(dc));
%err=[mse; mse];
%er = errorbar(x',y',err','k','linestyle','none');    
%hold off

con=mean(fFlanCon(1:18,:)');
inc=mean(fFlanCon(1:18,:)');
dFlank=abs(con-inc);
%figure;
%bar(dFlank)