
<!-- README.md is generated from README.Rmd. Please edit that file -->

# uklakes

<!-- badges: start -->
<!-- badges: end -->

The uklakes package allows you to retrieve a summary of the lake
information from the [UK CEH Lake Portal](https://uklakes.ceh.ac.uk/)
for a lake or series of lakes, based on the lakeid number. It does this
by responsibly webscraping the information (using the [polite
package](https://cran.r-project.org/package=polite)) from the webpage of
each lake.

You can also search for lakeid values based on strings in the lake name
to determine the lakeids to search for.

Information on the general physical characteristics, typology, chemistry
and connectivity metrics are retrieved. Biology and Land cover
information are not. For details of the information available, see the
[UK Lakes Portal Website](https://uklakes.ceh.ac.uk/).

Use of the package implies acceptance of the Terms of Use available
[here](https://www.ceh.ac.uk/terms-of-use).

## Installation

You can install the current version of uklakes from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("robbriers/uklakes")
```

## Examples of use

This is a basic example which shows you how to solve a common problem:

``` r
library(uklakes)
#> Use of this package implies acceptance of Terms of Use at 
#> https://www.ceh.ac.uk/terms-of-use
## basic example code
```
