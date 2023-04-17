import glob
import pandas as pd
import numpy as np
import itertools as it
import os

from scipy.signal import butter, lfilter





def butter_bandpass(lowcut, highcut, fs, order=5):
    nyq = 0.5 * fs
    low = lowcut / nyq
    high = highcut / nyq
    b, a = butter(order, [low, high], btype='band')
    return b, a


def butter_bandpass_filter(data, lowcut, highcut, fs, order=5):
    b, a = butter_bandpass(lowcut, highcut, fs, order=order)
    y = lfilter(b, a, data)
    return y

def selectDataframes(namePrefix):

    results=list()
    tag='.csv'
    folder='.'
    results += [each for each in os.listdir(folder) if each.endswith(tag) and each.startswith(namePrefix)]
    inDox=[s.find(namePrefix) for s in results]
    targetIndex=inDox.index(0)
    primary=results[targetIndex]

    df = pd.read_csv(primary)
    return(df)

def dissectDataframe(df,startString,stopString,baselineBuffer):
    x=df.loc[:, df.columns.str.contains('O2Hb')]
    x=x.to_numpy(dtype='float64')
    idx0a = df['stimulus'].tolist().index(startString)
    idx1 = df['stimulus'].tolist().index(stopString)
    idx0 = int(np.min([int(idx0a),int(abs(idx0a-baselineBuffer))]))
    idx=list([idx0,idx1])
    x=x[idx0:idx1]

    return(x,idx)

def epochDataframe(df,stimString,idx):

    idxStim = df['stimulus'].tolist()
    idx2 = [i for i, x2 in enumerate(idxStim) if x2 == stimString]
    idxRaw=list()
    idx2[:] = [ex for ex in idx2 if ex >= int(idx[0])]
    idx2[:] = [ax for ax in idx2 if ax <= int(idx[1])]
    idxStim=idx2
    for uu in idx2:
        lowers=int(uu)-int(idx[0])
        idxRaw.append(lowers)

    return(idxRaw,idxStim)



def nirsImport(df,taskName,baselineBuffer):
    lowcut=.005
    highcut=.1
    startStringBase='_Start'
    stopStringBase='_End'
    startString=taskName+startStringBase
    stopString=taskName+stopStringBase
    x,idx=dissectDataframe(df,startString,stopString,baselineBuffer)
    y=butter_bandpass_filter(x, lowcut, highcut, fs, order=5)
    meanToRemove=np.mean(y[0:(baselineBuffer-1)])
    data=y-meanToRemove
    return(data,idx)

def sliceRetriever(data,prePeriod,postPeriod,idxRaw,iterValue):

    s=idxRaw[int(iterValue-prePeriod):int(iterValue+postPeriod)]
    segmentData=data[s,:]
    return(segmentData)


def meanCalculation(data,idxRaw,prePeriod,postPeriod):
    featureList=list()
#iterValue=int(0)
    for iterValue in range(0,len(idxRaw)):
        segmentData=sliceRetriever(data,prePeriod,postPeriod,idxRaw,iterValue)

        taskMean=np.mean(segmentData,axis=0)
        chanNum=np.shape(taskMean)
        featureList.append(taskMean)
    totalMean=np.mean(np.asarray(featureList),axis=0)

    return(totalMean)

namePrefix='synched_OxySoft_NIRS_'
taskTag='doors1Data'


fs=int(10)
baselineBuffer=int(5*fs)


df=selectDataframes(namePrefix)




# doors 1
taskName='Doors1'
prePeriod=0
postPeriod=(fs*4)
data,idx=nirsImport(df,taskName,baselineBuffer)


stimString=str('2Doors')


#total doors1 av
idxRaw,idxStim=epochDataframe(df,stimString,idx)
totalD1Mean=meanCalculation(data,idxRaw,prePeriod,postPeriod)

#total doors1 UP
stimString=str('UpArrow')
idxRaw,idxStim=epochDataframe(df,stimString,idx)
d1UpArrowMean=meanCalculation(data,idxRaw,prePeriod,postPeriod)

#total doors1 DOWN
stimString=str('DownArrow')
idxRaw,idxStim=epochDataframe(df,stimString,idx)
d1DownArrowMean=meanCalculation(data,idxRaw,prePeriod,postPeriod)



## DOORS2
taskName='Doors2'

data,idx=nirsImport(df,taskName,baselineBuffer)

stimString=str('2Doors')


#total doors2 av
idxRaw,idxStim=epochDataframe(df,stimString,idx)
totalD2Mean=meanCalculation(data,idxRaw,prePeriod,postPeriod)

#total doors2 UP
stimString=str('UpArrow')
idxRaw,idxStim=epochDataframe(df,stimString,idx)
d2UpArrowMean=meanCalculation(data,idxRaw,prePeriod,postPeriod)

#total doors2 DOWN
stimString=str('DownArrow')
idxRaw,idxStim=epochDataframe(df,stimString,idx)
d2DownArrowMean=meanCalculation(data,idxRaw,prePeriod,postPeriod)

print(totalD1Mean)
print(totalD2Mean)