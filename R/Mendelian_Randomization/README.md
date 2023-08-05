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
  <a href="https://www.google.com/url?sa=i&url=https%3A%2F%2Fcommons.wikimedia.org%2Fwiki%2FFile%3ADirected_acylic_graph_for_Mendelian_randomization_Wikipedia_page.png&psig=AOvVaw2Od-Uu0nqUjijyS2WMScHC&ust=1691318740254000&source=images&cd=vfe&opi=89978449&ved=0CBMQjhxqFwoTCNip9MOrxYADFQAAAAAdAAAAABAE">
    <img src="mr_dag.png" alt="Logo" width="120" height="80">
  </a>

  <h3 align="center">Mendelian Randomization</h3>

  <p align="center">
    Discover cause/effect relations by using merely genetics!
    <br />
    <a href="https://github.com/Gero1999/code/new/main/R/Mendelian_Randomization"><strong>Explore the docs »</strong></a>
    <br />
    <br />
    <a href="https://github.com/Gero1999/code/new/main/R/Mendelian_Randomization">View Demo</a>
    ·
  </p>
</div>



<!-- ABOUT THE PROJECT -->
## About The Project


The purpose of this project is to be capable of automatizing pipeline processes in order to:

* Make a selection of SNPs to characterize a phenotype
* Perform multiple phenotype causal inferences
* Evaluate the weaknesses or broken assumptions with sensitivity plots and tests 

This powerful project explores the fascinating world of Mendelian Randomization, a methodology that leverages genetic instrumental variables to infer causal relationships between exposures and outcomes in observational data. MR serves as a crucial bridge between genetics and epidemiology, enabling researchers to shed light on complex biological pathways and uncover potential interventions for various diseases.

### What is Mendelian Randomization (MR)?

Mendelian Randomization is an innovative statistical technique that capitalizes on genetic variants, acting as instrumental variables, to assess the causal impact of an exposure (e.g., a biomarker) on an outcome (e.g., disease risk). The foundation of MR lies in the concept of natural randomization, where genetic variants are inherited randomly during meiosis, effectively mimicking a randomized controlled trial. This natural randomization enables researchers to overcome confounding and reverse causation, inherent challenges in traditional observational studies. The method makes to implicit assumptions; homogenity or monotonicity between the subjects and exchangeability between the tested groups. Another factor that is typically interesting to consider is the selection of a phenotype/cause that is highly genetic. 

### Understanding the analysis

This comprehensive MR Toolkit in R empowers you to conduct various essential analyses, including:

* __1. Inverse Variance Weighting (IVW)__. IVW is the cornerstone of MR analysis, estimating the causal effect by combining individual genetic variant-exposure and variant-outcome associations through a weighted regression. This approach assumes that all genetic variants satisfy the three fundamental MR assumptions: (i) genetic variants are strongly associated with the exposure, (ii) genetic variants do not influence the outcome through pathways unrelated to the exposure, and (iii) genetic variants affect the outcome only through the exposure.

* __2. Weighted Median (WM)__. The Weighted Median Method provides a robust alternative to IVW, even when a subset of genetic instruments violates the MR assumptions. It computes the causal effect as the median of individual variant-exposure effects, providing valid estimates as long as at least 50% of the genetic variants are valid instrumental variables.

* __3. Egger regression (ER)__. Egger Regression is designed to handle scenarios where the MR assumptions may be violated, specifically in the presence of pleiotropy (genetic variants affecting both exposure and outcome independently). This method incorporates a regression intercept term, allowing for asymmetry in the genetic variant-exposure associations. It is essential to note that Egger Regression requires a larger number of genetic variants to provide reliable estimates.


### Sensitivity Tests and Visualization

Ensuring the robustness of your MR analysis, the program incorporates essential sensitivity tests, such as Egger's Intercept and Q Cochran's statistic for homogeneity. These tests provide valuable insights into potential violations of MR assumptions, enabling you to identify potential sources of bias and interpret results more accurately.

Additionally, the code offers sensitivity plots, including scatter, leave-one-out or funnel plots. These help estimating the impact of influential genetic variants on causal estimates and supporting the interpretation and reliability of your MR analysis.


### Built With R

* [Biostrings]()
* [dplyr]()
* [ggplot2]()
* [tidyverse]()
* [pheatmap]()
* [ggrepel]()
* [devtools]()
* [genetics.binaRies]()
* [openxlsx]()
* [vroom]()


<p align="right">(<a href="#top">back to top</a>)</p>




<!-- USAGE EXAMPLES -->
## Still in develop!




