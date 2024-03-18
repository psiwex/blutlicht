%VLPFC-RITE: Ventrolateral Prefrontal Cortex (right) [0-3]
%OFFPC-RITE: Orbitofrontal Prefrontal Cortex (right)/Frontopolar Prefrontal Cortex (left) [4-6]
%DLPFC-RITE: Dorsolateral Prefrontal Cortex (right)/Frontopolar Prefrontal Cortex (right) [7-9]
%OFPFC-MID: Orbitofrontal Prefrontal Cortex [10-12]
%DLPFC-LEFT: Dorsolateral Prefrontal Cortex (left)/Frontopolar Prefrontal Cortex (left) [13-15]
%OFFPC-LEFT: Orbitofrontal Prefrontal Cortex (left)/Frontopolar Prefrontal Cortex (left) [16-18]
%VLPFC-LEFT: Ventrolateral Prefrontal Cortex (left) [19-22]

fs=10;
d1T = readtable('d1Data.csv','NumHeaderLines',0);
d1=table2array(d1T(:,:));
d1DownRaw = readtable('d1DownRaw.csv','NumHeaderLines',0);
d1DownRaw=table2array(d1DownRaw(:,:));
d1UpRaw = readtable('d1UpRaw.csv','NumHeaderLines',0);
d1UpRaw=table2array(d1UpRaw(:,:));

d2T = readtable('d2Data.csv','NumHeaderLines',0);
d2=table2array(d2T(:,:));
d2DownRaw = readtable('d2DownRaw.csv','NumHeaderLines',0);
d2DownRaw=table2array(d2DownRaw(:,:));
d2UpRaw = readtable('d2UpRaw.csv','NumHeaderLines',0);
d2UpRaw=table2array(d2UpRaw(:,:));

VFT = readtable('vftData.csv','NumHeaderLines',0);
VFT=table2array(VFT(:,:));

vft1Raw = readtable('vft1Raw.csv','NumHeaderLines',0);
vft1Raw=table2array(vft1Raw(:,:));

vft2Raw = readtable('vft2Raw.csv','NumHeaderLines',0);
vft2Raw=table2array(vft2Raw(:,:));

vft3Raw = readtable('vft3Raw.csv','NumHeaderLines',0);
vft3Raw=table2array(vft3Raw(:,:));

fb = readtable('fbData.csv','NumHeaderLines',0);
fb=table2array(fb(:,:));

fbConRaw = readtable('fbConRaw.csv','NumHeaderLines',0);
fbConRaw=table2array(fbConRaw(:,:));

fbIncRaw = readtable('fbIncRaw.csv','NumHeaderLines',0);
fbIncRaw=table2array(fbIncRaw(:,:));

dlvft1=abs(mean(VFT(((vft1Raw(1)+1):vft2Raw(1)),14:16),2));
dlvft2=abs(mean(VFT(((vft2Raw(1)+1):vft3Raw(1)),14:16),2));
dlvft3=abs(mean(VFT(((vft3Raw(1)+1):vft1Raw(2)),14:16),2));


dlvft1=[dlvft1; zeros(600,1)];
dlvft2=[zeros(300,1); dlvft2; zeros(300,1)];
dlvft3=[zeros(600,1); dlvft3];

figure(1);
plot(dlvft1);

xlabel('Time (ms)')
ylabel('Oxy-Hb')
title('DLPFC Oxygenation')
hold on;
plot(dlvft2,'r');
plot(dlvft3,'g');
legend('Rest','Alphabet','Animals')
hold off;

dlvft1=abs(mean(VFT(((vft1Raw(2)+1):vft2Raw(2)),14:16),2));
dlvft2=abs(mean(VFT(((vft2Raw(2)+1):vft3Raw(2)),14:16),2));
dlvft3=abs(mean(VFT(((vft3Raw(2)+1):end),14:16),2));

dlvft1b=[dlvft1; zeros(600,1)];
dlvft2b=[zeros(300,1); dlvft2; zeros(300,1)];
dlvft3b=[zeros(600,1); dlvft3];

figure(2);
plot(dlvft1b);

xlabel('Time (ms)')
ylabel('Oxy-Hb')
title('DLPFC Oxygenation')
hold on;
plot(dlvft2b,'r');
plot(dlvft3b,'g');
legend('Rest','Alphabet','Animals')
hold off;

%% spectrogram
x=abs(dlvft2-dlvft1);

%M = 49;
%L = 11;
%g = bartlett(M);
%Ndft = 1024;
%[s,f,t] = spectrogram(x,g,L,Ndft,fs);
%s = spectrogram(x,fs);
figure(3);
spectrogram(x,fs, 'yaxis')


%M = 49;
%L = 11;
%g = bartlett(M);
%Ndft = 1024;
%[s,f,t] = spectrogram(x,g,L,Ndft,fs);
%s = spectrogram(x,fs);
figure(4);

plot(dlvft1);

xlabel('Time (ms)')
ylabel('Oxy-Hb')
title('DLPFC Oxygenation')
hold on;
plot(dlvft2,'r');
plot(dlvft3,'g');
legend('Rest','Alphabet','Animals')
hold off;


