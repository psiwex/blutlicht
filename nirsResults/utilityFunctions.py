import numpy as np
import scipy as sp
import pandas as pd
from scipy import signal, arange, fft, fromstring, roll
from scipy.signal import butter, lfilter, ricker
import os
import glob
from sklearn.neighbors import KNeighborsClassifier
from sklearn.discriminant_analysis import QuadraticDiscriminantAnalysis
from sklearn.naive_bayes import GaussianNB
from sklearn.svm import SVC
from sklearn.feature_selection import RFE
from sklearn.svm import SVR

from sklearn.model_selection import cross_val_score
from sklearn import metrics
from sklearn.cluster import DBSCAN
from sklearn.metrics import recall_score, precision_score, f1_score, accuracy_score
from scipy.stats import stats
from sklearn.decomposition import PCA

def fastClassOutputs(N,X,y,featureNumber):
    clf = QuadraticDiscriminantAnalysis()
    ca1finalAcc,ca1finalF1,finalFeatures,finalLength,ca1As=dualClass(N,clf,X,y,featureNumber)
    #cb1fsAcc,cb1fsF1,finalFeatures,finalLength,cb1As=fsClass(N,clf,X,y,featureNumber)

    clf = GaussianNB()
    #ca2finalAcc,ca2finalF1,finalFeatures,finalLength,ca2As=dualClass(N,clf,X,y,featureNumber)
    #cb2fsAcc,cb2fsF1,finalFeatures,finalLength,cb2As=fsClass(N,clf,X,y,featureNumber)

    clf = SVC(gamma=2, C=1)
    ca3finalAcc,ca3finalF1,finalFeatures,finalLength,ca3As=dualClass(N,clf,X,y,featureNumber)
    #cb3fsAcc,cb3fsF1,finalFeatures,finalLength,cb3As=fsClass(N,clf,X,y,featureNumber)

    clf = KNeighborsClassifier(n_neighbors=3)
    ca4finalAcc,ca4finalF1,finalFeatures,finalLength,ca4As=dualClass(N,clf,X,y,featureNumber)
    #cb4fsAcc,cb4fsF1,finalFeatures,finalLength,cb4As=fsClass(N,clf,X,y,featureNumber)
    return(ca1finalAcc,ca1finalF1,ca1As,ca3finalAcc,ca3finalF1,ca3As,ca4finalAcc,ca4finalF1,ca4As)

def classOutputs(N,X,y,featureNumber):
    clf = QuadraticDiscriminantAnalysis()
    ca1finalAcc,ca1finalF1,finalFeatures,finalLength,ca1As=dualClass(N,clf,X,y,featureNumber)
    cb1fsAcc,cb1fsF1,finalFeatures,finalLength,cb1As=fsClass(N,clf,X,y,featureNumber)

    clf = GaussianNB()
    ca2finalAcc,ca2finalF1,finalFeatures,finalLength,ca2As=dualClass(N,clf,X,y,featureNumber)
    cb2fsAcc,cb2fsF1,finalFeatures,finalLength,cb2As=fsClass(N,clf,X,y,featureNumber)

    clf = SVC(gamma=2, C=1)
    ca3finalAcc,ca3finalF1,finalFeatures,finalLength,ca3As=dualClass(N,clf,X,y,featureNumber)
    cb3fsAcc,cb3fsF1,finalFeatures,finalLength,cb3As=fsClass(N,clf,X,y,featureNumber)

    clf = KNeighborsClassifier(n_neighbors=3)
    ca4finalAcc,ca4finalF1,finalFeatures,finalLength,ca4As=dualClass(N,clf,X,y,featureNumber)
    cb4fsAcc,cb4fsF1,finalFeatures,finalLength,cb4As=fsClass(N,clf,X,y,featureNumber)
    return(ca1finalAcc,ca1finalF1,cb1fsAcc,cb1fsF1,ca2finalAcc,ca2finalF1,cb2fsAcc,cb2fsF1,ca3finalAcc,ca3finalF1,cb3fsAcc,cb3fsF1,ca4finalAcc,ca4finalF1,cb4fsAcc,cb4fsF1,ca1As,ca2As,ca3As,ca4As,cb1As,cb2As,cb3As,cb4As)

