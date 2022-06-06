library(Rmisc)
library(ggplot2)

# Load dataset with mapped data with LLAH
myData <- read.csv('all_data_fr_2.csv', header = FALSE)
names(myData) <- c("subject", "fr_index", "fr_size" ,"sac_len", "fix_dur", "fr_speed", "type", "section")


# Load raw dataset from original video scene
rawData <- read.csv('all_raw.csv', header = FALSE)
names(rawData) <- c("subject", "timestamp", "x", "y", "fix_dur", "sac_len", "regression", "type")


# remove outliers
qt <- quantile(myData$fix_dur)[4]
myData <- subset(myData, myData$fix_dur<qt)
boxplot(myData$fix_dur)

# remove outliers
qt <- quantile(rawData$fix_dur, prob = seq(0, 1, length = 11), type = 5)
qt <- qt[10]

rawData <- subset(rawData, myData$fix_dur<qt)
boxplot(myData$fix_dur)

# ACM <- subset(myData, type == "ACM")
# LNCS <- subset(myData, type == "LNCS")
# 
# fit <- aov(aggData$fix ~ aggData$subject)
# summary(fit)
# 
# mean(myData$fr_speed)

tgc <- summarySE(data = myData, measurevar = "fix_dur", groupvars = c("type", "section"))


ggplot(tgc, aes(x=section, y=fix_dur, fill=type)) +
  geom_bar(position=position_dodge(), stat="identity") +
  geom_errorbar(aes(ymin=fix_dur-se, ymax=fix_dur+se),
                width=.2,                    # Width of the error bars
                position=position_dodge(.9))

aggRawDataSac <- aggregate(rawData$sac_len ~ rawData$subject, FUN = mean)
names(aggRawDataSac) <- c("subject", "sac")

aggDataSac <- aggregate(myData$sac_len ~ myData$subject, FUN = mean)
names(aggDataSac) <- c("subject", "sac")

aggRawDataFix <- aggregate(rawData$fix_dur ~ rawData$subject, FUN = mean)
names(aggRawDataFix) <- c("subject", "fix")

aggDataFix <- aggregate(myData$fix_dur ~ myData$subject, FUN = mean)
names(aggDataFix) <- c("subject", "fix")

aggRawDataSpeed <- aggregate(rawData$sac_len/(rawData$fix_dur*16) ~ rawData$subject, FUN = mean)
names(aggRawDataSpeed) <- c("subject", "speed")

aggDataSpeed <- aggregate(myData$fr_speed ~ myData$subject, FUN = mean)
names(aggDataSpeed) <- c("subject", "speed")


