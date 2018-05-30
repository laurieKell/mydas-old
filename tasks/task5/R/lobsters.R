## ---- knitr, eval=TRUE, echo=FALSE, warning=FALSE------------------------
knitr::opts_chunk$set(echo = FALSE)

library(knitr)

opts_chunk$set(comment   =NA, 
               warning   =FALSE, 
               message   =FALSE, 
               error     =FALSE, 
               echo      =FALSE,
               fig.width =10, 
               fig.height=10,
               cache     =TRUE, 
               fig.path  ="../tex/om-lobster",
               cache.path="../cache/om-lobster-/")

iFig=0
iTab=0

## ---- dir----------------------------------------------------------------
dirMy="/home/laurence/Desktop/sea++/mydas/tasks/task5"
dirDat=file.path(dirMy,"data")

nits=500

## ---- pkgs---------------------------------------------------------------
library(ggplot2)
library(plyr)
library(dplyr)
library(reshape)
library(GGally)

library(FLCore)
library(FLRP)
library(FLasher)
library(ggplotFL)
library(FLife)

## ----devs----------------------------------------------------------------
set.seed(1233)
srDev=FLife:::rlnoise(nits,FLQuant(0,dimnames=list(year=1:100)),.3,b=0.0)

## ---- lh-----------------------------------------------------------------
ab=cbind(a=c(0.000126,0.00919,0.0017,0.0004,0.001086,0.000447),
         b=c(3.36,2.922,2.797,3.123,2.896,3.01))
         
lh=read.csv("/home/laurence/Desktop/sea++/mydas/tasks/task5/inputs/lobsterGrw.csv")
lh=cbind(lh,rbind(ab,cbind(a   =rep(NA,dim(lh)[1]-dim(ab)[1]),
                           b   =rep(NA,dim(lh)[1]-dim(ab)[1]))))

lh=cbind(lh,cbind(a50=c( 6.0,rep(NA,dim(lh)[1]-1)),
                  l50=c(77.5,rep(NA,dim(lh)[1]-1)),
                  t0 =c(-0.1,rep(NA,dim(lh)[1]-1))))

## ---- par----------------------------------------------------------------
my_smooth <- function(data,mapping,...){
  ggplot(data=data,mapping=mapping)+
    geom_point(...,size=.5)+
    geom_smooth(...,method="lm",se=FALSE)}

my_density <- function(data,mapping,...){
  ggplot(data=data,mapping=mapping)+
    geom_density(...,lwd=1)}

theme_set(theme_bw(base_size=20))

ggpairs(transform(lh,linf=log(linf),k=log(k),a50=a50),
        lower = list(continuous = wrap(my_smooth)),
        diag=list(continuous=wrap(my_density,alpha=0.2)),
        title = "")+
  theme(legend.position ="none",
        panel.grid.major =element_blank(),
        axis.ticks       =element_blank(),
        axis.text.x      =element_blank(),
        axis.text.y      =element_blank(),
        panel.border     =element_rect(linetype = 1, colour="black", fill=NA))

## ----eql-----------------------------------------------------------------
sim<-function(x,niters=500,se=0.3){
  
  mn=aaply(x,1,mean, na.rm=TRUE)
  sd=aaply(x,1,var,  na.rm=TRUE)^0.5
  n =aaply(x,1,function(x) sum(!is.na(x)))
  se=sd/n^0.5
  
  if (any(is.na(se))) se[is.na(se)]=se
  
  y=data.frame(mn=mn,se=se)
  y=mdply(y,function(mn,se) rnorm(niters,mn,se))[,-(1:2)]
  
  res=FLPar(array(unlist(c(y)),c(dim(x)[1],niters)))
  
  dimnames(res)$params=names(mn)
  
  res}

# create FLPar
lh=FLife:::mf2FLPar(lh)

lh=sim(lh,    niters=nits)

lh=lhPar(lh,s=0.8)
eq=lhEql(lh)

## ----vectors-------------------------------------------------------------
sel<-function(x) 
  catch.sel(x)%/%fapex(catch.sel(x))

dat=FLQuants(eq,"M"=m,"Selectivity"=sel,"Maturity"=mat,"Mass"=stock.wt)

res=ldply(dat,function(x) cast(as.data.frame(quantile(x,probs=c(0.025,0.25,0.5,0.75,0.975))),
                               age~iter,value="data"))

ggplot(res)+
  geom_ribbon(aes(age,ymin=`25%`,ymax=`75%`),alpha=0.5,fill="red")+
  geom_ribbon(aes(age,ymin=`2.5%`,ymax=`97.5%`),alpha=0.1,fill="red")+
  geom_line(aes(age,`50%`))+
  facet_wrap(~.id,scale="free")+
  scale_x_continuous(limits=c(0,10))+
  xlab("Age")+ylab("")

## ----eq, fig.height=6,fig.width=8----------------------------------------
plot(iter(eq,1),refpts=FALSE)

## ----om------------------------------------------------------------------
#http://www.fishbase.org/manual/Key%20Facts.htm

gTime=round(FLife:::genTime(FLPar(aaply(lh,1,mean))))
maxf =mean(refpts(eq)["crash","harvest"]/refpts(eq)["msy","harvest"]*0.75)

eq@fbar=refpts(eq)["msy","harvest"]%*%FLQuant(c(rep(.1,19),
                                              seq(.1,maxf,length.out=40),
                                              seq(maxf,.7,length.out=gTime)[-1],
                                              rep(.7,61)))[,1:100]

om=as(eq,"FLStock")
om=fwd(om,fbar=fbar(om)[,-1],sr=eq,residuals=srDev)

save(lh,eq,om,file=file.path(dirDat,"lobster.RData"),compress="xz")

plot(om)

