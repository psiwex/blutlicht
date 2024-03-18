load('megaMat.mat')
load('vft0.mat')
%% DOORS
d1=megaMac(:,1); d2=megaMac(:,7);

d1u=megaMac(:,3); d2u=megaMac(:,9);

d1d=megaMac(:,5); d2d=megaMac(:,11);

d=[d1; d2];
du=[d1u; d2u];
dd=[d1d; d2d];
du=du-d;

dd1=reshape(d,7,20);
ddu1=reshape(du,7,20);
ddd1=reshape(dd,7,20);

[h,p]=ttest(v1',v3');

fm=megaMac(:,19);
fc=megaMac(:,21);
fi=megaMac(:,23);
[h,p]=ttest(fm,fc);
[h,p]=ttest(fm,fi);

[h,p]=ttest(fc,fi);

fcc=reshape(fc,7,10);

fci=reshape(fi,7,10);

fcm=reshape(fm,7,10);
 [h,p]=ttest(fci',fcm');
[h,p]=ttest(fcc',fci');
 [h,p]=ttest(fcc',fcm');

trgroup=[zeros(20,1); ones(20,1)];
training=[ddd1 ddu1];
pvalue=2;
testing=training;

[w_mad,a_mad,training_mad,test_mad]=feature_selection_aden(training',trgroup',testing',pvalue);
 
x=test_mad(1:20,:);
y=test_mad(21:40,:);
[h,p]=ttest(x,y);



[w_mad,a_mad,training_mad,test_mad]=feature_selection_adenz(training',trgroup',testing',pvalue);
 
x=test_mad(1:20,:);
y=test_mad(21:40,:);
[h,p]=ttest(x,y);

%du=sort(du,'descend');
%dd=sort(dd,'descend');


du=mean([d1u d2u],2);
dd=mean([d1d d2d],2);
 difs=abs(du-dd);

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
aden=[aden1,aden2,aden3,aden4,aden5];
adFeat=sort(aden,'ascend');

dux=du(adFeat);
ddx=dd(adFeat);
[h,p]=ttest(dux,ddx);
%dux=du(aden);
%ddx=dd(aden);

duq=[d1u(adFeat); d2u(adFeat)];
ddq=[d1d(adFeat); d2d(adFeat)];

[h,p]=ttest(duq,ddq);
duck=[duq;ddq];
[h,p]=ttest(duck);

