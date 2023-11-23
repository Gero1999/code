<div id="top"></div>




<!-- PROJECT LOGO -->
<br />
<div align="center">
  <a href="https://github.com/Gero1999/code/new/main/R/BayesianPoisson-DrVisits">
    <img src="icon.png" alt="Logo" width="100" height="80">
  </a>

  <h3 align="center">Poisson model created with rJags</h3>

  <p align="center">
    And predict the number of times a person attends the doctor!
    <br />
    <a href=""><strong>Explore the docs »</strong></a>
    <br />
    <br />
    ·
  </p>
</div>



<!-- ABOUT THE PROJECT -->
## Aims of the Project


The purpose of this project is to run a Bayesian model:

* In specific a Poisson regression with counting data
* Use rjags software for model definition
* Predict health visits of a person based on age and health condition




## Key Characteristics of the Poisson Distribution

The Poisson distribution is characterized by the following parameters and properties:

### 1. Parameter: λ (Lambda)

The Poisson distribution has a single parameter, denoted as λ (lambda), which represents the average rate at which events occur within a fixed interval. λ is a positive real number.

### 2. Probability Mass Function (PMF)

The probability mass function of the Poisson distribution is given by:

\[
P(X = k) = \frac{e^{-\lambda} \lambda^k}{k!}
\]

Where:
- \(P(X = k)\) is the probability of observing \(k\) events.
- \(e\) is the base of the natural logarithm (approximately 2.71828).
- \(\lambda\) is the average event rate.
- \(k\) is the number of events (count) you want to model.
- \(k!\) is the factorial of \(k\).

### 3. Events Are Independent

The Poisson distribution assumes that events occur independently within the fixed interval. This means that the occurrence of one event does not affect the occurrence of another event.

### 4. Mean and Variance

The mean and variance of the Poisson distribution are both equal to λ:

\[
\text{Mean} = \text{Variance} = \lambda
\]

## Applications in Bayesian Simulation Modeling

In Bayesian simulation modeling, the Poisson distribution is applied in various scenarios, including:

### 1. Count Data Modeling

Poisson distributions are used to model count data, such as the number of customer arrivals at a store, the number of emails received in an hour, or the number of defects in a manufacturing process.

### 2. Rare Event Modeling

When events are rare, such as equipment failures, accidents, or disease outbreaks, the Poisson distribution is often used to model these occurrences.

### 3. Bayesian Inference

Bayesian statisticians use the Poisson distribution as a likelihood function within a Bayesian framework. It helps in estimating the posterior distribution of the parameter λ, incorporating prior information and updating beliefs with observed data.

### 4. Spatial and Temporal Analysis

In spatial statistics, the Poisson distribution is employed for modeling the spatial distribution of events. In temporal analysis, it can model events occurring over time.

## Bayesian Simulation with Poisson Distribution

When conducting Bayesian simulation with the Poisson distribution, the key steps involve specifying prior distributions for λ, collecting data on event counts, and updating the posterior distribution through Bayesian inference techniques, such as Markov chain Monte Carlo (MCMC) methods.

In summary, the Poisson distribution is a valuable tool in Bayesian simulation modeling for analyzing and modeling count data and rare events. Its simplicity and applicability make it a fundamental component of Bayesian statistics, especially when modeling events occurring over time or space.


### Built With R

* [rjags]()
* [COUNT]()
* [tidyverse]()



<p align="right">(<a href="#top">back to top</a>)</p>






