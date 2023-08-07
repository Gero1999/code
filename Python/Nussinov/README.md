<div id="top"></div>



<!-- PROJECT LOGO -->
<br />
<div align="center">
  <a href="https://github.com/othneildrew/Best-README-Template">
    <img src="RNAm.png" alt="Logo" width="140" height="80">
  </a>

  <h3 align="center">Nussinov Algorithm</h3>

  <p align="center">
    Unleash RNA's secret dance of bonds and folds
    <br />
    <a href="https://github.com/Gero1999/code/edit/main/Python/HMM_profile_analyser"><strong>Explore the docs »</strong></a>
    <br />
    <br />
  </p>
</div>




<!-- ABOUT THE PROJECT -->
## About The Project

The utility of this project remains in:
* Predict a RNA molecule folding
* Use dynamic programming to find an optimal solution
* Make a graphicacl representation of the result programatically (still in process)

<br/>


## How the algorithm works

The Nussinov algorithm is a dynamic programming method used to predict secondary structures in RNA molecules. It identifies stable base pairings by assigning scores for matching and non-matching pairs. By efficiently exploring all possible pairings, the algorithm finds the secondary structure with the maximum number of base pairs, which represents the most stable configuration.

The algorithm creates a matrix to store the maximum number of base pairs for each subsequence of the RNA molecule. It then fills in the matrix diagonally, starting with the shortest subsequences and gradually building up to the full RNA sequence. By comparing scores, the algorithm identifies the most stable secondary structure.

While the Nussinov algorithm provides valuable estimations of RNA secondary structures, it is a simplified model that may not capture all the complexities of RNA folding. As a foundational method in RNA secondary structure prediction, it has paved the way for more advanced algorithms and experimental techniques to further refine and validate predictions.

<br/>


### Built With

* [Pandas]()
* [RE]()
* [Numpy]()


<p align="right">(<a href="#top">back to top</a>)</p>



<!-- USAGE EXAMPLES -->
## Usage

In process

<p align="right">(<a href="#top">back to top</a>)</p>


<!-- ADDITIONALLY -->
## Contact
