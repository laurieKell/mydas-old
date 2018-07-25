library(plyr)
library(dplyr)
library(reshape)
library(ggplot2)

library(FLCore)
library(ggplotFL)
library(FLasher)
library(FLBRP)
library(FLife)
library(mpb)

source('~/Desktop/flr/mpb/R/mseMPB.R')
source("/home/laurence/Desktop/flr/mpb/R/hcr.R")

source('~/Desktop/flr/mpb/R/setMP.R')
source('~/Desktop/flr/mpb/R/pellam.R')

theme_set(theme_bw())

dirMy ="/home/laurence/Desktop/sea++/mydas/tasks/task4"
dirDat=file.path(dirMy,"data")

## OM
load(file.path(dirDat,"turbot.RData"))

om=window(om,start=20,end=90)

## MP
mp=setMP(as(window(om,end=55),"biodyn"),
         r =median(prior["r"],na.rm=T),
         k =median(prior["v"],na.rm=T),
         b0=0.8,
         p =median(p(prior["bmsy"]/prior["v"]),na.rm=TRUE))

nits=dims(mp)$iter
set.seed(1234)
srDev=FLife:::rlnoise(nits,FLQuant(0,dimnames=list(year=1:100)),0.3,b=0.0)
uDev =FLife:::rlnoise(nits,FLQuant(0,dimnames=list(year=1:100)),0.2,b=0.0)
eq=iter(eq,seq(nits))

mse =mseMPB(om,eq,mp,start=55,ftar=0.5,srDev=srDev,uDev=uDev)
