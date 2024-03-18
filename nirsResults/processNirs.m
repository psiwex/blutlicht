function [filteredData]=processNirs(data,fs)

%--------------------------------------------------------------------------
 % processNirs.m

 % Last updated: April 2023, John LaRocco
 
 % Ohio State University Wexner Medical Center
 
 % Details: Loads NIRS data from Artinis Brite for preprocessing. 

 % Input Variables: 
 % data: A 2d matrix containing the raw EEG. 
 % fs: Sampling frequency. Positive, real integer. 
 
 % Output Variables: 
 % filteredData: 2D matrix of preprocessed time domain data.


%--------------------------------------------------------------------------
filteredData=data;
%filteredData=smoothdata(data);
%filteredData=data-mean(data);
%filteredData = bandpass(filteredData,[0.00001 .999*fs/2],fs);
%filteredData = bandpass(filteredData,[.1 .999*fs/2],fs);
%filteredData = bandpass(filteredData,[0.001 .1],fs);

filteredData = bandpass(filteredData,[.001*fs .999*fs/2],fs);
%filteredData = bandpass(filteredData,[.01 .5],fs);

%filteredData=smoothdata(filteredData);

%filteredData=detrend(filteredData);

%filteredData=filteredData-mean(filteredData);


%filteredData=smoothdata(filteredData);

end