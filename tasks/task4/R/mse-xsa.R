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
source('~/Desktop/flr/mse/R/msy.R')
source('~/Desktop/flr/mse/R/hcr.R')
source('~/Desktop/flr/FLife/R/omOut.R')
source('~/Desktop/flr/mpb/R/mseXSA.R')

theme_set(theme_bw())

dirMy ="/home/laurence/Desktop/sea++/mydas/tasks/task5"
dirDat=file.path(dirMy,"data")

xsa=function(om,pg=10,ctrl=xsaControl){
  stk=setPlusGroup(om,pg)
  idx=FLIndex(index=stock.n(stk))
  range(idx)[c("plusgroup","startf","endf")]=c(pg,0.1,.2)
  stk+FLXSA(stk,idx,control=ctrl,diag.flag=FALSE)}

load(file.path(dirDat,"turbot.RData"))

##OM
om=iter(om,1:500)
eq=iter(eq,1:500)

om=window(om,start=25)
range(om)[c("minfbar","maxfbar")]=ceiling(mean(lh["a1"]))
range(eq)[c("minfbar","maxfbar")]=ceiling(mean(lh["a1"]))

##MP
xsaControl=FLXSA.control(tol    =1e-09, maxit   =150, 
                         min.nse=0.3,   fse     =1.0, 
                         rage   =1,     qage    =6, 
                         shk.n  =TRUE,  shk.f   =TRUE, 
                         shk.yrs=1,     shk.ages=4, 
                         window =10,    tsrange =10, 
                         tspower= 0,
                         vpa    =FALSE)
mp=xsa(window(om,end=75),ctrl=xsaControl,pg=10)

plot(FLStocks(list("xsa"=mp,"om"=om)))

nits=dim(mp)[6]
set.seed(4321)
srDev=FLife:::rlnoise(nits,rec(    om)[,,,,,1]%=%0,0.3,b=0.0)
uDev =FLife:::rlnoise(nits,stock.n(om)[,,,,,1]%=%0,0.2,b=0.0)

mse =mseXSA(om,eq,
            mp,control=xsaControl,
            ftar=1.0,
            interval=1,start=70,end=100,
            srDev=srDev,uDev=uDev)

plot(FLStocks(llply(FLStocks("1"=mse, "2"=mseY, "3"=mseC),window,start=75,end=100)))+
  facet_grid(qname~stock,scale="free")

plaiceXsaMse=rbind(cbind("Scenario"="none",  omSmry(window(mse, start=70),eqPlaice)),
                   cbind("Scenario"="year",  omSmry(window(mseY,start=70),eqPlaice)),
                   cbind("Scenario"="cohort",omSmry(window(mseC,start=70),eqPlaice)))

ggplot(transform(subset(plaiceXsaMse,year>85),yield=catch/msy_yield))+
  geom_histogram(aes(yield))+
  facet_grid(Scenario~.)

ggplot(transform(subset(plaiceXsaMse,year>85&year<=95),yield=ssb/msy_ssb))+
  geom_histogram(aes(yield))+
  facet_grid(Scenario~.)
