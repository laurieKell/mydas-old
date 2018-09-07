library(plyr)
library(dplyr)
library(reshape)
library(ggplot2)

library(FLCore)
library(ggplotFL)
library(FLasher)
library(FLBRP)
library(FLife)

library(devtools)
devtools::install_github("lauriekell/mydas", subdir="pkgs/mydas")

sessionInfo()

dirMy ="/home/laurence/Desktop/sims/wklife"
dirDat=file.path(dirMy,"data")
dirRes=file.path(dirMy,"results")

### Stochasticity
nits=100
set.seed(1234)
srDev=FLife:::rlnoise(nits,FLQuant(0,dimnames=list(year=1:100)),0.2,b=0.0)

### OEM
uDev =FLife:::rlnoise(nits,FLQuant(0,dimnames=list(year=1:100)),0.3,b=0.0)

## MSE for Derivate empirical MP
scen=expand.grid(stock=c("turbot","lobster","ray","pollack","razor","brill","sprat")[1],
                 k1=seq(0.2,0.8,0.2),k2=seq(0.2,0.8,0.2),gamma=seq(0.75,1.25,0.25),
                 stringsAsFactors=FALSE)

empD=NULL
for (i in seq(dim(scen)[1])){
  load(file.path(dirDat,paste(scen[i,"stock"],".RData",sep="")))
  om=iter(om,seq(nits))
  eq=iter(eq,seq(nits))
  lh=iter(lh,seq(nits))
  
  res =mseSBTD(om,eq,control=with(scen[i,],c(k1=k1,k2=k2,gamma=gamma)),start=60,end=100,srDev=srDev,uDev=uDev)
  empD=rbind(empD,cbind(scen=i,stock=scen[i,"stock"],k1r=scen[i,"k1"],k2=scen[i,"k2"],gamma=scen[i,"gamma"],omSmry(res,eq,lh)))
  
  save(empD,file=file.path(dirRes,"empD.RData"))}

## MSE for Proportion empirical MP
scen=expand.grid(stock=c("turbot","lobster","ray","pollack","razor","brill","sprat")[1],
                 k1=seq(0.1,0.4,0.1),k2=seq(0.1,0.4,0.1),
                 stringsAsFactors=FALSE)
empP=NULL
for (i in seq(dim(scen)[1])){
  load(file.path(dirDat,paste(scen[i,"stock"],".RData",sep="")))
  om=iter(om,seq(nits))
  eq=iter(eq,seq(nits))
  lh=iter(lh,seq(nits))

  res =mseSBTP(om,eq,control=with(scen[i,],c(k1=k1,k2=k2)),start=60,end=100,srDev=srDev,uDev=uDev,refYr=)
  empD=rbind(res,cbind(scen=i,stock=scen[i,"stock"],k1r=scen[i,"k1"],k2=scen[i,"k2"],gamma=scen[i,"gamma"],omSmry(res,eq,lh)))
  
  save(empD,file=file.path(dirRes,"empD.RData"))}


