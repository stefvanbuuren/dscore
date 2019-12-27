
<!-- README.md is generated from README.Rmd. Please edit that file -->

# dscore

<!-- badges: start -->

[![Lifecycle:
maturing](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://www.tidyverse.org/lifecycle/#maturing)
[![](https://img.shields.io/badge/github%20version-0.42.0-orange.svg)](https://github.com/stefvanbuuren/dscore/rename)
<!-- badges: end -->

The *D*-score is a numerical score that measures generic development in
children. The *D*-score can be used to analyze and predict development
of children using tools developed for numerical measures, like height
and weight.

The `dscore` package contains tools to

  - Map your item names to the GSED convention
  - Calculate *D*-score from item level responses
  - Transform the *D*-scores into DAZ, age-standardised Z-scores

The required input consists of *item level* responses on milestones from
widely used instruments for measuring child development.

## Installation

You can install the development version from
[GitHub](https://github.com/) with:

``` r
install.packages("remotes")
remotes::install_github("stefvanbuuren/dscore")
```

## Overview

This overview shows how to estimate the *D*-score and the *D*-score
age-adjusted Z-score (DAZ) from child data on developmental milestones.
The overview covers some typical actions needed when estimating the
*D*-score and DAZ:

1.  Identify whether the `dscore` package covers your measurement
    instrument;
2.  Map your variable names to the GSED 9-position schema;
3.  Calculate *D*-score and DAZ;
4.  Summarise your results.

### Is your measurement instrument covered?

The `dscore` package covers a subset of all possible assessment
instruments. Moreover, it may have a restricted age range for a given
instrument. Your first tasks are

  - to evaluate whether the current `dscore` package can convert your
    measurements into *D*-scores;
  - to choose a `key` that best suits your objectives.

The inventory by Fernald et al. ([2017](#ref-fernald2017)) identified
[147
instruments](http://pubdocs.worldbank.org/en/685691512577486773/ECD-Measurement-Inventory-children-0-8-years-WorldBank.xlsx)
for assessing the development of children aged 0-8 years. Well-known
examples include the *Bayley Scales for Infant and Toddler Development*
and the *Ages & Stages Questionnaires*. The *D*-score is defined by and
calculated from, subsets of milestones from such instruments.

Assessment instruments connect to the *D*-score through a *measurement
model*. We use the term *key* to refer to a particular instance of a
measurement model. The `dscore` package currently supports three keys:

1.  `dutch`, a model developed for the *Dutch development instrument*;
2.  `gcdg`, a model covering 14 instruments using *direct* measurements;
3.  `gsed`, a model covering 20 instruments using a mix of *direct* and
    *caregiver-reported* measurements;

Although the differences between *D*-scores calculated under different
keys are generally small, the results are not identical. Hence, we may
compare only *D*-scores that are calculated under the same key. The
table given below displays the number of items per instrument under each
key. If the entry is blank, the key does not cover the
instrument.

| Code  | Instrument                                              | Items | dutch | gcdg | gsed |
| ----- | ------------------------------------------------------- | ----: | ----: | ---: | ---: |
| `aqi` | Ages & Stages Questionnaires-3                          |   230 |       |   29 |   17 |
| `bar` | Barrera Moncada                                         |    22 |       |   15 |   13 |
| `bat` | Battelle Development Inventory and Screener-2           |   137 |       |      |      |
| `by1` | Bayley Scales for Infant and Toddler Development-1      |   156 |       |   85 |   76 |
| `by2` | Bayley Scales for Infant and Toddler Development-2      |   121 |       |   16 |   16 |
| `by3` | Bayley Scales for Infant and Toddler Development-3      |   320 |       |  105 |   67 |
| `cro` | Caregiver Reported Early Development Instrument (CREDI) |   149 |       |      |   62 |
| `ddi` | Dutch Development Instrument (Van Wiechenschema)        |    77 |    76 |   65 |   64 |
| `den` | Denver-2                                                |   111 |       |   67 |   50 |
| `dmc` | Developmental Milestones Checklist                      |    66 |       |      |   43 |
| `gri` | Griffiths Mental Development Scales                     |   312 |       |  104 |   93 |
| `iyo` | Infant and Young Child Development (IYCD)               |    90 |       |      |   55 |
| `kdi` | Kilifi Developmental Inventory                          |    69 |       |      |      |
| `mac` | MacArthur Communicative Development Inventory           |     6 |       |    3 |    3 |
| `mds` | WHO Motor Development Milestones                        |     6 |       |      |    1 |
| `mdt` | Malawi Developmental Assessment Tool (MDAT)             |   136 |       |      |  126 |
| `peg` | Pegboard                                                |     2 |       |    1 |    1 |
| `pri` | Project on Child Development Indicators (PRIDI)         |    63 |       |      |      |
| `sbi` | Stanford Binet Intelligence Scales-4/5                  |    33 |       |    6 |    1 |
| `sgr` | Griffiths for South Africa                              |    58 |       |   19 |   19 |
| `tep` | Test de Desarrollo Psicomotor (TEPSI)                   |    61 |       |   33 |   31 |
| `vin` | Vineland Social Maturity Scale                          |    50 |       |   17 |   17 |
|       |                                                         |  2275 |    76 |  565 |  807 |
|       | Extensions                                              |       |       |      |      |
| `rap` | Global Scale of Early Development - RAPID SF            |   139 |       |      |      |
| `mul` | Mullen Scales of Early Learning                         |   232 |       |      |   85 |
| `hyp` | Demonstration items                                     |     5 |       |      |      |
|       |                                                         |  2651 |    76 |  565 |  892 |

Unfortunately, it is not possible to calculate the *D*-score if your
instrument is not on the list, or if all of its entries under the key
headings are blank. You may wish to file an extension request to
incorporate your instrument in a future version of the `dscore` package.
It remains an empirical question, however, whether the requested
extension is possible.

For some instruments, e.g., for `cro` only one choice is possible
(`"gsed"`). For `gri`, we may choose between `"gcdg"` and `"gsed"`. Your
choice may depend on the goal of your analysis. If you want to compare
to other *D*-scores calculated under key `"gcdg"`, or reproduce an
analysis made under that key, then pick `"gcdg"`. If that is not the
case, then `"gsed"` is probably a better choice because of its broader
generalizability. The default key is `"gsed"`.

<img src="man/figures/README-graphkey-1.png" width="100%" />

The designs of the original cohorts determine the age coverage for each
instrument. The figure above indicates the age range currently supported
by the `"gsed"` key. Some instruments contain many items for the first
two years (e.g., `by1`, `dmc`), whereas others cover primarily upper
ages (e.g., `tep`, `mul`). If you find that the ages in your sample
deviate from those in the figure, you may wish to file an extension
request to incorporate new ages in a future version of the `dscore`
package.

### Map variable names to the GSED 9-position schema

The `dscore()` function accepts item names that follow the GSED
9-position schema. A name with a length of nine characters identifies
every milestone. The following table shows the construction of names.

| Position | Description          | Example |
| -------: | :------------------- | :------ |
|      1-3 | instrument           | `by3`   |
|      4-5 | developmental domain | `cg`    |
|        6 | administration mode  | `d`     |
|      7-9 | item number          | `018`   |

Thus, item `by3cgd018` refers to the 18th item in the cognitive scale of
the Bayley-III. The label of the item can be obtained by

``` r
library(dscore)
get_labels("by3cgd018")
#>           by3cgd018 
#> "Inspects own hand"
```

You may decompose item names into components as follows:

``` r
decompose_itemnames(c("by3cgd018", "denfmd014"))
#>   instrument domain mode number
#> 1        by3     cg    d    018
#> 2        den     fm    d    014
```

This function returns a `data.frame` with four character vectors.

The `dscore` package can recognise 2651 item names. The expression
`get_itemnames()` returns a (long) vector of all known item names. Let
us construct a table of instruments by domains:

``` r
items <- get_itemnames()
din <- decompose_itemnames(items)
knitr::kable(with(din, table(instrument, domain)), format = "html") %>% 
  kableExtra::column_spec(1, monospace = TRUE)
```

<table>

<thead>

<tr>

<th style="text-align:left;">

</th>

<th style="text-align:right;">

ad

</th>

<th style="text-align:right;">

cg

</th>

<th style="text-align:right;">

cl

</th>

<th style="text-align:right;">

cm

</th>

<th style="text-align:right;">

co

</th>

<th style="text-align:right;">

eh

</th>

<th style="text-align:right;">

ex

</th>

<th style="text-align:right;">

fa

</th>

<th style="text-align:right;">

fm

</th>

<th style="text-align:right;">

fr

</th>

<th style="text-align:right;">

gm

</th>

<th style="text-align:right;">

hd

</th>

<th style="text-align:right;">

hs

</th>

<th style="text-align:right;">

lg

</th>

<th style="text-align:right;">

md

</th>

<th style="text-align:right;">

mo

</th>

<th style="text-align:right;">

pd

</th>

<th style="text-align:right;">

px

</th>

<th style="text-align:right;">

re

</th>

<th style="text-align:right;">

se

</th>

<th style="text-align:right;">

sl

</th>

<th style="text-align:right;">

vs

</th>

<th style="text-align:right;">

wm

</th>

<th style="text-align:right;">

xx

</th>

</tr>

</thead>

<tbody>

<tr>

<td style="text-align:left;font-family: monospace;">

aqi

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

48

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

45

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

47

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

51

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

39

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

</tr>

<tr>

<td style="text-align:left;font-family: monospace;">

bar

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

22

</td>

</tr>

<tr>

<td style="text-align:left;font-family: monospace;">

bat

</td>

<td style="text-align:right;">

26

</td>

<td style="text-align:right;">

26

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

27

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

30

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

28

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

</tr>

<tr>

<td style="text-align:left;font-family: monospace;">

by1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

117

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

39

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

</tr>

<tr>

<td style="text-align:left;font-family: monospace;">

by2

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

78

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

43

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

</tr>

<tr>

<td style="text-align:left;font-family: monospace;">

by3

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

89

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

48

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

66

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

68

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

49

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

</tr>

<tr>

<td style="text-align:left;font-family: monospace;">

cro

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

51

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

39

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

59

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

</tr>

<tr>

<td style="text-align:left;font-family: monospace;">

ddi

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

23

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

27

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

27

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

</tr>

<tr>

<td style="text-align:left;font-family: monospace;">

den

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

28

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

26

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

35

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

22

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

</tr>

<tr>

<td style="text-align:left;font-family: monospace;">

dmc

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

11

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

17

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

11

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

27

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

</tr>

<tr>

<td style="text-align:left;font-family: monospace;">

gri

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

66

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

64

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

82

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

77

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

23

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

</tr>

<tr>

<td style="text-align:left;font-family: monospace;">

hyp

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

5

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

</tr>

<tr>

<td style="text-align:left;font-family: monospace;">

iyo

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

30

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

40

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

20

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

</tr>

<tr>

<td style="text-align:left;font-family: monospace;">

kdi

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

34

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

35

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

</tr>

<tr>

<td style="text-align:left;font-family: monospace;">

mac

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

6

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

</tr>

<tr>

<td style="text-align:left;font-family: monospace;">

mds

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

6

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

</tr>

<tr>

<td style="text-align:left;font-family: monospace;">

mdt

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

34

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

34

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

34

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

34

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

</tr>

<tr>

<td style="text-align:left;font-family: monospace;">

mul

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

50

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

50

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

48

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

36

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

48

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

</tr>

<tr>

<td style="text-align:left;font-family: monospace;">

peg

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

</tr>

<tr>

<td style="text-align:left;font-family: monospace;">

pri

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

34

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

13

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

16

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

</tr>

<tr>

<td style="text-align:left;font-family: monospace;">

rap

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

30

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

5

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

16

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

48

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

28

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

11

</td>

</tr>

<tr>

<td style="text-align:left;font-family: monospace;">

sbi

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

11

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

10

</td>

<td style="text-align:right;">

12

</td>

<td style="text-align:right;">

0

</td>

</tr>

<tr>

<td style="text-align:left;font-family: monospace;">

sgr

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

6

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

5

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

6

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

5

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

36

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

</tr>

<tr>

<td style="text-align:left;font-family: monospace;">

tep

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

8

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

36

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

17

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

</tr>

<tr>

<td style="text-align:left;font-family: monospace;">

vin

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

50

</td>

</tr>

</tbody>

</table>

We obtain the first three item names and labels from the `mdt` domain
`gm` as

``` r
items <- head(get_itemnames(instrument = "mdt", domain = "gm"), 3)
get_labels(items)
#>                                          mdtgmd001                                          mdtgmd002 
#>                             "Lifts chin off floor" "Prone (on tummy), can lift head up to 90 degrees" 
#>                                          mdtgmd003 
#>             "Holds head upright for a few seconds"
```

In practice, you need to spend some time to figure out how item names in
your data map to those in the `dscore` package. Once you’ve completed
this mapping, rename the items into the GSED 9-position schema. For
example, suppose that your first three gross motor MDAT items are called
`mot1`, `mot2`, and
`mot3`.

``` r
data <- data.frame(id = c(1, 1, 2), age = c(1, 1.6, 0.9), mot1 = c(1, NA, NA), 
                   mot2 = c(0, 1, 1), mot3 = c(NA, 0, 1))
data
#>   id age mot1 mot2 mot3
#> 1  1 1.0    1    0   NA
#> 2  1 1.6   NA    1    0
#> 3  2 0.9   NA    1    1
```

Renaming is easy to do by changing the names attribute.

``` r
old_names <- names(data)[3:5]
new_names <- get_itemnames(instrument = "mdt", domain = "gm")[1:3]
names(data)[3:5] <- new_names
data
#>   id age mdtgmd001 mdtgmd002 mdtgmd003
#> 1  1 1.0         1         0        NA
#> 2  1 1.6        NA         1         0
#> 3  2 0.9        NA         1         1
```

There may be different versions and revision of the same instrument.
Therefore, carefully check whether the item labels match up with the
labels in version of the instrument that you administered.

The `dscore` package assumes that response to milestones are dichotomous
(1 = PASS, 0 = FAIL). If necessary, recode your data to match these
response categories.

### Calculate the *D*-score and DAZ

Once the data are in proper shape, calculation of the *D*-score and DAZ
is easy.

The `milestones` dataset in the `dscore` package contains responses of
27 preterm children measured at various age between birth and 2.5 years
on the Dutch Development Instrument (`ddi`). The dataset looks like:

``` r
head(milestones[, c(1, 3, 4, 9:14)])
#>    id   age    sex ddigmd053 ddigmd056 ddicmm030 ddifmd002 ddifmd003 ddifmm004
#> 1 111 0.487   male         1         1         1         1         1         0
#> 2 111 0.657   male        NA        NA        NA        NA         1         1
#> 3 111 1.180   male        NA        NA        NA        NA        NA        NA
#> 4 111 1.906   male        NA        NA        NA        NA        NA        NA
#> 5 177 0.550 female         1         1         1         1         1         1
#> 6 177 0.767 female        NA        NA        NA        NA         1         1
```

Each row corresponds to a visit. Most children have three or four
visits. Columns starting with `ddi` hold the responses on DDI-items. A
`1` means a PASS, a `0` means a FAIL, and `NA` means that the item was
not administered.

The `milestones` dataset has properly named columns that identify each
item. Calculating the *D*-score and DAZ is then done by:

``` r
ds <- dscore(milestones)
dim(ds)
#> [1] 100   6
```

Where `ds` is a `data.frame` with the same number of rows as the input
data. The first six rows are

``` r
head(ds)
#>       a  n     p    d   sem    daz
#> 1 0.487 11 0.909 31.3 1.584 -1.442
#> 2 0.657 14 0.643 34.7 0.981 -2.176
#> 3 1.180 19 0.947 48.7 1.551 -1.191
#> 4 1.906 13 0.846 60.0 1.177 -0.627
#> 5 0.550 11 0.818 29.5 1.334 -2.767
#> 6 0.767 14 0.786 36.5 0.920 -2.533
```

The table below provides the interpretation of the
output:

| Name  | Interpretation                                                     |
| ----- | ------------------------------------------------------------------ |
| `a`   | Decimal age                                                        |
| `n`   | number of items used to calculate *D*-score                        |
| `p`   | Percentage of passed milestones                                    |
| `d`   | *D*-score estimate, mean of posterior                              |
| `sem` | Standard error of measurement, standard deviation of the posterior |
| `daz` | *D*-score corrected for age                                        |

### Summarise *D*-score and DAZ

Combine the `milestones` data and the result by

``` r
md <- cbind(milestones, ds)
```

We may plot the 27 individual developmental curves by

``` r
library(ggplot2)
library(dplyr)

r <- builtin_references %>% 
  filter(pop == "dutch") %>% 
  select(age, SDM2, SD0, SDP2)

ggplot(md, aes(x = a, y = d, group = id, color = sex)) + 
  theme_light() + 
  theme(legend.position = c(.85, .15)) +
  theme(legend.background = element_blank()) +
  theme(legend.key = element_blank()) +
  annotate("polygon", x = c(r$age, rev(r$age)), 
           y = c(r$SDM2, rev(r$SDP2)), alpha = 0.1, fill = "green") +
  annotate("line", x = r$age, y = r$SDM2, lwd = 0.3, alpha = 0.2, color = "green") +
  annotate("line", x = r$age, y = r$SDP2, lwd = 0.3, alpha = 0.2, color = "green") +
  annotate("line", x = r$age, y = r$SD0, lwd = 0.5, alpha = 0.2, color = "green") +
  coord_cartesian(xlim = c(0, 2.5)) +
  ylab(expression(paste(italic(D), "-score", sep = ""))) +
  xlab("Age (in years)") +
  scale_color_brewer(palette = "Set1") +
  geom_line(lwd = 0.1) +
  geom_point(size = 1)
```

<img src="man/figures/README-graphD-1.png" width="100%" />

Note that similarity of these curves to growth curves for body height
and weight.

The DAZ is an age-standardized *D*-score with a standard normal
distribution with mean 0 and variance 1. We plot the individual DAZ
curves relative to the Dutch references by

``` r
ggplot(md, aes(x = a, y = daz, group = id, color = factor(sex))) + 
  theme_light() + 
  theme(legend.position = c(.85, .15)) +
  theme(legend.background = element_blank()) +
  theme(legend.key = element_blank()) +
  scale_color_brewer(palette = "Set1") +
  annotate("rect", xmin = -Inf, xmax = Inf, ymin = -2, ymax = 2, alpha = 0.1,
            fill = "green") +
  coord_cartesian(xlim = c(0, 2.5), 
                  ylim = c(-4, 4)) +
  geom_line(lwd = 0.1) +
  geom_point(size = 1) +
  xlab("Age (in years)") +
  ylab("DAZ") 
```

<img src="man/figures/README-graphDAZ-1.png" width="100%" />

Note that the *D*-scores and DAZ are a little lower than average. The
explanation here is that these all children are born preterm. We can
[account for
prematurity](https://stefvanbuuren.name/dbook1/sec-pops.html#age-adjustment)
by correcting for gestational age.

The distributions of DAZ for boys and girls show that a large overlap:

``` r
ggplot(md) + 
  theme_light() +
  scale_fill_brewer(palette = "Set1") +
  geom_density(aes(x = daz, group = sex, fill = sex), alpha = 0.4, 
               adjust = 1.5, color = "transparent") +
  xlab("DAZ")
```

<img src="man/figures/README-density-1.png" width="100%" />

Under the assumption of independence, we may test whether sex
differences are constant in age by a linear regression that includes the
interaction between age and sex:

``` r
summary(lm(daz ~  age * sex, data = md))
#> 
#> Call:
#> lm(formula = daz ~ age * sex, data = md)
#> 
#> Residuals:
#>    Min     1Q Median     3Q    Max 
#> -2.584 -0.832 -0.220  0.583  3.325 
#> 
#> Coefficients:
#>             Estimate Std. Error t value Pr(>|t|)    
#> (Intercept)  -2.4099     0.3361   -7.17  1.6e-10 ***
#> age           0.9893     0.2813    3.52  0.00067 ***
#> sexmale       0.0621     0.4659    0.13  0.89422    
#> age:sexmale  -0.1462     0.3738   -0.39  0.69647    
#> ---
#> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
#> 
#> Residual standard error: 1.18 on 96 degrees of freedom
#> Multiple R-squared:  0.201,  Adjusted R-squared:  0.176 
#> F-statistic: 8.04 on 3 and 96 DF,  p-value: 7.83e-05
```

This group of very preterms starts around -2.5 SD, followed by a
catch-up in child development of approximately 1.0 SD per year. The size
of the catch-up is equal for boys and girls.

We may account for the clustering effect by including random intercept
and age effects, and rerun as

``` r
library(lme4)
#> Loading required package: Matrix
lmer(daz ~  1 + age + sex + sex * age + (1 + age | id), data = md)
#> Linear mixed model fit by REML ['lmerMod']
#> Formula: daz ~ 1 + age + sex + sex * age + (1 + age | id)
#>    Data: md
#> REML criterion at convergence: 311
#> Random effects:
#>  Groups   Name        Std.Dev. Corr 
#>  id       (Intercept) 1.048         
#>           age         0.668    -0.88
#>  Residual             0.968         
#> Number of obs: 100, groups:  id, 27
#> Fixed Effects:
#> (Intercept)          age      sexmale  age:sexmale  
#>     -2.4300       1.0348       0.0864      -0.1878
```

This analysis yields the same substantive conclusions as before.

## Resources

### Books and reports

1.  [Introduction into the
    *D*-score](https://stefvanbuuren.name/dbook1/)
2.  [Inventory of 147 instruments for measuring early child
    development](http://documents.worldbank.org/curated/en/384681513101293811/A-toolkit-for-measuring-early-childhood-development-in-low-and-middle-income-countries):
    Fernald et al. ([2017](#ref-fernald2017))

### Keys

1.  Project with `dutch` key, 0-2 years: van Buuren
    ([2014](#ref-vanbuuren2014))
2.  Project with `gcdg` key: Weber et al. ([2019](#ref-weber2019))
3.  Project with `gsed` key: GSED team (Maureen Black, Kieran Bromley,
    Vanessa Cavallera (lead author), Jorge Cuartas, Tarun Dua
    (corresponding author), Iris Eekhout, Günther Fink, Melissa
    Gladstone, Katelyn Hepworth, Magdalena Janus, Patricia Kariger,
    Gillian Lancaster, Dana McCoy, Gareth McCray, Abbie Raikes, Marta
    Rubio-Codina, Stef van Buuren, Marcus Waldman, Susan Walker and Ann
    Weber) ([2019](#ref-gsedteam2019))

### Methodology

1.  Interval scale: Jacobusse, van Buuren, and Verkerk
    ([2006](#ref-jacobusse2006))
2.  Adaptive testing: Jacobusse and van Buuren
    ([2007](#ref-jacobusse2007))

## Acknowledgement

This study was supported by the Bill & Melinda Gates Foundation. The
contents are the sole responsibility of the authors and may not
necessarily represent the official views of the Bill & Melinda Gates
Foundation or other agencies that may have supported the primary data
studies used in the present study. The authors wish to recognize the
principal investigators and their study team members for their generous
contribution of the data that made this tool possible and the members of
the Ki team who directly or indirectly contributed to the study: Amina
Abubakar, Claudia R. Lindgren Alves, Orazio Attanasio, Maureen M. Black,
Maria Caridad Araujo, Susan M. Chang-Lopez, Gary L. Darmstadt, Bernice
M. Doove, Wafaie Fawzi, Lia C.H. Fernald, Günther Fink, Emanuela
Galasso, Melissa Gladstone, Sally M. Grantham-McGregor, Cristina
Gutierrez de Pineres, Pamela Jervis, Jena Derakhshani Hamadani,
Charlotte Hanlon, Simone M. Karam, Gillian Lancaster, Betzy Lozoff,
Gareth McCray, Jeffrey R Measelle, Girmay Medhin, Ana M. B. Menezes,
Lauren Pisani, Helen Pitchik, Muneera Rasheed, Lisy Ratsifandrihamanana,
Sarah Reynolds, Linda Richter, Marta Rubio-Codina, Norbert Schady,
Limbika Sengani, Chris Sudfeld, Marcus Waldman, Susan P. Walker, Ann M.
Weber and Aisha K. Yousafzai.

### Literature

<div id="refs" class="references">

<div id="ref-fernald2017">

Fernald, L.C.H., E. Prado, P. Kariger, and A. Raikes. 2017. “A Toolkit
for Measuring Early Childhood Development in Low and Middle-Income
Countries.”
<http://documents.worldbank.org/curated/en/384681513101293811/A-toolkit-for-measuring-early-childhood-development-in-low-and-middle-income-countries>.

</div>

<div id="ref-gsedteam2019">

GSED team (Maureen Black, Kieran Bromley, Vanessa Cavallera (lead
author), Jorge Cuartas, Tarun Dua (corresponding author), Iris Eekhout,
Günther Fink, Melissa Gladstone, Katelyn Hepworth, Magdalena Janus,
Patricia Kariger, Gillian Lancaster, Dana McCoy, Gareth McCray, Abbie
Raikes, Marta Rubio-Codina, Stef van Buuren, Marcus Waldman, Susan
Walker and Ann Weber). 2019. “The Global Scale for Early Development
(Gsed).” *Early Childhood Matters*.
<https://earlychildhoodmatters.online/2019/the-global-scale-for-early-development-gsed/>.

</div>

<div id="ref-jacobusse2007">

Jacobusse, G., and S. van Buuren. 2007. “Computerized Adaptive Testing
for Measuring Development of Young Children.” *Statistics in Medicine*
26 (13): 2629–38.
<https://stefvanbuuren.name/publication/2007-01-01_jacobusse2007/>.

</div>

<div id="ref-jacobusse2006">

Jacobusse, G., S. van Buuren, and P.H. Verkerk. 2006. “An Interval Scale
for Development of Children Aged 0-2 Years.” *Statistics in Medicine* 25
(13): 2272–83.
<https://stefvanbuuren.name/publication/2006-01-01_jacobusse2006/>.

</div>

<div id="ref-vanbuuren2014">

van Buuren, S. 2014. “Growth Charts of Human Development.” *Statistical
Methods in Medical Research* 23 (4): 346–68.
<https://stefvanbuuren.name/publication/2014-01-01_vanbuuren2014gc/>.

</div>

<div id="ref-weber2019">

Weber, A.M., M. Rubio-Codina, S.P. Walker, S. van Buuren, I. Eekhout, S.
Grantham-McGregor, M.C. Araujo, et al. 2019. “The D-Score: A Metric for
Interpreting the Early Development of Infants and Toddlers Across Global
Settings.” *BMJ Global Health* 4: e001724.
<https://gh.bmj.com/content/bmjgh/4/6/e001724.full.pdf>.

</div>

</div>
