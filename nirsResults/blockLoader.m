function [EEG,command,dat]=blockLoader(fileNam,fs,rawData)

%--------------------------------------------------------------------------
 % blockLoader.m

 % Last updated: Dec 2023, John LaRocco
 
 % Ohio State University
 
 % Details: Function to load entries in RTAA dataset. 
 
 % Input Variables: 
 % fileNam: String for file name.
 % fs: Integer of sampling frequency.  
 % rawData: Array with data values.  
 
 % Output Variables: 
 % EEG: EEGLAB standard data struct made from loaded file. 
 % dat: EEGLAB dat output.
 % command: EEGLAB command output.
%--------------------------------------------------------------------------


EEG=[];
dat=[];
command=[];

EEG.srate=fs;
EEG.data=rawData;
[EEG.pnts,EEG.chans]=size(EEG.data);
EEG.nbchan=EEG.chans;
EEG.chans=1:EEG.nbchan;
EEG.xmin=0;
EEG.xmax=EEG.pnts/fs;
EEG.times=1:1:EEG.pnts;
EEG.filename=fileNam;
EEG.datfile=EEG.filename;
EEG.event=[];
EEG.trials=1;
EEG.urevent=EEG.event;
EEG.reference='common';

load('eegChanlocs.mat','chans')
EEG.chanlocs=chans;

end