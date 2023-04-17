from pylsl import StreamInlet, resolve_stream
import numpy as np
import msvcrt
import time
import numpy as np
import pandas as pd
from datetime import datetime

def main():

    chanNames=['Rx1-Tx1 O2Hb','Rx1-Tx1 HHb','Rx1-Tx2 O2Hb','Rx1-Tx2 HHb','Rx1-Tx3 O2Hb','Rx1-Tx3 HHb','Rx1-Tx4 O2Hb','Rx1-Tx4 HHb','Rx2-Tx3 O2Hb','Rx2-Tx3 HHb','Rx2-Tx4 O2Hb','Rx2-Tx4 HHb','Rx2-Tx5 O2Hb','Rx2-Tx5 HHb','Rx3-Tx4 O2Hb','Rx3-Tx4 HHb','Rx3-Tx5 O2Hb','Rx3-Tx5 HHb','Rx3-Tx6 O2Hb','Rx3-Tx6 HHb','Rx4-Tx5 O2Hb','Rx4-Tx5 HHb','Rx4-Tx6 O2Hb','Rx4-Tx6 HHb','Rx4-Tx7 O2Hb','Rx4-Tx7 HHb','Rx5-Tx6 O2Hb','Rx5-Tx6 HHb','Rx5-Tx7 O2Hb','Rx5-Tx7 HHb','Rx5-Tx8 O2Hb','Rx5-Tx8 HHb','Rx6-Tx7 O2Hb','Rx6-Tx7 HHb','Rx6-Tx8 O2Hb','Rx6-Tx8 HHb','Rx6-Tx9 O2Hb','Rx6-Tx9 HHb','Rx7-Tx8 O2Hb','Rx7-Tx8 HHb','Rx7-Tx9 O2Hb','Rx7-Tx9 HHb','Rx7-Tx10 O2Hb','Rx7-Tx10 HHb','Rx7-Tx11 O2Hb','Rx7-Tx11 HHb']

    jj=int(0)
    jThreshold=int(3000)
    portionNumber=int(0)
    # first resolve an EEG stream on the lab network
    print("looking for NIRS stream...")
    streams = resolve_stream('type', 'NIRS')
    timeSheet=time.time()

    stringName='OxySoft_NIRS_'+ str(timeSheet) + '.csv'
    # create a new inlet to read from the stream



    inlet = StreamInlet(streams[0])
    timestampList=list() 
    nirsList=list() 
    keyList=list()
    timeList=list()
    utcList=list()  
    nirsList0=list() 
    nirsList1=list() 
    nirsList2=list() 
    nirsList3=list() 
    nirsList4=list() 
    nirsList5=list() 
    nirsList6=list() 
    nirsList7=list() 
    nirsList8=list() 
    nirsList9=list() 
    nirsList10=list() 
    nirsList11=list() 
    nirsList12=list() 
    nirsList13=list() 
    nirsList14=list() 
    nirsList15=list() 
    nirsList16=list() 
    nirsList17=list() 
    nirsList18=list() 
    nirsList19=list() 
    nirsList20=list() 
    nirsList21=list() 
    nirsList22=list() 
    nirsList23=list() 
    nirsList24=list() 
    nirsList25=list() 
    nirsList26=list() 
    nirsList27=list() 
    nirsList28=list() 
    nirsList29=list()
    nirsList30=list() 
    nirsList31=list() 
    nirsList32=list() 
    nirsList33=list() 
    nirsList34=list() 
    nirsList35=list() 
    nirsList36=list() 
    nirsList37=list() 
    nirsList38=list() 
    nirsList39=list() 
    nirsList40=list() 
    nirsList41=list() 
    nirsList42=list() 
    nirsList43=list() 
    nirsList44=list() 
    nirsList45=list() 

    while True:
        # get a new sample (you can also omit the timestamp part if you're not
        # interested in it)
        
        sample, timestamp = inlet.pull_sample()
        #print(timestamp, sample)


        if msvcrt.kbhit():
        	pressedKey = msvcrt.getwch()
        	if pressedKey==str('p'):
        	    jj=int(2999)
        	    
        else:
        	pressedKey='_'

        #dt = datetime.now()
        dt = datetime.utcnow().isoformat(sep=' ', timespec='milliseconds')
        timas=str(dt)
        timerUtc=time.time()
        timeUtc=str(timerUtc)
        #massData=np.hstack((str(timestamp),str(sample)))
        #massData=np.hstack((massData,str(pressedKey)))

        timestampList.append(timestamp)
        nirsList.append(sample)
        nirsList0.append(sample[0])
        nirsList1.append(sample[1])
        nirsList2.append(sample[2])
        nirsList3.append(sample[3])
        nirsList4.append(sample[4])
        nirsList5.append(sample[5])
        nirsList6.append(sample[6])
        nirsList7.append(sample[7])
        nirsList8.append(sample[8])
        nirsList9.append(sample[9])
        nirsList10.append(sample[10])
        nirsList11.append(sample[11])
        nirsList12.append(sample[12])
        nirsList13.append(sample[13])
        nirsList14.append(sample[14])
        nirsList15.append(sample[15])
        nirsList16.append(sample[16])
        nirsList17.append(sample[17])
        nirsList18.append(sample[18])
        nirsList19.append(sample[19])
        nirsList20.append(sample[20])
        nirsList21.append(sample[21])
        nirsList22.append(sample[22])
        nirsList23.append(sample[23])
        nirsList24.append(sample[24])
        nirsList25.append(sample[25])
        nirsList26.append(sample[26])
        nirsList27.append(sample[27])
        nirsList28.append(sample[28])
        nirsList29.append(sample[29])
        nirsList30.append(sample[30])
        nirsList31.append(sample[31])
        nirsList32.append(sample[32])
        nirsList33.append(sample[33])
        nirsList34.append(sample[34])
        nirsList35.append(sample[35])
        nirsList36.append(sample[36])
        nirsList37.append(sample[37])
        nirsList38.append(sample[38])
        nirsList39.append(sample[39])
        nirsList40.append(sample[40])
        nirsList41.append(sample[41])
        nirsList42.append(sample[42])
        nirsList43.append(sample[43])
        nirsList44.append(sample[44])
        nirsList45.append(sample[45])
        utcList.append(timeUtc)


        timeList.append(timas)
        keyList.append(pressedKey)
        #zipped = list(zip(timestampList, nirsList, keyList))
        zipped = list(zip(timestampList, timeList, utcList, nirsList0, nirsList1, nirsList2, nirsList3, nirsList4, nirsList5, nirsList6, nirsList7, nirsList8, nirsList9, nirsList10, nirsList11, nirsList12, nirsList13, nirsList14, nirsList15, nirsList16, nirsList17, nirsList18, nirsList19, nirsList20, nirsList21, nirsList22, nirsList23, nirsList24, nirsList25, nirsList26, nirsList27, nirsList28, nirsList29, nirsList30, nirsList31, nirsList32, nirsList33, nirsList34, nirsList35, nirsList36, nirsList37, nirsList38, nirsList39, nirsList40, nirsList41, nirsList42, nirsList43, nirsList44, nirsList45, keyList))
        df = pd.DataFrame(zipped, columns=['Timer','Timestamp','UTC','Rx1-Tx1 O2Hb','Rx1-Tx1 HHb','Rx1-Tx2 O2Hb','Rx1-Tx2 HHb','Rx1-Tx3 O2Hb','Rx1-Tx3 HHb','Rx1-Tx4 O2Hb','Rx1-Tx4 HHb','Rx2-Tx3 O2Hb','Rx2-Tx3 HHb','Rx2-Tx4 O2Hb','Rx2-Tx4 HHb','Rx2-Tx5 O2Hb','Rx2-Tx5 HHb','Rx3-Tx4 O2Hb','Rx3-Tx4 HHb','Rx3-Tx5 O2Hb','Rx3-Tx5 HHb','Rx3-Tx6 O2Hb','Rx3-Tx6 HHb','Rx4-Tx5 O2Hb','Rx4-Tx5 HHb','Rx4-Tx6 O2Hb','Rx4-Tx6 HHb','Rx4-Tx7 O2Hb','Rx4-Tx7 HHb','Rx5-Tx6 O2Hb','Rx5-Tx6 HHb','Rx5-Tx7 O2Hb','Rx5-Tx7 HHb','Rx5-Tx8 O2Hb','Rx5-Tx8 HHb','Rx6-Tx7 O2Hb','Rx6-Tx7 HHb','Rx6-Tx8 O2Hb','Rx6-Tx8 HHb','Rx6-Tx9 O2Hb','Rx6-Tx9 HHb','Rx7-Tx8 O2Hb','Rx7-Tx8 HHb','Rx7-Tx9 O2Hb','Rx7-Tx9 HHb','Rx7-Tx10 O2Hb','Rx7-Tx10 HHb','Rx7-Tx11 O2Hb','Rx7-Tx11 HHb', 'Key'])
        df.to_csv(stringName)  
        latestSample=np.array([str(timestamp), str(timas), str(timeUtc), str(sample), str(pressedKey)], dtype='str')
        print(jj)
        jj=jj+1
        if int(jj)==int(jThreshold):
        	timeSheet2=time.time()
        	stringName2='Portioned_OxySoft_NIRS_'+ str(portionNumber) +'_timedAt_'+ str(timeSheet2) + '.csv'
        	jj=int(0)
        	portionNumber=portionNumber+1
        	df.to_csv(stringName2)
        	print('DATA EXPORTED.')

        print(latestSample)       
       
if __name__ == '__main__':
    main()