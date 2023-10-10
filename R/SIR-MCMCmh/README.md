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
  <a href="https://commons.wikimedia.org/wiki/File:LD_plot_of_SNPs_with_top-ranked_BFs_in_CHB_of_1000_Genome_Phase_I..png">
    <img src="LD_plot.png" alt="Logo" width="150" height="100">
  </a>

  <h3 align="center">LD proxy algorithm</h3>

  <p align="center">
    If one variant is not present takes the closest alternative!
    <br />
    <a href="https://github.com/Gero1999/code/new/main/R/LD_proxy"><strong>Explore the docs »</strong></a>
    <br />
    <br />
    ·
  </p>
</div>



<!-- ABOUT THE PROJECT -->
## About The Project

This project introduces a powerful algorithm that leverages PLINK reference data and the snpStats package to identify the closest variant to a given genetic marker. LD-Proxy is a crucial tool in genetic association studies, enabling researchers to efficiently select proxy variants that capture the same genetic signal as the target variant.

## What is LD-Proxy?

LD-Proxy, short for Linkage Disequilibrium Proxy, is a method used to estimate the genetic correlation between two variants based on their linkage disequilibrium (LD) patterns. In genetics, LD refers to the non-random association of alleles at different loci due to genetic linkage. By identifying proxy variants in high LD with the target variant, researchers can perform association analyses more efficiently, as proxy variants are often more readily available or less expensive to genotype.

## Understanding the Algorithm

This comprehensive LD-Proxy Algorithm in R leverages PLINK reference data and the snpStats package to execute the following steps:

1. **Data Preprocessing**: The algorithm takes as input the target genetic marker and a set of variants to consider as proxies. It preprocesses the PLINK reference data and performs data manipulation tasks to prepare the data for analysis.

2. **LD Calculation**: Using the snpStats package, LD-Proxy calculates the pairwise linkage disequilibrium (LD) between the target variant and each potential proxy variant. This step ensures that only variants in high LD with the target are selected as proxies.

3. **Proxy Variant Selection**: The algorithm identifies the variant with the highest LD value as the closest proxy variant to the target. This proxy variant is then recommended for downstream genetic association analyses.

## Getting Started

To use the LD-Proxy Algorithm, you'll need to have R installed on your system. Additionally, ensure that the snpStats package is installed to handle the LD calculations.


### Built With R

* [snpStats]()
* [dplyr]()
* [tidyverse]()
* [genetics.binaRies]()
* [vroom]()


<p align="right">(<a href="#top">back to top</a>)</p>




<!-- USAGE EXAMPLES -->
