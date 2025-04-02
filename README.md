
<!-- README.md is generated from README.Rmd. Please edit that file -->

# uklakes <img src="man/figures/logo.png" align="right" height="139" alt="" />

<!-- badges: start -->

[![R-CMD-check](https://github.com/robbriers/uklakes/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/robbriers/uklakes/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://codecov.io/gh/robbriers/uklakes/graph/badge.svg)](https://app.codecov.io/gh/robbriers/uklakes)
[![Lifecycle:
stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)
[![Project Status: Active – The project has reached a stable, usable
state and is being actively
developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![pkgcheck](https://github.com/robbriers/uklakes/workflows/pkgcheck/badge.svg)](https://github.com/robbriers/uklakes/actions?query=workflow%3Apkgcheck)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.15092617.svg)](https://doi.org/10.5281/zenodo.15092617)
<!-- badges: end -->

The [UK CEH Lake Portal](https://uklakes.ceh.ac.uk/) is a GIS-based
inventory of information about more than 40000 lakes across the UK. The
information available for each lake varies, but includes basic physical
description, typology and other information.

The `uklakes` package allows you to retrieve a summary of the lake
information for a lake or series of lakes, based on the lake wbid
(waterbody id) number. It does this by responsibly webscraping the
information (using the [polite
package](https://cran.r-project.org/package=polite)) from the webpage of
each lake as the website does not provide an API or any easy way to
extract the data returned. You can also search for lake wbid values
based on strings in the lake name to determine the wbids to search for.

Information on the general physical characteristics, typology, chemistry
and connectivity metrics are retrieved. Biology, Land cover and water
quality information are not. For details of the information available,
see the [UK Lakes Portal Website](https://uklakes.ceh.ac.uk/), or the
[output reference
list](https://robbriers.github.io/uklakes/articles/uklakes_output_ref.html).

Use of the package implies acceptance of the Terms of Use available
[here](https://www.ceh.ac.uk/terms-of-use).

## Installation

You can install the current version of uklakes from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("robbriers/uklakes")
```

## Details of use

See the [Get
started](https://robbriers.github.io/uklakes/articles/uklakes.html)
vignette for how to use the package.

## Code of Conduct

Please note that the `uklakes` package is released with a [Contributor
Code of
Conduct](https://contributor-covenant.org/version/2/1/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.
