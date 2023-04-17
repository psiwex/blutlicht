import pandas as pd
import numpy as np
import itertools as it
import os
from scipy.signal import butter, lfilter
from scipy import stats 

def findNearest(array, value):
    array = np.asarray(array)
    idx = (np.abs(array - value)).argmin()
    return(array[idx],idx)

def returnAnchors(utcTimes, upConv2):
    outIndex=list()
    for se in range(0,len(upConv2)):
    	[samplDex,upIndex]=findNearest(utcTimes, upConv2[se])
    	marginOfError=abs(upConv2[se]-samplDex)
    	outIndex.append(upIndex)
    	print(marginOfError)
    return(outIndex)

def returnDataframes(taskTag, namePrefix, fs, offsetFactor):

    results=list()
    tag='.csv'
    folder='.'
    results += [each for each in os.listdir(folder) if each.endswith(tag) and each.startswith(namePrefix)]
    inDox=[s.find(namePrefix) for s in results]
    targetIndex=inDox.index(0)
    primary=results[targetIndex]

    df = pd.read_csv(primary)
#print(df)

    df1=df['UTC']
# times converted to milliseconds when possible for consistency. JS Psych table values are in milliseconds
    utcTimes=df1.to_numpy()
#print(ut)
    taskList=list()
    taskList += [each for each in os.listdir(folder) if each.endswith(tag) and each.startswith(taskTag)]
    taskDox=[s.find(taskTag) for s in taskList]
    targetTaskIndex=taskDox.index(0)
    fileToLoad=taskList[targetTaskIndex]
#print(fileToLoad)

    dfNew = pd.read_csv(fileToLoad)
    sas=list(dfNew.columns.values)
    df2=dfNew['rt']
    responseTimes=df2.to_numpy()
    df3=dfNew['time_elapsed']
    timeElapsed=df3.to_numpy()
    taskLength=abs(timeElapsed[-1]-timeElapsed[offsetFactor])
    print(taskLength)

    char1='utc_'
    char2='.csv'
    mystr=fileToLoad
    outNums=mystr[mystr.find(char1)+4 : mystr.find(char2)]
    outNums=float(outNums)
    outScaled=(outNums/1000)
    print(outScaled)

    [closestSample,taskEndIndex]=findNearest(utcTimes, outScaled)
    print('Task End Index')
    print(taskEndIndex)
    marginOfError=abs(closestSample-outScaled)
# potential sanity check. Should be really freaking low, given these are milliseconds. 100 ms or less is fine. 
    print('End Index Margin of Error')
    print(marginOfError)


# now we need to find all non-zero rt/response time values (or other market), and calculate the approximate index for them in the NIRS csv
    activePoints=np.argwhere(np.isnan(responseTimes)==False)

# do not forget to scale back and forth to milliseconds for UTC and index values!!!
    mileStones=timeElapsed[activePoints]
    utConv=int(outNums)-mileStones
#utConv=int(outNums)-mileStones[-1]
#print('MILESTONES')
#print(utConv)
    startPoint=float(utConv[-1])
#print('START POINT')
#print(startPoint)

    taskLengthIndex=np.ceil(float(fs*taskLength/1000))
    print('Task Length Index')
    print(taskLengthIndex)
#taskLengthIndex=np.ceil(float(taskLength/1000))
    taskStartIndex=int(abs(taskEndIndex-taskLengthIndex+1))
    #startIndex=taskStartIndex
    print('Task Start Index')
    print(taskStartIndex)
    startPointScaled=(utcTimes[taskStartIndex])

    [closestStartSample,taskStarterIndex]=findNearest(utcTimes, startPointScaled)
    marginOfErrorStart=abs(closestStartSample-startPointScaled)
    print('START Margin of Error')
    print(marginOfErrorStart)
    timeInUtc=abs(closestStartSample-outScaled)
    print('Start UTC')
    print(timeInUtc)
    return(dfNew,df,timeElapsed,taskStartIndex,taskEndIndex,outNums,taskLength) 


def stimCombiner(dA,dB,dC,dD):

    newList=list()

    totalLength=len(dA)

    for kj in range(0,totalLength):
        example1=dA[kj]
        example2=dB[kj]
        example3=dC[kj]
        example4=dD[kj]
    #print(kj)
        if (example1 != str('_')) or (example2 != str('_')) or (example3 != str('_')) or (example4 != str('_')): 

            if (example1 != str('_')):
                newList.append(example1)

            if (example2 != str('_')):
                newList.append(example2)

            if (example3 != str('_')):
                newList.append(example3)

            if (example4 != str('_')):
                newList.append(example4)

        else: 
  
            newList.append('_')
    newList=newList[0:(len(dA))]
    return(newList)
