library(Rmisc)
library(ggplot2)
library(reshape2)
library(plyr)

fullData <- read.csv('data/all_fixations_with_parameters.csv' ,header = TRUE)
fullData<- fullData[!(fullData$section=="-"),]

sweepReading <- fullData[(fullData$sweep==1),]

aggSweepReading <- aggregate(sweepReading, 
                               by=list(sweepReading$cond, sweepReading$section), 
                               FUN = mean, na.rm=TRUE)

averageSweep <- aggregate(sweepReading$sweep ~ sweepReading$cond + sweepReading$section, 
                               data = sweepReading, sum)


fixiationSweep <- summarySE(data = sweepReading, measurevar = "fix_dur", groupvars = c("cond", "section"))

ggplot(fixiationsweep, aes(x=section, y=fix_dur, fill=cond)) +
  geom_bar(position=position_dodge(), stat="identity") +
  geom_errorbar(aes(ymin=fix_dur-se, ymax=fix_dur+se),
                width=.2, position=position_dodge(.9)) + 
  scale_fill_discrete(name="Experimental\nCondition") +
  ylab('Fixation Duration') + 
  xlab('Section of Interest') +
  ggtitle('The Average of First Fixation Duration\nAfter sweep') 

distanceSweep <- summarySE(data = sweepReading, measurevar = "dist", groupvars = c("cond", "section"))

ggplot(distancesweep, aes(x=section, y=dist, fill=cond)) +
  geom_bar(position=position_dodge(), stat="identity") +
  geom_errorbar(aes(ymin=dist-se, ymax=dist+se),
                width=.2, position=position_dodge(.9)) + 
  scale_fill_discrete(name="Experimental\nCondition") +
  ylab('Saccadic Length') + 
  xlab('Section of Interest') +
  ggtitle('The Average of Saccadic Length in sweep')  

averageSweep <- summarySE(data = sweepReading, measurevar = "sweep", groupvars = c("cond", "section"))

ggplot(distanceSweep, aes(x=section, y=N, fill=cond)) +
  geom_bar(position=position_dodge(), stat="identity") +
  scale_fill_discrete(name="Experimental\nCondition") +
  ylab('Number of sweeps') + 
  xlab('Section of Interest') +
  ggtitle('Number of sweeps\nin the Sections of interest') 