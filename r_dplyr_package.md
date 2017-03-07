# R dplyr Package

### R dplyr interface

Using dplyr requires having access to a PostgreSQL server running BETYdb or [installing your own](Local-install.md).

Comprehensive documentation for the `dplyr` interface to databases is provided in the [dplyr vignette](https://cran.r-project.org/web/packages/dplyr/vignettes/databases.html)

## Connect to Database

```{r}
library(dplyr)
library(data.table)
## connection to database
d <- list(host = 'localhost',
          dbname = 'bety',
          user = 'bety',
          password = 'bety')

bety <- src_postgres(host = d$host, user = d$user, password = d$password, dbname = d$dbname)
```

## Query Miscanthus yield data

```{r}

species <- tbl(bety, 'species') %>% 
  select(id, scientificname, genus) %>% 
  filter(genus == "Miscanthus") %>% 
  mutate(specie_id = id) 

yields <-tbl(bety, 'yields') %>%
  select(date, mean, site_id, specie_id)

sites <- tbl(bety, 'sites') %>% 
  select(id, sitename, city, country) %>% 
  mutate(site_id = id)

mxgdata <- inner_join(species, yields, by = 'specie_id') %>%
  left_join(sites, by = 'site_id') %>% 
  select(-ends_with(".x"), -ends_with(".y")) %>% # drops duplicate rows
  collect() 
```

## Yield data with experimental treatments

Here we query Miscanthus and Switchgrass yield data along with planting, irrigation, and fertilization rates in order to update teh meta-analysis originally performed by Heaton et al (2004).

```r

## query and join tables
species <- tbl(bety, 'species') %>% 
  select(id, scientificname, genus) %>% 
  rename(specie_id = id)

sites <- tbl(bety, sql(
  paste("select id as site_id, st_y(st_centroid(sites.geometry)) AS lat,",
        "st_x(st_centroid(sites.geometry)) AS lon,",
        " sitename, city, country from sites"))
  )

citations <- tbl(bety, 'citations') %>%
  select(citation_id = id, author, year, title)

yields <- tbl(bety, 'yields') %>%
  select(id, date, mean, n, statname, stat, site_id, specie_id, treatment_id, citation_id, cultivar_id) %>% 
  left_join(species, by = 'specie_id') %>%
  left_join(sites, by = 'site_id') %>% 
  left_join(citations, by = 'citation_id')

managements_treatments <- tbl(bety, 'managements_treatments') %>%
  select(treatment_id, management_id)

treatments <- tbl(bety, 'treatments') %>% 
  dplyr::mutate(treatment_id = id) %>% 
  dplyr::select(treatment_id, name, definition, control)

managements <- tbl(bety, 'managements') %>%
  filter(mgmttype %in% c('fertilizer_N', 'fertilizer_N_rate', 'planting', 'irrigation')) %>%
  dplyr::mutate(management_id = id) %>%
  dplyr::select(management_id, date, mgmttype, level, units) %>%
  left_join(managements_treatments, by = 'management_id') %>%
  left_join(treatments, by = 'treatment_id') 

nitrogen <- managements %>% 
  filter(mgmttype == "fertilizer_N_rate") %>%
  select(treatment_id, nrate = level)

planting <- managements %>% filter(mgmttype == "planting") %>%
  select(treatment_id, planting_date = date)

planting_rate <- managements %>% filter(mgmttype == "planting") %>%
  select(treatment_id, planting_date = date, planting_density = level) 

irrigation <- managements %>% 
  filter(mgmttype == 'irrigation') 

irrigation_rate <- irrigation %>% 
  filter(units == 'mm', !is.na(treatment_id)) %>% 
  group_by(treatment_id, year = sql("extract(year from date)"), units) %>% 
  summarise(irrig.mm = sum(level)) %>% 
  group_by(treatment_id) %>% 
  summarise(irrig.mm.y = mean(irrig.mm))

irrigation_boolean <- irrigation %>%
  collect %>%   
  group_by(treatment_id) %>% 
  mutate(irrig = as.logical(mean(level))) %>% 
  select(treatment_id, irrig = irrig)

irrigation_all <- irrigation_boolean %>%
  full_join(irrigation_rate, copy = TRUE, by = 'treatment_id')

grass_yields <- yields %>% 
  filter(genus %in% c('Miscanthus', 'Panicum')) %>%
  left_join(nitrogen, by = 'treatment_id') %>% 
  #left_join(planting, by = 'treatment_id') %>% 
  left_join(planting_rate, by = 'treatment_id') %>% 
  left_join(irrigation_all, by = 'treatment_id', copy = TRUE) %>% 
  collect %>% 
  mutate(age = year(date)- year(planting_date),
         nrate = ifelse(is.na(nrate), 0, nrate),
         SE = ifelse(statname == "SE", stat, ifelse(statname == 'SD', stat / sqrt(n), NA)),
         continent = ifelse(lon < -30, 'united_states', ifelse(lon < 75, 'europe', 'asia')))
```
