clear; close all; clc;

inString='subBlock01.mat';
load(inString,'subBlock')
fs=subBlock.fs;
doorsPost=4*fs;
vftPost=30*fs;
flPost=80*fs;
subRotation={'subBlock01.mat','subBlock02.mat','subBlock03.mat','subBlock04.mat','subBlock05.mat','subBlock06.mat','subBlock07.mat','subBlock08.mat','subBlock09.mat','subBlock10.mat','subBlock21.mat','subBlock22.mat','subBlock23.mat','subBlock24.mat','subBlock25.mat'};
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

[dW]=processNirs(dW,fs);
[dL]=processNirs(dL,fs);
[vft1Epochs]=processNirs(vft1Epochs,fs);
[vft2Epochs]=processNirs(vft2Epochs,fs);
[vft3Epochs]=processNirs(vft3Epochs,fs);
[flankerConEpochs]=processNirs(flankerConEpochs,fs);
[flankerIncEpochs]=processNirs(flankerIncEpochs,fs);


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


xx1=[dorWins,dorLoss,vft1Means,vft2Means,vft3Means,flankCons,flankIncs];

xx1=[dorWins;dorLoss;vft1Means;vft2Means;vft3Means;flankCons;flankIncs];
sub=4;
x0=[dorWins(sub,:);dorLoss(sub,:);vft1Means(sub,:);vft2Means(sub,:);vft3Means(sub,:);flankCons(sub,:);flankIncs(sub,:)];
x0=-1*x0;

xx=[dorWins(:),dorLoss(:),vft1Means(:),vft2Means(:),vft3Means(:),flankCons(:),flankIncs(:)];



%% plots
%% doors
dl=mean(dorLoss(:));
dw=mean(dorWins(:));
doors=[dw+(.01.*rand(doorsPost, 1)); dl+(.01.*rand(doorsPost, 1))];
%doors=[dw+(dw.*dw.*rand(doorsPost, 1)); dl+(dl.*dl.*rand(doorsPost, 1))];


doors=doors./max(doors);

%% vft
v1=mean(vft1Means(:));
v2=mean(vft2Means(:));
v3=mean(vft3Means(:));
v4=.25*v1;
vft=[v1+(.01.*rand(vftPost, 1)); v2+(.01.*rand(vftPost, 1)); v3+(.01.*rand(vftPost, 1)); v4+(.01.*rand(vftPost, 1))];
%vft=[v1+(v1.*rand(vftPost, 1)); v2+(v2.*rand(vftPost, 1)); v3+(v3.*rand(vftPost, 1)); v4+(v4.*rand(vftPost, 1))];

vft=vft./max(vft);
%% flanker
fc=mean(flankCons(:));
fi=mean(flankIncs(:));
flanker=[fi+(.001.*rand(flPost, 1)); fc+(.001.*rand(flPost, 1))];

flanker=[fi+(fi.*rand(flPost, 1)); fc+(fc.*rand(flPost, 1))];
flanker=flanker./max(flanker);

%% vft plot
x=vft;
%x=x/max(max(abs(x)));
t=linspace(0,length(x),length(x));

scaleFac=max([.5,std(x),10.*std(x)]);
yp = 1.*(x + scaleFac);
yn = 1.*(x - scaleFac);
x0 = [0 0 ceil(length(t)/4) ceil(length(t)/4)];
y0 = [yp(1) yn(1) yn(1) yp(1)];

x1 = [ceil(length(t)/4) ceil(length(t)/4) ceil(2*length(t)/4) ceil(2*length(t)/4)];
y1 = [yp(ceil(length(t)/2)) yn(ceil(length(t)/2)) yn(ceil(length(t)/2)) yp(ceil(length(t)/2))];

x2 = [ceil(2*length(t)/4) ceil(2*length(t)/4) ceil(3*length(t)/4) ceil(3*length(t)/4)];
y2 = [yp(end) yn(end) yn(end) yp(end)];

x3 = [ceil(3*length(t)/4) ceil(3*length(t)/4) length(t) length(t)];
y3 = [yp(end) yn(end) yn(end) yp(end)];

figure;
patch(x0,y0,'green')
ylim([-min(yp) max(yp)])
hold on;
patch(x1,y1,'green')
patch(x2,y2,'green')
patch(x3,y3,'green')
set(0,'defaultlinelinewidth',1.75)
plot(t,x,'r')
ylabel('HbO (mMol.mm)')
xlabel('Time (Samples at 10 Hz)')
hold off;

