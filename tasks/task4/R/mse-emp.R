library(plyr)
library(dplyr)
library(reshape)
library(ggplot2)

library(FLCore)
library(ggplotFL)
library(FLasher)
library(FLRP)
library(FLife)
library(FLAssess)
library(FLXSA)
library(mpb)

source('~/Desktop/flr/mpb/R/mseXSA.R')
source('~/Desktop/flr/mpb/R/hcr.R')
source('~/Desktop/flr/mpb/R/mseXSA.R')
source('~/Desktop/flr/mpb/R/pellam.R')
source('~/Desktop/flr/mpb/R/biodyn-fwdWindow.R')

source('~/Desktop/flr/FLife/R/omOut.R')

theme_set(theme_bw())

dirMy ="/home/laurence/Desktop/sea++/mydas/tasks/task5"
dirDat=file.path(dirMy,"data")

## OM
load(file.path(dirDat,"turbot.RData"))

om=iter(window(om,start=20,end=90),1:20)

## MP
source('~/Desktop/flr/mpb/R/mseEMP.R')

nits=dims(om)$iter
set.seed(1234)
srDev=FLife:::rlnoise(nits,FLQuant(0,dimnames=list(year=1:100)),0.3,b=0.0)
uDev =FLife:::rlnoise(nits,FLQuant(0,dimnames=list(year=1:100)),0.2,b=0.0)
eq=iter(eq,seq(nits))

#mseEMP<-function(
  #OM as FLStock and FLBRP
  #om,eq,

  #MP,
  control=c(k1=3.0,k2=1.5,gamma=1,nyrs=5,lag=1,interval=3);

  #years over which to run MSE, doesnt work if interval==1, this is a bug
  interval=3;start=range(om)["maxyear"]-30;end=range(om)["maxyear"]-interval;

  #Stochasticity, either by default or suppliedas args
  #srDev=FLife:::rlnoise(dim(om)[6],FLQuant(0,dimnames=list(year=start:end)),0.3);
  #uDev =FLife:::rlnoise(dim(om)[6],FLQuant(0,dimnames=dimnames(iter(stock.n(om),1))),0.2);

  #Capacity, i.e. F in OM can not be greater than this
  maxF=1.5
  #){

  ##So you dont run to the end then crash
  end=min(end,range(om)["maxyear"]-interval)

  ## Make sure number of iterations are consistent
  nits=c(om=dims(om)$iter, eq=dims(params(eq))$iter, rsdl=dims(srDev)$iter)
  if (length(unique(nits))>=2 & !(1 %in% nits)) ("Stop, iters not '1 or n' in om")
  if (nits['om']==1) stock(om)=propagate(stock(om),max(nits))

  ## Limit on capacity, add to fwd(om) if you want
  maxF=median(FLQuant(1,dimnames=dimnames(srDev))%*%apply(fbar(window(om,end=start)),6,max)*maxF)

  ## Observation Error (OEM) setup
  pGrp=range(om)["plusgroup"]

  cpue=window(stock(om),end=start)
  cpue=cpue%*%uDev[,dimnames(cpue)$year]

  ## Loop round years
  cat('\n==')
  for (iYr in seq(start,end,interval)){
    cat(iYr,", ",sep="")

    ## Observation Error, using data from last year back to the last assessment
    ## CPUE
    cpue=window(cpue,end=iYr-1)
    cpue[,ac(iYr-(interval:1))]=stock(om)[,ac(iYr-(interval:1))]%*%uDev[,ac(iYr-(interval:1))]
    #### Management Procedure

    u=window(apply(cpue,c(2,6),mean),end=iYr-1)
    tac=hcrSBT1(u,catch(om)[,ac(iYr-1)])

    #### Operating Model update
    om =fwd(om,catch=tac,sr=eq,residual=srDev,effort_max=mean(maxF))
    }
  cat('==\n')

  return(om)}

mse =mseEMP(om,eq,mp,start=55,ftar=0.5,srDev=srDev,uDev=uDev)
