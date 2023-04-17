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
taskTag='doors1Data'


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
#print(ut)



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
df3=dfNew['time_elapsed']
timeElapsed=df3.to_numpy()
taskLength=abs(timeElapsed[-1]-timeElapsed[2])
print(taskLength)

char1='utc_'
char2='.csv'
mystr=fileToLoad
outNums=mystr[mystr.find(char1)+4 : mystr.find(char2)]
outNums=float(outNums)
outScaled=(outNums/1000)
print(outScaled)

[closestSample,taskEndIndex]=findNearest(utcTimes, outScaled)
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
print('MILESTONES')
print(utConv)
startPoint=float(utConv[-1])
print('START POINT')
print(startPoint)

taskLengthIndex=np.ceil(float(fs*taskLength/1000))
print('Task Length Index')
print(taskLengthIndex)
#taskLengthIndex=np.ceil(float(taskLength/1000))
taskStartIndex=int(abs(taskEndIndex-taskLengthIndex+1))
startIndex=taskStartIndex
print('Start Point')
print(taskStartIndex)
startPointScaled=(utcTimes[taskStartIndex])

[closestStartSample,taskStartIndex]=findNearest(utcTimes, startPointScaled)
marginOfErrorStart=abs(closestStartSample-startPointScaled)
print('START MOE')
print(marginOfErrorStart)
timeInUtc=abs(closestStartSample-outScaled)
print('Start UTC')
print(timeInUtc)

dfU=dfNew["stimulus"].str.contains("UpArrow")
dfD=dfNew["stimulus"].str.contains("DownArrow")
df2D=dfNew["stimulus"].str.contains("2Doors")


dfUbool=dfU.tolist()
dfDbool=dfD.tolist()
df2Dbool=df2D.tolist()

aU=dfNew[dfNew["stimulus"].str.contains("UpArrow", na=False)].index.to_numpy() 
aD=dfNew[dfNew["stimulus"].str.contains("DownArrow", na=False)].index.to_numpy() 
a2D=dfNew[dfNew["stimulus"].str.contains("2Doors", na=False)].index.to_numpy() 

# for up arrows
upArrowTimes=timeElapsed[aU]
upConv=abs((upArrowTimes)-(timeElapsed[1]))
upConv=np.asarray(upConv)/taskLength
upConv2=(timeInUtc*upConv)+closestStartSample
#upIndex=returnAnchors(utcTimes, upConv2)

upIndex=np.ceil((upConv*taskLengthIndex)+startIndex)
upIndex=upIndex.astype(int)
upIndex=upIndex.tolist()

# for down arrows
dArrowTimes=timeElapsed[aD]
dConv=abs((dArrowTimes)-(timeElapsed[1]))
dConv=np.asarray(dConv)/taskLength
dConv2=(timeInUtc*dConv)+closestStartSample

#dIndex=returnAnchors(utcTimes, dConv2)
dIndex=np.ceil((dConv*taskLengthIndex)+startIndex)
dIndex=dIndex.astype(int)
dIndex=dIndex.tolist()


# for doors
d2Times=timeElapsed[a2D]
d2Conv=abs((d2Times)-(timeElapsed[1]))
d2Conv=np.asarray(d2Conv)/taskLength
d2Conv2=(timeInUtc*d2Conv)+closestStartSample

#d2Index=returnAnchors(utcTimes, d2Conv2)

d2Index=np.ceil((d2Conv*taskLengthIndex)+startIndex)
d2Index=d2Index.astype(int)
d2Index=d2Index.tolist()
#d2Index=returnAnchors(utcTimes, d2Conv2)

#print(len(utcTimes))

totalIndex=d2Index+dIndex+upIndex
totalIndex.sort()
totalIndex=set(totalIndex)
totalIndex=sorted(totalIndex, key=int)
print('TOTAL INDEX')
print(totalIndex)
newStim=list()
#for len
# for loop through new stimulus list/column to add event specific events and timestamps in primary file

for jee in range(0,(len(utcTimes))):
    #print(jee)
    if int(jee) in totalIndex:

        if int(jee) in upIndex:
            newStim.append('UpArrow')
            print('Up')
    

        if int(jee) in dIndex:
            newStim.append('DownArrow')
            print('Down')

        if int(jee) in d2Index:
            newStim.append('2Doors')
            print('Doors')

    else:
        #newStim.append('_')
        if int(jee)==int(taskStartIndex):
            newStim.append('Doors_Start')
            print('DoorsStart')
        else:
            if int(jee)==int(taskEndIndex):
                newStim.append('Doors_End')
                print('DoorsEnd')
            else:
                newStim.append('_')

newStim=newStim[0:(len(utcTimes))]
#print(newStim)
df['stimulus'] = newStim

outString='doors1_OxySoft_NIRS_Timestamp_'+str(outNums)+'_UTC.csv'
df.to_csv(outString, sep=',', encoding='utf-8', header='true')
print('Doors 1 Synched')