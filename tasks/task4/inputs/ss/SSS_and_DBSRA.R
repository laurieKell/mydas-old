Min.Year=1930; Max.Year=2011
Catch # read catch data 
Outs<-data.frame(Year=c(Min.Year:Max.Year),
                 Catch=Catch)
##################################################################################
###     DBSRA     ################################################################
##################################################################################
# set Kprior
# set BMSY_B0.prior
# set FMSY_M.prior
# set Dep (Depletion prior)
M=0.3
dbsra.ALB<-dbsra(year=Outs$Year,
                 catch=Outs$Catch,
                 catchCV=0.1,
                 catargs=list(dist="none",low=0,up=Inf,unit="tones"), #list arguments associated with resampling of catch. "none" = no resampling
                 agemat=5, 
                 k = list(low=min(kprior),up=max(kprior),tol=0.01,permax=1000), 
                 btk = list(dist="norm",low=0.2,up=1,mean=Dep,sd=0.1,refyr=2011),
                 fmsym = list(dist="unif",low=0,up=2,mean=FMSY_M.prior,sd=0.1), #dist= "none", the mean is used as a fixed constant.
                 bmsyk = list(dist="unif",low=0,up=1,mean=BMSY_B0.prior,sd=0.1),
                 M=list(dist="none",low=0.2,up=0.5,mean=M,sd=0.01),
                 nsims = 1000, graphs=c())  

Biom.traj2<-read.csv("Biotraj-dbsra.csv",header=F)
Biom.traj2<-Biom.traj2[,-c(1,ncol(Biom.traj2))]
Biom.traj2<-cbind(Biom.traj2,Bmsy=dbsra.ALB$Values$Bmsy)
ALB.Bdbsra<-Biom.traj2[Biom.traj2[,ncol(Biom.traj2)-1]>0,] #eliminates the ones that went extinct
BBmsy_dbsra<-ALB.Bdbsra[,-ncol(ALB.Bdbsra)]/ALB.Bdbsra[,ncol(ALB.Bdbsra)]
Outs$Bdbsra<-ALB.Bdbsra[,-ncol(ALB.Bdbsra)]

##################################################################################
#####   SSS  #####################################################################
##################################################################################
source(paste(getwd(),"/SSS/SSS_code_newSRs.R",sep=""))
SSreps<-1000
POP.SSS.BH<-SSS(filepath=paste(SSdir,"/SSS/",sep=""),
                file.name=c("ALB-NAO.dat","ALB-NAO.ctl"),
                reps=SSreps,
                seed.in=19,
                M.in=c(0,M,0.1,0,M,0.1), 
                Dep.in=c(10,Dep,0.1), 
                SR_type=3, # BH
                h.in=c(-10,0.9,0.1), #option 10 is rtnorm
                FMSY_M.in=c(-4,FMSY_M.prior,0.1),
                BMSY_B0.in=c(-4,BMSY_B0.prior,0.1),
                L1.in=c(0,0,0,0),
                Linf.in=c(0,0,0,0),
                k.in=c(0,0,0,0),
                Zfrac.Beta.in=c(-99,0.2,0.6,-99,0.5,2),
                R_start=c(0,9),
                doR0.loop=c(1,8.1,14.1,0.5),
                sum_age=0,
                sb_ofl_yrs=c(Max.Year,Max.Year+1,Max.Year+1),
                f_yr=Max.Year,
                year0=Min.Year,
                genders=F)

# SSS outs
Outs$B.SSS<-apply(POP.SSS.BH$Total_Biomass,2,median)
Outs$SSB.SSS<-apply(POP.SSS.BH$SB_series,2,median)

