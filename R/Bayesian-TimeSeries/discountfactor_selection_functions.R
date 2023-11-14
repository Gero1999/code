##################################################
##### using discount factor ##########
##################################################
## compute measures of forecasting accuracy
## MAD: mean absolute deviation
## MSE: mean square error
## MAPE: mean absolute percentage error
## Neg LL: Negative log-likelihood of disc,
##         based on the one step ahead forecast distribution
measure_forecast_accuracy <- function(et, yt, Qt=NA, nt=NA, type){
  if(type == "MAD"){
    measure <- mean(abs(et))
  }else if(type == "MSE"){
    measure <- mean(et^2)
  }else if(type == "MAPE"){
    measure <- mean(abs(et)/yt)
  }else if(type == "NLL"){
    measure <- log_likelihood_one_step_ahead(et, Qt, nt)
  }else{
    stop("Wrong type!")
  }
  return(measure)
}


## compute log likelihood of one step ahead forecast function
log_likelihood_one_step_ahead <- function(et, Qt, nt){
  ## et:the one-step-ahead error
  ## Qt: variance of one-step-ahead forecast function
  ## nt: degrees freedom of t distribution
  T <- length(et)
  aux=0
  for (t in 1:T){
    zt=et[t]/sqrt(Qt[t])
    aux=(dt(zt,df=nt[t],log=TRUE)-log(sqrt(Qt[t]))) + aux 
  } 
  return(-aux)
}

## Maximize log density of one-step-ahead forecast function to select discount factor
adaptive_dlm <- function(data, matrices, initial_states, df_range, type, 
                         forecast=TRUE){
  measure_best <- NA
  measure <- numeric(length(df_range))
  valid_data <- data$valid_data
  df_opt <- NA
  j <- 0
  ## find the optimal discount factor
  for(i in df_range){
    j <- j + 1
    results_tmp <- forward_filter_unknown_v(data, matrices, initial_states, i)
    
    measure[j] <- measure_forecast_accuracy(et=results_tmp$et, yt=data$yt,
                                            Qt=results_tmp$Qt, 
                                            nt=c(initial_states$n0,results_tmp$nt), type=type)
    
    
    if(j == 1){
      measure_best <- measure[j]
      results_filtered <- results_tmp
      df_opt <- i
    }else if(measure[j] < measure_best){
      measure_best <- measure[j]
      results_filtered <- results_tmp
      df_opt <- i
    }
  }
  results_smoothed <- backward_smoothing_unknown_v(data, matrices, results_filtered, delta = df_opt)
  if(forecast){
    results_forecast <- forecast_function(results_filtered, length(valid_data), 
                                          matrices, df_opt)
    return(list(results_filtered=results_filtered, 
                results_smoothed=results_smoothed, 
                results_forecast=results_forecast, 
                df_opt = df_opt, measure=measure))
  }else{
    return(list(results_filtered=results_filtered, 
                results_smoothed=results_smoothed, 
                df_opt = df_opt, measure=measure))
  }
  
}