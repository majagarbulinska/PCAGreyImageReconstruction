# Author: Maja Garbulinska

library(imager)
library(ggplot2)

PCA <- function(matrix){
  
  # standardize the input matrix and call it F
  F <- t(matrix)
  
  # Compute the covariance matrix of F
  C <- F%*%t(F)
  
  # Compute the eigenvectors and eigenvalus of the covariance matrix
  eVal <- eigen(C)$values
  eVec <- eigen(C)$vectors
  
  #expansion coefficients
  T = t(eVec) %*% F
  
  # compute the fraction of variance in the data explained by each of the PCs
  varFrac = eVal/sum(eVal)
  #message("Message: Fraction of Explained Variance by each PC:", paste(varFrac,collapse=", "))
  
  # return the results as a list
  result <- list(F = F, C = C, eVal = eVal, eVec = eVec, T = T, varFrac = varFrac)
  return(result)
}

reconstructionPCA <- function(data, k){
  # get the PCA results
  resultPCA <- PCA(data)
  eVec <- resultPCA$eVec
  T <- resultPCA$T
  
  # reconstruct the data
  if (k>1){
    recons <- eVec[, 1:k] %*% T[1:k,]
  }
  else { 
    # if k == 1, we have that T[1:k,] is a vector. 
    # We need to transpose it to correctly multiply.
    recons <- eVec[,1:k]  %*% t(T[1:k, ])
  }
  return(t(recons))
}

reconstructImageToDataFrame <- function(image, k){
  reconstruction <- reconstructionPCA(data = image[,,,1], k)
  data <- as.data.frame(imager::as.cimg(reconstruction))
  data$k <- k
  return(data)
}

createReconDF <- function(imagePath, PCs, includeOriginal = TRUE){
  # load the image
  image <- imager::load.image(imagePath)
  # if 3 channels make it grey
  if (dim(image)[4] == 3) {
    image <- imager::grayscale(image)
  }
  
  # apply PCA reconstructions
  reconstructionsDF <- lapply(PCs, FUN = reconstructImageToDataFrame, image = image)
  reconstructionsDF <- do.call('rbind', reconstructionsDF)
  
  # create levels for the k variable (necessary for nice plotting):
  reconstructedLevels <- paste(as.character(PCs), "PCs")
  
  # return dataset containing the original image or not:
  if (includeOriginal == T){
    # transform the original image to a dataframe for plotting in ggplot2
    originalDF <- as.data.frame(image)
    # add column with the number of PCs
    originalLevel <- paste("Original -", ncol(image), "PCs")
    originalDF$k  <- originalLevel
    
    # rbind the datasets
    DF <- rbind(originalDF, reconstructionsDF)
    
    DF$k <- factor(DF$k , levels = c(originalLevel, reconstructedLevels))
    return(DF)
  }else{
    DF$k <- factor(DF$k , levels = reconstructedLevels)
    return(DF)
  }
}


### EXAMPLE:

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