def proofFile(stimList, taskStartIndex, taskEndIndex, sequenceStrings):
    if stimList[taskStartIndex]!=sequenceStrings[0]:
        stimList[(taskStartIndex-1)]=str(sequenceStrings[0])

    if stimList[taskEndIndex]!=sequenceStrings[1]:
        stimList[(taskEndIndex)]=str(sequenceStrings[1])
    return(stimList)        
 

def triTimestamp(stringsToFind, sequenceStrings, dfNew, timeElapsed, taskLength, taskStartIndex, taskLengthIndex, utcTimes):

    dfU=dfNew["stimulus"].str.contains(stringsToFind[0])
    dfD=dfNew["stimulus"].str.contains(stringsToFind[1])
    df2D=dfNew["stimulus"].str.contains(stringsToFind[2])

    dfUbool=dfU.tolist()
    dfDbool=dfD.tolist()
    df2Dbool=df2D.tolist()

    aU=dfNew[dfNew["stimulus"].str.contains(stringsToFind[0], na=False)].index.to_numpy() 
    aD=dfNew[dfNew["stimulus"].str.contains(stringsToFind[1], na=False)].index.to_numpy() 
    a2D=dfNew[dfNew["stimulus"].str.contains(stringsToFind[2], na=False)].index.to_numpy() 

    upArrowTimes=timeElapsed[aU]
    upConv=abs((upArrowTimes)-(timeElapsed[1]))
    upConv=np.asarray(upConv)/taskLength
    upIndex=np.ceil((upConv*taskLengthIndex)+taskStartIndex)
    upIndex=upIndex.astype(int)
    upIndex=upIndex.tolist()

    dArrowTimes=timeElapsed[aD]
    dConv=abs((dArrowTimes)-(timeElapsed[1]))
    dConv=np.asarray(dConv)/taskLength
    dIndex=np.ceil((dConv*taskLengthIndex)+taskStartIndex)
    dIndex=dIndex.astype(int)
    dIndex=dIndex.tolist()

    d2Times=timeElapsed[a2D]
    d2Conv=abs((d2Times)-(timeElapsed[1]))
    d2Conv=np.asarray(d2Conv)/taskLength
    d2Index=np.ceil((d2Conv*taskLengthIndex)+taskStartIndex)
    d2Index=d2Index.astype(int)
    d2Index=d2Index.tolist()

    totalIndex=d2Index+dIndex+upIndex
    totalIndex.sort()
    totalIndex=set(totalIndex)
    totalIndex=sorted(totalIndex, key=int)

   # if vftFlag==int(1):
    #    totalIndex=taskStartIndex+np.asarray(totalIndex)
    #    totalIndex=list(totalIndex)
    newStim=list()

    for jee in range(0,(len(utcTimes))):

        if int(jee) in totalIndex:

            if int(jee) in upIndex:
                newStim.append(stringsToFind[0])
                print(stringsToFind[0])
    

            if int(jee) in dIndex:
                newStim.append(stringsToFind[1])
                print(stringsToFind[1])

            if int(jee) in d2Index:
                newStim.append(stringsToFind[2])
                print(stringsToFind[2])

        else:

            if int(jee)==int(taskStartIndex):
                newStim.append(sequenceStrings[0])
                print(sequenceStrings[0])
            else:
                if int(jee)==int(taskEndIndex):
                    newStim.append(sequenceStrings[1])
                    print(sequenceStrings[1])
                else:
                    newStim.append('_')

  #  if newStim[taskStartIndex]!=sequenceStrings[0]:
    #    newStim[(taskStartIndex-1)]=sequenceStrings[0]

  #  if newStim[taskEndIndex]!=sequenceStrings[1]:
  #      newStim[(taskEndIndex)]=sequenceStrings[1]
        
 
    newStim=newStim[0:(len(utcTimes))]
    if len(newStim)<<len(utcTimes):
        alphas=int(abs(len(utcTimes)-len(newStim)+1))
        for ias in range(0,alphas):
            newStim.append('_')
    newStim=newStim[0:(len(utcTimes))]
    return(newStim,totalIndex)

