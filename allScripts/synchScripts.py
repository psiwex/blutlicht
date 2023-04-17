import glob
import pandas as pd
import numpy as np
import itertools as it
import os

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

    [closestStartSample,taskStartIndex]=findNearest(utcTimes, startPointScaled)
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

    newStim=newStim[0:(len(utcTimes))]
    return(newStim,totalIndex)

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

    dfRC=dfNew["stimulus"].str.contains(stringsToFind[0])
    dfLC=dfNew["stimulus"].str.contains(stringsToFind[1])
    dfRI=dfNew["stimulus"].str.contains(stringsToFind[3])
    dfLI=dfNew["stimulus"].str.contains(stringsToFind[2])

    allEvents=timeElapsed
    upConv=abs((allEvents)-(timeElapsed[1]))
    upConv=np.asarray(upConv)/taskLength
    upIndex=np.ceil((upConv*taskLengthIndex)+taskStartIndex)
    upIndex=upIndex.astype(int)
    allIndex=upIndex.tolist()


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

    totalIndex=liIndex+riIndex+lcIndex+rcIndex
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


#nantes='OxySoft_NIRS_'
namePrefix='stitched_OxySoft_NIRS_'
taskTag='doors1Data'
stringsToFind=list(['UpArrow','DownArrow','2Doors'])
sequenceStrings=list(['Doors1_Start','Doors1_End'])

fs=int(10)
offsetFactor=int(2)

dfNew,df,timeElapsed,taskStartIndex,taskEndIndex,outNums,taskLength=returnDataframes(taskTag, namePrefix, fs, offsetFactor)

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
df1=df['UTC']
utcTimes=df1.to_numpy()
taskLengthIndex=int(np.round(fs*taskLength/1000))
stimD2,totalIndexVFT=triTimestamp(stringsToFind, sequenceStrings, dfNew, timeElapsed, taskLength, taskStartIndex, taskLengthIndex, utcTimes)
#print(totalIndexVFT)
df['stimulus_D2'] = stimD2
#outString='doors2_OxySoft_NIRS_Timestamp_'+str(outNums)+'_UTC.csv'
#df.to_csv(outString, sep=',', encoding='utf-8', header='true')
print('Doors 2 Synched')


taskTag='vftData'
stringsToFind=list(['REST','D','SAY ANIMAL NAMES'])
sequenceStrings=list(['VFT_Start','VFT_End'])

offsetFactorVFT=int(0)

dfNew,df0,timeElapsed,taskStartIndex,taskEndIndex,outNums,taskLength=returnDataframes(taskTag, namePrefix, fs, offsetFactorVFT)

df1=df['UTC']
utcTimes=df1.to_numpy()
taskLengthIndex=int(np.round(fs*taskLength/1000))

stimVFT,totalIndex=triTimestamp(stringsToFind, sequenceStrings, dfNew, timeElapsed, taskLength, taskStartIndex, taskLengthIndex, utcTimes)
df['stimulus_VFT'] = stimVFT
#outString='vft_OxySoft_NIRS_Timestamp_'+str(outNums)+'_UTC.csv'
#df.to_csv(outString, sep=',', encoding='utf-8', header='true')
print('VFT Synched')


taskTag='flankerArrowsData'

dfNew,df0,timeElapsed,taskStartIndex,taskEndIndex,outNums,taskLength=returnDataframes(taskTag, namePrefix, fs, offsetFactorVFT)
df1=df['UTC']
utcTimes=df1.to_numpy()
taskLengthIndex=int(np.round(fs*taskLength/1000))

stateStrings=list(['CONGRUENT','INCONGRUENT'])
stringsToFind=list(['CCCSCCC','HHHKHHH','CCCHCCC','HHHSHHH'])

stringsToFind=list(['>>>>>','<<<<<','>><>>','<<><<'])
sequenceStrings=list(['Flanker_Start','Flanker_End'])

flankerStim,newRt,newResponse=arrowFlanker(stringsToFind, sequenceStrings, stateStrings, dfNew, timeElapsed, taskLength, taskStartIndex, taskLengthIndex, utcTimes)

df['stimulus_flanker'] = flankerStim
df['rt'] = newRt
df['response'] = newResponse
newList=stimCombiner(stimD1,stimVFT,flankerStim,stimD2)
df['stimulus'] = newList

#outString='flankerArrows_OxySoft_NIRS_Timestamp_'+str(outNums)+'_UTC.csv'

outString='synched_OxySoft_NIRS_Timestamp_'+str(outNums)+'_UTC.csv'
df.to_csv(outString, sep=',', encoding='utf-8', header='true')
print('Flanker (Arrows) Synched')



