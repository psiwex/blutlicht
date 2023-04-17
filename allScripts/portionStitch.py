import pandas as pd
import numpy as np
import time
import os

tag='.csv'
folder='.'
tes='Portioned_OxySoft_NIRS_'


results=list()
results += [each for each in os.listdir(folder) if each.endswith(tag) and each.startswith(tes)]

print(results)

# next: find number in between each entry of results list. Then load them in that order, and add them to a big mega file. Then export mega 

fileNums=list()
fileToLoad=results[0]
char1=tes
char2='_timedAt_'
for ii in results:
    mystr=ii
    outNums=mystr[mystr.find(char1)+23 : mystr.find(char2)]
    outNums=int(outNums)
    fileNums.append(outNums)

fileNums.sort()
iia=0

magicNumber=char1+str(iia)+char2
inDox=[s.find(magicNumber) for s in results]
targetIndex=inDox.index(0)
fileLoad=results[targetIndex]
seedFile = pd.read_csv(fileLoad)
print(fileLoad)
for iia in range(1,len(fileNums)):
    print(iia)
    magicNumber=char1+str(iia)+char2
    print(magicNumber)
    inDox=[s.find(magicNumber) for s in results]
    targetIndex=inDox.index(0)
    fileLoad=results[targetIndex]

    if iia==int(1):
        seedFile2 = pd.read_csv(fileLoad)
        print(fileLoad)
        newFile = pd.concat([seedFile,seedFile2],ignore_index=True)

    else:
        newFile2 = pd.read_csv(fileLoad)
        print(fileLoad)
        newFile = pd.concat([newFile,newFile2],ignore_index=True)

timeSheet=time.time()
outString='stitched_OxySoft_NIRS_'+str(timeSheet)+'_UTC.csv'
newFile.to_csv(outString, sep=',', encoding='utf-8', header='true')
print(outString)
