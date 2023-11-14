## create list for matrices
set_up_dlm_matrices_unknown_v <- function(Ft, Gt, Wt_star){
  if(!is.array(Gt)){
    Stop("Gt and Ft should be array")
  }
  if(missing(Wt_star)){
    return(list(Ft=Ft, Gt=Gt))
  }else{
    return(list(Ft=Ft, Gt=Gt, Wt_star=Wt_star))
  }
}


## create list for initial states
set_up_initial_states_unknown_v <- function(m0, C0_star, n0, S0){
  return(list(m0=m0, C0_star=C0_star, n0=n0, S0=S0))
}

forward_filter_unknown_v <- function(data, matrices, 
                                     initial_states, delta){
  ## retrieve dataset
  yt <- data$yt
  T<- length(yt)
  
  ## retrieve matrices
  Ft <- matrices$Ft
  Gt <- matrices$Gt
  if(missing(delta)){
    Wt_star <- matrices$Wt_star
  }
  
  ## retrieve initial state
  m0 <- initial_states$m0
  C0_star <- initial_states$C0_star
  n0 <- initial_states$n0
  S0 <- initial_states$S0
  C0 <- S0*C0_star
  
  ## create placeholder for results
  d <- dim(Gt)[1]
  at <- matrix(0, nrow=T, ncol=d)
  Rt <- array(0, dim=c(d, d, T))
  ft <- numeric(T)
  Qt <- numeric(T)
  mt <- matrix(0, nrow=T, ncol=d)
  Ct <- array(0, dim=c(d, d, T))
  et <- numeric(T)
  nt <- numeric(T)
  St <- numeric(T)
  dt <- numeric(T)
  
  # moments of priors at t
  for(i in 1:T){
    if(i == 1){
      at[i, ] <- Gt[, , i] %*% m0
      Pt <- Gt[, , i] %*% C0 %*% t(Gt[, , i])
      Pt <- 0.5*Pt + 0.5*t(Pt)
      if(missing(delta)){
        Wt <- Wt_star[, , i]*S0
        Rt[, , i] <- Pt + Wt
        Rt[,,i] <- 0.5*Rt[,,i]+0.5*t(Rt[,,i])
      }else{
        Rt[, , i] <- Pt/delta
        Rt[,,i] <- 0.5*Rt[,,i]+0.5*t(Rt[,,i])
      }
      
    }else{
      at[i, ] <- Gt[, , i] %*% t(mt[i-1, , drop=FALSE])
      Pt <- Gt[, , i] %*% Ct[, , i-1] %*% t(Gt[, , i])
      if(missing(delta)){
        Wt <- Wt_star[, , i] * St[i-1]
        Rt[, , i] <- Pt + Wt
        Rt[,,i]=0.5*Rt[,,i]+0.5*t(Rt[,,i])
      }else{
        Rt[, , i] <- Pt/delta
        Rt[,,i] <- 0.5*Rt[,,i]+0.5*t(Rt[,,i])
      }
    }
    
    # moments of one-step forecast:
    ft[i] <- t(Ft[, , i]) %*% t(at[i, , drop=FALSE]) 
    Qt[i] <- t(Ft[, , i]) %*% Rt[, , i] %*% Ft[, , i] + 
      ifelse(i==1, S0, St[i-1])
    et[i] <- yt[i] - ft[i]
    
    nt[i] <- ifelse(i==1, n0, nt[i-1]) + 1
    St[i] <- ifelse(i==1, S0, 
                    St[i-1])*(1 + 1/nt[i]*(et[i]^2/Qt[i]-1))
    
    # moments of posterior at t:
    At <- Rt[, , i] %*% Ft[, , i] / Qt[i]
    
    mt[i, ] <- at[i, ] + t(At) * et[i]
    Ct[, , i] <- St[i]/ifelse(i==1, S0, 
                              St[i-1])*(Rt[, , i] - Qt[i] * At %*% t(At))
    Ct[,,i] <- 0.5*Ct[,,i]+0.5*t(Ct[,,i])
  }
  cat("Forward filtering is completed!\n")
  return(list(mt = mt, Ct = Ct,  at = at, Rt = Rt, 
              ft = ft, Qt = Qt,  et = et, 
              nt = nt, St = St))
}