def clusterMeans(dataVector):
    featureList=list()

    mean0=np.squeeze(np.mean(dataVector[0:3]))
    mean1=np.squeeze(np.mean(dataVector[4:6]))
    mean2=np.squeeze(np.mean(dataVector[7:9]))
    mean3=np.squeeze(np.mean(dataVector[10:12]))
    mean4=np.squeeze(np.mean(dataVector[13:15]))
    mean5=np.squeeze(np.mean(dataVector[16:18]))
    mean6=np.squeeze(np.mean(dataVector[19:22]))
    dataMean=np.array([mean0,mean1,mean2,mean3,mean4,mean5,mean6])
    dataMean=dataMean.tolist()

    std0=np.squeeze(np.std(dataVector[0:3]))
    std1=np.squeeze(np.std(dataVector[4:6]))
    std2=np.squeeze(np.std(dataVector[7:9]))
    std3=np.squeeze(np.std(dataVector[10:12]))
    std4=np.squeeze(np.std(dataVector[13:15]))
    std5=np.squeeze(np.std(dataVector[16:18]))
    std6=np.squeeze(np.std(dataVector[19:22]))
    dataStd=np.array([std0,std1,std2,std3,std4,std5,std6])

    dataStd=dataStd.tolist()
    #print(dataStd)
    joinData=dataMean+dataStd
    return(joinData,dataMean,dataStd)

def arrowFlanker(stringsToFind, sequenceStrings, stateStrings, dfNew, timeElapsed, taskLength, taskStartIndex, taskLengthIndex, utcTimes):

    df2=dfNew['rt']
    responseTimes=df2.to_numpy()
    rtList=list(responseTimes)

    df4=dfNew['response']
    responseCode=df4.to_numpy()
    responseList=list(responseCode)

    aRC=dfNew[dfNew["stimulus"].str.contains(stringsToFind[0], na=False)].index.to_numpy() 
    aLC=dfNew[dfNew["stimulus"].str.contains(stringsToFind[1], na=False)].index.to_numpy() 
    aRI=dfNew[dfNew["stimulus"].str.contains(stringsToFind[3], na=False)].index.to_numpy() 
    aLI=dfNew[dfNew["stimulus"].str.contains(stringsToFind[2], na=False)].index.to_numpy() 
    aBE=dfNew[dfNew["stimulus"].str.contains(stringsToFind[4], na=False)].index.to_numpy() 


    dfRC=dfNew["stimulus"].str.contains(stringsToFind[0])
    dfLC=dfNew["stimulus"].str.contains(stringsToFind[1])
    dfRI=dfNew["stimulus"].str.contains(stringsToFind[3])
    dfLI=dfNew["stimulus"].str.contains(stringsToFind[2])
    dfBE=dfNew["stimulus"].str.contains(stringsToFind[4])

    allEvents=timeElapsed
    upConv=abs((allEvents)-(timeElapsed[1]))
    upConv=np.asarray(upConv)/taskLength
    upIndex=np.ceil((upConv*taskLengthIndex)+taskStartIndex)
    upIndex=upIndex.astype(int)
    allIndex=upIndex.tolist()

# for right congruent
    beTimes=timeElapsed[aBE]
    upConv=abs((beTimes)-(timeElapsed[1]))
    upConv=np.asarray(upConv)/taskLength
    upIndex=np.ceil((upConv*taskLengthIndex)+taskStartIndex)
    upIndex=upIndex.astype(int)
    beIndex=upIndex.tolist()
#upIndex=rcIndex


# for right congruent
    rcTimes=timeElapsed[aRC]
    upConv=abs((rcTimes)-(timeElapsed[1]))
    upConv=np.asarray(upConv)/taskLength
    upIndex=np.ceil((upConv*taskLengthIndex)+taskStartIndex)
    upIndex=upIndex.astype(int)
    rcIndex=upIndex.tolist()
#upIndex=rcIndex

# for left congruent
    lcTimes=timeElapsed[aLC]
    upConv=abs((lcTimes)-(timeElapsed[1]))
    upConv=np.asarray(upConv)/taskLength
    upIndex=np.ceil((upConv*taskLengthIndex)+taskStartIndex)
    upIndex=upIndex.astype(int)
    lcIndex=upIndex.tolist()

# for right incongruent
    riTimes=timeElapsed[aRI]
    upConv=abs((riTimes)-(timeElapsed[1]))
    upConv=np.asarray(upConv)/taskLength
    upIndex=np.ceil((upConv*taskLengthIndex)+taskStartIndex)
    upIndex=upIndex.astype(int)
    riIndex=upIndex.tolist()
#upIndex=rcIndex

# for left incongruent
    liTimes=timeElapsed[aRI]
    upConv=abs((liTimes)-(timeElapsed[1]))
    upConv=np.asarray(upConv)/taskLength
    upIndex=np.ceil((upConv*taskLengthIndex)+taskStartIndex)
    upIndex=upIndex.astype(int)
    liIndex=upIndex.tolist()

    totalIndex=liIndex+riIndex+lcIndex+rcIndex+beIndex
    totalIndex.sort()
    totalIndex=set(totalIndex)
    totalIndex=sorted(totalIndex, key=int)
