# rOpenSci traits package

The [rOpenSci traits package](https://github.com/ropensci/traits/) is an R client for various sources of species trait data. 
The traits package provides functions that interface with the BETYdb API. 

These instructions are from the traits package documentation, which is released with a MIT-BSD license.

## Installation

Launch R

```sh
$ R
```

Install the stable version of the package from CRAN:

```r
install.packages("traits")
```

Or development version from GitHub:


```r
devtools::install_github("ropensci/traits")
```


## Load traits


```r
library("traits")
```

## Example 1: Query trait data for Willow

Get trait data for Willow (_Salix_ spp.)


```r
(salix <- betydb_search("Salix Vcmax"))
#> Source: local data frame [14 x 31]
#> 
#>    access_level       author checked citation_id citation_year  city
#>           (int)        (chr)   (int)       (int)         (int) (chr)
#> 1             4       Merilo       1         430          2005 Saare
#> 2             4       Merilo       1         430          2005 Saare
#> 3             4       Merilo       1         430          2005 Saare
#> 4             4       Merilo       1         430          2005 Saare
#> 5             4 Wullschleger       1          51          1993    NA
#> 6             4       Merilo       1         430          2005 Saare
#> 7             4       Merilo       1         430          2005 Saare
#> 8             4       Merilo       1         430          2005 Saare
#> 9             4       Merilo       1         430          2005 Saare
#> 10            4       Merilo       1         430          2005 Saare
#> 11            4       Merilo       1         430          2005 Saare
#> 12            4       Merilo       1         430          2005 Saare
#> 13            4       Merilo       1         430          2005 Saare
#> 14            4         Wang       1         381          2010    NA
#> Variables not shown: commonname (chr), cultivar_id (int), date (chr),
#>   dateloc (chr), genus (chr), id (int), lat (dbl), lon (dbl), mean (chr),
#>   month (dbl), n (int), notes (chr), result_type (chr), scientificname
#>   (chr), site_id (int), sitename (chr), species_id (int), stat (chr),
#>   statname (chr), trait (chr), trait_description (chr), treatment (chr),
#>   treatment_id (int), units (chr), year (dbl)
# equivalent:
# (out <- betydb_search("willow"))
```

Summarise data from the output `data.frame`


```r
library("dplyr")
salix %>%
  group_by(scientificname, trait) %>%
  mutate(.mean = as.numeric(mean)) %>%
  summarise(mean = round(mean(.mean, na.rm = TRUE), 2),
            min = round(min(.mean, na.rm = TRUE), 2),
            max = round(max(.mean, na.rm = TRUE), 2),
            n = length(n))
#> Source: local data frame [4 x 6]
#> Groups: scientificname [?]
#> 
#>                    scientificname trait  mean   min   max     n
#>                             (chr) (chr) (dbl) (dbl) (dbl) (int)
#> 1                           Salix Vcmax 65.00 65.00 65.00     1
#> 2                Salix dasyclados Vcmax 46.08 34.30 56.68     4
#> 3 Salix sachalinensis × miyabeana Vcmax 79.28 79.28 79.28     1
#> 4                 Salix viminalis Vcmax 43.04 19.99 61.29     8
```

[BETYdb](https://www.betydb.org/) is the _Biofuel Ecophysiological Traits and Yields Database_. You can get many different types of data from this database, including trait data. 

Function setup: All functions are prefixed with `betydb_`. Plural function names like `betydb_traits()` accept parameters and always give back a data.frame, while singular function names like `betydb_trait()` accept an ID and give back a list. 

The idea with the functions with plural names is to search for either traits, species, etc., and with the singular function names to get data by one or more IDs.



## Example 2: Get yield data for Switchgrass (_Panicum virgatum_)


```r
out <- betydb_search(query = "Switchgrass Yield")
```

Summarise data from the output `data.frame`


```r
library("dplyr")
out %>%
  group_by(id) %>%
  summarise(mean_result = mean(as.numeric(mean), na.rm = TRUE)) %>%
  arrange(desc(mean_result))
```

```
## Source: local data frame [509 x 2]
## 
##       id mean_result
## 1   1666       27.36
## 2  16845       27.00
## 3   1669       26.36
## 4  16518       26.00
## 5   1663       25.35
## 6  16742       25.00
## 7   1594       24.78
## 8   1674       22.71
## 9   1606       22.54
## 10  1665       22.46
## ..   ...         ...
```

## Advanced Queries

The tables above will return values of _tablename_id that can be used to query other tables

### Query a Single trait record by its id

```r
betydb_trait(id = 10)
```

```
## $created_at
## NULL
## 
## $description
## [1] "Leaf Percent Nitrogen"
## 
## $id
## [1] 10
## 
## $label
## NULL
## 
## $max
## [1] "10"
## 
## $min
## [1] "0.02"
## 
## $name
## [1] "leafN"
## 
## $notes
## [1] ""
## 
## $standard_name
## NULL
## 
## $standard_units
## NULL
## 
## $units
## [1] "percent"
## 
## $updated_at
## [1] "2011-06-06T09:40:42-05:00"
```

### Query a single Species


```r
betydb_specie(id = 10)
```

```
## $AcceptedSymbol
## [1] "ACKA2"
## 
## $commonname
## [1] "karroothorn"
## 
## $created_at
## NULL
## 
## $genus
## [1] "Acacia"
## 
## $id
## [1] 10
## 
## $notes
## [1] ""
## 
## $scientificname
## [1] "Acacia karroo"
## 
## $spcd
## NULL
## 
## $species
## [1] "karroo"
## 
## $updated_at
## [1] "2011-03-01T15:02:25-06:00"
```

### Query a single Citation



```r
betydb_citation(10)
```

```
## $author
## [1] "Casler"
## 
## $created_at
## NULL
## 
## $doi
## [1] "10.2135/cropsci2003.2226"
## 
## $id
## [1] 10
## 
## $journal
## [1] "Crop Science"
## 
## $pdf
## [1] "http://crop.scijournals.org/cgi/reprint/43/6/2226.pdf"
## 
## $pg
## [1] "2226–2233"
## 
## $title
## [1] "Cultivar X environment interactions in switchgrass"
## 
## $updated_at
## NULL
## 
## $url
## [1] "http://crop.scijournals.org/cgi/content/abstract/43/6/2226"
## 
## $user_id
## NULL
## 
## $vol
## [1] 43
## 
## $year
## [1] 2003
```

### Query a single Site


```r
betydb_site(id = 1)
```

```
## $city
## [1] "Aliartos"
## 
## $country
## [1] "GR"
## 
## $geometry
## [1] "POINT (23.17 38.37 114.0)"
## 
## $greenhouse
## [1] FALSE
## 
## $notes
## [1] ""
## 
## $sitename
## [1] "Aliartos"
## 
## $state
## [1] ""
```
