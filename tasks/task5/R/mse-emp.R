library(plyr)
library(dplyr)
library(reshape)
library(ggplot2)

library(FLCore)
library(ggplotFL)
library(FLasher)
library(FLBRP)

library(devtools)
devtools::install_github("lauriekell/mydas", subdir="pkgs/mydas")

sessionInfo()

dirMy ="wklife/sims"
dirDat=file.path(dirMy,"data")
dirRes=file.path(dirMy,"results")

## OM
load(file.path(dirDat,"turbot.RData"))

om=window(om,start=20,end=90)

### Stochasticity
nits=dims(om)$iter
set.seed(1234)
srDev=FLife:::rlnoise(nits,FLQuant(0,dimnames=list(year=1:100)),0.2,b=0.0)

### OEM
uDev =FLife:::rlnoise(nits,FLQuant(0,dimnames=list(year=1:100)),0.3,b=0.0)

## MSE for Derivate empirical MP
scen=expand.grid(stock=c("turbot","lobster","ray","pollack","razor","brill","sprat"),
                 k1=seq(1.5,2.5,0.5),k2=seq(1.5,3.0,0.5),gamma=seq(0.75,1.25,0.25))

empD=NULL
for (i in seq(dim(scen)[1])){
  res =mseEMPSBTD(om,eq,control=with(scen[i,],c(k1=k1,k2=k2,gamma=gamma)),start=60,end=100,srDev=srDev,uDev=uDev)
  empD=rbind(res,cbind(scen=i,k1r=scen[i,"k1"],k2=scen[i,"k2"],gamma=scen[i,"gamma"],omSmry(res,eq,lh)))
  
  save(empD,file=file.path(dirRes,"empD.RData"))}

## MSE for Proportion empirical MP
scen=expand.grid(stock=c("turbot","lobster","ray","pollack","razor","brill","sprat"),
                 k1=seq(0.2,0.25,0.3),k2=seq(0.2,0.25,0.3))
empP=NULL
for (i in seq(dim(scen)[1])){
  res =mseEMPSBTP(om,eq,control=with(scen[i,],c(k1=k1,k2=k2,gamma=gamma)),start=60,end=100,srDev=srDev,uDev=uDev)
  empD=rbind(res,cbind(scen=i,k1r=scen[i,"k1"],k2=scen[i,"k2"],gamma=scen[i,"gamma"],omSmry(res,eq,lh)))
  
  save(empD,file=file.path(dirRes,"empD.RData"))}


