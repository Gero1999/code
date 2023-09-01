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

## Implemented Algorithms

### 1. Logistic Regression

**Description:**
Logistic regression is a binary classification algorithm that models the probability of a sample belonging to a particular class. It's a fundamental building block for more complex algorithms and is widely used in various applications.

**Mathematics:**
Logistic regression involves the sigmoid function for modeling probabilities:

![Sigmoid Function](https://latex.codecogs.com/svg.image?%5Csigma%28z%29%20%3D%20%5Cfrac%7B1%7D%7B1%20&plus;%20e%5E%7B-z%7D%7D)

And the cost function (cross-entropy loss) for optimizing model parameters:

![Cross-Entropy Loss](https://latex.codecogs.com/svg.image?J%28%5Ctheta%29%20%3D%20-%5Cfrac%7B1%7D%7Bm%7D%5Csum_%7Bi%3D1%7D%5E%7Bm%7D%20%5By%5E%7B%28i%29%7D%20%5Clog%28h%28x%5E%7B%28i%29%7D%29%29%20&plus;%20%281%20-%20y%5E%7B%28i%29%7D%29%20%5Clog%281%20-%20h%28x%5E%7B%28i%29%7D%29%29%5D)

### 2. Neural Networks

**Description:**
Neural networks are a fundamental part of deep learning. Here, we implement a basic feedforward neural network, which consists of input, hidden, and output layers. This allows you to grasp the basics of neural network architecture.

**Mathematics:**
Neural networks involve concepts such as forward propagation:

![Forward Propagation](https://latex.codecogs.com/svg.image?z%5E%7B%28l%29%7D%20%3D%20%5Ctheta%5E%7B%28l-1%29%7D%20%5Ccdot%20a%5E%7B%28l-1%29%7D)

Activation functions (e.g., ReLU):

![ReLU Activation](https://latex.codecogs.com/svg.image?a%5E%7B%28l%29%7D%20%3D%20%5Ctext%7BReLU%7D%28z%5E%7B%28l%29%7D%29)

And backpropagation for training:

![Backpropagation](https://latex.codecogs.com/svg.image?%5Cdelta%5E%7B%28l%29%7D%20%3D%20%5Ctheta%5E%7B%28l%29%7D%20%5Ccdot%20%5Cdelta%5E%7B%28l&plus;1%29%7D%20%5Codot%20f%27%28z%5E%7B%28l%29%7D%29)

### 3. Autoencoders

**Description:**
Autoencoders are a type of neural network used for unsupervised learning tasks like dimensionality reduction and feature extraction. Implementing autoencoders will give you insight into representation learning.

**Mathematics:**
Autoencoders involve encoding and decoding processes:

![Autoencoder Architecture](https://latex.codecogs.com/svg.image?%5Ctext%7BEncoder%7D%3A%20%5Cquad%20z%20%3D%20f%28x%29%2C%20%5Cquad%20%5Ctext%7BDecoder%7D%3A%20%5Cquad%20x%27%20%3D%20g%28z%29)

Along with loss functions like mean squared error (MSE) for reconstruction:

![MSE Loss](https://latex.codecogs.com/svg.image?J%20%3D%20%5Cfrac%7B1%7D%7Bm%7D%20%5Csum_%7Bi%3D1%7D%5E%7Bm%7D%20%5Cleft%5C%7C%20x%5E%7B%28i%29%7D%20-%20x%27%5E%7B%28i%29%7D%20%5Cright%5C%7C%5E2)




## Built With

* [Numpy]()
* [Collections]()


