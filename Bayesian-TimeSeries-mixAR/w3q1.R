# QUIZ 1 WEEK 3

library(MCMCpack)
library(mvtnorm)

#### Model setup
earthquakes.dat <- read.delim("earthquakes.txt")
earthquakes.dat$Quakes=as.numeric(earthquakes.dat$Quakes)
y=earthquakes.dat$Quakes[1:100] ## this is the training data
y.new=earthquakes.dat$Quakes[101:103] ## this is the test data


## read data, you need to make sure the data file is in your current working directory 
covid.dat <- read.delim("GoogleSearchIndex.txt")
covid.dat$Week=as.Date(as.character(covid.dat$Week),format = "%Y-%m-%d")
y.dat=covid.dat$covid[1:57] ## this is the training data
y.new=covid.dat$covid[58:60] ## this is the test data








p=1 ## order of AR process
K=2 ## number of mixing component
Y=matrix(y[3:100],ncol=1) ## y_{p+1:T}
Fmtx=matrix(c(y[2:(100-1)],y[1:(100-2)]),nrow=2,byrow=TRUE) ## design matrix F
n=length(Y) ## T-p

## prior hyperparameters
m0=matrix(rep(0,p),ncol=1)
C0=10*diag(p)
n0=0.02
d0=0.02
a=rep(1,K)

#### sample functions


sample_omega=function(L.cur){
  n.vec=sapply(1:K, function(k){sum(L.cur==k)})
  rdirichlet(1,a+n.vec)
}

sample_L_one=function(beta.cur,omega.cur,nu.cur,y.cur,Fmtx.cur){
  prob_k=function(k){
    beta.use=beta.cur[((k-1)*p+1):(k*p)]
    omega.cur[k]*dnorm(y.cur,mean=sum(beta.use*Fmtx.cur),sd=sqrt(nu.cur))
  }
  prob.vec=sapply(1:K, prob_k)
  L.sample=sample(1:K,1,prob=prob.vec/sum(prob.vec))
  return(L.sample)
}

sample_L=function(y,x,beta.cur,omega.cur,nu.cur){
  L.new=sapply(1:n, function(j){sample_L_one(beta.cur,omega.cur,nu.cur,y.cur=y[j,],Fmtx.cur=x[,j])})
  return(L.new)
}

sample_nu=function(L.cur,beta.cur){
  n.star=n0+n
  err.y=function(idx){
    L.use=L.cur[idx]
    beta.use=beta.cur[((L.use-1)*p+1):(L.use*p)]
    err=Y[idx,]-sum(Fmtx[,idx]*beta.use)
    return(err^2)
  }
  d.star=d0+sum(sapply(1:n,err.y))
  1/rgamma(1,shape=n.star/2,rate=d.star/2)
}


sample_beta=function(k,L.cur,nu.cur){
  idx.select=(L.cur==k)
  n.k=sum(idx.select)
  if(n.k==0){
    m.k=m0
    C.k=C0
  }else{
    y.tilde.k=Y[idx.select,]
    Fmtx.tilde.k=Fmtx[,idx.select]
    e.k=y.tilde.k-t(Fmtx.tilde.k)%*%m0
    Q.k=t(Fmtx.tilde.k)%*%C0%*%Fmtx.tilde.k+diag(n.k)
    Q.k.inv=chol2inv(chol(Q.k))
    A.k=C0%*%Fmtx.tilde.k%*%Q.k.inv
    m.k=m0+A.k%*%e.k
    C.k=C0-A.k%*%Q.k%*%t(A.k)
  }
  
  rmvnorm(1,m.k,nu.cur*C.k)
}

#### MCMC setup

## number of iterations
nsim=10000

## store parameters

beta.mtx=matrix(0,nrow=p*K,ncol=nsim)
L.mtx=matrix(0,nrow=n,ncol=nsim)
omega.mtx=matrix(0,nrow=K,ncol=nsim)
nu.vec=rep(0,nsim)

## initial value

beta.cur=rep(0,p*K)
L.cur=rep(1,n)
omega.cur=rep(1/K,K)
nu.cur=1



## Gibbs Sampler

for (i in 1:nsim) {
  set.seed(i)
  
  ## sample omega
  omega.cur=sample_omega(L.cur)
  omega.mtx[,i]=omega.cur
  
  ## sample L
  L.cur=sample_L(Y,Fmtx,beta.cur,omega.cur,nu.cur)
  L.mtx[,i]=L.cur
  
  ## sample nu
  nu.cur=sample_nu(L.cur,beta.cur)
  nu.vec[i]=nu.cur
  
  ## sample beta
  beta.cur=as.vector(sapply(1:K, function(k){sample_beta(k,L.cur,nu.cur)}))
  beta.mtx[,i]=beta.cur
  
  ## show the numer of iterations 
  if(i%%1000==0){
    print(paste("Number of iterations:",i))
  }
  
}

#### show the result

sample.select.idx=seq(1001,10000,by=1)

post.pred.y.mix=function(idx){
  
  k.vec.use=L.mtx[,idx]
  beta.use=beta.mtx[,idx]
  nu.use=nu.vec[idx]
  
  
  get.mean=function(s){
    k.use=k.vec.use[s]
    sum(Fmtx[,s]*beta.use[((k.use-1)*p+1):(k.use*p)])
  }
  mu.y=sapply(1:n, get.mean)
  sapply(1:length(mu.y), function(k){rnorm(1,mu.y[k],sqrt(nu.use))})
  
}  

y.post.pred.sample=sapply(sample.select.idx, post.pred.y.mix)

summary.vec95=function(vec){
  c(unname(quantile(vec,0.025)),mean(vec),unname(quantile(vec,0.975)))
}

summary.y=apply(y.post.pred.sample,MARGIN=1,summary.vec95)

plot(Y,type='b',xlab='Time',ylab='',pch=16,ylim=c(-1.2,1.5))
lines(summary.y[2,],type='b',col='grey',lty=2,pch=4)
lines(summary.y[1,],type='l',col='purple',lty=3)
lines(summary.y[3,],type='l',col='purple',lty=3)
legend("topright",legend=c('Truth','Mean','95% C.I.'),lty=1:3,
       col=c('black','grey','purple'),horiz = T,pch=c(16,4,NA))
