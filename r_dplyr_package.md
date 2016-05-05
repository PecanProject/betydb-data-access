# R dplyr Package

### R dplyr interface

Using dplyr requires having access to a PostgreSQL server running BETYdb or [installing your own](Local-install.md).

Comprehensive documentation for the `dplyr` interface to databases is provided in the [dplyr vignette](https://cran.r-project.org/web/packages/dplyr/vignettes/databases.html)

```{r}
install.packages('dplyr')
library(dplyr)
d <- settings$database$bety[c("dbname", "password", "host", "user")]
bety <- src_postgres(host = d$host, user = d$user, password = d$password, dbname = d$dbname)

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