#print('TOTAL INDEX')
#print(totalIndex)
    newStim=list()
    newRt=list()
    newResponse=list()
    jj=int(0)
#for len
# for loop through new stimulus list/column to add event specific events and timestamps in primary file
#responseTimes

#print(allIndex)
    for jee in range(0,(len(utcTimes))):
    #print(jee)
        if int(jee) in totalIndex:

            if int(jee) in lcIndex:
                newStim.append(stateStrings[0])
                print(stateStrings[0])
    
            if int(jee) in liIndex:
                newStim.append(stateStrings[1])
                print(stateStrings[1])


            if int(jee) in rcIndex:
                newStim.append(stateStrings[0])
                print(stateStrings[0])
    
            if int(jee) in riIndex:
                newStim.append(stateStrings[1])
                print(stateStrings[1])
            if int(jee) in beIndex:
                newStim.append(stateStrings[2])
                print(stateStrings[2])



        else:
        #newStim.append('_')
            if int(jee)==int(taskStartIndex):
                newStim.append(sequenceStrings[0])
                print(sequenceStrings[0])
            else:
                if int(jee)==int(taskEndIndex):
                    newStim.append(sequenceStrings[1])
                    print(sequenceStrings[1])
                else:
                    newStim.append('_')
# other columns
        if int(jee) in allIndex:

            rtValue=rtList[jj]
            responseValue=responseList[jj]

            newRt.append(rtValue)
            newResponse.append(responseValue)
            jj=jj+1

        else:

            newRt.append('_')
            newResponse.append('_')

    newStim=newStim[0:(len(utcTimes))]
    newRt=newRt[0:(len(utcTimes))]
    newResponse=newResponse[0:(len(utcTimes))]
    return(newStim,newRt,newResponse)



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

def dissectDataframe(df,startString,stopString,stimColumn,baselineBuffer):
    x=df.loc[:, df.columns.str.contains('O2Hb')]
    x=x.to_numpy(dtype='float64')
    idx0a = df[stimColumn].tolist().index(startString)
    idx1 = df[stimColumn].tolist().index(stopString)
    idx0 = int(np.min([int(idx0a),int(abs(idx0a-baselineBuffer))]))
    idx=list([idx0,idx1])
    x=x[idx0:idx1]

    return(x,idx)

def epochDataframe(df,stimString,stimColumn,idx):

    idxStim = df[stimColumn].tolist()
    idx2 = [i for i, x2 in enumerate(idxStim) if x2 == stimString]
    idxRaw=list()
    idx2[:] = [ex for ex in idx2 if ex >= int(idx[0])]
    idx2[:] = [ax for ax in idx2 if ax <= int(idx[1])]
    idxStim=idx2
    for uu in idx2:
        lowers=int(uu)-int(idx[0])
        idxRaw.append(lowers)

    return(idxRaw,idxStim)

def nirsImport(df,taskName,stimColumn,baselineBuffer):
    lowcut=.005
    highcut=.1
    startStringBase='_Start'
    stopStringBase='_End'
    startString=taskName+startStringBase
    stopString=taskName+stopStringBase
    x,idx=dissectDataframe(df,startString,stopString,stimColumn,baselineBuffer)
    y=butter_bandpass_filter(x, lowcut, highcut, fs, order=5)
    meanToRemove=np.mean(y[0:(baselineBuffer-1)])
    data=y-meanToRemove
    return(data,idx)

def sliceRetriever(data,prePeriod,postPeriod,idxRaw,iterValue):

    s=idxRaw[int((iterValue-prePeriod)):int((iterValue+postPeriod))]
    segmentData=data[s,:]
    return(segmentData)


def flankerArrowGrade(dfFlanker):
    dRTotal=dfFlanker.loc[(dfFlanker['stimulus'] == '<<><<') | (dfFlanker['stimulus'] == '>>>>>')]
    dR=dRTotal.values.tolist()
    dLTotal=dfFlanker.loc[(dfFlanker['stimulus'] == '>><>>') | (dfFlanker['stimulus'] == '<<<<<')]
    dL=dLTotal.values.tolist()