def featureSelect(X, y, featureNumber, catToSearch):
    locks1 = np.where(y==catToSearch)
    locks2 = np.where(y!=catToSearch)
    X1 = np.squeeze(X[locks1,:])
    X2 = np.squeeze(X[locks2,:])
    totalLength=np.array([np.shape(X1)[0],np.shape(X2)[0]])
    topFeatures=eegFeatureReducer(X1, X2, featureNumber)
    aX1=balancedMatrix(X1, totalLength)
    aX2=balancedMatrix(X2, totalLength)
    atopFeatures=eegFeatureReducer(aX1, aX2, featureNumber)
    aFeatures=np.unique(np.vstack([topFeatures, atopFeatures])).flatten()
    return (aFeatures,totalLength,X1,X2)

def speedClass(X1, X2):
    
    Xa = np.vstack([X1, X2])
    t0 = 1*np.ones([1, len(X1)])
    t1 = 0*np.ones([1, len(X2)])
    targets = np.hstack([t0, t1])
    ya = np.transpose(np.ravel(targets))
    return (Xa,ya)

def dirClass(N,clf,Xa,ya):
    scores = cross_val_score(clf, Xa, ya, cv=N)
    avScore=scores.mean()
    avStd=scores.std()
    scores = cross_val_score(clf, Xa, ya, cv=N, scoring='f1_macro')
    f1Score=scores.mean()
    f1Std=scores.std()
    scores = cross_val_score(clf, Xa, ya, cv=N, scoring='roc_auc')
    aucScore=scores.mean()
    aucStd=scores.std()

    return (avScore,f1Score,avStd,f1Std,aucScore,aucStd)

#from numpy import mean,cov,double,cumsum,dot,linalg,array,rank
#from pylab import plot,subplot,axis,stem,show,figure

def princomp(A):

    M = (A-mean(A.T,axis=1)).T # subtract the mean (along columns)
    [latent,coeff] = linalg.eig(cov(M)) # attention:not always sorted
    score = dot(coeff.T,M) # projection of the data in the new space
    return coeff,score,latent


def dualClass(N,clf,X,y,featureNumber):
    nuNu=list()
    runCats=np.squeeze(np.unique(y))
    nuInd=list()
    nuAv=list()
    nuF1=list()
    nuAs=list()
#   features1=np.array([339 340 341 342 160 161 181 182 183 329 336 337 338 718 719 720 184 185 186 203 204 205 190 191 192 193 194 168 169 170 310 164 165 166 217 218 219 168 169 170 404 405 406 189 190 191 203 204 205 155 156 157 409 410 411 201 202 203 343 344 345 165 166 167 303 304 305 188 189 190 195 196 197 161 162 163 342 343 344 100 181 182 239 240 870 165 166 167 293 294 295 325 326 327 328 329 330 168 169 170 287 288 289 168 169 170 133 134 135 168 169 658 659 660 153 154 155 378 379 380 63 64 65 203 204 205 413 414 415 145 146 147 168 169 170 168 169 170 332 333 334 190 191 192 298 299 300 186 202 203 204 344 345 191 192 193 203 204 205 238 239 240 288 289 290 236 237 238 239 240 168 169 170 205 153 154 155 293 294 295 162 163 164 165 166 131 132 133 134 164 165 166 168 169 170 168 169 170 709 778 779 168 169 170 232 233 234 378 379 380 605 606 607 98 99 100 181 182 183 9 10 11 308 309 310 98 99 100])

    f2=np.array([9, 10, 11, 63, 64, 65, 98, 99, 100, 131, 132, 133, 134, 135, 145, 146, 147, 153, 154, 155, 156, 157, 160, 161, 162, 163, 164, 165, 166, 167, 168, 169, 170, 181, 182, 183, 184, 185, 186, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197, 201, 202, 203, 204, 205, 217, 218, 219, 232, 233, 234, 236, 237, 238, 239, 240, 287, 288, 289, 290, 293, 294, 295, 298, 299, 300, 303, 304, 305, 308, 309, 310, 325, 326, 327, 328, 329, 330, 332, 333, 334, 336, 337, 338, 339, 340, 341, 342, 343, 344, 345, 378, 379, 380, 404, 405, 406, 409, 410, 411, 413, 414, 415, 605, 606, 607, 658, 659, 660, 709, 718, 719, 720, 778, 779, 870])
    for ii in runCats:

        aFeatures,totalLength,X1,X2=featureSelect(X, y, featureNumber, ii)
        Xa,ya=speedClass(X1, X2)
        Xa = np.squeeze(Xa[:,f2])
        #pcaData = PCA(n_components=3)
        #Xa = pcaData.fit_transform(Xa)
