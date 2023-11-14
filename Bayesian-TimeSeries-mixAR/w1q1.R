phi1 = 0.1
phi2 = 0.8
v = 1
library(colorRamps)
#library(leaflet)
library(fields)
library(mvtnorm)


set.seed(1)
y.sample = arima.sim(n=200,model=list(order=c(2,0,0),ar=c(phi1,phi2),sd=sqrt(v)))

##plot the simulate data
plot.ts(y.sample,ylab=expression(italic(y)[italic(t)]),xlab=expression(italic(t)),
        main='')

#y.sample=arima.sim(n=200,model=list(order=c(2,0,0),ar=c(phi1,phi2),sd=sqrt(v)))




## set up
N=200
p=2  ## order of AR process
n.all=length(y.sample) ## T, total number of data

Y=matrix(y.sample[3:n.all],ncol=1)
Fmtx=matrix(c(y.sample[2:(n.all-1)],y.sample[1:(n.all-2)]),nrow=p,byrow=TRUE)
n=length(Y)







m0=matrix(rep(0,p),ncol=1)
C0=diag(p)
n0=2
d0=2

e=Y-t(Fmtx)%*%m0
Q=t(Fmtx)%*%C0%*%Fmtx+diag(n)
Q.inv=chol2inv(chol(Q))
A=C0%*%Fmtx%*%Q.inv
m=m0+A%*%e
C=C0-A%*%Q%*%t(A)
n.star=n+n0
d.star=t(Y-t(Fmtx)%*%m0)%*%Q.inv%*%(Y-t(Fmtx)%*%m0)+d0


n.sample=5000

nu.sample=rep(0,n.sample)
phi.sample=matrix(0,nrow=n.sample,ncol=p)

for (i in 1:n.sample) {
  set.seed(i)
  nu.new=1/rgamma(1,shape=n.star/2,rate=d.star/2)
  nu.sample[i]=nu.new
  phi.new=rmvnorm(1,mean=m,sigma=nu.new*C)
  phi.sample[i,]=phi.new
}

par(mfrow=c(1,3))
hist(phi.sample[,1],freq=FALSE,xlab=expression(phi[1]),main="",ylim=c(0,6.4))
lines(density(phi.sample[,1]),type='l',col='red')
hist(phi.sample[,2],freq=FALSE,xlab=expression(phi[2]),main="",ylim=c(0,6.4))
lines(density(phi.sample[,2]),type='l',col='red')
hist(nu.sample,freq=FALSE,xlab=expression(nu),main="")
lines(density(nu.sample),type='l',col='red')


print(paste0('phi1: ', mean(phi.sample[,1])))
print(paste0('phi2: ', mean(phi.sample[,2])))
print(paste0('nu: ', mean(nu.sample)))



## get in sample prediction
post.pred.y=function(s){
  
  beta.cur=matrix(phi.sample[s,],ncol=1)
  nu.cur=nu.sample[s]
  mu.y=t(Fmtx)%*%beta.cur
  sapply(1:length(mu.y), function(k){rnorm(1,mu.y[k],sqrt(nu.cur))})
  
  
}  

y.post.pred.sample=sapply(1:5000, post.pred.y)





## show the result
summary.vec95=function(vec){
  c(unname(quantile(vec,0.025)),mean(vec),unname(quantile(vec,0.975)))
}

summary.y=apply(y.post.pred.sample,MARGIN=1,summary.vec95)

plot(Y,type='b',xlab='Time',ylab='',ylim=c(-7,7),pch=16)
lines(summary.y[2,],type='b',col='grey',lty=2,pch=4)
lines(summary.y[1,],type='l',col='purple',lty=3)
lines(summary.y[3,],type='l',col='purple',lty=3)
legend("topright",legend=c('Truth','Mean','95% C.I.'),lty=1:3,col=c('black','grey','purple'),
       horiz = T,pch=c(16,4,NA))
