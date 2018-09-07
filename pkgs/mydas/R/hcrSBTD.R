hcrSBTD<-function(yrs,
                  control=c(k1=2.0,k2=3.0,gamma=1),
                  index,
                  catch,...){
print(1)  
print(index)
print(apply(index,6,mean))
  lambda=FLQuant(ddply(as.data.frame(index%/%apply(index,6,mean)), 
                          .(iter), with,  data.frame(data=coefficients(lm(data~year))[2])))
  print(lambda)
print(2)  
  flag  =lambda<0
  lambda=abs(lambda)
print(3)  
  res   =1+ifelse(flag,-control["k1"],control["k2"])*exp(log(lambda)*ifelse(flag,control["gamma"],1))
print(4)  
  res   =res%*%apply(catch,6,mean)
print(5)  
  
  dmns     =dimnames(catch)
  dmns$year=yrs
  dmns$iter=dimnames(index)$iter
print(6)  
  
  res      =FLQuant(rep(c(res),each=length(yrs)),dimnames=dmns)
print(7)  
  
  return(res)}
