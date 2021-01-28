### Grey Image Reconstruction Using Principal Component Analysis
#### Author: Maja Garbulinska

This repository contains a simple example of image reconstruction using Principle Component Analysis (PCA). Principle Component Analysis is a technique used for both exploratory data analysis and dimentionality reduction. 

You can learn more in [this cool tutorial](https://www.datacamp.com/community/tutorials/pca-analysis-r) I found. 

Although R packages are available for PCA, my code in `ImageReconstruction.R` uses base R and linear algebra. Following the code of the `PCA()` function is a good way to understand what actually happens in a PCA algorithm. 

The function takes matrix and outputs the results of PCA in a list. You can use it as follows:
```R
MyPCA <- PCA(yourmatrix)
```
Now to access the results:
```R
MyPCA$F - access the transpose of the initial matrix
MyPCA$C - access the covariance matrix of F
MyPCA$eVal - access the eigen valus of C
MyPCA$eVec - access the eigen vectors of C
MyPCA$T - access the expantion coefficients
MYPCA$varFrac - access the vector of the fraction of variance explained by each PC
```
result <- list(F = F, C = C, eVal = eVal, eVec = eVec, T = T, varFrac = varFrac)


Futher part of the code requires the following libraries.

```R
library(imager) # to read the images and transform them to grayscale
library(ggplot2) # to graph the results. 
```
