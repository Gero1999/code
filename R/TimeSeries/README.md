<div id="top"></div>




<!-- PROJECT LOGO -->
<br />
<div align="center">
  <a href="https://github.com/Gero1999/code/new/main/R/BayesianPoisson-DrVisits">
    <img src="icon.png" alt="Logo" width="100" height="80">
  </a>

  <h3 align="center">Time series in R</h3>

  <p align="center">
     Practice with different models and with diagnostics plots!
    <br />
    <a href=""><strong>Explore the docs »</strong></a>
    <br />
    <br />
    ·
  </p>
</div>



<!-- ABOUT THE PROJECT -->
**Still in progress!**

## Aims of the Project


The purpose of this project is to fit different models to time series data to:

* Understand the seasonality and trending patterns in the search of the term "cough"
* Determine which model among the selected is the best for the time series data
* Develop explanations and reasonings for the time series data analysis


## Key Characteristics of time-series models
### AR (Autoregressive) Model:

The Autoregressive (AR) model is a type of time series model where the value of the variable at a given time point is linearly dependent on its past values. Mathematically, an AR(p) model is represented as:

\[ Y_t = c + \phi_1 Y_{t-1} + \phi_2 Y_{t-2} + \ldots + \phi_p Y_{t-p} + \varepsilon_t \]

Here, \(Y_t\) is the variable of interest at time \(t\), \(c\) is a constant, \(\phi_i\) are the autoregressive coefficients, and \(\varepsilon_t\) is white noise.

### NDLM (Nonlinear Dynamic Linear Model):

The Nonlinear Dynamic Linear Model (NDLM) is a flexible time series model that allows for nonlinear relationships between variables. It extends the Linear Dynamical System to incorporate nonlinearity. The model is often represented using state-space equations:

\[ \text{Observation equation: } Y_t = F(X_t, \theta) + \varepsilon_t \]
\[ \text{State equation: } X_{t+1} = G(X_t, \theta) + \eta_t \]

Here, \(Y_t\) is the observed data, \(X_t\) is the unobservable state, \(F\) and \(G\) are nonlinear functions, \(\theta\) represents parameters, and \(\varepsilon_t\) and \(\eta_t\) are error terms.

### Mixture AR (Autoregressive) Model:

The Mixture Autoregressive (AR) Model combines multiple AR models with different parameters. It assumes that the time series is a mixture of several autoregressive processes. Each component AR process is weighted by a probability, and the overall model can be expressed as:

\[ Y_t = \sum_{i=1}^{k} \pi_i \cdot AR_i + \varepsilon_t \]

Here, \(AR_i\) represents the \(i\)-th AR process, \(\pi_i\) is the probability of selecting the \(i\)-th process, and \(\varepsilon_t\) is white noise.

These models offer different approaches to capturing temporal dependencies and nonlinearity in time series data, providing flexibility for various modeling scenarios.

### Built With R

* [gtrendsR]()
* [dlm]()
* [mixAR]()


<p align="right">(<a href="#top">back to top</a>)</p>