#princomp(X)
        avScore,f1Score,avStd,f1Std,aucScore,aucStd=dirClass(N,clf,Xa,ya)

        nuNu.append(aFeatures)
        nuInd.append(totalLength)
        nuAv.append(avScore)
        nuF1.append(f1Score)
        nuAs.append(aucScore)

    finalFeatures=np.asarray(nuNu,dtype=object)
    finalLength=np.asarray(totalLength)
    finalAcc=np.mean(np.asarray(nuAv))
    finalF1=np.mean(np.asarray(nuF1))
    finalAs=np.mean(np.asarray(nuAs))
    return(finalAcc,finalF1,finalFeatures,finalLength,finalAs)


def fsClass(N,clf,X,y,featureNumber):
    nuNu=list()
    runCats=np.squeeze(np.unique(y))
    nuInd=list()
    nuAv=list()
    nuF1=list()
    nuAs=list()
    for ii in runCats:
  
        aFeatures,totalLength,X1,X2=featureSelect(X, y, featureNumber, ii)

        Xa,ya=speedClass(X1, X2)
        Xa=np.squeeze(Xa[:,aFeatures])
        avScore,f1Score,avStd,f1Std,aucScore,aucStd=dirClass(N,clf,Xa,ya)

        nuNu.append(aFeatures)
        nuInd.append(totalLength)
        nuAv.append(avScore)
        nuF1.append(f1Score)
        nuAs.append(aucScore)

    finalFeatures=np.asarray(nuNu,dtype=object)
    finalLength=np.asarray(totalLength)
    finalAcc=np.mean(np.asarray(nuAv))
    finalF1=np.mean(np.asarray(nuF1))
    finalAs=np.mean(np.asarray(nuAs))
    return(finalAcc,finalF1,finalFeatures,finalLength,finalAs)

def pairLoader(subName):

    outNamData=subName+'_Data.csv'
    outNamLabels=subName+'_Labels.csv'
    X = np.genfromtxt(outNamData, delimiter=',')
    y = np.genfromtxt(outNamLabels, delimiter=',')

    X = X.astype(float)
    y = y.astype(int)

    X[np.isnan(X)] = 0
    X[np.isinf(X)] = 0

    y[np.isnan(y)] = 0
    y[np.isinf(y)] = 0

    lims=np.shape(X)
    x0=int(lims[0])
    x1=int(lims[1])

    X=np.squeeze(X[1:x0,1:x1])
    runCats=np.squeeze(np.unique(y))
    return(X,y)


