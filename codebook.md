Codebook
========

Variable list and descriptions
------------------------------

Variable name    | Description
-----------------|------------
subject          | ID the subject who performed the activity for each window sample. Its range is from 1 to 30.
activity         | Activity name
featDomain       | Feature: Time domain signal or frequency domain signal (Time or Freq)
featAcceleration | Feature: Acceleration signal (Body or Gravity)
featInstrument   | Feature: Measuring instrument (Accelerometer or Gyroscope)
featJerk         | Feature: Jerk signal
featMagnitude    | Feature: Magnitude of the signals calculated using the Euclidean norm
featVariable     | Feature: Variable (Mean or SD)
featAxis         | Feature: 3-axial signals in the X, Y and Z directions (X, Y, or Z)
Count            | Feature: Count of data points used to compute `average`
average          | Feature: Average of each variable for each activity and each subject

Dataset structure
-----------------

```r
str(dtTidy)
```

```
## Classes ‘data.table’ and 'data.frame':  11880 obs. of  11 variables:
## $ subject         : int  1 1 1 1 1 1 1 1 1 1 ...
## $ activity        : Factor w/ 6 levels "LAYING","SITTING",..: 1 1 1 1 1 1 1 1 1 1 ...
## $ featDomain      : Factor w/ 2 levels "Time","Freq": 1 1 1 1 1 1 1 1 1 1 ...
## $ featAcceleration: Factor w/ 3 levels NA,"Body","Gravity": 1 1 1 1 1 1 1 1 1 1 ...
## $ featInstrument  : Factor w/ 2 levels "Accelerometer",..: 2 2 2 2 2 2 2 2 2 2 ...
## $ featJerk        : Factor w/ 2 levels NA,"Jerk": 1 1 1 1 1 1 1 1 2 2 ...
## $ featMagnitude   : Factor w/ 2 levels NA,"Magnitude": 1 1 1 1 1 1 2 2 1 1 ...
## $ featVariable    : Factor w/ 2 levels "Mean","SD": 1 1 1 2 2 2 1 2 1 1 ...
## $ featAxis        : Factor w/ 4 levels NA,"X","Y","Z": 2 3 4 2 3 4 1 1 2 3 ...
## $ count           : int  50 50 50 50 50 50 50 50 50 50 ...
## $ average         : num  -0.0166 -0.0645 0.1487 -0.8735 -0.9511 ...
## - attr(*, "sorted")= chr  "subject" "activity" "featDomain" "featAcceleration" ...
## - attr(*, ".internal.selfref")=<externalptr> 

```

List the key variables in the data table
----------------------------------------


```r
key(dtTidy)
```

```
## [1] "subject"          "activity"         "featDomain"      
## [4] "featAcceleration" "featInstrument"   "featJerk"        
## [7] "featMagnitude"    "featVariable"     "featAxis"
```

List the some lines of data table
----------------------------------------


```r
print(head(dtTidy))
```
```
##    subject activity featDomain featAcceleration featInstrument featJerk
## 1:       1   LAYING       Time               NA      Gyroscope       NA
## 2:       1   LAYING       Time               NA      Gyroscope       NA
## 3:       1   LAYING       Time               NA      Gyroscope       NA
## 4:       1   LAYING       Time               NA      Gyroscope       NA
## 5:       1   LAYING       Time               NA      Gyroscope       NA
## 6:       1   LAYING       Time               NA      Gyroscope       NA
##    featMagnitude featVariable featAxis count     average
## 1:            NA         Mean        X    50 -0.01655309
## 2:            NA         Mean        Y    50 -0.06448612
## 3:            NA         Mean        Z    50  0.14868944
## 4:            NA           SD        X    50 -0.87354387
## 5:            NA           SD        Y    50 -0.95109044
## 6:            NA           SD        Z    50 -0.90828466
```
