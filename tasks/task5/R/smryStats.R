library(FLCore)
library(FLRP)
library(FLife)
library(plyr)
library(reshape)

load("/home/laurence/Desktop/sea++/mydas/tasks/task5/data/lobster.RData")

res=FLife:::omSmry(om,eq)

ggplot(subset(res, iter%in%seq(500)[c(ssb(om)[,"50"])<0]))+
  geom_line(aes(year,stock,group=iter))

