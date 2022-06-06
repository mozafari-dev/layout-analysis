library(Rmisc)
library(ggplot2)
library(reshape2)

fullData <- read.csv('data/all_fixations_with_parameters.csv' ,header = TRUE)
fullData<- fullData[!(fullData$section=="-------------"),]

forwardReading <- read.csv('data/forward_reading.csv' ,header = TRUE)
forwardReading<- forwardReading[!(forwardReading$section=="-------------"),]

aggForwardReading <- aggregate(forwardReading, 
                               by=list(forwardReading$cond, forwardReading$section), 
                               FUN = mean, na.rm=TRUE)
# SacSubjects <- aggregate(fullData$dist ~ fullData$subject, FUN = mean)
# names(SacSubjects) <- c("subject", "sac")
# 
# SacCondition <- aggregate(fullData$dist ~ fullData$cond, FUN = mean)
# names(SacCondition) <- c("condition", "sac")
# 
# SacSection <- aggregate(fullData$dist ~ fullData$section, FUN = mean)
# names(SacSection) <- c("section", "sac")
# 
# SacROI <- aggregate(fullData$dist ~ fullData$roi, FUN = mean)
# names(SacSection) <- c("roi", "sac")

tgc <- summarySE(data = forwardReading, measurevar = "fr_time", groupvars = c("cond", "section"))
ggplot(tgc, aes(x=section, y=fr_time, fill=cond)) +
      geom_bar(position=position_dodge(), stat="identity") +
      geom_errorbar(aes(ymin=fr_time-se, ymax=fr_time+se),
                    width=.2, position=position_dodge(.9)) + 
      scale_fill_discrete(name="Experimental\nCondition") +
      ylab('Fixation Duration') + 
      xlab('Section of Interest') +
      ggtitle('The Average of Aggregated Fixtion Duration in Each Forward Reading')