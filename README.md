
# tidymocap

<!-- badges: start -->
<!-- badges: end -->

The goal of `tidymocap`  is to tidy data from various motion capture sources. Additionally, augment the poses by calculating kinematics and (some) kinetics.

## Installation

You can install the development version of `tidymocap` like so:

``` r
install_github("roaldarbol/tidymocap")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(tidymocap)
data_raw <- tidymocap::anipose_raw
data_tidy <- tidymocap::tidy_anipose(data_raw)
data_augmented <- tidymocap::augment_poses(data_tidy)
```

