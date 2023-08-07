

<!-- PROJECT LOGO -->
<br />
<div align="center">
  <a href="https://github.com/Gero1999/code/new/main/Python/manipulation_FASTA">
    <img src="file_logo.png" alt="Logo" width="90" height="90">
  </a>

  <h3 align="center">FASTA files</h3>

  <p align="center">
    Make it work: FASTA & furious!
    <br />
    <br />
    <br />
    <a href="https://github.com/Gero1999/code/tree/main/Python/manipulation_FASTA">View Demo</a>
    ·
  </p>
</div>



<!-- ABOUT THE PROJECT -->

## About The Project

This is __the very first bioinformatics code I wrote__ involving bioinformatics when I started learning Python (by 2019). That is why I still keep it here as a nice remind of how much I evolved (and I still can). 
Overall, this collection of functions provides a simple yet effective way to read and manipulate FASTA files, allowing for easy retrieval of protein sequences and enabling searches based on regular expressions for more flexible data analysis. These functions are valuable tools for any bioinformatician or biologist working with protein sequences in the context of computational analysis and research.

The aim of this project is to download summary statistics from GWAS Catalog:

* __extract_fasta(path_to_fasta_file)__
This function processes a FASTA file, a widely-used format for storing biological sequences like DNA, RNA, and proteins. FASTA files consist of multiple entries, each beginning with a header line starting with ">," followed by the sequence data on subsequent lines. The extract_fasta function takes the file path of a FASTA file (path_to_fasta_file) and converts it into a dictionary, where each protein name serves as the key, and its corresponding sequence is the value.

* __find_protein(dicc, prot_name)__
The find_protein function searches for a specific protein name (prot_name) within the dictionary of protein sequences (dicc). If the protein name exists in the dictionary, the function returns the corresponding sequence. Otherwise, it prints an error message indicating that the protein name was not found.

* __guess_protein(dicc, reg_exp)__
guess_protein is a helpful utility to search for proteins in the dictionary (dicc) based on a regular expression (reg_exp). Regular expressions allow you to specify patterns to match specific protein names. The function returns a list of protein names that match the provided regular expression.


## What is a FASTA file?


A FASTA file is a plain-text format used to store biological sequences, such as DNA, RNA, or protein sequences. It is a widely adopted format in bioinformatics and genomics research due to its simplicity and compatibility across different platforms and software. In a FASTA file, each sequence is represented by a header line that starts with the symbol ">", followed by a unique identifier or name for the sequence. The sequence data itself is located on the lines immediately following the header. The sequence may span multiple lines, and there are no specific restrictions on line length. FASTA files are commonly used to store and exchange biological sequences, making them easy to share and analyze using various computational tools and programming languages.


### Built With Python

* None

<p align="right">(<a href="#top">back to top</a>)</p>

