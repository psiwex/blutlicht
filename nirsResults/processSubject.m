function [dW,dL,vft1Epochs,vft2Epochs,vft3Epochs,flankerConEpochs,flankerIncEpochs]=processSubject(subBlock,doorsPost,vftPost,flPost)

%--------------------------------------------------------------------------
 % processSubject.m

 % Last updated: Nov 2023, John LaRocco
 
 % Ohio State University Wexner Medical Center
 
 % Details: Loads NIRS data from a subject.  


%--------------------------------------------------------------------------
fs=subBlock.fs;
%doorsPost=4*fs;
%vftPost=30*fs;
%flPost=8*fs;
%% doors
d1=subBlock.doors1;
d2=subBlock.doors2;
doors1Win=subBlock.doors1Win;
doors2Win=subBlock.doors2Win;
doors1Los=subBlock.doors1Los;
doors2Los=subBlock.doors2Los;

[d1]=processNirs(d1,fs);
[d2]=processNirs(d2,fs);
% win
d1WEpochs=[];

% if subBlock.id=='04'
% d1=-1*d1;
% d2=-1*d2;
% 
% end

if subBlock.id=='08'
for ii=1:(length(doors1Win)-1)

    d1WEpochs(ii,:,:)=d1(doors1Win(ii):(doors1Win(ii)+doorsPost),:);
end

else
for ii=1:length(doors1Win)

    d1WEpochs(ii,:,:)=d1(doors1Win(ii):(doors1Win(ii)+doorsPost),:);
end


end

d2WEpochs=[];
for ii=1:length(doors2Win)
    d2WEpochs(ii,:,:)=d2(doors2Win(ii):(doors2Win(ii)+doorsPost),:);
end

dW=[d1WEpochs; d2WEpochs];

% loss
d1LEpochs=[];
for ii=1:length(doors1Los)

    d1LEpochs(ii,:,:)=d1(doors1Los(ii):(doors1Los(ii)+doorsPost),:);
end

d2LEpochs=[];
for ii=1:length(doors2Los)
    d2LEpochs(ii,:,:)=d2(doors2Los(ii):(doors2Los(ii)+doorsPost),:);
end

dL=[d1LEpochs; d2LEpochs];

%% vft
vft=subBlock.vft;
% 
% if subBlock.id=='04'
% vft=-1*vft;
% 
% end
% 

vft1=subBlock.vft1;
vft2=subBlock.vft2;
vft3=subBlock.vft3;

[vft]=processNirs(vft,fs);

vft1Epochs=[];
for ii=1:length(vft1)
    vft1Epochs(ii,:,:)=vft((vft1(ii)+1):(vft1(ii)+vftPost),:);
    
end

vft2Epochs=[];
for ii=1:length(vft2)
    vft2Epochs(ii,:,:)=vft(vft2(ii):(vft2(ii)+vftPost),:);
end

vft3Epochs=[];
for ii=1:length(vft3)
    vft3Epochs(ii,:,:)=vft(vft3(ii):(vft3(ii)+vftPost),:);
end

%% flanker
flanker=subBlock.flanker;

% if subBlock.id=='04'
% flanker=-1*flanker;
% end
% 

fbIncRaw=subBlock.flankerInc;
fbConRaw=subBlock.flankerCon;

[flSampl,~]=size(subBlock.flanker);

fbConRaw=[abs((flSampl-6*flPost)-1); abs((flSampl-4*flPost)-1); abs((flSampl-2*flPost)-1)];
fbIncRaw=[abs((flSampl-5*flPost)-1); abs((flSampl-3*flPost)-1); abs((flSampl-1*flPost)-1)];



[flanker]=processNirs(flanker,fs);
flankerConEpochs=[];
for ii=1:length(fbConRaw)
    flankerConEpochs(ii,:,:)=flanker((fbConRaw(ii)+1):(fbConRaw(ii)+flPost),:);

end
if (abs(fbConRaw(1)-fbIncRaw(1))==1)
fbIncRaw=fbIncRaw+flPost;
end
flankerIncEpochs=[];
for ii=1:length(fbIncRaw)
    flankerIncEpochs(ii,:,:)=flanker(fbIncRaw(ii):(fbIncRaw(ii)+flPost),:);

end

%% averaging and thresholding
%dWm=squeeze(mean(dW));
%dLm=squeeze(mean(dL));

%vft1m=squeeze(mean(vft1Epochs));
%vft2m=squeeze(mean(vft2Epochs));
%vft3m=squeeze(mean(vft3Epochs));

%fcm=squeeze(mean(flankerConEpochs));
%fim=squeeze(mean(flankerIncEpochs));


end