# practice is at 30 per class. 50 per block. 
    totalEntries=(len(dR)+len(dL))

    conLocs=dfFlanker.loc[(dfFlanker['stim_type'] == 'congruent')]
    conTot=conLocs.values.tolist()
    incLocs=dfFlanker.loc[(dfFlanker['stim_type'] == 'incongruent')]
    incTot=incLocs.values.tolist()

    dRC=dfFlanker[(dfFlanker['response'] == 'arrowright') & (dfFlanker['stimulus'] == '>>>>>')]
    dLC=dfFlanker[(dfFlanker['response'] == 'arrowleft') & (dfFlanker['stimulus'] == '<<<<<')]
    dRI=dfFlanker[(dfFlanker['response'] == 'arrowright') & (dfFlanker['stimulus'] == '<<><<')]
    dLI=dfFlanker[(dfFlanker['response'] == 'arrowleft') & (dfFlanker['stimulus'] == '>><>>')]

    bRC=dRC['rt'].values.tolist()
    bLC=dLC['rt'].values.tolist()
    bRI=dRI['rt'].values.tolist()
    bLI=dLI['rt'].values.tolist()

    rtRC=np.mean(np.asarray(bRC))
    rtLC=np.mean(np.asarray(bLC))

    rtRI=np.mean(np.asarray(bRI))
    rtLI=np.mean(np.asarray(bLI))

    rtCon=np.mean([rtRC,rtLC])
    rtInc=np.mean([rtRI,rtLI])
    rtTot=np.mean([rtRC,rtLC,rtRI,rtLI])

    accCon=(len(bRC)+len(bLC))/len(conTot)
    accInc=(len(bRI)+len(bLI))/len(incTot)
    accTot=(len(bRC)+len(bLC)+len(bRI)+len(bLI))/(len(incTot)+len(conTot))

    iesCon=rtCon/accCon
    iesInc=rtInc/accInc
    iesTot=rtTot/accTot
    return(rtCon,rtInc,rtTot,accCon,accInc,accTot,iesCon,iesInc,iesTot)


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


#nantes='OxySoft_NIRS_'
namePrefix='stitched_OxySoft_NIRS_'
taskTag='doors1Data'
stringsToFind=list(['UpArrow','DownArrow','2Doors'])
sequenceStrings=list(['Doors1_Start','Doors1_End'])

fs=int(10)
offsetFactor=int(2)

dfNew,df,timeElapsed,taskStartIndex,taskEndIndex,outNums,taskLength=returnDataframes(taskTag, namePrefix, fs, offsetFactor)
idxD1=list([taskStartIndex,taskEndIndex])

df1=df['UTC']
utcTimes=df1.to_numpy()
taskLengthIndex=int(np.round(fs*taskLength/1000))

stimD1,totalIndex=triTimestamp(stringsToFind, sequenceStrings, dfNew, timeElapsed, taskLength, taskStartIndex, taskLengthIndex, utcTimes)
df['stimulus_D1'] = stimD1

#outString='doors1_OxySoft_NIRS_Timestamp_'+str(outNums)+'_UTC.csv'
#df.to_csv(outString, sep=',', encoding='utf-8', header='true')
print('Doors 1 Synched')

taskTag='doors2Data'
stringsToFind=list(['UpArrow','DownArrow','2Doors'])
sequenceStrings=list(['Doors2_Start','Doors2_End'])

dfNew,df0,timeElapsed,taskStartIndex,taskEndIndex,outNums,taskLength=returnDataframes(taskTag, namePrefix, fs, offsetFactor)
idxD2=list([taskStartIndex,taskEndIndex])

df1=df['UTC']
utcTimes=df1.to_numpy()

taskLengthIndex=int(np.round(fs*taskLength/1000))
stimD2,totalIndex=triTimestamp(stringsToFind, sequenceStrings, dfNew, timeElapsed, taskLength, taskStartIndex, taskLengthIndex, utcTimes)
stimD2=proofFile(stimD2, taskStartIndex, taskEndIndex, sequenceStrings)
df['stimulus_D2'] = stimD2
#outString='doors2_OxySoft_NIRS_Timestamp_'+str(outNums)+'_UTC.csv'
#df.to_csv(outString, sep=',', encoding='utf-8', header='true')
print('Doors 2 Synched')

taskTag='vftData'
stringsToFind=list(['REST','D','SAY ANIMAL NAMES'])
sequenceStrings=list(['VFT_Start','VFT_End'])

offsetFactorVFT=int(0)

dfNew,df0,timeElapsed,taskStartIndex,taskEndIndex,outNums,taskLength=returnDataframes(taskTag, namePrefix, fs, offsetFactorVFT)
idxVFT=list([taskStartIndex,taskEndIndex])

df1=df['UTC']
utcTimes=df1.to_numpy()

taskLengthIndex=int(np.round(fs*taskLength/1000))

stimVFT,totalIndexVFT=triTimestamp(stringsToFind, sequenceStrings, dfNew, timeElapsed, taskLength, taskStartIndex, taskLengthIndex, utcTimes)

stimVFT=proofFile(stimVFT, taskStartIndex, taskEndIndex, sequenceStrings)

