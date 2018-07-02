library(ggplot2)
library(reshape)
library(plyr)
library(dplyr)
library(FLCore)
library(ggplotFL)

library(mpb)

## sim pella
bd=sim(p=0.000000001)
plot(bd)

u=stock(bd,0.5)
u=rlnorm(1,log(u),.1)

setParams(bd)=u
setControl(bd)=params(bd)

hat=fit(bd,u)
hat@stock=stock(fwd(hat,catch=catch(hat)))

plot(as(list(hat=hat,true=bd),"biodyns"))

## sim dbsra
bdsra=sim(p=0.000000001)

u=stock(bdsra,0.6)
u[,]=NA
u[,c(1:5,45:49)]=c(rep(1,5),rep(0.9,5))

#params(bdsra)["r"]=1.5
setParams(bdsra)=u
setControl(bdsra)=params(bdsra)
dbsra=fit(bdsra,u)
bdsra@stock=stock(fwd(bdsra,catch=catch(bdsra)))

plot(as(list(hat=hat,true=bd,bdsra=bdsra),"biodyns"))

## Brill
load("/home/laurence/Desktop/sea++/mydas/tasks/task5/data/brill.RData")

bd=biodyn(om)

u=stock(bd,0.5)[,-100]

params(bd)["r"]=prior[c("r")]
params(bd)["k"]=1200
params(bd)["p"]=0.000000001

setParams(bd)=u
setControl(bd)=params(bd)

hat=fit(bd,u)
#hat@stock=stock(fwd(hat,catch=catch(hat)))

plot(as(list(hat=hat,true=bd),"biodyns"))

bdsra=bd

u=stock(bdsra,0.5)
u[]=NA
u[,c(1:5,96:100)]=c(rep(1,5),rep(0.5,5))

setControl(bdsra)=params(bdsra)

bdsra=fit(bd,u)
#bdsra@stock=stock(fwd(bdsra,catch=catch(bdsra)))

plot(as(list(hat=hat,true=bd,dbsra=bdsra),"biodyns"))
