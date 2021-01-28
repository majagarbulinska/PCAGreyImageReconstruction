### Grey Image Reconstruction Using Principal Component Analysis
#### Author: Maja Garbulinska

This repository contains a simple example of image reconstruction using Principle Component Analysis (PCA). Principle Component Analysis is a technique used for both exploratory data analysis and dimentionality reduction. 

You can learn more in [this cool tutorial](https://www.datacamp.com/community/tutorials/pca-analysis-r) I found. 

##### `ImageReconstruction.R`
Although R packages are available for PCA, my code in `ImageReconstruction.R` uses base R and linear algebra. Following the code of the `PCA()` function is a good way to understand what actually happens in a PCA algorithm. 

The function takes matrix and outputs the results of PCA in a list. You can use it as follows:
```R
MyPCA <- PCA(yourmatrix)
```
Now to access the results:
```R
# access F - the transpose of the initial data matrix:
MyPCA$F
# access C - the covariance matrix of F:
MyPCA$C 
# access the eigen valus of C:
MyPCA$eVal
# access the eigen vectors of C:
MyPCA$eVec
# access the expantion coefficients:
MyPCA$T
# access the vector of the fraction of variance explained by each PC:
MYPCA$varFrac
```




Futher part of the code requires the following libraries.

```R
library(imager) # to read the images and transform them to grayscale
library(ggplot2) # to graph the results. 
```
