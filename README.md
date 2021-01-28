### Grey Image Reconstruction Using Principal Component Analysis
#### Author: Maja Garbulinska

This repository contains a simple example of image reconstruction using Principle Component Analysis (PCA). Principle Component Analysis is a technique used for both exploratory data analysis and dimentionality reduction. 

You can learn more in [this cool tutorial](https://www.datacamp.com/community/tutorials/pca-analysis-r) I found. 


Here is an example of a cat image reconstruction done using the `ImageReconstruction.R` script you can find in this repository: 

![A Reconstructed Cat](reconstructedCat.png?raw=true "A Reconstructed Cat")

*Please note: This script outputs grayscale images, but you can input either a grayscale image or an color image.*

*Please note: The script might take some time especially for bigger images. I decided not to make the computations parallel to keep the code simple.*

##### The example code
Here is some example code that is also contained in the `ImageReconstruction.R` script. You will need the `imager` and the `ggplot2` packages. This is what I used to create the cute reconstructed cat graph above. 

```R
library(imager)
library(ggplot2)

exampleDF <- createReconDF("cat.jpg", 
                           PCs = c(2, 4, 6, 8, 10, 12, 20, 30, 50, 100, 200), 
                           includeOriginal = TRUE)


reconstructedCat <- ggplot(exampleDF, aes(x,y))+
  geom_raster(aes(fill = value))+ 
  # remove blank spaces around the images
  scale_x_continuous(expand = c(0, 0))+
  scale_y_continuous(expand = c(0, 0),
                     trans = scales::reverse_trans())+
  # change colour to black and white
  scale_fill_gradient(low = "black", high = "white")+
  # facet by the number of PCs
  facet_wrap(.~k)+
  theme(legend.position = "None",
        # remove x label
        axis.title.x = element_blank(), 
        # remove y label
        axis.title.y = element_blank())+
  # fix ratio of x and y scales
  coord_fixed(ratio = 1)

ggsave("reconstructedCat.png", plot = reconstructedCat)
```
#### The functions in more detail
Whereas it is possible to just use the example code and reconstruct your own images, I have also explained the functions found in the script in more detail. 

##### The `PCA()` function
Although R packages are available for PCA, my code in `ImageReconstruction.R` uses base R and linear algebra. Following the code of the `PCA()` function is a good way to understand what actually happens in a PCA algorithm. 

The function takes matrix and outputs the results of PCA in a list. You can use it as follows:
```R
MyPCA <- PCA(yourmatrix)
```
To access the results:
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

##### The `reconstructionPCA()` function
This function uses the previously described `PCA()` function to extract the information necessary to perform data reconstruction. You have to provide this function with the image in a matrix format and number of principle components used to reconstruct the image. 

```R
MyReconstruction <- PCA(yourmatrix, k = 3)
```

##### The `reconstructImageToDataFrame()` function
This function takes `cimg` object (check the `imager` package) and outputs the image as a dataframe. The returned dataframe contains a `k` column that indicates how many principle components were used for reconstruction. 

```R
MyReconstructedDF <- reconstructImageToDataFrame(cimgImage, k = 3)
```

##### The `createReconDF()` function
This function takes the path to an image, reconstructs it using the given number of principle components and outputs a dataframe ready for ploting using the `ggplot2`.

