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

%d1u=[mega1(2,:) mega3(2,:) mega4(2,:) mega5(2,:) mega6(2,:) mega8(2,:) mega9(2,:)];
%d1d=[mega1(3,:) mega3(3,:) mega4(3,:) mega5(3,:) mega6(3,:) mega8(3,:) mega9(3,:)];

%d2u=[mega1(5,:) mega3(5,:) mega4(5,:) mega5(5,:) mega6(5,:) mega7(5,:) mega8(5,:) mega9(5,:)];
%d2d=[mega1(6,:) mega3(6,:) mega4(6,:) mega5(6,:) mega6(6,:) mega7(6,:) mega8(6,:) mega9(6,:)];


d1uAv=mean(reshape(d1u,10,805));
d1dAv=mean(reshape(d1d,10,805));
d2uAv=mean(reshape(d2u,10,805));
d2dAv=mean(reshape(d2d,10,805));


vft1=[mega1(7,:) mega2(7,:) mega3(7,:) mega4(7,:) mega5(7,:) mega6(7,:) mega7(7,:) mega8(7,:) mega9(7,:) mega10(7,:)];
vft2=[mega1(8,:) mega2(8,:) mega3(8,:) mega4(8,:) mega5(8,:) mega6(8,:) mega7(8,:) mega8(8,:) mega9(8,:) mega10(8,:)];
vft3=[mega1(9,:) mega2(9,:) mega3(9,:) mega4(9,:) mega5(9,:) mega6(9,:) mega7(9,:) mega8(9,:) mega9(9,:) mega10(9,:)];


vftAv1=mean(reshape(vft1,10,805));
vftAv2=mean(reshape(vft2,10,805));
vftAv3=mean(reshape(vft3,10,805));



flcon=[mega1(11,:) mega2(11,:) mega3(11,:) mega4(11,:) mega5(11,:) mega6(11,:) mega7(11,:) mega8(11,:) mega9(11,:) mega10(11,:)];
flinc=[mega1(12,:) mega2(12,:) mega3(12,:) mega4(12,:) mega5(12,:) mega6(12,:) mega7(12,:) mega8(12,:) mega9(12,:) mega10(12,:)];

fcon=[mega1(14,:) mega2(14,:) mega3(14,:) mega4(14,:) mega5(14,:) mega6(14,:) mega7(14,:) mega8(14,:) mega9(14,:) mega10(14,:)];
finc=[mega1(15,:) mega2(15,:) mega3(15,:) mega4(15,:) mega5(15,:) mega6(15,:) mega7(15,:) mega8(15,:) mega9(15,:) mega10(15,:)];


%fcon=[mega1(14,:) mega2(14,:) mega3(14,:) mega4(14,:) mega5(14,:) mega6(14,:) mega8(14,:) mega9(14,:) mega10(14,:)];
%finc=[mega1(15,:) mega2(15,:) mega3(15,:) mega4(15,:) mega5(15,:) mega6(15,:) mega8(15,:) mega9(15,:) mega10(15,:)];


%% run tests

%Doors: combine for up vs down
[h,p]=ttest(d1u,d1d);
[h,p]=ttest(d2u,d2d);
du=mean([d1u;d2u]);
dd=mean([d1d;d2d]);
[h,p]=ttest(du,dd);
du=([d1u d2u]);
dd=([d1d d2d]);
[h,p]=ttest(du,dd);
du=mean([d1u;d2u]);
dd=mean([d1d;d2d]);
%VFT: rest v animals, rest v alphabet, alphabet v animals
[h,p]=ttest(vft1,vft2);
[h,p]=ttest(vft1,vft3);
[h,p]=ttest(vft2,vft3);

% rest v task
%[h,p]=ttest(vft1,mean([vft2,vft3]));

% task v other
%[h,p]=ttest(vft3,mean([vft2,vft1]));

% alphabet v other
%[h,p]=ttest(vft2,mean([vft3,vft1]));

%flanker: con vs inc

[h,p]=ttest(fcon,finc);

fconAv=mean(reshape(fcon,10,805));
fincAv=mean(reshape(finc,10,805));
%% features
d1uF=reshape(d1uAv,23,35);
d2uF=reshape(d2uAv,23,35);

d1dF=reshape(d1dAv,23,35);
d2dF=reshape(d2dAv,23,35);

dAllUF=.5*([d1uF+d2uF]);
dAllDF=.5*([d1dF+d2dF]);

vftF1=reshape(vftAv1,23,35);
vftF2=reshape(vftAv2,23,35);
vftF3=reshape(vftAv3,23,35);

fconF=reshape(fconAv,23,35);
fincF=reshape(fincAv,23,35);