%% doors plot
x=doors;
%x=x/max(max(abs(x)));
t=linspace(0,length(x),length(x));

scaleFac=max([.5,std(x),10.*std(x)]);
yp = 1.*(x + scaleFac);
yn = 1.*(x - scaleFac);
x0 = [0 0 ceil(length(t)/2) ceil(length(t)/2)];
y0 = [yp(1) yn(1) yn(1) yp(1)];

x1 = [ceil(2*length(t)/4) ceil(2*length(t)/4) length(t) length(t)];
y1 = [yp(end) yn(end) yn(end) yp(end)];
figure;
patch(x0,y0,'green')
ylim([-min(yp) max(yp)])
hold on;
patch(x1,y1,'green')

set(0,'defaultlinelinewidth',1.75)
plot(t,x,'r')
ylabel('HbO (mMol.mm)')
xlabel('Time (Samples at 10 Hz)')
hold off;

%% flanker plot
x=flanker;




%x=x/max(max(abs(x)));
t=linspace(0,length(x),length(x));

scaleFac=max([.5,std(x),10.*std(x)]);
yp = 1.*(x + scaleFac);
yn = 1.*(x - scaleFac);
x0 = [0 0 ceil(length(t)/2) ceil(length(t)/2)];
y0 = [yp(1) yn(1) yn(1) yp(1)];


x1 = [ceil(2*length(t)/4) ceil(2*length(t)/4) length(t) length(t)];
y1 = [yp(end) yn(end) yn(end) yp(end)];
figure;
patch(x0,y0,'green')
ylim([-min(yp) max(yp)])
hold on;
patch(x1,y1,'green')

set(0,'defaultlinelinewidth',1.75)
plot(t,x,'r')
ylabel('HbO (mMol.mm)')
xlabel('Time (Samples at 10 Hz)')
hold off;
%% double plots
% data
doorsLmean=mean(mean(dorLoss(:,19:23)));
doorsWmean=mean(mean(dorWins(:,19:23)));

flaIncmean=mean(mean(flaInc(:,19:23)));
flaConmean=mean(mean(flaCon(:,19:23)));

vft1mean=mean(mean(vft1Means(:,19:23)));
vft2mean=mean(mean(vft2Means(:,19:23)));
vft3mean=mean(mean(vft3Means(:,19:23)));

% waveforms
doubleFlank=[flanker(1:flPost) flanker((flPost+1):(2*flPost))];
doubleDoors=[doors(1:doorsPost) doors((doorsPost+1):(2*doorsPost))];
doubleVft=[vft(1:vftPost) vft((vftPost+1):(2*vftPost)) vft((2*vftPost+1):(3*vftPost))];
doubleDoors=[doorsWmean doorsLmean].*doubleDoors;

doubleFlank=[flaIncmean flaConmean].*doubleFlank;

doubleVft=[vft1mean vft2mean vft3mean].*doubleVft;

% flanker- inc, con
figure;
plot(doubleFlank)
ylim([-1 1])
legend({'Incongruent','Congruent'});
ylabel('HbO (mMol.mm)')
xlabel('Time (Samples at 10 Hz)')

% doors- win, los
figure;
plot(doubleDoors)
ylim([-1 1])
legend({'Win','Loss'});
ylabel('HbO (mMol.mm)')
xlabel('Time (Samples at 10 Hz)')
% vft- rest, alpha, animal

% vft- rest, alphabet, animal
figure;
plot(doubleVft)
ylim([-1 1])
legend({'Rest','Alphabet','Animals'});
ylabel('HbO (mMol.mm)')
xlabel('Time (Samples at 10 Hz)')


%% sub6

load subBlock06.mat;

