# Projects Resume

Welcome to my code repository! Here, you'll find a collection of projects and learning materials I've developed


---

### Python 🐍
##### Sequence Analysis

* [HMM profiler](Python/HMM_profile_analyser). There are two parts. The profiler, which deduces the state-transition and emission matrices. And the decoder, which guess the most probable sequence. 
* [Nussinov algorithm](Python/Nussinov). Based on a RNA sequence, it predicts the folding and structure of the molecule based on merely dynamic programming.
* [FASTA extractor](Python/manipulation_FASTA). A very simple code to extract, organize and posteriously search information from a FASTA file.

##### Streamlit Apps
* [Clone trigger](streamlit/clone_trigger). Given a DNA reference sequence and a DNA intended to be clone it suggests top 20 list of forward and reverse primers that can be used as well as the restriction enzymes. 
* [Prot-Profiler](streamlit/prot-profiler-app). Based on a set of protein sequences it produces a HMM-profile
* [Resume](streamlit/resume). My professional portfolio detailing my experience, availability and different contributions

##### Machine Learning
* [DCGAN digit-image generator](Python/DCGAN_digits-generator). Implementation of a Deep Convolutional Generative Adversarial Network (DCGAN) in PyTorch to generate realistic handwritten digit images using the MNIST dataset
* [Text generator (Pharmaceutical names)](Python/Names_generator). Process a variable length input and completes it with characters to create a potential pharmaceutical product name
* [ML algorithms from scratch](Python/ML_implementations). Just for learning I implement different machine learning algorithms (LR, NN, PCA...) without using specific packages for them
---

### R-programming 🇷
##### Genomics
* [postGWAS comparison](R/postGWAS) Cleaning and standarization of multiple summary statistics as well as a genetic correlation and pathway analysis contrast (In Progress)
* [GWAS-Catalog download](R/GWAS-Catalog-Download). Download, cleaning and standarization of multiple GWAS-Catalog summary statistics based on a search pattern and a LD reference panel.
* [EM-Algorithm for allele frequency estimation](R/EM-HAF). Estimation of the allele frequencies in a haploid organism's genome using an EM algorithm based on genotype likelihoods.
* [Ancestry Estimation using Genotype Likelihoods](R/GenoLH-Ancestry). This project focuses on estimating the ancestral populations in African American individuals using a likelihood model based on genotype likelihoods and estimated ancestral allele frequencies from NGSadmix analysis.
* [Mendelian Randomization](R/Mendelian_Randomization) Automatized causal analyses of pairwise phenotype comparisons based on summary statistics performing IVW, Egger and Weighted Median. Includes quality plots.

##### Transcriptomics
* [DEA (Differential Expression Analysis)](R/DEA). Automatized search, cleaning, quality control and analysis of BioStudies reports of a topic (In Progress)
* [LD-proxy algorithm](R/LD-proxy). Based on a PLINK reference panel and a list of reference alleles, it identifies potential substitutes of these for each summary statistics integrated.

##### Proteomics
* [Protein Variant Analysis](R/Protein-Variant-Analysis). Analysis and study figures that can be performed over a set of translated DNA coding sequences. 

##### Shiny Apps
* [Texas Cheater](shinyR/texas-cheater) A Texas Poker simulator capable to predict your probabilities to win a game based on your game circumstances.
* [Pairwise Alignment](shinyR/pairwise_alignment). Assess the alignemnt of two sequences thorugh dinamyc programming (Watermann algorithm).

---

### Bash 💻
##### Omics
* [Pairwise genetic correlations](bash/pairwise_GC). Using AWK language performs the genetic correlation via [LDSC](https://github.com/bulik/ldsc) program and builds a matrix object 