df['stimulus_VFT'] = stimVFT
#outString='vft_OxySoft_NIRS_Timestamp_'+str(outNums)+'_UTC.csv'
#df.to_csv(outString, sep=',', encoding='utf-8', header='true')
print('VFT Synched')
totalIndV=taskStartIndex+np.asarray(totalIndexVFT)
totalIndV=list(totalIndV)


taskTag='flankerArrowsData'

dfFlanker,df0,timeElapsed,taskStartIndex,taskEndIndex,outNums,taskLength=returnDataframes(taskTag, namePrefix, fs, offsetFactorVFT)
idxFlanker=list([taskStartIndex,taskEndIndex])
df1=df['UTC']
utcTimes=df1.to_numpy()
taskLengthIndex=int(np.round(fs*taskLength/1000))

stateStrings=list(['CONGRUENT','INCONGRUENT','BLOCK'])
stringsToFind=list(['CCCSCCC','HHHKHHH','CCCHCCC','HHHSHHH'])

stringsToFind=list(['>>>>>','<<<<<','>><>>','<<><<','Block'])
sequenceStrings=list(['Flanker_Start','Flanker_End'])

flankerStim,newRt,newResponse=arrowFlanker(stringsToFind, sequenceStrings, stateStrings, dfFlanker, timeElapsed, taskLength, taskStartIndex, taskLengthIndex, utcTimes)
flankerStim=proofFile(flankerStim, taskStartIndex, taskEndIndex, sequenceStrings)

df['stimulus_flanker'] = flankerStim
df['rt'] = newRt
df['response'] = newResponse
#newList=stimCombiner(stimD1,stimVFT,flankerStim,stimD2)
#df['stimulus'] = newList

#outString='flankerArrows_OxySoft_NIRS_Timestamp_'+str(outNums)+'_UTC.csv'

outString='synched_OxySoft_NIRS_Timestamp_'+str(outNums)+'_UTC.csv'
df.to_csv(outString, sep=',', encoding='utf-8', header='true')
print('Flanker (Arrows) Synched')

# POST ANALYSIS
print('DATA EXPORTED')

baselineBuffer=int(5*fs)
namePrefix='synched_OxySoft_NIRS_'

# doors 1

taskTag='doors1Data'
taskName='Doors1'
prePeriod=0
stimColumn='stimulus_D1'
postPeriod=(fs*4)
data,idx=nirsImport(df,taskName,stimColumn,baselineBuffer)
print('DOORS 1 LOADED')

stimString=str('2Doors')
#total doors1 av
idxRaw,idxStim=epochDataframe(df,stimString,stimColumn,idxD1)
totalD1Mean=meanCalculation(data,idxRaw,prePeriod,postPeriod)
d1TotalData,d1TotalDataMean,d1TotalDataStd=clusterMeans(totalD1Mean)

#total doors1 UP
stimString=str('UpArrow')
idxRaw,idxStim=epochDataframe(df,stimString,stimColumn,idxD1)
d1UpArrowMean=meanCalculation(data,idxRaw,prePeriod,postPeriod)
d1UpData,d1UpDataMean,d1UpDataStd=clusterMeans(d1UpArrowMean)

#total doors1 DOWN
stimString=str('DownArrow')
idxRaw,idxStim=epochDataframe(df,stimString,stimColumn,idxD1)
d1DownArrowMean=meanCalculation(data,idxRaw,prePeriod,postPeriod)
d1DownData,d1DownDataMean,d1DownDataStd=clusterMeans(d1DownArrowMean)
print('DOORS 1 COMPLETE')
# doors 2

taskTag='doors2Data'
taskName='Doors2'
stimColumn='stimulus_D2'
prePeriod=0
postPeriod=(fs*4)
data,idx=nirsImport(df,taskName,stimColumn,baselineBuffer)
print('DOORS 2 LOADED')

stimString=str('2Doors')
#total doors1 av
idxRaw,idxStim=epochDataframe(df,stimString,stimColumn,idxD2)
totalD2Mean=meanCalculation(data,idxRaw,prePeriod,postPeriod)
d2TotalData,d2TotalDataMean,d2TotalDataStd=clusterMeans(totalD2Mean)

#total doors1 UP
stimString=str('UpArrow')
idxRaw,idxStim=epochDataframe(df,stimString,stimColumn,idxD2)
d2UpArrowMean=meanCalculation(data,idxRaw,prePeriod,postPeriod)
d2UpData,d2UpDataMean,d2UpDataStd=clusterMeans(d2UpArrowMean)

