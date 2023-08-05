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
  <a href="https://commons.wikimedia.org/wiki/File:Manhattan_Plot.png">
    <img src="manhattan_plot.png" alt="Logo" width="170" height="100">
  </a>

  <h3 align="center">post-GWAS analysis</h3>

  <p align="center">
    Compare and inspect the different GWAS phenotypes!
    <br />
    <a href="https://github.com/Gero1999/code/new/main/R/postGWAS"><strong>Explore the docs »</strong></a>
    <br />
    <br />
    ·
  </p>
</div>



<!-- ABOUT THE PROJECT -->
Welcome to the GWAS Summary Statistics Pipeline repository! This powerful pipeline allows you to perform essential operations on a set of Genome-Wide Association Study (GWAS) summary statistics. With this pipeline, you can gain deeper insights into your genetic data and discover potential biological implications.

* **QQ-plots and Histograms**. The pipeline generates QQ-plots and histograms to visualize the distribution of test p-values from your GWAS summary statistics. These plots help you assess the presence of significant associations and potential deviations from expected null distributions.

* **Manhattan Plots**. The pipeline creates Manhattan plots, labeling the top-significant Single Nucleotide Polymorphisms (SNPs) identified in your GWAS. These plots showcase genome-wide associations, highlighting genomic regions with strong associations.

* **Genomic Inflation Factor (GIF) Calculation**. The pipeline calculates the Genomic Inflation Factor (GIF) on a median basis. GIF is a measure used to assess the presence of systematic inflation in test statistics due to population stratification or other confounding factors. The GIF values are tested against a null-simulated distribution.

* **LDSC Analysis**. The pipeline employs [LDSC]((https://github.com/bulik/ldsc)) (LD Score Regression) to identify potential confounding phenomena in your GWAS data. LDSC is a Python-developed tool that estimates the average heritability in M SNPs (h2/M) and the confounding contribution (a) due to linkage disequilibrium inflation effect on the χ2 statistic. Pairwise genetic correlations (Rg) are performed using LDSC on common SNPs/variants of each comparison. The resulting correlations are visualized using hierarchical clustering with the "Pheatmap" R-package.

* **DEPICT Analysis**. Using [DEPICT]((https://github.com/perslab/depict)) (Data-driven Expression-Prioritized Integration for Complex Traits), the pipeline performs gene prioritization, pathway enrichment, and tissue enrichments based on your GWAS summary statistics. DEPICT uncovers potential biological mechanisms and tissue-specific associations associated with your genetic data.


### Built With R

* [snpStats]()
* [dplyr]()
* [fs]()
* [vroom]()
* [tidyverse]()
* [biomaRt]()
* [openxlsx]()
* [data.table]()
* [tidyr]()
* [pheatmap]()
* [ggrepel]()
* [VennDiagram]()


<p align="right">(<a href="#top">back to top</a>)</p>




<!-- USAGE EXAMPLES -->