### smoothing function ###
backward_smoothing_unknown_v <- function(data, matrices, 
                                         posterior_states,delta){
  ## retrieve data 
  yt <- data$yt
  T <- length(yt) 
  
  ## retrieve matrices
  Ft <- matrices$Ft
  Gt <- matrices$Gt
  
  ## retrieve matrices
  mt <- posterior_states$mt
  Ct <- posterior_states$Ct
  Rt <- posterior_states$Rt
  nt <- posterior_states$nt
  St <- posterior_states$St
  at <- posterior_states$at
  
  ## create placeholder for posterior moments 
  mnt <- matrix(NA, nrow = dim(mt)[1], ncol = dim(mt)[2])
  Cnt <- array(NA, dim = dim(Ct))
  fnt <- numeric(T)
  Qnt <- numeric(T)
  
  for(i in T:1){
    if(i == T){
      mnt[i, ] <- mt[i, ]
      Cnt[, , i] <- Ct[, , i]
    }else{
      if(missing(delta)){
        inv_Rtp1 <- chol2inv(chol(Rt[, , i+1]))
        Bt <- Ct[, , i] %*% t(Gt[, , i+1]) %*% inv_Rtp1
        mnt[i, ] <- mt[i, ] + Bt %*% (mnt[i+1, ] - at[i+1, ])
        Cnt[, , i] <- Ct[, , i] + Bt %*% (Cnt[, , i+1] - 
                                            Rt[, , i+1]) %*% t(Bt)
        Cnt[,,i] <- 0.5*Cnt[,,i]+0.5*t(Cnt[,,i])
      }else{
        inv_Gt <- solve(Gt[, , i+1])
        mnt[i, ] <- (1-delta)*mt[i, ] + 
          delta*inv_Gt %*% t(mnt[i+1, ,drop=FALSE])
        Cnt[, , i] <- (1-delta)*Ct[, , i] + 
          delta^2*inv_Gt %*% Cnt[, , i + 1]  %*% t(inv_Gt)
        Cnt[,,i] <- 0.5*Cnt[,,i]+0.5*t(Cnt[,,i])
      }
    }
    fnt[i] <- t(Ft[, , i]) %*% t(mnt[i, , drop=FALSE])
    Qnt[i] <- t(Ft[, , i]) %*% t(Cnt[, , i]) %*% Ft[, , i]
  }
  for(i in 1:T){
    Cnt[,,i]=St[T]*Cnt[,,i]/St[i] 
    Qnt[i]=St[T]*Qnt[i]/St[i]
  }
  cat("Backward smoothing is completed!\n")
  return(list(mnt = mnt, Cnt = Cnt, fnt=fnt, Qnt=Qnt))
}

## Forecast Distribution for k step
forecast_function_unknown_v <- function(posterior_states, k, 
                                        matrices, delta){
  
  ## retrieve matrices
  Ft <- matrices$Ft
  Gt <- matrices$Gt
  if(missing(delta)){
    Wt_star <- matrices$Wt_star
  }
  
  mt <- posterior_states$mt
  Ct <- posterior_states$Ct
  St <- posterior_states$St
  at <- posterior_states$at
  
  ## set up matrices
  T <- dim(mt)[1] # time points
  d <- dim(mt)[2] # dimension of state parameter vector
  
  ## placeholder for results
  at <- matrix(NA, nrow = k, ncol = d)
  Rt <- array(NA, dim=c(d, d, k))
  ft <- numeric(k)
  Qt <- numeric(k)
  
  for(i in 1:k){
    ## moments of state distribution
    if(i == 1){
      at[i, ] <- Gt[, , T+i] %*% t(mt[T, , drop=FALSE])
      
      if(missing(delta)){
        Rt[, , i] <- Gt[, , T+i] %*% Ct[, , T] %*% 
          t(Gt[, , T+i]) + St[T]*Wt_star[, , T+i]
      }else{
        Rt[, , i] <- Gt[, , T+i] %*% Ct[, , T] %*% 
          t(Gt[, , T+i])/delta
      }
      Rt[,,i] <- 0.5*Rt[,,i]+0.5*t(Rt[,,i])
      
    }else{
      at[i, ] <- Gt[, , T+i] %*% t(at[i-1, , drop=FALSE])
      if(missing(delta)){
        Rt[, , i] <- Gt[, , T+i] %*% Rt[, , i-1] %*% 
          t(Gt[, , T+i]) + St[T]*Wt_star[, , T + i]
      }else{
        Rt[, , i] <- Gt[, , T+i] %*% Rt[, , i-1] %*% 
          t(Gt[, , T+i])/delta
      }
      Rt[,,i] <- 0.5*Rt[,,i]+0.5*t(Rt[,,i])
    }
    
    
    ## moments of forecast distribution
    ft[i] <- t(Ft[, , T+i]) %*% t(at[i, , drop=FALSE])
    Qt[i] <- t(Ft[, , T+i]) %*% Rt[, , i] %*% Ft[, , T+i] + 
      St[T]
  }
  cat("Forecasting is completed!\n") # indicator of completion
  return(list(at=at, Rt=Rt, ft=ft, Qt=Qt))
}

## obtain 95% credible interval
get_credible_interval_unknown_v <- function(ft, Qt, nt, 
                                            quantile = c(0.025, 0.975)){
  bound <- matrix(0, nrow=length(ft), ncol=2)
  
  if ((length(nt)==1)){
    for (t in 1:length(ft)){
      t_quantile <- qt(quantile[1], df = nt)
      bound[t, 1] <- ft[t] + t_quantile*sqrt(as.numeric(Qt[t])) 
      
      # upper bound of 95% credible interval
      t_quantile <- qt(quantile[2], df = nt)
      bound[t, 2] <- ft[t] + 
        t_quantile*sqrt(as.numeric(Qt[t]))}
  }else{
    # lower bound of 95% credible interval
    for (t in 1:length(ft)){
      t_quantile <- qt(quantile[1], df = nt[t])
      bound[t, 1] <- ft[t] + 
        t_quantile*sqrt(as.numeric(Qt[t])) 
      
      # upper bound of 95% credible interval
      t_quantile <- qt(quantile[2], df = nt[t])
      bound[t, 2] <- ft[t] + 
        t_quantile*sqrt(as.numeric(Qt[t]))}
  }
  return(bound)
  
}