#total doors1 DOWN
stimString=str('DownArrow')
idxRaw,idxStim=epochDataframe(df,stimString,stimColumn,idxD2)
d2DownArrowMean=meanCalculation(data,idxRaw,prePeriod,postPeriod)
d2DownData,d2DownDataMean,d2DownDataStd=clusterMeans(d2DownArrowMean)

print('DOORS 2 COMPLETE')
# VFT

taskTag='VFTData'
taskName='VFT'
stimColumn='stimulus_VFT'
prePeriod=0
postPeriod=(fs*30)
data,idx=nirsImport(df,taskName,stimColumn,baselineBuffer)

stimString=str('REST')
#rest
idxRaw,idxStim=epochDataframe(df,stimString,stimColumn,idxVFT)
totalVFTMean=meanCalculation(data,idxRaw,prePeriod,postPeriod)
vft1Data,vft1DataMean,vft1DataStd=clusterMeans(totalVFTMean)
print('VFT Part 1 COMPLETE')

#alphabet
stimString=str('D')
idxRaw2,idxStim=epochDataframe(df,stimString,stimColumn,idxVFT)
dVFTAlphaMean=meanCalculation(data,idxRaw2,prePeriod,postPeriod)
vft2Data,vft2DataMean,vft2DataStd=clusterMeans(dVFTAlphaMean)
print('VFT Part 2 COMPLETE')

#animals
stimString=str('ANIMAL')
idxRaw,idxStim=epochDataframe(df,stimString,stimColumn,idxVFT)
if not idxRaw:
    idxRaw=np.asarray(idxRaw2)+int(300)
    idxRaw=list(idxRaw)
dVFTAnimalMean=meanCalculation(data,idxRaw,prePeriod,postPeriod)
vft3Data,vft3DataMean,vft3DataStd=clusterMeans(dVFTAnimalMean)

print('VFT Part 3 COMPLETE')

# FLANKER
taskTag='flankerArrowsData'
taskName='Flanker'
stimColumn='stimulus_flanker'
prePeriod=0
postPeriod=(fs*4)
data,idx=nirsImport(df,taskName,stimColumn,baselineBuffer)
print('FLANKER LOADED')


stimString=str('BLOCK')
#block
idxRaw,idxStim=epochDataframe(df,stimString,stimColumn,idxFlanker)
totalBlkMean=meanCalculation(data,idxRaw,prePeriod,postPeriod)
blkData,blkDataMean,blkDataStd=clusterMeans(totalBlkMean)
print('Flanker Part 1 COMPLETE')


stimString=str('CONGRUENT')
#congruent
idxRaw,idxStim=epochDataframe(df,stimString,stimColumn,idxFlanker)
totalConMean=meanCalculation(data,idxRaw,prePeriod,postPeriod)
conData,conDataMean,conDataStd=clusterMeans(totalConMean)
print('Flanker Part 2 COMPLETE')


stimString=str('INCONGRUENT')
#incongruent
idxRaw,idxStim=epochDataframe(df,stimString,stimColumn,idxFlanker)
totalIncMean=meanCalculation(data,idxRaw,prePeriod,postPeriod)
incData,incDataMean,incDataStd=clusterMeans(totalIncMean)
print('Flanker Part 3 COMPLETE')


postPeriod=(fs*8)
#block aves
idxRaw,idxStim=epochDataframe(df,stimString,stimColumn,idxFlanker)
totalBlkMean=meanCalculation(data,idxRaw,prePeriod,postPeriod)
blkData,blkDataMean,blkDataStd=clusterMeans(totalBlkMean)

idxCon=list([idxRaw[0],idxRaw[2],idxRaw[4]])
idxInc=list([idxRaw[1],idxRaw[3],idxRaw[5]])
print('Flanker Block Part 1 COMPLETE')

totalConBlkMean=meanCalculation(data,idxCon,prePeriod,postPeriod)
conData,conDataMean,conDataStd=clusterMeans(totalConBlkMean)
print('Flanker Block Part 2 COMPLETE')

totalIncBlkMean=meanCalculation(data,idxInc,prePeriod,postPeriod)
incData,incDataMean,incDataStd=clusterMeans(totalIncBlkMean)
print('Flanker Block Part 3 COMPLETE')

rtCon,rtInc,rtTot,accCon,accInc,accTot,iesCon,iesInc,iesTot=flankerArrowGrade(dfFlanker)