def ghostFeatures(rawData, indVal, chanNum, fs, lowcut, highcut, pcti, windows):
    i1=np.squeeze(indVal[0])
    can1=int(chanNum)
    ses1=np.squeeze(rawData[i1[0]:i1[1],:])
    singChan=ses1[0::,can1]
    w1=[0,fs]
    w2=[fs,np.min([(2*fs-1),len(singChan)])]
    f1a = featureExtraction(singChan[int(w1[0]):int(w1[1])], fs, lowcut, highcut, pcti)
    f1b = featureExtraction(singChan[int(w2[0]):int(w2[1])], fs, lowcut, highcut, pcti)
    #f1=featureCreation(singChan, fs, lowcut, highcut, pcti, windows)
    f1=np.concatenate((f1a,f1b),axis=0)
    return(f1)

def ghostHeap(rawData, indVal, fs, lowcut, highcut, pcti, windows):
 #   fa=ghostFeatures(rawData, indVal, 0, fs, lowcut, highcut, pcti, windows)
    fb=ghostFeatures(rawData, indVal, 1, fs, lowcut, highcut, pcti, windows)
    fc=ghostFeatures(rawData, indVal, 2, fs, lowcut, highcut, pcti, windows)
    fd=ghostFeatures(rawData, indVal, 3, fs, lowcut, highcut, pcti, windows)
    fe=ghostFeatures(rawData, indVal, 4, fs, lowcut, highcut, pcti, windows)
    ff=ghostFeatures(rawData, indVal, 5, fs, lowcut, highcut, pcti, windows)
    fg=ghostFeatures(rawData, indVal, 6, fs, lowcut, highcut, pcti, windows)
    fh=ghostFeatures(rawData, indVal, 7, fs, lowcut, highcut, pcti, windows)
    fi=ghostFeatures(rawData, indVal, 8, fs, lowcut, highcut, pcti, windows)
    fj=ghostFeatures(rawData, indVal, 9, fs, lowcut, highcut, pcti, windows)
    fk=ghostFeatures(rawData, indVal, 10, fs, lowcut, highcut, pcti, windows)
    fl=ghostFeatures(rawData, indVal, 11, fs, lowcut, highcut, pcti, windows)
    fm=ghostFeatures(rawData, indVal, 12, fs, lowcut, highcut, pcti, windows)
    fn=ghostFeatures(rawData, indVal, 13, fs, lowcut, highcut, pcti, windows)
    fo=ghostFeatures(rawData, indVal, 14, fs, lowcut, highcut, pcti, windows)
    fp=ghostFeatures(rawData, indVal, 15, fs, lowcut, highcut, pcti, windows)
    fq=ghostFeatures(rawData, indVal, 16, fs, lowcut, highcut, pcti, windows)
    #fa1=np.concatenate((fa,fb,fc,fd,fe,ff,fg,fh,fi,fj,fk,fl,fm,fn,fo,fp,fq),axis=0)
    fa1=np.concatenate((fb,fc,fd,fe,ff,fg,fh,fi,fj,fk,fl,fm,fn,fo,fp,fq),axis=0)
    return(fa1)

def ghostVector(rawData, fs, lowcut, highcut, pcti, h1, h2, h3, h4, h5, windows):
    f1=ghostHeap(rawData, h1, fs, lowcut, highcut, pcti, windows)
    f2=ghostHeap(rawData, h2, fs, lowcut, highcut, pcti, windows)
    f3=ghostHeap(rawData, h3, fs, lowcut, highcut, pcti, windows)
    f4=ghostHeap(rawData, h4, fs, lowcut, highcut, pcti, windows)
    f5=ghostHeap(rawData, h5, fs, lowcut, highcut, pcti, windows)
    featureVector=np.concatenate((f1,f2,f3,f4,f5),axis=0)
    return(featureVector)

