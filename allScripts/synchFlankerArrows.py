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


 

nantes='OxySoft_NIRS_'
tes='stitched_OxySoft_NIRS_'
tag='.csv'
folder='.'
taskTag='flankerArrowsData'

results=list()
results += [each for each in os.listdir(folder) if each.endswith(tag) and each.startswith(tes)]
inDox=[s.find(tes) for s in results]
targetIndex=inDox.index(0)
primary=results[targetIndex]

fs=int(10)
df = pd.read_csv(primary)
#print(df)

df1=df['UTC']
# times converted to milliseconds when possible for consistency. JS Psych table values are in milliseconds
utcTimes=df1.to_numpy()

#utcTimes=np.sort(utcTimes)


taskList=list()
taskList += [each for each in os.listdir(folder) if each.endswith(tag) and each.startswith(taskTag)]
taskDox=[s.find(taskTag) for s in taskList]
targetTaskIndex=taskDox.index(0)
fileToLoad=taskList[targetTaskIndex]
print(fileToLoad)

dfNew = pd.read_csv(fileToLoad)
sas=list(dfNew.columns.values)
df2=dfNew['rt']
responseTimes=df2.to_numpy()

rtList=list(responseTimes)

df3=dfNew['time_elapsed']
timeElapsed=df3.to_numpy()
taskLength=abs(timeElapsed[-1]-timeElapsed[0])
print(taskLength)

df4=dfNew['response']
responseCode=df4.to_numpy()
responseList=list(responseCode)

print(rtList)
print(responseList)


char1='utc_'
char2='.csv'
mystr=fileToLoad
print('FILENAME')
print(mystr)
outNums=mystr[mystr.find(char1)+4 : mystr.find(char2)]
outNums=float(outNums)
outScaled=(outNums/1000)
print('OUTSCALED')
print(outScaled)

[closestSample,taskEndIndex]=findNearest(utcTimes, outScaled)

print('CLOSEST SAMPLE')
print(closestSample)

print('TASK END INDEX')
print(taskEndIndex)

marginOfError=abs(closestSample-outScaled)
# potential sanity check. Should be really freaking low, given these are milliseconds. 100 ms or less is fine. 
print('End MOE')
print(marginOfError)


# now we need to find all non-zero rt/response time values (or other market), and calculate the approximate index for them in the NIRS csv
activePoints=np.argwhere(np.isnan(responseTimes)==False)

# do not forget to scale back and forth to milliseconds for UTC and index values!!!
mileStones=timeElapsed[activePoints]

utConv=int(outNums)-mileStones
#utConv=int(outNums)-mileStones[-1]

startPoint=float(utConv[-1])
print('START POINT')
print(startPoint)

taskLengthIndex=np.ceil(float(fs*taskLength/1000))
print('Task Length Index')
print(taskLengthIndex)
#taskLengthIndex=np.ceil(float(taskLength/1000))
taskStartIndex=int(abs(taskEndIndex-taskLengthIndex+1))

startIndex=float(taskStartIndex)

print('Start Point')
print(taskStartIndex)
startPointScaled=(utcTimes[taskStartIndex])
print('Scaled Start Point')
print(startPointScaled)
startIndex=(taskStartIndex)
[closestStartSample,taskStartIndex]=findNearest(utcTimes, startPointScaled)
marginOfErrorStart=abs(closestStartSample-startPointScaled)
print('START MOE')
print(marginOfErrorStart)
timeInUtc=abs(closestStartSample-outScaled)
print('Start UTC')
print(timeInUtc)

print('START INDEX')
print(startIndex)
#print('Seeker Sample')
#print(closestStartSample)


aU=dfNew[dfNew["stimulus"].str.contains(">>>>>|<<<<<", na=False)].index.to_numpy() 
aD=dfNew[dfNew["stimulus"].str.contains(">><>>|<<><<", na=False)].index.to_numpy() 