#VLPFC-RITE: Ventrolateral Prefrontal Cortex (right) [0-3]
#OFFPC-RITE: Orbitofrontal Prefrontal Cortex (right)/Frontopolar Prefrontal Cortex (left) [4-6]
#DLPFC-RITE: Dorsolateral Prefrontal Cortex (right)/Frontopolar Prefrontal Cortex (right) [7-9]
#OFPFC-MID: Orbitofrontal Prefrontal Cortex [10-12]
#DLPFC-RITE: Dorsolateral Prefrontal Cortex (left)/Frontopolar Prefrontal Cortex (left) [13-15]
#OFFPC-LEFT: Orbitofrontal Prefrontal Cortex (left)/Frontopolar Prefrontal Cortex (left) [16-18]
#VLPFC-LEFT: Ventrolateral Prefrontal Cortex (left) [19-22]

rawData = {
'Doors1MainMean': d1TotalDataMean,
'Doors1MainStd': d1TotalDataStd,
'Doors1UpMean': d1UpDataMean,
'Doors1UpStd': d1UpDataStd,
'Doors1DownMean': d1DownDataMean,
'Doors1DownStd': d1DownDataStd,

'Doors2MainMean': d2TotalDataMean,
'Doors2MainStd': d2TotalDataStd,
'Doors2UpMean': d2UpDataMean,
'Doors2UpStd': d2UpDataStd,
'Doors2DownMean': d2DownDataMean,
'Doors2DownStd': d2DownDataStd,

'VFT1MainMean': vft1DataStd,
'VFT1MainStd': vft1DataStd,
'VFT2Mean': vft2DataMean,
'VFT2Std': vft2DataStd,
'VFT3Mean': vft3DataMean,
'VFT3Std': vft3DataStd,

'FlankerMainMean': blkDataMean,
'FlankerMainStd': blkDataStd,
'FlankerConMean': conDataMean,
'FlankerConStd': conDataStd,
'FlankerIncMean': incDataMean,
'FlankerIncStd': incDataStd,

'FlankerAccMain': [str(accTot),'_','_','_','_','_','_'],
'FlankerAccCon': [str(accCon),'_','_','_','_','_','_'],
'FlankerAccInc': [str(accInc),'_','_','_','_','_','_'],

'FlankerRtMain': [str(rtTot),'_','_','_','_','_','_'],
'FlankerRtCon': [str(rtCon),'_','_','_','_','_','_'],
'FlankerRtInc': [str(rtInc),'_','_','_','_','_','_'],

'FlankerIesMain': [str(iesTot),'_','_','_','_','_','_'],
'FlankerIesCon': [str(iesCon),'_','_','_','_','_','_'],
'FlankerIesInc': [str(iesInc),'_','_','_','_','_','_']}


dfExport = pd.DataFrame(rawData, columns = ['Doors1MainMean', 'Doors1MainStd', 'Doors1UpMean', 'Doors1UpStd', 'Doors1DownMean', 'Doors1DownStd','Doors2MainMean', 'Doors2MainStd', 'Doors2UpMean', 'Doors2UpStd', 'Doors2DownMean', 'Doors2DownStd','VFT1MainMean','VFT1MainStd','VFT2Mean','VFT2Std','VFT3Mean','VFT3Std','FlankerMainMean','FlankerMainStd','FlankerConMean','FlankerConStd','FlankerIncMean','FlankerIncStd','FlankerAccMain','FlankerAccCon','FlankerAccInc','FlankerRtMain','FlankerRtCon','FlankerRtInc','FlankerIesMain','FlankerIesCon','FlankerIesInc'])

outString='features_OxySoft_NIRS_Timestamp_'+str(outNums)+'_UTC.csv'
dfExport.to_csv(outString, sep=',', encoding='utf-8', header='true')
print('Features Extracted')

## Statistics tests
#stats.ttest_1samp(TestSample1, popmean=0)
#stats.ttest_ind(TestSample1, TestSample2)

print('DOORS')
testV1=stats.ttest_1samp(d1DownDataMean, popmean=0)
print(testV1)

testV2=stats.ttest_ind(d1DownDataMean, d1UpDataMean)
print(testV2)

testV3=stats.ttest_ind(d2DownDataMean, d2UpDataMean)
print(testV3)

testV4=stats.ttest_ind(d1UpDataMean, d2UpDataMean)
print(testV4)

testV5=stats.ttest_ind(d1DownDataMean, d2DownDataMean)
print(testV5)

print('VFT')

testV1=stats.ttest_ind(vft1DataMean, vft2DataMean)
print(testV1)

testV2=stats.ttest_ind(vft1DataMean, vft3DataMean)
print(testV2)

testV3=stats.ttest_ind(vft2DataMean, vft3DataMean)
print(testV3)


print('Flanker')

testV1=stats.ttest_ind(conDataMean, incDataMean)
print(testV1)

testV2=stats.ttest_ind(blkDataMean, conDataMean)
print(testV2)

testV3=stats.ttest_ind(blkDataMean, incDataMean)
print(testV3)


