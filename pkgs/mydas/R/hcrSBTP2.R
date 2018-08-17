hcrSBTP2=function(adult,  juve,
                  yrAdult,yrJuve,
                  refJuve=-(1:5),
                  tac,tarCatch,
                  k1=0.25,k2=0.75,lag=1,interval=3){
  
  adultIdx=adult[,ac(dims(adult)$maxyear)]
  adultRef=aaply(adult[,ac(yrAdult)],3:6,mean)
  flag    =adultIdx<adultRef
  cBit    =tarCatch*(adultIdx/adultRef)*(1+ifelse(flag,-k1,k1))
  
  juveIdx =aaply(juve[,ac(dims(juve)$maxyear+refJuve)],3:6,mean)
  juveRef =aaply(juve[,ac(yrJuve) ],3:6,mean)
  flag    =juveIdx<juveRef
  rBit    =(juveIdx/juveRef)*(1+ifelse(flag,-k2,k2))
  
  # cat('ref Juve:',   as.integer(mean(refJuve)),
  #     '\t Juve:',    as.integer(mean(juve)),
  #     '\t ratio:',   mean(juve/refJuve),
  #     '\t rBit:',    mean(rBit),'\n')
  
  res =0.5*(tac+cBit*rBit)
  
  #   cat('TAC:',        as.integer(mean(tac)),
  #       '\t ratio:',   as.integer((mean(adult/refAdult))),
  #       '\t delta:',   as.integer((mean(cBit))),
  #       '\t New TAC:', as.integer(mean(res)),
  #       '\t rBit:',    mean(rBit),'\n')
  
  dmns=dimnames(tac)
  dmns$year=as.character(as.integer(dmns$year)+lag+seq(interval)-1)
  dmns$iter=dimnames(adult)$iter
  
  res=FLQuant(rep(c(res),each=interval),dimnames=dmns)
  
  return(res)}