def eegFeatureExtraction(df, fs, lowcut, highcut, pcti):
    chan1 = df.iloc[:, 2]
    chan2 = df.iloc[:, 3]
    chan3 = df.iloc[:, 4]
    chan4 = df.iloc[:, 5]

    # rotating the vectors to array
    c1 = np.real(np.asarray(chan1))
    c2 = np.real(np.asarray(chan2))
    c3 = np.real(np.asarray(chan3))
    c4 = np.real(np.asarray(chan4))

    # Normalizing these arrays
    c1 = c1-np.mean(c1)
    c2 = c2-np.mean(c2)
    c3 = c1-np.mean(c3)
    c4 = c4-np.mean(c4)

    c1 = c1[fs::]

    f1 = featureExtraction(c1, fs, lowcut, highcut, pcti)
    features = np.squeeze(np.shape(f1))

    c2 = c2[fs::]
    c3 = c3[fs::]
    c4 = c4[fs::]

    lengthFile = np.floor(np.squeeze(np.shape(c1))/np.float(4*fs))
    lbnds = np.arange(0, (lengthFile-1))
    ubnds = np.arange(1, (lengthFile))
    capper = np.min([len(lbnds), len(ubnds)])
    lbnds = 4*fs*lbnds[0:capper]
    ubnds = 4*fs*ubnds[0:capper]
    featureMatrix = np.zeros((capper, (4*features)))

    for ix in range(0, capper):
        s1 = featureExtraction(
            c1[int(lbnds[ix]):int(ubnds[ix])], fs, lowcut, highcut, pcti)
        s2 = featureExtraction(
            c2[int(lbnds[ix]):int(ubnds[ix])], fs, lowcut, highcut, pcti)
        s3 = featureExtraction(
            c3[int(lbnds[ix]):int(ubnds[ix])], fs, lowcut, highcut, pcti)
        s4 = featureExtraction(
            c4[int(lbnds[ix]):int(ubnds[ix])], fs, lowcut, highcut, pcti)
        featall = np.concatenate((s1, s2, s3, s4), axis=0)
        featall = np.squeeze(featall[0:(4*features)])
        featureMatrix[int(ix), :] = featall
    return (featureMatrix)


def butter_bandpass(lowcut, highcut, fs, order=4):
    nyq = 0.5 * fs
    low = (lowcut / nyq)
    high = (highcut / nyq)
    if high >= 1:
        high = .99
    if low <= 0:
        low = .001
    b, a = butter(order, [low, high], btype='band')
    return b, a


def butter_bandpass_filter(data, lowcut, highcut, fs, order=4):
    b, a = butter_bandpass(lowcut, highcut, fs, order=order)
    y = lfilter(b, a, data)
    return y


def welchProc(data, fs):
    # wsize=round(fs/10)
    f, P = signal.welch(data, fs)
    return f, P


def peakFinder(f, P):
    peakFLoc = np.where(P == np.amax(P))
    peakFLoc = peakFLoc[0]
    peakF = f[peakFLoc]
    vrms = np.sqrt(P.max())
    return peakF, peakFLoc, vrms


def smooth(x, window_len=11, window='hanning'):
    s = np.r_[x[window_len-1:0:-1], x, x[-2:-window_len-1:-1]]
    if window == 'flat':  # moving average
        w = np.ones(window_len, 'd')
    else:
        w = eval('np.'+window+'(window_len)')
    y = np.convolve(w/w.sum(), s, mode='valid')
    return y

def featureCreation(data, fs, lowcut, highcut, pcti, windows):
    feature_vector = np.array([])
    seconds_per_window = np.floor(len(data)/fs) / windows
    window_length = np.floor(seconds_per_window * fs)
    
    j=0
    while j < len(data):
        win_low = int(j)
        win_high = int(j+window_length)
        if win_high < len(data):
            print(str(win_low) + ' ' + str(win_high))
            current_data = data[win_low:win_high]
            current_feature = featureExtraction(current_data, fs, lowcut, highcut, pcti)
            feature_vector = np.hstack((feature_vector, current_feature))
        j = j + window_length
        #for j in range(np.floor(len(data)/window_length)):
        #    window_low = ((j-1) / windows) * len(data)
        #    window_high = (j / windows) * len(data)
        #    current_data = data[:,i]
        #    current_feature = featureExtraction(current_data, fs, lowcut, highcut, pcti)
        #    feature_vector = np.hstack((feature_vector, current_feature))
        
    return feature_vector


