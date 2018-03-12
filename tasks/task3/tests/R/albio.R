library(mpb)
library(stringr)
library(plyr)
library(ggplotFL)

source('~/Desktop/flr/mpb/R/biodyn-fit.R')

load("/home/laurence/Desktop/sea++/mydas/tasks/task3/tests/data/alb.RData")

sa        =biodyn(catch=catch(om), indices=cpue)
params(sa)[c("r","k","b0")]=c(0.45,3.5e5,1)
setControl(sa)=params(sa)
mp=as(list(sa=fit(sa)),"biodyns") 

mp[["mp"]]=biodyn(catch=catch(om), indices=(stock(om)[,-dim(om)[2],]+stock(om)[,-1])/2)
setControl(mp[["mp"]])=apply(params(mp[["sa"]]),1,mean)
mp[["mp"]]=fit(mp[["mp"]])

plot(mp)

