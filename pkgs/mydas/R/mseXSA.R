# The ICES Advice Rule for stocks where a wide range of stock sizes 
# has been seen so the stock recruitment relationship can be estimated
#
# if SSB>= MSY Btrigger
#    F=Fmsy
# else
#    F=FMSY*SSB/Btrigger  
#
# FMSY could be a proxy for FMSY, i.e. F0.1
#
# Where
#
# Btrigger is BPA,  i.e. Blim×exp(-1.645×sigma)
# Blim is the break point from segmented regression

# http://ices.dk/sites/pub/Publication%20Reports/Advice/2017/2017/12.04.03.01_Reference_points_for_category_1_and_2.pdf

icesAR<-function(x,ftar=1.0,fmin=0.05,bpa=0.5,sigma=0.3){
  
  hcrParam(
    ftar =refpts(x)["f0.1","harvest"]*ftar,
    btrig=refpts(x)["f0.1",    "ssb"]*exp(-1.645*sigma),
    fmin =refpts(x)["f0.1","harvest"]*fmin,
    blim =refpts(x)["f0.1",    "ssb"]*bpa)}

mseXSA<-function(  
  #OM as FLStock and FLBRP
  om,eq,
  
  #MP, this could be an XSA, biodyn etc,
  mp,control,
  rf="missing",
  
  #HCR
  ftar=1.0,fmin=0.05,bpa=0.5,sigma=0.3,
  
  #Bounds on TAC changes
  bndTac=c(0.01,100),
  
  #years over which to run MSE, doesnt work if interval==1, this is a bug
  interval=3,start=range(om)["maxyear"]-30,end=range(om)["maxyear"]-interval,
  
  #Stochasticity, either by default or suppliedas args
  srDev=rlnoise(dim(om)[6],FLQuant(0,dimnames=list(year=start:(end+interval))),0.3),
  uDev =rlnoise(dim(mp)[6],FLQuant(0,dimnames=dimnames(iter(stock.n(om),1))),0.2),
  
  #Capacity, i.e. F in OM can not be greater than this
  maxF=1.0,
  whitebox=FALSE){ 
  
  ##Check last year so you dont run to the end then crash
  end=min(end,range(om)["maxyear"]-interval)

  ## Make sure number of iterations in OM are consistent
  nits=c(om=dims(om)$iter, eq=dims(params(eq))$iter, rsdl=dims(srDev)$iter)
  if (length(unique(nits))>=2 & !(1 %in% nits)) ("Stop, iters not '1 or n' in om")
  if (nits['om']==1) stock(om)=propagate(stock(om),max(nits))

  ## Limit on capacity, add to fwd(om,maxF=maxF) so catches dont go stuoid 
  maxF=mean(FLQuant(1,dimnames=dimnames(srDev))%*%apply(fbar(window(om,end=start)),6,max)*maxF,na.rm=TRUE)

  ## Observation Error (OEM) setup before looping through years 
  ## this done so biology can be different from OM
  #sink("/dev/null")
  pGrp=range(mp)["plusgroup"]
  smp =setPlusGroup(om,pGrp)
  smp=trim(smp,age=range(mp)["min"]:range(mp)["max"])
  #sink(NULL)

  cpue=window(stock.n(smp),end=start-1)[seq(dim(smp)[1]-1)]
  cpue=cpue%*%uDev[dimnames(cpue)$age,dimnames(cpue)$year]

  ## MP, no need to add biological parameters and catch at this stage, as these are already there, 
  ## rather get rid of stuff that has to be added by OEM and stock assessment fit
  mp=window(mp,end=start-1)

  ## Loop round years
  cat('\n==')
  for (iYr in seq(start,end,interval)){
    #iYr=start
    cat(iYr,", ",sep="")
    
    if (!(whitebox)){
      ## Observation Error, using data from last year back to the last assessment
      #sink("/dev/null")
      smp =trim(setPlusGroup(om[,ac(rev(iYr-seq(interval)))],pGrp),age=range(mp)["min"]:range(mp)["max"])
      #sink(NULL)
      
      ## CPUE
      cpue=window(cpue,end=iYr-1)
      cpue[,ac(iYr-(interval:1))]=stock.n(smp)[dimnames(cpue)$age,ac(iYr-(interval:1))]%*%
        uDev[dimnames(cpue)$age,ac(iYr-(interval:1))]
      
      ## Update and fill in biological parameters
      if (iYr==start) 
        mp=window(mp,end=iYr-1)
      else 
        if (dims(mp)$maxyear>iYr) 
          mp=fwdWindow(mp,rf,end=iYr-1)
      
      ## Add catches and create plus group 
      #sink("/dev/null")
      mp.=trim(setPlusGroup(om[,ac(iYr-rev(seq(interval)))],pGrp),age=range(mp)["min"]:range(mp)["max"])
      #sink(NULL)
      
      ## Should really do landings and discards
      landings(   mp[,ac(iYr-(interval:1))])=landings(   mp.)
      landings.n( mp[,ac(iYr-(interval:1))])=landings.n( mp.)
      landings.wt(mp[,ac(iYr-(interval:1))])=landings.wt(mp.)
      discards(   mp[,ac(iYr-(interval:1))])=discards(   mp.)
      discards.n( mp[,ac(iYr-(interval:1))])=discards.n( mp.)
      discards.wt(mp[,ac(iYr-(interval:1))])=discards.wt(mp.)
      catch(      mp[,ac(iYr-(interval:1))])=catch(      mp.)
      catch.n(    mp[,ac(iYr-(interval:1))])=catch.n(    mp.)
      catch.wt(   mp[,ac(iYr-(interval:1))])=catch.wt(   mp.)
      stock.wt(   mp[,ac(iYr-(interval:1))])=stock.wt(   mp.)
      
      
      #### Management Procedure
      ## fit
      idx=FLIndex(index=cpue)
      range(idx)[c("startf","endf")]=c(0.01,0.1)

      ## Bug with adding range
      xsa=FLXSA(mp,idx,control=control,diag.flag=FALSE)
      range(xsa)[c("min","max","plusgroup")]=range(mp)[c("min","max","plusgroup")]
      mp=mp+xsa
      stock.n(mp)[is.na(stock.n(mp))]=1
      
    }else{
      #sink("/dev/null")
      mp=trim(window(setPlusGroup(om,pGrp),end=iYr-1),age=range(mp)["min"]:range(mp)["max"])
      #sink(NULL)
    }

    if (!("FLBRP"%in%is(rf))){
      ## Stock recruiment relationship
      if (!FALSE){
        sr=as.FLSR(window(mp,end=iYr-3),model="segreg")
        lower(sr)[1:2]=c(c(min(rec(sr),na.rm=TRUE)/max(ssb(sr),na.rm=TRUE)),
                         c(min(ssb(sr),na.rm=TRUE)))
        upper(sr)[1:2]=c(c(max(rec(sr),na.rm=TRUE)/min(ssb(sr),na.rm=TRUE)),
                         c(max(ssb(sr),na.rm=TRUE)))
        sr=fmle(sr,control=list(trace=FALSE))#,method="L-BFGS-B")
        
        params(sr)["a"][is.na(params(sr)["a"])]=median(params(sr)["a"],na.rm=TRUE)
        params(sr)["b"][is.na(params(sr)["b"])]=median(params(sr)["b"],na.rm=TRUE)
      }
      else{
        sr=as.FLSR(window(mp,end=iYr-3),model="geomean")
        sr=fmle(sr,control=list(trace=FALSE),method="L-BFGS-B")
        
        params(sr)["a"][is.na(params(sr)["a"])]=median(params(sr)["a"],na.rm=TRUE)
      }
      ## Reference points
      rf=brp(FLBRP(mp,sr=sr))
    }
    
    ## in year update
    mp=fwdWindow(mp,rf,end=iYr)
    mp[,ac(iYr)]=mp[,ac(iYr-1)]
    #try(save(om,mp,rf,file="/home/laurence/Desktop/tmp/mseXSA1.RData"))
    mp=fwd(mp,catch=catch(om)[,ac(iYr)],sr=list(model="bevholt",params=params(rf)),effort_max=maxF)
    
    print(plot(FLStocks(MP=mp,OM=window(om,start=dims(mp)$minyear,end=dims(mp)$maxyear))))
    
    ## HCR
    hcrPar=icesAR(rf,ftar=ftar,fmin=fmin,bpa=bpa,sigma=sigma)
    
    #try(save(mp,rf,hcrPar,iYr,file="/home/laurence/Desktop/tmp/mseXSA2.RData"))
    tac=hcr(mp,refs=rf,hcrPar,
            hcrYrs=iYr+seq(interval),
            bndTac=bndTac,
            tac =TRUE)
    tac[is.na(tac)]=1  
    
    #### Operating Model update
    #try(try(save(om,eq,tac,srDev,maxF,file="/home/laurence/Desktop/tmp/mseXSA3.RData")))
    om =fwd(om,catch=tac,sr=list(model="bevholt",params=params(eq)),residuals=srDev,effort_max=mean(maxF)) 
  }
  
  cat("==\n")
  
  return(om)}