def featureExtraction(data, fs, lowcut, highcut, pcti):
    widths = np.arange(1, 31)
    data[np.isnan(data)] = 0
    data[np.isinf(data)] = 0
    intensityPcti = np.percentile(data, pcti)
    dMean = np.mean(data)
    data = data-np.mean(data)
    data = smooth(data.flatten())
    data = butter_bandpass_filter(data, lowcut, highcut, fs, order=4)
    data = signal.cwt(data, signal.ricker, widths)
    f, P = welchProc(data, fs)
    peakFLoc = np.where(P == np.amax(P))
    peakFLoc = peakFLoc[0]
    peakF = f[peakFLoc]
    vrms = np.sqrt(P.max())
    Psum = np.sum(P, axis=1)
    Psum = Psum.flatten()
    # print(np.shape(Psum))
    # print(np.shape(vrms))
    # print(np.shape(peakF))
    # print(np.shape(peakFLoc))
    # print(np.shape(intensityPcti))
    featureVector = np.hstack(
        (Psum.flatten(), vrms, peakF, peakFLoc, dMean, intensityPcti))
    # print(featureVector)
    featureVector[np.isnan(featureVector)] = 0
    featureVector[np.isinf(featureVector)] = 0
    # print(featureVector)
    return featureVector


#def balancedMatrix(a, totalLength):
def balMatrix(a, totalLength):
    maxLen = np.max(totalLength)
    minLen = np.min(totalLength)
    ratioL = np.floor(maxLen/minLen)
    finalR = np.ceil(minLen*ratioL)
    aT = np.copy(a)
    features = np.shape(a)[1]
    aTT = np.zeros([1, features])
    for ii in range(0, int(ratioL)):
        aTT1 = np.copy(aT)
        aTT = np.vstack([aTT1, aTT])
        aTT = np.squeeze(aTT)

    aTT = aTT[0:(maxLen-1), :]
    aTT = np.squeeze(aTT)
    return (aTT)

def balancedMatrix(a, totalLength):
#def balMatrix(a, totalLength):
    minLen = np.min(totalLength)
    [xw,xh]=np.shape(a)
    orders=np.random.permutation(xw)
    truncatedOrd=np.squeeze(orders[0:minLen])
    aTT = a[truncatedOrd, :]
    aTT = np.squeeze(aTT)
    return (aTT)


def eegFeatureReducer(featureMatrixA, featureMatrixB, featureNumber):
    m0 = np.mean(featureMatrixA, axis=0)
    m1 = np.mean(featureMatrixB, axis=0)
    distancesVec = np.abs(m0-m1)
    tempR = np.argpartition(-distancesVec, featureNumber)
    resultArgs = tempR[:featureNumber]
    topFeatures = np.flip(resultArgs)

    return (topFeatures)


def featureReducer(Xf, yf, features):
    estimator = SVR(kernel="linear")
    selector = RFE(estimator, features, step=15)
    selector = selector.fit(Xf, yf)
    topFeatures = np.where(selector.ranking_ == 1)
    Xnew = np.squeeze(Xf[:, topFeatures])
    return (Xnew, topFeatures)


def crossValClass(clf, X, y, xfold):
    scores = cross_val_score(clf, X, y, cv=xfold)
    print("Accuracy: %0.2f (+/- %0.2f)" % (scores.mean(), scores.std() * 2))
    scores = cross_val_score(clf, X, y, cv=xfold, scoring='f1_macro')
    print("F1 Score: %0.2f (+/- %0.2f)" % (scores.mean(), scores.std() * 2))