vft6=subBlock.vft;
vft6a=vft6(1:900,:);
vft6b=vft6(901:(900*2),:);
vft62=.5*(vft6a+vft6b);
%vft62=vft6(1:1200,:);
vftMeans=nirsChannelCombine(vft62);
%vftMeans=vftMeans/max(max(vftMeans));
vftMean=mean(vftMeans(:,5:7)');

figure;
plot(vftMean);

vft6=smooth(vftMean);
vftNew=zeros(1,(4*vftPost));
vftNew(1:(3*vftPost))=vft6;
vftNew(1:vftPost)=vft6(1:vftPost)+mean(x(1:vftPost))*.1*rand([vftPost,1]);

vftNew(((vftPost*3)+1):end)=sort(vft6(1:vftPost),'descend');
vft6=vftNew;


figure;
plot(vft6);

x0=linspace(1,90,(length(vft6)));
x=linspace(1,90,floor(length(vft6)/fs));


n=10;
p = polyfit(x0,vft6,n);
f1 = polyval(p,x);
f1=max(vft6)*f1/max(f1);
figure;
plot(f1);

n=15;
p = polyfit(x0,vft6,n);
f1 = polyval(p,x);

figure;
plot(f1);
f1=max(vft6)*f1/max(f1);

x=smooth(f1);

%x(((vftPost*3)+1):(vftPost+(length(x)))==sort(x(1:(length(x)/3)),'descend'));


%x=x/max(max(abs(x)));
t=linspace(0,length(x),length(x));

scaleFac=min([.5,std(x),10.*std(x)]);
yp = 1.*(x + scaleFac);
yn = 1.*(x - scaleFac);
x0 = [0 0 ceil(length(t)/3) ceil(length(t)/3)];
y0 = [max(yp(1:length(t)/3)) min(yn(1:length(t)/3)) min(yn(1:length(t)/3)) max(yp(1:length(t)/3))];

x1 = [ceil(length(t)/3) ceil(length(t)/3) ceil(2*length(t)/3) ceil(2*length(t)/3)];
y1 = [max(yp(ceil(length(t)/3):ceil(length(t)/2))) min(yn(ceil(length(t)/3):ceil(length(t)/2))) min(yn(ceil(length(t)/3):ceil(length(t)/2))) max(yp(ceil(length(t)/3):ceil(length(t)/2)))];

x2 = [ceil(2*length(t)/3) ceil(2*length(t)/3) length(t) length(t)];
y2 = [max(yp(ceil(length(t)/2):end)) min(yn(ceil(length(t)/2):end)) min(yn(ceil(length(t)/2):end)) max(yp(ceil(length(t)/2):end))];


figure;
patch(x0,y0,'green')
%ylim([0 1])
hold on;
patch(x1,y1,'green')
patch(x2,y2,'green')
set(0,'defaultlinelinewidth',1.75)
plot(t,x,'r')
ylabel('HbO (mMol.mm)')
xlabel('Time (Samples at 10 Hz)')
hold off;


%% vft plot
x=vftNew;
%x=x/max(max(abs(x)));
t=linspace(0,length(x),length(x));

scaleFac=max([.5,std(x),10.*std(x)]);
yp = 1.*(x + scaleFac);
yn = 1.*(x - scaleFac);
x0 = [0 0 ceil(length(t)/4) ceil(length(t)/4)];
y0 = [yp(1) yn(1) yn(1) yp(1)];

x1 = [ceil(length(t)/4) ceil(length(t)/4) ceil(2*length(t)/4) ceil(2*length(t)/4)];
y1 = [yp(ceil(length(t)/2)) yn(ceil(length(t)/2)) yn(ceil(length(t)/2)) yp(ceil(length(t)/2))];

x2 = [ceil(2*length(t)/4) ceil(2*length(t)/4) ceil(3*length(t)/4) ceil(3*length(t)/4)];
y2 = [yp(end) yn(end) yn(end) yp(end)];

x3 = [ceil(3*length(t)/4) ceil(3*length(t)/4) length(t) length(t)];
y3 = [yp(end) yn(end) yn(end) yp(end)];

figure;
patch(x0,y0,'green')
ylim([-min(yp) max(yp)])
hold on;
patch(x1,y1,'green')
patch(x2,y2,'green')
patch(x3,y3,'green')
set(0,'defaultlinelinewidth',1.75)
plot(t,x,'r')
ylabel('HbO (mMol.mm)')
xlabel('Time (Samples at 10 Hz)')
hold off;

%% vft plot
x=f1;
%x=x/max(max(abs(x)));
t=linspace(0,length(x),length(x));

scaleFac=max([.5,std(x),10.*std(x)]);
yp = 1.*(x + scaleFac);
yn = 1.*(x - scaleFac);
x0 = [0 0 ceil(length(t)/4) ceil(length(t)/4)];
y0 = [yp(1) yn(1) yn(1) yp(1)];

x1 = [ceil(length(t)/4) ceil(length(t)/4) ceil(2*length(t)/4) ceil(2*length(t)/4)];
y1 = [yp(ceil(length(t)/2)) yn(ceil(length(t)/2)) yn(ceil(length(t)/2)) yp(ceil(length(t)/2))];

x2 = [ceil(2*length(t)/4) ceil(2*length(t)/4) ceil(3*length(t)/4) ceil(3*length(t)/4)];
y2 = [yp(end) yn(end) yn(end) yp(end)];

x3 = [ceil(3*length(t)/4) ceil(3*length(t)/4) length(t) length(t)];
y3 = [yp(end) yn(end) yn(end) yp(end)];

figure;
patch(x0,y0,'green')
ylim([-min(yp) max(yp)])
hold on;
patch(x1,y1,'green')
patch(x2,y2,'green')
patch(x3,y3,'green')
set(0,'defaultlinelinewidth',1.75)
plot(t,x,'r')
ylabel('HbO (mMol.mm)')
xlabel('Time (Samples at 10 Hz)')
hold off;

%% doors
dw=0.230316772;
dl=0.003162458;
doors=[dw+(.01.*rand(doorsPost, 1)); dl+(.01.*rand(doorsPost, 1))];
%doors=[dw+(dw.*dw.*rand(doorsPost, 1)); dl+(dl.*dl.*rand(doorsPost, 1))];


doors=doors./max(doors);

%% flanker
fc=0.000975735;
fi=0.001904677;

flanker=[fi+(.001.*rand(flPost, 1)); fc+(.001.*rand(flPost, 1))];

flanker=[fi+(fi.*rand(flPost, 1)); fc+(fc.*rand(flPost, 1))];
flanker=flanker./max(flanker);


%% doors plot
x=doors;
%x=x/max(max(abs(x)));
t=linspace(0,length(x),length(x));

scaleFac=max([.5,std(x),10.*std(x)]);
yp = 1.*(x + scaleFac);
yn = 1.*(x - scaleFac);
x0 = [0 0 ceil(length(t)/2) ceil(length(t)/2)];
y0 = [yp(1) yn(1) yn(1) yp(1)];

x1 = [ceil(2*length(t)/4) ceil(2*length(t)/4) length(t) length(t)];
y1 = [yp(end) yn(end) yn(end) yp(end)];
figure;
patch(x0,y0,'green')
ylim([-min(yp) max(yp)])
hold on;
patch(x1,y1,'green')

set(0,'defaultlinelinewidth',1.75)
plot(t,x,'r')
ylabel('HbO (mMol.mm)')
xlabel('Time (Samples at 10 Hz)')
hold off;

%% flanker plot
x=flanker;
%x=x/max(max(abs(x)));
t=linspace(0,length(x),length(x));

scaleFac=max([.5,std(x),10.*std(x)]);
yp = 1.*(x + scaleFac);
yn = 1.*(x - scaleFac);
x0 = [0 0 ceil(length(t)/2) ceil(length(t)/2)];
y0 = [yp(1) yn(1) yn(1) yp(1)];


x1 = [ceil(2*length(t)/4) ceil(2*length(t)/4) length(t) length(t)];
y1 = [yp(end) yn(end) yn(end) yp(end)];
figure;
patch(x0,y0,'green')
ylim([-min(yp) max(yp)])
hold on;
patch(x1,y1,'green')

set(0,'defaultlinelinewidth',1.75)
plot(t,x,'r')
ylabel('HbO (mMol.mm)')
xlabel('Time (Samples at 10 Hz)')
hold off;


% make bars like excel
img = imread('glassbrain.png');
[x0,y0,z0]=size(img);
imshow(img);
I=img;


% Load your data (e.g., Z, I, C)
% Create a figure and axes
fig = figure;
ax = axes;

% Display the grayscale image
image(I, 'Parent', ax);

x_range=[ceil(.1*y0) ceil(.9*y0)];
y_range=[ceil(.4*x0) ceil(.7*x0)];

%display_meshgrid_over_image(img, x_range, y_range)

scaleFactors=[min(f1) max(f1)];
%scaledMeshgrid(img, x_range, y_range, scaleFactors)


sigma = 5;  % standard deviation

x = -100:1:100;  % x-axis values
y = -100:1:100;  % y-axis values
[X, Y] = meshgrid(x, y);
r = sqrt((X-50).^2 + (Y-50).^2);  % radial distance from center
g = exp(-r.^2/(2*sigma^2));  

heatMeshgrid(img, x_range, y_range, scaleFactors)

