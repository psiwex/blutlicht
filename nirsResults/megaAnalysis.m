load('megaMat.mat')
load('vft0.mat')

d1=megaMac(:,1); d2=megaMac(:,7);

d1u=megaMac(:,3); d2u=megaMac(:,9);

d1d=megaMac(:,5); d2d=megaMac(:,11);

d=[d1; d2];
du=[d1u; d2u];
dd=[d1d; d2d];

du=[d1u; d2u];
dd=[d1d; d2d];

du=mean([d1u d2u],2);
dd=mean([d1d d2d],2);

dd1=reshape(d,7,20);
ddu1=reshape(du,7,20);
ddd1=reshape(dd,7,20);

[h,p]=ttest(v1',v3');

fm=megaMac(:,19);
fc=megaMac(:,21);
fi=megaMac(:,23);
[h,p]=ttest(fm,fc)
[h,p]=ttest(fm,fi);

[h,p]=ttest(fc,fi)

fcc=reshape(fc,7,10);

fci=reshape(fi,7,10);

fcm=reshape(fm,7,10);
 [h,p]=ttest(fci',fcm');
[h,p]=ttest(fcc',fci');
 [h,p]=ttest(fcc',fcm');



 [w_mad,a_mad,training_mad,test_mad]=feature_selection_aden(training,group,testing,pvalue);
