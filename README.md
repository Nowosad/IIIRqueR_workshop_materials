# Machine learning approaches for working with spatial data

## Abstract

The 'Machine Learning Approaches for Working with Spatial Data' workshop highlights the similarities and differences between machine learning using spatial data and non-spatial data. The workshop guides participants through various stages of machine learning workflows, from data preparation to model evaluation and prediction.
A traditional machine learning workflow will be discussed, followed by specific approaches for dealing with spatial data. These include spatial feature engineering, spatial cross-validation, area of applicability, and model explainability.
The workshop will use reproducible code, plots, and flowcharts to illustrate spatial machine learning workflows and methodologies.

## Prerequisites

A working recent version or R and RStudio is required to follow the workshop, along with several R packages listed below.

- R: <https://cloud.r-project.org/>
- RStudio: <https://posit.co/download/rstudio-desktop/#download>

```r
install.packages("remotes")
pkg_list = c("sf", "terra", "rpart", "mlr3", "mlr3learners", "mlr3spatiotempcv",
             "ggplot2", "CAST", "DALEX", "DALEXtra", "tidyr")
remotes::install_cran(pkg_list)
```

## Materials

Slides: [jakubnowosad.com](https://jakubnowosad.com/IIIRqueR_workshop/)

This repository contains the materials for the talk "Machine learning approaches for working with spatial data" given at the III Congreso & XIV Jornadas de Usuarios de R, Sevilla, Spain on 2024-11-08.

The best way to get them is to download the repository as a ZIP file from https://github.com/Nowosad/IIIRqueR_workshop_materials/archive/refs/heads/main.zip and unpack it on your computer. 
Then, you may open the .Rproj file and start working on the exercises in RStudio.


