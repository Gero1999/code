<div id="top"></div>
<!--



-->
[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]
[![LinkedIn][linkedin-shield]][linkedin-url]



<!-- PROJECT LOGO -->
<br />
<div align="center">
  <a href="https://github.com/Gero1999/code/new/main/R/EM-HAF">
    <img src="icon.png" alt="Logo" width="80" height="80">
  </a>

  <h3 align="center">Haploid Allele Frequency Estimate with EM algorithm</h3>

  <p align="center">
    Identify the most common allele frequence and guess the base!
    <br />
    <br />
    <br />
    <a href="https://github.com/Gero1999/code/tree/main/R/EM-HAF">View Demo</a>
    ·
  </p>
</div>



<!-- ABOUT THE PROJECT -->
## Aims of the project


The purpose of this project is to be capable of automatizing pipeline processes in order to:

* Understand the GATK proposal for base calling
* Deploy the EM algorithm over a practical bioinformatics case
* Infer the alelle frequency in an haploid organism

<p align="right">(<a href="#top">back to top</a>)</p>


## Likelihood model 

The likelihood model used in this project is based on the genotype likelihoods calculated using the Genome Analysis ToolKit (GATK). For a specific genotype (denoted as Z = z), the probability of observing data X for an individual at a particular genomic site is proportional to the product of the probability of a read-base (𝑏𝑑) given the genotype. This probability calculation is performed for all reads, and the product of these probabilities extends to the depth of coverage (D) for that site.

To compute the probability of a read-base (given the genotype), the error probability of the read (denoted as 𝜖𝑑) is considered. If the observed base matches the assumed genotype (z), the error's complement (1 - 𝜖𝑑) is used. If there is a mismatch, the error is divided by three (𝜖𝑑/3) since we are studying haploid organisms.


## EM Algorithm

The Expectation-Maximization (EM) algorithm is employed to estimate allele frequencies in this project. The algorithm iteratively refines these estimates through two key steps:

Expectation Step: For each individual, the algorithm calculates the expected genotype likelihood for a site, denoted as $Q_i(Z_j)$. This calculation uses the current allele frequency estimates ($f^{(n)}$). The probability $Q_i(Z_j)$ represents the likelihood that a particular genotype Z is present at site j given the observed data from individual i. It takes into account the observed read data and the allele frequencies.

Maximization Step: In this step, the algorithm updates the allele frequency estimates ($f_j^{n+1}$) using the expectations calculated in the previous step. It considers all individuals for each site and incorporates the expected genotype likelihoods.

These iterations continue until the estimates converge or a predefined number of iterations is reached. The EM algorithm enables us to obtain accurate estimates of allele frequencies for each genomic site in haploid organisms.

These two components, the likelihood model and the EM algorithm, form the core of the project, allowing us to infer allele frequencies effectively.



<p align="right">(<a href="#top">back to top</a>)</p>


### Built With R

* No package requirements



<p align="right">(<a href="#top">back to top</a>)</p>




<!-- USAGE EXAMPLES -->
## Still in develop!




