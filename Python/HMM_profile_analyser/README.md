<div id="top"></div>



<!-- PROJECT LOGO -->
<br />
<div align="center">
  <a href="https://github.com/othneildrew/Best-README-Template">
    <img src="protein_1axc.png" alt="Logo" width="80" height="80">
  </a>

  <h3 align="center">HMM-profiler</h3>

  <p align="center">
    Read your proteins secrets
    <br />
    <a href="https://github.com/Gero1999/code/edit/main/Python/HMM_profile_analyser"><strong>Explore the docs »</strong></a>
    <br />
    <br />
  </p>
</div>




<!-- ABOUT THE PROJECT -->
## About The Project

The utility of this project remains in:
* Capturing the biological features and characteristics behind a protein family
* Using basic code to build simple HMM models
* Evaluate new potential proteins belonging to the identified family

The files you can find in this repository are:

1) **HMM_profiler.** Given a set of sequences (presumably from the same protein family) it constructs a HMM model of two matrices, one revealing state transitions (being the states: Deletion, Insertion, Match) or emissions (for the 20 aminoacids). <br/> <br/>
2) **HMM_decoder_and_evaluator.** Given a HMM profile involving two matrices (state transition and residue emission) the function can generate the most probable sequence, or alternatively given one sequence calculate its probability to be part of the considered family.

<br/>


## What is a HMM-profile?


A Hidden Markov Model (HMM) profile for protein sequences is a probabilistic model used in bioinformatics to represent conserved patterns and domains within a protein family. It is a type of sequence profile that captures both the positional information and the variability of amino acids at different positions in the protein sequence.The HMM profile is based on the concept of a "hidden" state, which represents the unknown functional region or domain of the protein. The model contains two main components:

* Emission Probabilities. These probabilities describe the likelihood of observing a particular amino acid at each position in the protein sequence. They are derived from a multiple sequence alignment of homologous proteins belonging to the same family. The alignment identifies conserved residues and patterns that are characteristic of the protein family.

* Transition Probabilities. These probabilities govern the likelihood of transitioning from one state to another along the protein sequence. The transitions correspond to moving from one position to the next within the conserved domain.

HMM profiles are widely used in various bioinformatics applications, including protein domain annotation, functional prediction, and sequence database searching. When applied to search a protein database, the HMM profile can efficiently identify homologous sequences and classify them into the respective protein family based on the similarity to the conserved domain. The power of HMM profiles lies in their ability to capture both local and global sequence information, making them highly effective in identifying remote homologs that may share low sequence similarity but have conserved functional regions. They provide a more sensitive and accurate method for protein sequence analysis compared to traditional sequence similarity searches based on fixed sequence motifs or pairwise alignments.


### Built With

* [Pandas]()
* [Numpy]()
* [Collections]()


<p align="right">(<a href="#top">back to top</a>)</p>



<!-- USAGE EXAMPLES -->
## Usage

You can actually see a practical example with short TAF sequences in the next [streamlit app](https://gero1999-code-streamlitprot-profiler-appapp-uorzny.streamlitapp.com/)

<p align="right">(<a href="#top">back to top</a>)</p>


<!-- ADDITIONALLY -->
## Contact

The protein represented in the entrance of the document is the human PCNA (1AXC), you can read more about it or obtain the image in [Wikipedia](https://da.wikipedia.org/wiki/Fil:1axc_tricolor.png)


<p align="right">(<a href="#top">back to top</a>)</p>


