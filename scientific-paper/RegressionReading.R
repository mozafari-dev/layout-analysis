library(Rmisc)
library(ggplot2)
library(reshape2)
library(plyr)

fullData <- read.csv('data/all_fixations_with_parameters.csv' ,header = TRUE)
fullData<- fullData[!(fullData$section=="-"),]

regressionReading <- fullData[(fullData$regression==1),]

aggRegressionReading <- aggregate(regressionReading, 
                               by=list(regressionReading$cond, regressionReading$section), 
                               FUN = mean, na.rm=TRUE)

averageRegression <- aggregate(regressionReading$regression ~ regressionReading$cond + regressionReading$section, 
                               data = regressionReading, sum)


# fixiationRegression <- summarySE(data = regressionReading, measurevar = "fix_dur", groupvars = c("cond", "section"))
# 
# ggplot(fixiationRegression, aes(x=section, y=fix_dur, fill=cond)) +
#   geom_bar(position=position_dodge(), stat="identity") +
#   geom_errorbar(aes(ymin=fix_dur-se, ymax=fix_dur+se),
#                 width=.2, position=position_dodge(.9)) + 
#   scale_fill_discrete(name="Experimental\nCondition") +
#   ylab('Fixation Duration') + 
#   xlab('Section of Interest') +
#   ggtitle('The Average of First Fixation Duration\nAfter Regression') 
# 
# distanceRegression <- summarySE(data = regressionReading, measurevar = "dist", groupvars = c("cond", "section"))
# 
# ggplot(distanceRegression, aes(x=section, y=dist, fill=cond)) +
#   geom_bar(position=position_dodge(), stat="identity") +
#   geom_errorbar(aes(ymin=dist-se, ymax=dist+se),
#                 width=.2, position=position_dodge(.9)) + 
#   scale_fill_discrete(name="Experimental\nCondition") +
#   ylab('Saccadic Length') + 
#   xlab('Section of Interest') +
#   ggtitle('The Average of Saccadic Length in Regression')  

averageRegression <- summarySE(data = regressionReading, measurevar = "regression", groupvars = c("cond", "section"))

ggplot(averageRegression, aes(x=section, y=N, fill=cond)) +
  geom_bar(position=position_dodge(), stat="identity") +
  scale_fill_discrete(name="Experimental\nCondition") +
  ylab('Number of Regressions') + 
  xlab('Section of Interest') +
  ggtitle('Number of Regressions\nin the Sections of interest') 