aRC=dfNew[dfNew["stimulus"].str.contains(">>>>>", na=False)].index.to_numpy() 
aLC=dfNew[dfNew["stimulus"].str.contains("<<<<<", na=False)].index.to_numpy() 
aRI=dfNew[dfNew["stimulus"].str.contains("<<><<", na=False)].index.to_numpy() 
aLI=dfNew[dfNew["stimulus"].str.contains(">><>>", na=False)].index.to_numpy() 

dfRC=dfNew["stimulus"].str.contains(">>>>>")
dfLC=dfNew["stimulus"].str.contains("<<<<<")
dfRI=dfNew["stimulus"].str.contains("<<><<")
dfLI=dfNew["stimulus"].str.contains(">><>>")

#for all
allEvents=timeElapsed
upConv=abs((allEvents)-(timeElapsed[1]))
upConv=np.asarray(upConv)/taskLength
upIndex=np.ceil((upConv*taskLengthIndex)+startIndex)
upIndex=upIndex.astype(int)
allIndex=upIndex.tolist()


# for right congruent
rcTimes=timeElapsed[aRC]
upConv=abs((rcTimes)-(timeElapsed[1]))
upConv=np.asarray(upConv)/taskLength
upIndex=np.ceil((upConv*taskLengthIndex)+startIndex)
upIndex=upIndex.astype(int)
rcIndex=upIndex.tolist()
#upIndex=rcIndex

# for left congruent
lcTimes=timeElapsed[aLC]
upConv=abs((lcTimes)-(timeElapsed[1]))
upConv=np.asarray(upConv)/taskLength
upIndex=np.ceil((upConv*taskLengthIndex)+startIndex)
upIndex=upIndex.astype(int)
lcIndex=upIndex.tolist()

# for right incongruent
riTimes=timeElapsed[aRI]
upConv=abs((riTimes)-(timeElapsed[1]))
upConv=np.asarray(upConv)/taskLength
upIndex=np.ceil((upConv*taskLengthIndex)+startIndex)
upIndex=upIndex.astype(int)
riIndex=upIndex.tolist()
#upIndex=rcIndex

# for left incongruent
liTimes=timeElapsed[aRI]
upConv=abs((liTimes)-(timeElapsed[1]))
upConv=np.asarray(upConv)/taskLength
upIndex=np.ceil((upConv*taskLengthIndex)+startIndex)
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
            newStim.append('CONGRUENT')
            print('CONGRUENT')
    
        if int(jee) in liIndex:
            newStim.append('INCONGRUENT')
            print('INCONGRUENT')


        if int(jee) in rcIndex:
            newStim.append('CONGRUENT')
            print('CONGRUENT')
    
        if int(jee) in riIndex:
            newStim.append('INCONGRUENT')
            print('INCONGRUENT')


    else:
        #newStim.append('_')
        if int(jee)==int(taskStartIndex):
            newStim.append('Flanker_Start')
            print('FlankerStart')
        else:
            if int(jee)==int(taskEndIndex):
                newStim.append('Flanker_End')
                print('FlankerEnd')
            else:
                newStim.append('_')

# let us GRADE

    if int(jee) in allIndex:

        rtValue=rtList[jj]
        #print(rtValue)
        responseValue=responseList[jj]
        #print(responseValue)
        newRt.append(rtValue)
        newResponse.append(responseValue)
        jj=jj+1

    else:
        #newStim.append('_')
        newRt.append('_')
        newResponse.append('_')

newStim=newStim[0:(len(utcTimes))]
newRt=newRt[0:(len(utcTimes))]
newResponse=newResponse[0:(len(utcTimes))]

df['stimulus'] = newStim
df['rt'] = newRt
df['response'] = newResponse

outString='flankerArrows_OxySoft_NIRS_Timestamp_'+str(outNums)+'_UTC.csv'
df.to_csv(outString, sep=',', encoding='utf-8', header='true')
print('Flanker (Arrows) Synched')
