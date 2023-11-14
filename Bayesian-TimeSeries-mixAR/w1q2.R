# QUIZ 2 (WEEK 1)
# READ DATA
## read data, you need to make sure the data file is in your current working directory 
earthquakes.dat <- read.delim("earthquakes.txt")
earthquakes.dat$Quakes=as.numeric(earthquakes.dat$Quakes)
y.dat=earthquakes.dat$Quakes[1:100] ## this is the training data
y.new=earthquakes.dat$Quakes[101:103] ## this is the test data

## read data, you need to make sure the data file is in your current working directory 
covid.dat <- read.delim("GoogleSearchIndex.txt")
covid.dat$Week=as.Date(as.character(covid.dat$Week),format = "%Y-%m-%d")
y.dat=covid.dat$covid[1:57] ## this is the training data
y.new=covid.dat$covid[58:60] ## this is the test data



# ANALYSIS

y.sample = y.dat

library(mvtnorm)


## simulate data


phi1=0.5
phi2=0.4
v=1


set.seed(1)
#y.sample=arima.sim(n=200,model=list(order=c(2,0,0),ar=c(phi1,phi2),sd=sqrt(v)))


## set up
N=100
p=2 ## order of AR process
n.all=length(y.sample) ## T, total number of data


Y=matrix(y.sample[3:n.all],ncol=1)
Fmtx=matrix(c(y.sample[2:(n.all-1)],y.sample[1:(n.all-2)]),nrow=p,byrow=TRUE)
n=length(Y)


## posterior inference


## set the prior
m0=matrix(rep(0,p),ncol=1)
C0=diag(p)
n0=2
d0=0.02


## calculate parameters that will be reused in the loop
e=Y-t(Fmtx)%*%m0
Q=t(Fmtx)%*%C0%*%Fmtx+diag(n)
Q.inv=chol2inv(chol(Q))
A=C0%*%Fmtx%*%Q.inv
m=m0+A%*%e
C=C0-A%*%Q%*%t(A)
n.star=n+n0
d.star=t(Y-t(Fmtx)%*%m0)%*%Q.inv%*%(Y-t(Fmtx)%*%m0)+d0




n.sample=5000


## store posterior samples
nu.sample=rep(0,n.sample)
phi.sample=matrix(0,nrow=n.sample,ncol=p)




for (i in 1:n.sample) {
  set.seed(i)
  nu.new=1/rgamma(1,shape=n.star/2,rate=d.star/2)
  nu.sample[i]=nu.new
  phi.new=rmvnorm(1,mean=m,sigma=nu.new*C)
  phi.sample[i,]=phi.new
}











## the prediction function


y_pred_h_step=function(h.step,s){
  phi.cur=matrix(phi.sample[s,],ncol=1)
  nu.cur=nu.sample[s]
  y.cur=c(y.sample[200],y.sample[199])
  y.pred=rep(0,h.step)
  for (i in 1:h.step) {
    mu.y=sum(y.cur*phi.cur)
    y.new=rnorm(1,mu.y,sqrt(nu.cur))
    y.pred[i]=y.new
    y.cur=c(y.new,y.cur)
    y.cur=y.cur[-length(y.cur)]
  }
  return(y.pred)
}













set.seed(1)
y.post.pred.ahead=sapply(1:5000, function(s){y_pred_h_step(h.step=3,s=s)})


par(mfrow=c(1,3))
hist(y.post.pred.ahead[1,],freq=FALSE,xlab=expression(y[201]),main="")
lines(density(y.post.pred.ahead[1,]),type='l',col='red')
hist(y.post.pred.ahead[2,],freq=FALSE,xlab=expression(y[202]),main="")
lines(density(y.post.pred.ahead[2,]),type='l',col='red')
hist(y.post.pred.ahead[3,],freq=FALSE,xlab=expression(y[203]),main="")
lines(density(y.post.pred.ahead[3,]),type='l',col='red')








summary.vec95=function(vec){
  c(unname(quantile(vec,0.025)),mean(vec),unname(quantile(vec,0.975)))
}


apply(y.post.pred.ahead,MARGIN=1,summary.vec95)








print(colMeans(phi.sample))
print(mean(nu.sample))
