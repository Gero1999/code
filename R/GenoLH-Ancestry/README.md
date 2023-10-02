<div id="top"></div>
<!--



-->

<!-- PROJECT LOGO -->
<br />
<div align="center">
  <a href="https://github.com/Gero1999/code/new/main/R/GenoLH-Ancestry">
    <img src="icon.png" alt="Logo" width="80" height="80">
  </a>

  <h3 align="center">Ancestry likelihood estimation based on NGSadmix data</h3>

  <p align="center">
    Identify the most common allele frequence and guess the base!
    <br />
    <br />
    <br />
    <a href="https://github.com/Gero1999/code/tree/main/R/GenoLH-Ancestry">View Demo</a>
    ·
  </p>
</div>



<!-- ABOUT THE PROJECT -->
## Aims of the project


The purpose of this project is to be capable of automatizing pipeline processes in order to:

* Ancestry Estimation over NGS-Admix data
* Likelihood Ratio Testing (LRT) to identify individuals with significant chinese ancestry
* Uncover genetic heritage of the African American population studied 

<p align="right">(<a href="#top">back to top</a>)</p>

# Ancestry Estimation and Chinese Ancestry Analysis

## Table of Contents

1. [Introduction](#introduction)
2. [Data Overview](#data-overview)
3. [Likelihood Model](#likelihood-model)
4. [Estimation Method](#estimation-method)
5. [Results and Interpretation](#results-and-interpretation)
6. [Conclusion](#conclusion)

## Introduction

The **Ancestry Estimation and Chinese Ancestry Analysis** project aims to investigate the ancestral proportions within a group of individuals, specifically African Americans. By employing a likelihood model and statistical estimation techniques, this project seeks to identify the extent of Chinese ancestry within this population. Understanding the ancestral makeup of African Americans can provide valuable insights into their genetic heritage and historical migrations.

## Data Overview

The project utilizes genetic data obtained from a group of African American individuals. The dataset includes genotype likelihoods for each individual at various genetic loci. Additionally, estimates of ancestral allele frequencies and admixture proportions were obtained through the NGSadmix analysis tool, which assumed the presence of three ancestral populations: European, African, and Asian.

## Likelihood Model

The likelihood model employed in this project is designed to assess the likelihood of observed genetic data under different hypotheses about the number of ancestral populations contributing to the genetic makeup of African American individuals. Two main hypotheses are considered:

1. **Null Hypothesis (H0):** This hypothesis assumes that African Americans have European and African ancestry only, with no significant Chinese ancestry.

2. **Alternative Hypothesis (H1):** The alternative hypothesis considers the possibility of additional Chinese ancestry in African Americans, in addition to European and African ancestry.

The likelihood model takes into account the genotype likelihoods for each individual at specific genetic loci and uses estimated ancestral allele frequencies and admixture proportions to compute the likelihood of the observed genetic data under each hypothesis.

## Estimation Method

To estimate the ancestral proportions and test the hypotheses, the following steps are undertaken:

### 1. Identify Ancestral Populations

The ancestral populations considered in the analysis include:
- **ASW**: HapMap African ancestry individuals from SW US
- **CEU**: European individuals
- **CHB**: Han Chinese in Beijing
- **YRI**: Yoruba individuals from Nigeria

Three ancestries are considered: European, African, and Asian, with some populations associated with each.

### 2. Likelihood Calculation

- Genotype likelihoods are estimated for each individual at each genetic locus, taking into account the estimated ancestral allele frequencies and admixture proportions.
- The likelihood of the observed data under both the null and alternative hypotheses is computed for each individual.

### 3. Likelihood Ratio Test

A likelihood ratio test (LRT) is performed to assess whether there is a significant amount of Chinese ancestry in African Americans. The LRT statistic is calculated as twice the difference in log likelihoods between the null and alternative models.

### 4. Interpretation of Results

Based on the LRT, p-values are calculated, and significance tests are conducted for each individual. Individuals with significant p-values are identified as having a potentially significant proportion of Chinese ancestry.

## Results and Interpretation

The project's results reveal the extent of Chinese ancestry within the African American population. Individuals with significant p-values from the likelihood ratio test are identified as having a noteworthy Chinese ancestral component, shedding light on the diverse genetic heritage of African Americans.

## Conclusion

This **Ancestry Estimation and Chinese Ancestry Analysis** project provides insights into the ancestral proportions of African Americans and uncovers the presence of Chinese ancestry within this population. By employing a likelihood model and rigorous statistical analysis, this research contributes to our understanding of the genetic diversity and historical migrations that have shaped the African American population.


### Built With R

* No package requirements



<p align="right">(<a href="#top">back to top</a>)</p>






