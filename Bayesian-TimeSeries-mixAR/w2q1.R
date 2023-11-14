# QUIZ 1 WEEK 2


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

## simulate data
set.seed(1)
AR.model = list(order = c(2, 0, 0), ar = c(0.5,0.4))
#y.sample = arima.sim(n=100,model=AR.model,sd=0.1)


plot(y.sample,type='l',xlab='time',ylab='')






par(mfrow=c(1,2))
acf(y.sample,main="",xlab='Lag')
pacf(y.sample,main="",xlab='Lag')






n.all=length(y.sample)
p.star=15
Y=matrix(y.sample[(p.star+1):n.all],ncol=1)
sample.all=matrix(y.sample,ncol=1)
n=length(Y)
p=seq(1,p.star,by=1)


design.mtx=function(p_cur){
  Fmtx=matrix(0,ncol=n,nrow=p_cur)
  for (i in 1:p_cur) {
    start.y=p.star+1-i
    end.y=start.y+n-1
    Fmtx[i,]=sample.all[start.y:end.y,1]
  }
  return(Fmtx)
}




criteria.ar=function(p_cur){
  Fmtx=design.mtx(p_cur)
  beta.hat=chol2inv(chol(Fmtx%*%t(Fmtx)))%*%Fmtx%*%Y
  R=t(Y-t(Fmtx)%*%beta.hat)%*%(Y-t(Fmtx)%*%beta.hat)
  sp.square=R/(n-p_cur)
  aic=2*p_cur+n*log(sp.square)
  bic=log(n)*p_cur+n*log(sp.square)
  result=c(aic,bic)
  return(result)
}


criteria=sapply(p,criteria.ar)


plot(p,criteria[1,],type='p',pch='a',col='red',xlab='AR order p',ylab='Criterion',main='',
     ylim=c(min(criteria)-10,max(criteria)+10))
points(p,criteria[2,],pch='b',col='blue')











